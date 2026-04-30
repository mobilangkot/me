local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer

local function getChar() return LP.Character end
local function getHRP()
    local c = getChar(); if not c then return nil end
    return c:FindFirstChild("HumanoidRootPart")
        or c:FindFirstChild("UpperTorso")
        or c:FindFirstChild("Torso")
end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local CFG = {
    maxEvidence  = 8,
    minCycleTime = 30,  -- minimum detik per siklus
    speed        = 100,
    jumpPower    = 70,
    liftWait     = 8,   -- tunggu setelah klik lift
    depositWait  = 2,   -- tunggu setelah deposit
    collectDelay = 0.3, -- delay antar collect
    tpDelay      = 0.2, -- delay setelah teleport
}

local AI_ON        = false
local SPEED_ON     = false
local NOCLIP_ON    = false
local HL_ON        = true
local BABY_ON      = false
local AUTO_COLLECT = false
local CLOSED       = false

local collected   = 0
local cycleCount  = 0
local aiPhase     = "IDLE"

local foundModels = {}
local highlights  = {}

-- ================================================================
--  SPEED
-- ================================================================
local speedConn
local function startSpeedLoop()
    if speedConn then speedConn:Disconnect() end
    speedConn = RunService.Heartbeat:Connect(function()
        if not SPEED_ON then return end
        local c = LP.Character; if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid"); if not h then return end
        h.UseJumpPower = true
        h.WalkSpeed    = CFG.speed
        h.JumpPower    = CFG.jumpPower
    end)
end
local function resetSpeed()
    local c = LP.Character; if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid"); if not h then return end
    h.WalkSpeed = 16; h.JumpPower = 50
end
startSpeedLoop()

-- ================================================================
--  NOCLIP
-- ================================================================
local noclipConn
local function startNoclip()
    if noclipConn then noclipConn:Disconnect() end
    noclipConn = RunService.Stepped:Connect(function()
        if not NOCLIP_ON then return end
        local c = LP.Character; if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end)
end
local function stopNoclip()
    local c = LP.Character; if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = true end
    end
end
startNoclip()

-- ================================================================
--  HIGHLIGHT
-- ================================================================
local function clearHighlights()
    for _, h in ipairs(highlights) do pcall(function() h:Destroy() end) end
    highlights = {}
end
local function addHighlight(target, isNearest)
    local h = Instance.new("Highlight")
    h.Parent              = target
    h.FillColor           = isNearest and Color3.fromRGB(255,255,0) or Color3.fromRGB(0,255,255)
    h.OutlineColor        = isNearest and Color3.fromRGB(255,150,0) or Color3.fromRGB(0,150,255)
    h.FillTransparency    = isNearest and 0 or 0.15
    h.OutlineTransparency = 0
    h.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    table.insert(highlights, h)
end

-- ================================================================
--  HELPERS
-- ================================================================
local function tpTo(pos)
    local hrp = getHRP(); if not hrp then return false end
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0))
    task.wait(CFG.tpDelay)
    return true
end

local function firePrompt(prompt)
    return pcall(function() fireproximityprompt(prompt) end)
end

local function findPromptByText(text)
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("ProximityPrompt") and
           (o.ActionText == text or o.ObjectText == text) then
            local p = o:FindFirstAncestorWhichIsA("BasePart")
            if not p then
                local m = o:FindFirstAncestorWhichIsA("Model")
                if m then p = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart", true) end
            end
            if p then return o, p.Position end
        end
    end
    return nil, nil
end

local function getEvidenceFolder()
    local ok, r = pcall(function()
        return workspace:WaitForChild("Data", 3)
            :WaitForChild("Detective", 3)
            :WaitForChild("Evidence", 3)
            :WaitForChild("Instances", 3)
    end)
    return ok and r or nil
end

local function getPromptFromModel(model)
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            local a = string.lower(d.ActionText)
            local o = string.lower(d.ObjectText)
            if a == "collect" or o == "collect" then return d end
        end
    end
end

-- ================================================================
--  AUTO BABY
-- ================================================================
local function fireAllBaby()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and
           (obj.ActionText == "Baby" or obj.ObjectText == "Baby") then
            pcall(function() obj.MaxActivationDistance = 9999 end)
            pcall(function() fireproximityprompt(obj) end)
        end
    end
end

local remotes    = ReplicatedStorage:FindFirstChild("Remotes")
local babyAction = remotes and remotes:FindFirstChild("BabyAction")
if babyAction then
    pcall(function()
        babyAction.OnClientEvent:Connect(function(...)
            if select(1,...) == "dropBaby" and BABY_ON then
                task.wait(0.15); fireAllBaby()
            end
        end)
    end)
end

local function doRespawn()
    local c = LP.Character; if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then h.Health = 0 end
end

-- ================================================================
--  GUI
-- ================================================================
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "SQv12"; gui.ResetOnSpawn = false

local C = {
    bg0    = Color3.fromRGB(8,   8,  10),
    bg1    = Color3.fromRGB(14,  14, 18),
    bg2    = Color3.fromRGB(20,  20, 26),
    border = Color3.fromRGB(32,  32, 40),
    accent = Color3.fromRGB(220, 220, 220),
    dim    = Color3.fromRGB(90,  90, 100),
    on     = Color3.fromRGB(200, 200, 200),
    off    = Color3.fromRGB(45,  45,  55),
    ok     = Color3.fromRGB(100, 200, 140),
    info   = Color3.fromRGB(120, 160, 220),
    red    = Color3.fromRGB(200,  60,  60),
    green  = Color3.fromRGB( 60, 180,  80),
    warn   = Color3.fromRGB(220, 160,  60),
}

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size             = UDim2.new(0, 260, 0, 10)
mainFrame.Position         = UDim2.new(0, 14, 0, 14)
mainFrame.BackgroundColor3 = C.bg0
mainFrame.BorderSizePixel  = 0
mainFrame.Active           = true
mainFrame.Draggable        = true
mainFrame.ZIndex           = 2
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local mStroke = Instance.new("UIStroke", mainFrame)
mStroke.Color = C.border; mStroke.Thickness = 1

-- Header
local header = Instance.new("Frame", mainFrame)
header.Size             = UDim2.new(1,0,0,44)
header.BackgroundColor3 = C.bg1
header.BorderSizePixel  = 0; header.ZIndex = 3
Instance.new("UICorner", header).CornerRadius = UDim.new(0,12)
local hPatch = Instance.new("Frame", header)
hPatch.Size = UDim2.new(1,0,0.5,0); hPatch.Position = UDim2.new(0,0,0.5,0)
hPatch.BackgroundColor3 = C.bg1; hPatch.BorderSizePixel = 0; hPatch.ZIndex = 3

local titleTxt = Instance.new("TextLabel", header)
titleTxt.Size = UDim2.new(1,-100,0,22); titleTxt.Position = UDim2.new(0,14,0,4)
titleTxt.BackgroundTransparency = 1
titleTxt.Text = "SQ Tool v12 — TP Mode"
titleTxt.TextColor3 = C.accent; titleTxt.Font = Enum.Font.GothamBold
titleTxt.TextSize = 13; titleTxt.TextXAlignment = Enum.TextXAlignment.Left; titleTxt.ZIndex = 4

local subTxt = Instance.new("TextLabel", header)
subTxt.Size = UDim2.new(1,-100,0,12); subTxt.Position = UDim2.new(0,14,0,27)
subTxt.BackgroundTransparency = 1
subTxt.Text = "menzcreate  |  discord: menzcreate"
subTxt.TextColor3 = Color3.fromRGB(100,100,120); subTxt.Font = Enum.Font.Gotham
subTxt.TextSize = 9; subTxt.TextXAlignment = Enum.TextXAlignment.Left; subTxt.ZIndex = 4

local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.new(0,24,0,24); minBtn.Position = UDim2.new(1,-60,0,10)
minBtn.BackgroundColor3 = Color3.fromRGB(28,28,36); minBtn.TextColor3 = C.dim
minBtn.Font = Enum.Font.GothamBold; minBtn.TextSize = 13; minBtn.Text = "-"
minBtn.AutoButtonColor = false; minBtn.BorderSizePixel = 0; minBtn.ZIndex = 5
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,6)

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0,24,0,24); closeBtn.Position = UDim2.new(1,-32,0,10)
closeBtn.BackgroundColor3 = Color3.fromRGB(40,20,20); closeBtn.TextColor3 = C.red
closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 13; closeBtn.Text = "X"
closeBtn.AutoButtonColor = false; closeBtn.BorderSizePixel = 0; closeBtn.ZIndex = 5
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

-- Float container
local floatContainer = Instance.new("Frame", gui)
floatContainer.Size = UDim2.new(0,44,0,98)
floatContainer.Position = UDim2.new(0,14,0,14)
floatContainer.BackgroundTransparency = 1
floatContainer.Visible = false; floatContainer.ZIndex = 14

local floatBtn = Instance.new("TextButton", floatContainer)
floatBtn.Size = UDim2.new(0,44,0,44)
floatBtn.BackgroundColor3 = C.bg1; floatBtn.TextColor3 = C.accent
floatBtn.Font = Enum.Font.GothamBold; floatBtn.TextSize = 20; floatBtn.Text = "SQ"
floatBtn.AutoButtonColor = false; floatBtn.BorderSizePixel = 0; floatBtn.ZIndex = 15
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", floatBtn).Color = C.border

local miniAiBtn = Instance.new("TextButton", floatContainer)
miniAiBtn.Size = UDim2.new(0,44,0,44); miniAiBtn.Position = UDim2.new(0,0,0,50)
miniAiBtn.BackgroundColor3 = C.off; miniAiBtn.TextColor3 = C.dim
miniAiBtn.Font = Enum.Font.GothamBold; miniAiBtn.TextSize = 14; miniAiBtn.Text = "AI"
miniAiBtn.AutoButtonColor = false; miniAiBtn.BorderSizePixel = 0; miniAiBtn.ZIndex = 15
Instance.new("UICorner", miniAiBtn).CornerRadius = UDim.new(0,10)
local miniAiStroke = Instance.new("UIStroke", miniAiBtn)
miniAiStroke.Color = C.border; miniAiStroke.Thickness = 1

local function updateMiniAI()
    miniAiBtn.BackgroundColor3 = AI_ON and C.green or C.off
    miniAiStroke.Color         = AI_ON and C.ok    or C.border
end

-- Status
local statusBar = Instance.new("Frame", mainFrame)
statusBar.Size = UDim2.new(1,-16,0,22); statusBar.Position = UDim2.new(0,8,0,50)
statusBar.BackgroundColor3 = C.bg2; statusBar.BorderSizePixel = 0; statusBar.ZIndex = 3
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0,6)

local statusTxt = Instance.new("TextLabel", statusBar)
statusTxt.Size = UDim2.new(1,-10,1,0); statusTxt.Position = UDim2.new(0,8,0,0)
statusTxt.BackgroundTransparency = 1; statusTxt.Text = "Ready"
statusTxt.TextColor3 = C.dim; statusTxt.Font = Enum.Font.Gotham
statusTxt.TextSize = 10; statusTxt.TextXAlignment = Enum.TextXAlignment.Left; statusTxt.ZIndex = 4

-- Info row
local infoRow = Instance.new("Frame", mainFrame)
infoRow.Size = UDim2.new(1,-16,0,20); infoRow.Position = UDim2.new(0,8,0,76)
infoRow.BackgroundTransparency = 1; infoRow.ZIndex = 3

local evTxt = Instance.new("TextLabel", infoRow)
evTxt.Size = UDim2.new(0.5,0,1,0); evTxt.BackgroundTransparency = 1
evTxt.Text = "Evidence: 0/8"; evTxt.TextColor3 = C.ok
evTxt.Font = Enum.Font.GothamBold; evTxt.TextSize = 10
evTxt.TextXAlignment = Enum.TextXAlignment.Left; evTxt.ZIndex = 4

local cycleTxt = Instance.new("TextLabel", infoRow)
cycleTxt.Size = UDim2.new(0.5,0,1,0); cycleTxt.Position = UDim2.new(0.5,0,0,0)
cycleTxt.BackgroundTransparency = 1; cycleTxt.Text = "Siklus: 0"
cycleTxt.TextColor3 = C.dim; cycleTxt.Font = Enum.Font.Gotham
cycleTxt.TextSize = 10; cycleTxt.TextXAlignment = Enum.TextXAlignment.Right; cycleTxt.ZIndex = 4

-- Timer bar
local timerBar = Instance.new("Frame", mainFrame)
timerBar.Size = UDim2.new(1,-16,0,20); timerBar.Position = UDim2.new(0,8,0,100)
timerBar.BackgroundTransparency = 1; timerBar.ZIndex = 3

local timerTxt = Instance.new("TextLabel", timerBar)
timerTxt.Size = UDim2.new(1,0,1,0); timerTxt.BackgroundTransparency = 1
timerTxt.Text = "Timer: -"; timerTxt.TextColor3 = C.dim
timerTxt.Font = Enum.Font.Gotham; timerTxt.TextSize = 10
timerTxt.TextXAlignment = Enum.TextXAlignment.Left; timerTxt.ZIndex = 4

local divLine = Instance.new("Frame", mainFrame)
divLine.Size = UDim2.new(1,-16,0,1); divLine.Position = UDim2.new(0,8,0,124)
divLine.BackgroundColor3 = C.border; divLine.BorderSizePixel = 0; divLine.ZIndex = 3

-- Toggle rows
local ROW_H = 34; local ROW_GAP = 4; local ROW_Y = 132
local function mkRow(label, icon, yPos)
    local row = Instance.new("Frame", mainFrame)
    row.Size = UDim2.new(1,-16,0,ROW_H); row.Position = UDim2.new(0,8,0,yPos)
    row.BackgroundColor3 = C.bg1; row.BorderSizePixel = 0; row.ZIndex = 3
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1,-50,1,0); lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = icon .. "  " .. label
    lbl.TextColor3 = C.accent; lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 4
    local pill = Instance.new("TextButton", row)
    pill.Size = UDim2.new(0,38,0,20); pill.Position = UDim2.new(1,-46,0.5,-10)
    pill.BackgroundColor3 = C.off; pill.TextColor3 = C.dim
    pill.Font = Enum.Font.GothamBold; pill.TextSize = 9; pill.Text = "OFF"
    pill.AutoButtonColor = false; pill.BorderSizePixel = 0; pill.ZIndex = 5
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1
    btn.Text = ""; btn.ZIndex = 6
    return pill, btn
end

local function setPill(pill, on)
    pill.BackgroundColor3 = on and C.on  or C.off
    pill.TextColor3       = on and C.bg0 or C.dim
    pill.Text             = on and "ON"  or "OFF"
end

local function rY(i) return ROW_Y + (i-1)*(ROW_H+ROW_GAP) end

local hlPill,   hlBtn   = mkRow("Highlight",    "H",  rY(1))
local spPill,   spBtn   = mkRow("Speed + Jump", "S",  rY(2))
local ncPill,   ncBtn   = mkRow("Noclip",       "N",  rY(3))
local aiPill,   aiBtn   = mkRow("AI Farming",   "AI", rY(4))
local autoPill, autoBtn = mkRow("Auto Collect", "C",  rY(5))
local babyPill, babyBtn = mkRow("Auto Baby",    "B",  rY(6))
setPill(hlPill, true)

local AY = rY(7)
local function mkActBtn(txt, y)
    local b = Instance.new("TextButton", mainFrame)
    b.Size = UDim2.new(1,-16,0,30); b.Position = UDim2.new(0,8,0,y)
    b.BackgroundColor3 = C.bg2; b.TextColor3 = C.accent
    b.Font = Enum.Font.Gotham; b.TextSize = 11; b.Text = txt
    b.AutoButtonColor = false; b.BorderSizePixel = 0; b.ZIndex = 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", b).Color = C.border
    return b
end
local tpBtn      = mkActBtn("Teleport ke Terdekat", AY)
local respawnBtn = mkActBtn("Respawn",               AY + 34)
mainFrame.Size   = UDim2.new(0, 260, 0, AY + 34 + 30 + 14)

local hintTxt = Instance.new("TextLabel", mainFrame)
hintTxt.Size = UDim2.new(1,-16,0,12); hintTxt.Position = UDim2.new(0,8,1,-14)
hintTxt.BackgroundTransparency = 1; hintTxt.Text = "RightCtrl = hide/show"
hintTxt.TextColor3 = Color3.fromRGB(35,35,45); hintTxt.Font = Enum.Font.Gotham
hintTxt.TextSize = 9; hintTxt.TextXAlignment = Enum.TextXAlignment.Left; hintTxt.ZIndex = 3

-- Confirm close
local confirmFrame = Instance.new("Frame", gui)
confirmFrame.Size = UDim2.new(0,220,0,100); confirmFrame.Position = UDim2.new(0.5,-110,0.5,-50)
confirmFrame.BackgroundColor3 = C.bg1; confirmFrame.BorderSizePixel = 0
confirmFrame.Visible = false; confirmFrame.ZIndex = 20
Instance.new("UICorner", confirmFrame).CornerRadius = UDim.new(0,12)
Instance.new("UIStroke", confirmFrame).Color = C.red

local cTxt = Instance.new("TextLabel", confirmFrame)
cTxt.Size = UDim2.new(1,-16,0,40); cTxt.Position = UDim2.new(0,8,0,10)
cTxt.BackgroundTransparency = 1
cTxt.Text = "Tutup semua fitur?\nWindow tidak bisa dibuka lagi."
cTxt.TextColor3 = C.accent; cTxt.Font = Enum.Font.Gotham
cTxt.TextSize = 11; cTxt.TextWrapped = true; cTxt.ZIndex = 21

local cYes = Instance.new("TextButton", confirmFrame)
cYes.Size = UDim2.new(0.45,0,0,26); cYes.Position = UDim2.new(0.05,0,0,60)
cYes.BackgroundColor3 = Color3.fromRGB(40,12,12); cYes.TextColor3 = C.red
cYes.Font = Enum.Font.GothamBold; cYes.TextSize = 11; cYes.Text = "Tutup"
cYes.BorderSizePixel = 0; cYes.ZIndex = 22
Instance.new("UICorner", cYes).CornerRadius = UDim.new(0,6)

local cNo = Instance.new("TextButton", confirmFrame)
cNo.Size = UDim2.new(0.45,0,0,26); cNo.Position = UDim2.new(0.5,0,0,60)
cNo.BackgroundColor3 = C.bg2; cNo.TextColor3 = C.accent
cNo.Font = Enum.Font.GothamBold; cNo.TextSize = 11; cNo.Text = "Batal"
cNo.BorderSizePixel = 0; cNo.ZIndex = 22
Instance.new("UICorner", cNo).CornerRadius = UDim.new(0,6)

-- ================================================================
--  UI UPDATERS
-- ================================================================
local function updateStatus(t, col)
    statusTxt.Text       = t or ""
    statusTxt.TextColor3 = col or C.dim
end
local function updateCount(n)
    evTxt.Text = "Evidence: " .. n .. "/" .. CFG.maxEvidence
end
local function updateCycle(n)
    cycleTxt.Text = "Siklus: " .. n
end
local function updateTimer(t)
    timerTxt.Text = "Timer: " .. math.floor(t) .. "s"
end

-- ================================================================
--  MINIMIZE / CLOSE
-- ================================================================
local MINIMIZED = false
local function setMin(v)
    MINIMIZED = v
    mainFrame.Visible      = not v
    floatContainer.Visible = v
end
minBtn.MouseButton1Click:Connect(function() setMin(true) end)
floatBtn.MouseButton1Click:Connect(function() setMin(false) end)

local function shutdown()
    CLOSED = true; AI_ON = false; SPEED_ON = false
    NOCLIP_ON = false; HL_ON = false
    stopNoclip(); clearHighlights(); resetSpeed()
    if speedConn  then speedConn:Disconnect()  end
    if noclipConn then noclipConn:Disconnect() end
    gui:Destroy()
end
closeBtn.MouseButton1Click:Connect(function() confirmFrame.Visible = true end)
cYes.MouseButton1Click:Connect(function() confirmFrame.Visible = false; shutdown() end)
cNo.MouseButton1Click:Connect(function() confirmFrame.Visible = false end)

UserInputService.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightControl and not CLOSED then
        if MINIMIZED then setMin(false)
        else mainFrame.Visible = not mainFrame.Visible end
    end
end)

-- ================================================================
--  TOGGLES
-- ================================================================
hlBtn.MouseButton1Click:Connect(function()
    HL_ON = not HL_ON; setPill(hlPill, HL_ON)
    if not HL_ON then clearHighlights() end
end)
spBtn.MouseButton1Click:Connect(function()
    SPEED_ON = not SPEED_ON; setPill(spPill, SPEED_ON)
    if not SPEED_ON then resetSpeed() end
end)
ncBtn.MouseButton1Click:Connect(function()
    NOCLIP_ON = not NOCLIP_ON; setPill(ncPill, NOCLIP_ON)
    if not NOCLIP_ON then stopNoclip() end
end)
babyBtn.MouseButton1Click:Connect(function()
    BABY_ON = not BABY_ON; setPill(babyPill, BABY_ON)
end)
autoBtn.MouseButton1Click:Connect(function()
    AUTO_COLLECT = not AUTO_COLLECT; setPill(autoPill, AUTO_COLLECT)
end)
tpBtn.MouseButton1Click:Connect(function()
    if #foundModels == 0 then return end
    local h = getHRP(); if not h then return end
    local best, bestD = nil, math.huge
    for _, m in ipairs(foundModels) do
        local bp = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart", true)
        if bp then
            local d = (bp.Position - h.Position).Magnitude
            if d < bestD then best = bp; bestD = d end
        end
    end
    if best then h.CFrame = CFrame.new(best.Position + Vector3.new(0,4,0)) end
end)
respawnBtn.MouseButton1Click:Connect(doRespawn)

-- ================================================================
--  MAIN AI — PURE TELEPORT
-- ================================================================
local function runAI()
    collected  = 0
    cycleCount = 0
    updateCount(0)
    updateCycle(0)
    updateStatus("AI start - pure TP mode", C.info)
    task.wait(1)

    while AI_ON do
        if CLOSED then break end

        local cycleStart = tick()
        cycleCount += 1
        updateCycle(cycleCount)

        -- ════════════════════════════════
        --  STEP 1: TP ke lift Lobby + klik
        -- ════════════════════════════════
        updateStatus("Step 1: Cari lift Lobby...", C.info)
        local liftPr, liftPos = findPromptByText("Lobby")
        if not liftPr then
            updateStatus("Lift Lobby tidak ditemukan, tunggu...", C.warn)
            task.wait(3); continue
        end

        tpTo(liftPos)
        updateStatus("Klik lift Lobby...", C.info)
        firePrompt(liftPr)
        task.wait(CFG.liftWait)
        if not AI_ON then break end

        -- ════════════════════════════════
        --  STEP 2: Collect di Lobby (TP per item)
        -- ════════════════════════════════
        updateStatus("Step 2: Collect evidence di Lobby...", C.ok)
        collected = 0
        updateCount(0)

        local maxAttempts = 30  -- batas loop biar tidak infinite
        local attempt     = 0

        while collected < CFG.maxEvidence and AI_ON do
            if CLOSED then break end
            attempt += 1
            if attempt > maxAttempts then
                updateStatus("Max attempt tercapai, lanjut deposit", C.warn)
                break
            end

            local folder = getEvidenceFolder()
            if not folder then
                updateStatus("Folder evidence tidak ada", C.warn)
                task.wait(1); continue
            end

            -- Kumpulkan semua evidence yang ada
            local evList = {}
            local hrpNow = getHRP()
            for _, model in ipairs(folder:GetChildren()) do
                local pr = getPromptFromModel(model)
                if pr then
                    local bp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
                    if bp then
                        local d = hrpNow and (bp.Position - hrpNow.Position).Magnitude or 0
                        table.insert(evList, {pr=pr, pos=bp.Position, d=d, name=model.Name})
                    end
                end
            end

            if #evList == 0 then
                updateStatus("Evidence habis, tunggu spawn...", C.warn)
                task.wait(2); continue
            end

            -- Sort by jarak
            table.sort(evList, function(a, b) return a.d < b.d end)
            local ev = evList[1]

            updateStatus(string.format("Collect [%d/%d]: %s", collected+1, CFG.maxEvidence, ev.name), C.ok)

            -- TP ke evidence
            tpTo(ev.pos)
            task.wait(0.1)

            -- Fire prompt
            local ok = pcall(function() fireproximityprompt(ev.pr) end)
            if ok then
                collected += 1
                updateCount(collected)
            end

            task.wait(CFG.collectDelay)
        end

        if not AI_ON then break end

        -- ════════════════════════════════
        --  STEP 3: TP ke lift Facility + klik
        -- ════════════════════════════════
        updateStatus("Step 3: Cari lift Facility...", C.info)
        local facPr, facPos = findPromptByText("Facility")
        if not facPr then
            updateStatus("Lift Facility tidak ditemukan, tunggu...", C.warn)
            task.wait(3)
        else
            tpTo(facPos)
            updateStatus("Klik lift Facility...", C.info)
            firePrompt(facPr)
            task.wait(CFG.liftWait)
        end

        if not AI_ON then break end

        -- ════════════════════════════════
        --  STEP 4: TP ke Deposit Evidence + klik
        -- ════════════════════════════════
        updateStatus("Step 4: Cari Deposit Evidence...", C.info)
        local depPr, depPos = findPromptByText("Deposit Evidence")
        if not depPr then
            updateStatus("Deposit prompt tidak ditemukan, tunggu...", C.warn)
            task.wait(3)
        else
            tpTo(depPos)
            updateStatus("Deposit " .. collected .. " evidence...", C.ok)
            task.wait(0.3)
            firePrompt(depPr)
            task.wait(CFG.depositWait)
            updateStatus("Deposit selesai!", C.ok)
        end

        if not AI_ON then break end

        -- ════════════════════════════════
        --  Pastikan minimal 30 detik per siklus
        -- ════════════════════════════════
        local elapsed = tick() - cycleStart
        local remaining = CFG.minCycleTime - elapsed

        if remaining > 0 then
            updateStatus(string.format("Cooldown %.0fs...", remaining), C.warn)
            local endTime = tick() + remaining
            while tick() < endTime and AI_ON do
                updateTimer(endTime - tick())
                task.wait(0.5)
            end
        end

        timerTxt.Text = "Timer: -"
        collected = 0
        updateCount(0)
        task.wait(0.5)
    end

    updateStatus("AI stop", C.dim)
    updateMiniAI()
end

-- ================================================================
--  AI TOGGLE
-- ================================================================
local function toggleAI()
    AI_ON = not AI_ON
    setPill(aiPill, AI_ON)
    updateMiniAI()
    if AI_ON then
        updateStatus("AI aktif - TP Mode", C.info)
        task.spawn(runAI)
    else
        updateStatus("AI stop", C.dim)
        timerTxt.Text = "Timer: -"
    end
end
aiBtn.MouseButton1Click:Connect(toggleAI)
miniAiBtn.MouseButton1Click:Connect(toggleAI)

-- ================================================================
--  SCAN LOOP (highlight saja)
-- ================================================================
task.spawn(function()
    while true do
        task.wait(0.5)
        if CLOSED then break end
        local h = getHRP(); if not h or not h.Parent then task.wait(1); continue end
        local folder = getEvidenceFolder(); if not folder then continue end

        clearHighlights(); foundModels = {}
        local nearest, bestD = nil, math.huge
        for _, model in ipairs(folder:GetChildren()) do
            local pr = getPromptFromModel(model)
            if pr then
                local bp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
                if bp then
                    local d = (bp.Position - h.Position).Magnitude
                    if d <= 15000 then
                        table.insert(foundModels, model)
                        if d < bestD then nearest = model; bestD = d end
                        if AUTO_COLLECT and not AI_ON then
                            pcall(function() fireproximityprompt(pr) end)
                        end
                    end
                end
            end
        end
        if HL_ON then
            for _, m in ipairs(foundModels) do addHighlight(m, m == nearest) end
        end
    end
end)

-- ================================================================
--  RESPAWN
-- ================================================================
LP.CharacterAdded:Connect(function(char)
    task.wait(1.5)
    if SPEED_ON then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.WalkSpeed    = CFG.speed
            hum.JumpPower    = CFG.jumpPower
        end
    end
end)

-- ================================================================
--  INIT
-- ================================================================
updateStatus("Ready - v12 Pure TP", C.ok)
updateMiniAI()
