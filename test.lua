local Players            = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local UserInputService   = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local character   = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local function resolveHRP(char)
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
end
local function resolveHum(char)
    return char:FindFirstChildOfClass("Humanoid")
end

-- State
local AI_ON       = false
local AI_STATE    = "IDLE"
local COL_COUNT   = 0
local MAX_COL     = 8

-- Prompt & posisi tersimpan
local savedPrompts = {
    deposit  = nil,
    lobby    = nil,
    facility = nil,
}
local savedPos = {
    deposit  = nil,
    lobby    = nil,
    facility = nil,
}

-- =============================================
-- GUI
-- =============================================
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name         = "AIFarming"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size             = UDim2.new(0, 300, 0, 480)
frame.Position         = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local accent = Instance.new("Frame", frame)
accent.Size             = UDim2.new(1, 0, 0, 3)
accent.BackgroundColor3 = Color3.fromRGB(30, 180, 120)
accent.BorderSizePixel  = 0
accent.ZIndex           = 5
Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 12)

local titleBar = Instance.new("Frame", frame)
titleBar.Size             = UDim2.new(1, 0, 0, 40)
titleBar.Position         = UDim2.new(0, 0, 0, 3)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
titleBar.BorderSizePixel  = 0
titleBar.ZIndex           = 4

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size            = UDim2.new(1, -12, 0, 21)
titleLbl.Position        = UDim2.new(0, 12, 0, 4)
titleLbl.BackgroundTransparency = 1
titleLbl.TextColor3      = Color3.fromRGB(255,255,255)
titleLbl.Font            = Enum.Font.GothamBold
titleLbl.TextSize        = 14
titleLbl.TextXAlignment  = Enum.TextXAlignment.Left
titleLbl.Text            = "🧠  AI Farming"
titleLbl.ZIndex          = 5

local subLbl = Instance.new("TextLabel", titleBar)
subLbl.Size            = UDim2.new(1, -12, 0, 13)
subLbl.Position        = UDim2.new(0, 12, 0, 24)
subLbl.BackgroundTransparency = 1
subLbl.TextColor3      = Color3.fromRGB(30, 180, 120)
subLbl.Font            = Enum.Font.Gotham
subLbl.TextSize        = 11
subLbl.TextXAlignment  = Enum.TextXAlignment.Left
subLbl.Text            = "by menzcreate  •  discord: menzcreate"
subLbl.ZIndex          = 5

-- Status bar
local statusBar = Instance.new("Frame", frame)
statusBar.Size             = UDim2.new(1, -16, 0, 28)
statusBar.Position         = UDim2.new(0, 8, 0, 50)
statusBar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
statusBar.BorderSizePixel  = 0
statusBar.ZIndex           = 3
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0, 7)

local statusLbl = Instance.new("TextLabel", statusBar)
statusLbl.Size               = UDim2.new(1, -10, 1, 0)
statusLbl.Position           = UDim2.new(0, 8, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.TextColor3         = Color3.fromRGB(160,160,180)
statusLbl.Font               = Enum.Font.Gotham
statusLbl.TextSize           = 11
statusLbl.TextXAlignment     = Enum.TextXAlignment.Left
statusLbl.Text               = "Idle"
statusLbl.ZIndex             = 4

-- Collect counter
local countBar = Instance.new("Frame", frame)
countBar.Size             = UDim2.new(1, -16, 0, 22)
countBar.Position         = UDim2.new(0, 8, 0, 84)
countBar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
countBar.BorderSizePixel  = 0
countBar.ZIndex           = 3
Instance.new("UICorner", countBar).CornerRadius = UDim.new(0, 7)

local countLbl = Instance.new("TextLabel", countBar)
countLbl.Size               = UDim2.new(1, -10, 1, 0)
countLbl.Position           = UDim2.new(0, 8, 0, 0)
countLbl.BackgroundTransparency = 1
countLbl.TextColor3         = Color3.fromRGB(80, 220, 130)
countLbl.Font               = Enum.Font.GothamBold
countLbl.TextSize           = 11
countLbl.TextXAlignment     = Enum.TextXAlignment.Left
countLbl.Text               = "Evidence: 0 / 8"
countLbl.ZIndex             = 4

-- Saved positions panel
local posPanel = Instance.new("Frame", frame)
posPanel.Size             = UDim2.new(1, -16, 0, 76)
posPanel.Position         = UDim2.new(0, 8, 0, 112)
posPanel.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
posPanel.BorderSizePixel  = 0
posPanel.ZIndex           = 3
Instance.new("UICorner", posPanel).CornerRadius = UDim.new(0, 8)

local posPad = Instance.new("UIPadding", posPanel)
posPad.PaddingLeft  = UDim.new(0, 8)
posPad.PaddingTop   = UDim.new(0, 6)

local posTitle = Instance.new("TextLabel", posPanel)
posTitle.Size               = UDim2.new(1, -10, 0, 16)
posTitle.BackgroundTransparency = 1
posTitle.TextColor3         = Color3.fromRGB(120,120,140)
posTitle.Font               = Enum.Font.GothamBold
posTitle.TextSize           = 11
posTitle.TextXAlignment     = Enum.TextXAlignment.Left
posTitle.Text               = "Prompt Status:"
posTitle.ZIndex             = 4

local function makePosLabel(posY, label)
    local l = Instance.new("TextLabel", posPanel)
    l.Position           = UDim2.new(0, 0, 0, posY)
    l.Size               = UDim2.new(1, -8, 0, 16)
    l.BackgroundTransparency = 1
    l.TextColor3         = Color3.fromRGB(100,100,120)
    l.Font               = Enum.Font.Gotham
    l.TextSize           = 11
    l.TextXAlignment     = Enum.TextXAlignment.Left
    l.Text               = "  ❌  " .. label
    l.ZIndex             = 4
    return l
end

local posDeposit  = makePosLabel(20, "Deposit Evidence")
local posLobby    = makePosLabel(38, "Lobby (Lift)")
local posFacility = makePosLabel(56, "Facility (Lift)")

-- Buttons
local function newBtn(text, posY, col)
    local b = Instance.new("TextButton", frame)
    b.Size             = UDim2.new(1, -16, 0, 32)
    b.Position         = UDim2.new(0, 8, 0, posY)
    b.BackgroundColor3 = col
    b.TextColor3       = Color3.new(1,1,1)
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 12
    b.Text             = text
    b.AutoButtonColor  = false
    b.BorderSizePixel  = 0
    b.ZIndex           = 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local C_TEAL  = Color3.fromRGB(15, 130, 90)
local C_GREY  = Color3.fromRGB(32, 32, 42)
local C_AMBER = Color3.fromRGB(160, 110, 10)
local C_RED   = Color3.fromRGB(160, 25, 25)
local C_BLUE  = Color3.fromRGB(20, 70, 160)

local btnScan    = newBtn("🔍  Scan Prompt Otomatis",    196, C_TEAL)
local btnDeposit = newBtn("📍  Simpan: Deposit Evidence", 234, C_GREY)
local btnLobby   = newBtn("📍  Simpan: Lobby Lift",       272, C_GREY)
local btnFacility = newBtn("📍  Simpan: Facility Lift",   310, C_GREY)
local btnAI      = newBtn("🧠  AI Farming  :  OFF",       352, C_GREY)
local btnStop    = newBtn("⏹  Stop",                      394, C_RED)

local hintLbl = Instance.new("TextLabel", frame)
hintLbl.Size               = UDim2.new(1,-16,0,14)
hintLbl.Position           = UDim2.new(0,8,1,-16)
hintLbl.BackgroundTransparency = 1
hintLbl.TextColor3         = Color3.fromRGB(50,50,65)
hintLbl.Font               = Enum.Font.Gotham
hintLbl.TextSize            = 10
hintLbl.TextXAlignment     = Enum.TextXAlignment.Left
hintLbl.Text               = "RightCtrl = hide/show"
hintLbl.ZIndex             = 3

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)

-- =============================================
-- Helpers
-- =============================================
local function setStatus(text, col)
    statusLbl.Text       = text
    statusLbl.TextColor3 = col or Color3.fromRGB(160,160,180)
end

local function setCount(n)
    countLbl.Text = "Evidence: " .. n .. " / " .. MAX_COL
end

local function updatePosLabel(lbl, found)
    local cur = lbl.Text
    local name = cur:sub(6)
    lbl.Text      = (found and "  ✅  " or "  ❌  ") .. name
    lbl.TextColor3 = found
        and Color3.fromRGB(80,220,130)
        or  Color3.fromRGB(100,100,120)
end

local function setBtnSaved(btn, saved)
    btn.BackgroundColor3 = saved and C_TEAL or C_GREY
end

-- =============================================
-- Cari prompt di workspace
-- =============================================
local function findPromptByText(text)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            if obj.ActionText == text or obj.ObjectText == text then
                local part = obj:FindFirstAncestorWhichIsA("BasePart")
                if not part then
                    local mdl = obj:FindFirstAncestorWhichIsA("Model")
                    if mdl then part = mdl.PrimaryPart or mdl:FindFirstChildWhichIsA("BasePart",true) end
                end
                if part then return obj, part.Position end
            end
        end
    end
    return nil, nil
end

local function getPromptFromModel(model)
    for _, desc in ipairs(model:GetDescendants()) do
        if desc:IsA("ProximityPrompt") then
            local at = string.lower(desc.ActionText)
            local ot = string.lower(desc.ObjectText)
            if at == "collect" or ot == "collect" then return desc end
        end
    end
end

local function getInstancesFolder()
    local ok, res = pcall(function()
        return workspace
            :WaitForChild("Data", 5)
            :WaitForChild("Detective", 5)
            :WaitForChild("Evidence", 5)
            :WaitForChild("Instances", 5)
    end)
    return ok and res or nil
end

-- =============================================
-- Scan otomatis
-- =============================================
local function doScan()
    setStatus("🔍 Scanning prompt...", Color3.fromRGB(80,180,255))

    local p1, pos1 = findPromptByText("Deposit Evidence")
    if p1 then
        savedPrompts.deposit = p1
        savedPos.deposit     = pos1
        updatePosLabel(posDeposit, true)
        setBtnSaved(btnDeposit, true)
    else
        updatePosLabel(posDeposit, false)
    end

    local p2, pos2 = findPromptByText("Lobby")
    if p2 then
        savedPrompts.lobby = p2
        savedPos.lobby     = pos2
        updatePosLabel(posLobby, true)
        setBtnSaved(btnLobby, true)
    else
        updatePosLabel(posLobby, false)
    end

    local p3, pos3 = findPromptByText("Facility")
    if p3 then
        savedPrompts.facility = p3
        savedPos.facility     = pos3
        updatePosLabel(posFacility, true)
        setBtnSaved(btnFacility, true)
    else
        updatePosLabel(posFacility, false)
    end

    local found = (p1 and 1 or 0) + (p2 and 1 or 0) + (p3 and 1 or 0)
    setStatus("✅ Scan selesai: " .. found .. "/3 ditemukan",
        found == 3 and Color3.fromRGB(80,220,130) or Color3.fromRGB(255,200,60))
end

-- Simpan manual (dari posisi player sekarang)
local function saveManual(key, lbl, btn, displayName)
    local hrp2 = resolveHRP(LocalPlayer.Character)
    if not hrp2 then return end

    -- Cari prompt terdekat dengan text yang cocok
    local bestPrompt, bestPos, bestDist = nil, nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            if obj.ActionText == displayName or obj.ObjectText == displayName then
                local part = obj:FindFirstAncestorWhichIsA("BasePart")
                if part then
                    local d = (part.Position - hrp2.Position).Magnitude
                    if d < bestDist then
                        bestPrompt = obj
                        bestPos    = part.Position
                        bestDist   = d
                    end
                end
            end
        end
    end

    if bestPrompt then
        savedPrompts[key] = bestPrompt
        savedPos[key]     = bestPos
        updatePosLabel(lbl, true)
        setBtnSaved(btn, true)
        setStatus("✅ Saved: " .. displayName, Color3.fromRGB(80,220,130))
    else
        setStatus("⚠ Tidak ada prompt '" .. displayName .. "' terdekat", Color3.fromRGB(255,80,80))
    end
end

btnScan.MouseButton1Click:Connect(doScan)
btnDeposit.MouseButton1Click:Connect(function()
    saveManual("deposit", posDeposit, btnDeposit, "Deposit Evidence")
end)
btnLobby.MouseButton1Click:Connect(function()
    saveManual("lobby", posLobby, btnLobby, "Lobby")
end)
btnFacility.MouseButton1Click:Connect(function()
    saveManual("facility", posFacility, btnFacility, "Facility")
end)

-- =============================================
-- Pathfinding
-- =============================================
local function walkTo(targetPos, label)
    local char = LocalPlayer.Character
    local hum  = resolveHum(char)
    local hrp2 = resolveHRP(char)
    if not hum or not hrp2 then return false end

    setStatus("🚶 " .. (label or "berjalan..."), Color3.fromRGB(80,180,255))

    local path = PathfindingService:CreatePath({
        AgentRadius   = 2,
        AgentHeight   = 5,
        AgentCanJump  = true,
        AgentCanClimb = true,
        WaypointSpacing = 4,
    })

    local ok = pcall(function() path:ComputeAsync(hrp2.Position, targetPos) end)
    if not ok or path.Status ~= Enum.PathStatus.Success then
        -- Fallback
        hum:MoveTo(targetPos)
        hum.MoveToFinished:Wait(5)
        return true
    end

    for _, wp in ipairs(path:GetWaypoints()) do
        if not AI_ON then return false end
        if wp.Action == Enum.PathWaypointAction.Jump then
            hum.Jump = true
        end
        hum:MoveTo(wp.Position)
        local done = hum.MoveToFinished:Wait(3)
        if not done then
            hum.Jump = true
            task.wait(0.3)
        end
    end
    return true
end

-- =============================================
-- Collect phase
-- =============================================
local function collectPhase()
    local folder = getInstancesFolder()
    if not folder then
        setStatus("⚠ Folder evidence tidak ada", Color3.fromRGB(255,80,80))
        return
    end

    while COL_COUNT < MAX_COL and AI_ON do
        local hrp2 = resolveHRP(LocalPlayer.Character)
        if not hrp2 then break end

        -- Kumpulkan targets
        local targets = {}
        for _, model in ipairs(folder:GetChildren()) do
            local prompt = getPromptFromModel(model)
            if prompt then
                local bp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart",true)
                if bp then
                    local d = (bp.Position - hrp2.Position).Magnitude
                    table.insert(targets, {prompt=prompt, pos=bp.Position, dist=d, name=model.Name})
                end
            end
        end

        if #targets == 0 then
            setStatus("📭 Evidence habis di area ini", Color3.fromRGB(255,200,60))
            break
        end

        table.sort(targets, function(a,b) return a.dist < b.dist end)
        local t = targets[1]

        setStatus(string.format("🔍 [%d/%d] → %s", COL_COUNT+1, MAX_COL, t.name), Color3.fromRGB(80,180,255))
        walkTo(t.pos, t.name)
        if not AI_ON then return end
        task.wait(0.3)

        local ok = pcall(function() fireproximityprompt(t.prompt) end)
        if ok then
            COL_COUNT += 1
            setCount(COL_COUNT)
            task.wait(0.5)
        else
            task.wait(0.5)
        end
    end
end

-- =============================================
-- AI State Machine
-- =============================================
local function runAI()
    COL_COUNT = 0
    setCount(0)
    setStatus("🤖 AI dimulai...", Color3.fromRGB(255,220,60))
    task.wait(1)

    while AI_ON do

        -- FASE 1: Cari evidence di island
        AI_STATE = "ISLAND"
        setStatus("🏝 Cari evidence di island...", Color3.fromRGB(80,220,130))
        collectPhase()
        if not AI_ON then break end

        -- Kalau masih kurang, naik ke Lobby
        if COL_COUNT < MAX_COL then
            AI_STATE = "GOING_LOBBY"
            setStatus("🛗 Menuju Lobby lift...", Color3.fromRGB(80,180,255))

            if savedPos.lobby then
                walkTo(savedPos.lobby, "Lobby Lift")
                if not AI_ON then break end
                task.wait(0.5)
                pcall(function() fireproximityprompt(savedPrompts.lobby) end)
                setStatus("🛗 Naik ke Lobby...", Color3.fromRGB(80,180,255))
                task.wait(4) -- tunggu transisi
            end

            -- FASE 2: Cari evidence di Lobby
            AI_STATE = "LOBBY"
            setStatus("🏢 Cari evidence di Lobby...", Color3.fromRGB(80,220,130))
            collectPhase()
            if not AI_ON then break end

            -- Naik Facility balik ke island
            AI_STATE = "GOING_FACILITY"
            setStatus("🛗 Menuju Facility lift...", Color3.fromRGB(80,180,255))

            if savedPos.facility then
                walkTo(savedPos.facility, "Facility Lift")
                if not AI_ON then break end
                task.wait(0.5)
                pcall(function() fireproximityprompt(savedPrompts.facility) end)
                setStatus("🛗 Turun ke island...", Color3.fromRGB(80,180,255))
                task.wait(4)
            end
        end

        if not AI_ON then break end

        -- FASE 3: Deposit
        AI_STATE = "DEPOSIT"
        setStatus("⛵ Menuju Deposit Evidence...", Color3.fromRGB(255,220,60))

        if savedPos.deposit then
            walkTo(savedPos.deposit, "Deposit")
            if not AI_ON then break end
            task.wait(0.5)
            -- Delay anti-validasi server
            setStatus("⏳ Menunggu validasi server...", Color3.fromRGB(255,200,60))
            task.wait(4)
            local ok = pcall(function() fireproximityprompt(savedPrompts.deposit) end)
            setStatus(ok and "✅ Deposit berhasil!" or "❌ Deposit gagal",
                ok and Color3.fromRGB(80,220,130) or Color3.fromRGB(255,80,80))
            task.wait(2)
        end

        -- Reset dan ulangi
        COL_COUNT = 0
        setCount(0)
        setStatus("🔄 Siklus selesai — ulang...", Color3.fromRGB(255,220,60))
        task.wait(2)
    end

    AI_STATE = "IDLE"
    setStatus("⏹ AI dihentikan", Color3.fromRGB(160,160,180))
end

-- =============================================
-- Tombol AI & Stop
-- =============================================
btnAI.MouseButton1Click:Connect(function()
    AI_ON = not AI_ON
    if AI_ON then
        btnAI.Text             = "🧠  AI Farming  :  ON"
        btnAI.BackgroundColor3 = C_AMBER
        task.spawn(runAI)
    else
        AI_ON = false
        btnAI.Text             = "🧠  AI Farming  :  OFF"
        btnAI.BackgroundColor3 = C_GREY
        local char = LocalPlayer.Character
        local hum  = char and resolveHum(char)
        if hum then hum:MoveTo(hum.RootPart.Position) end
    end
end)

btnStop.MouseButton1Click:Connect(function()
    AI_ON = false
    btnAI.Text             = "🧠  AI Farming  :  OFF"
    btnAI.BackgroundColor3 = C_GREY
    local char = LocalPlayer.Character
    local hum  = char and resolveHum(char)
    if hum then hum:MoveTo(hum.RootPart.Position) end
    setStatus("⏹ Dihentikan manual", Color3.fromRGB(160,160,180))
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    character = char
end)

-- Auto scan saat load
task.delay(2, doScan)

setStatus("✅ Ready — scan dulu lalu start AI", Color3.fromRGB(80,220,130))
