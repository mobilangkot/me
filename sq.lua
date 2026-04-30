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

-- ================================================================
--  WAYPOINTS LOBBY
-- ================================================================
local WP_LOBBY = {
    Vector3.new(8161.51, 100.58, 3467.29),
    Vector3.new(8161.72, 100.64, 3479.62),
    Vector3.new(8159.29, 100.64, 3511.45),
    Vector3.new(8160.60, 100.64, 3538.66),
    Vector3.new(8162.03, 100.64, 3571.83),
    Vector3.new(8162.13, 100.64, 3604.28),
    Vector3.new(8161.74, 100.84, 3625.52),
    Vector3.new(8160.47, 100.84, 3647.83),
    Vector3.new(8178.13, 100.76, 3647.75),
    Vector3.new(8197.30, 100.62, 3648.46),
    Vector3.new(8212.91, 100.62, 3648.93),
    Vector3.new(8215.57, 100.63, 3652.71),
    Vector3.new(8195.54, 100.63, 3634.16),
    Vector3.new(8185.91, 100.62, 3648.93),
    Vector3.new(8159.49, 100.84, 3650.85),
    Vector3.new(8160.48, 103.26, 3662.38),
    Vector3.new(8160.41, 108.92, 3672.17),
    Vector3.new(8160.95, 113.85, 3680.46),
    Vector3.new(8162.65, 113.82, 3699.50),
    Vector3.new(8188.36, 116.26, 3730.59),
    Vector3.new(8204.80, 117.37, 3744.69),
    Vector3.new(8171.44, 116.26, 3735.82),
    Vector3.new(8162.61, 113.82, 3696.03),
    Vector3.new(8160.81, 100.84, 3650.94),
    Vector3.new(8127.28, 100.84, 3649.91),
    Vector3.new(8126.05, 100.64, 3684.14),
    Vector3.new(8124.43, 100.82, 3639.85),
    Vector3.new(8124.23,  81.48, 3602.05),
    Vector3.new(8117.99,  81.51, 3560.41),
    Vector3.new(8128.44,  81.47, 3546.72),
    Vector3.new(8111.59,  81.47, 3547.93),
    Vector3.new(8122.87,  81.51, 3589.31),
    Vector3.new(8159.56, 100.84, 3648.06),
    Vector3.new(8159.93, 100.64, 3593.18),
    Vector3.new(8157.72, 100.64, 3590.89),
    Vector3.new(8163.13, 100.64, 3587.88),
    Vector3.new(8161.31, 100.64, 3540.46),
    Vector3.new(8160.07, 100.64, 3475.56),
}

-- Posisi tujuan boat dekat island
local ISLAND_BOAT_POS = Vector3.new(-2842.02, -786.00, 15529.18),

-- ================================================================
--  CONFIG
-- ================================================================
local CFG = {
    maxEvidence   = 8,
    collectRadius = 35,
    wpReach       = 7,
    moveTimeout   = 10,
    speed         = 100,
    jumpPower     = 70,
}

-- ================================================================
--  STATE
-- ================================================================
local COLLECT_ON   = false
local SPEED_ON     = false
local NOCLIP_ON    = false
local HL_ON        = true
local BABY_ON      = false
local AUTO_COLLECT = false
local CLOSED       = false

local collected        = 0
local wpIdx            = 1
local autoNoclipActive = false
local foundModels      = {}
local highlights       = {}

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
local function applyNoclip(state)
    local c = LP.Character; if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = not state end
    end
end
local function startNoclip()
    if noclipConn then noclipConn:Disconnect() end
    noclipConn = RunService.Stepped:Connect(function()
        if NOCLIP_ON or autoNoclipActive then
            applyNoclip(true)
        end
    end)
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
local function getPromptFromModel(model)
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            local a = string.lower(d.ActionText)
            local o = string.lower(d.ObjectText)
            if a == "collect" or o == "collect" then return d end
        end
    end
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

local function nearestWpIndex(arr, pos)
    local best, bestD = 1, math.huge
    for i = 1, #arr do
        local d = (arr[i] - pos).Magnitude
        if d < bestD then bestD = d; best = i end
    end
    return best
end

local function doRespawn()
    local c = LP.Character; if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then h.Health = 0 end
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

-- ================================================================
--  BOAT FINDER
--  Cari VehicleSeat/Seat yang ada kata "boat" di nama atau parentnya
--  Lalu gerakkan ke dekat island
-- ================================================================
local function findBoat()
    -- Cek apakah player sedang duduk di seat
    local char = getChar(); if not char then return nil end
    local hrp  = getHRP();  if not hrp  then return nil end

    -- Cek seat via Humanoid.SeatPart
    local hum = getHum()
    if hum and hum.SeatPart then
        local seat = hum.SeatPart
        -- Cek apakah seat atau parentnya ada kata "boat"
        local function hasBoat(obj)
            if not obj then return false end
            if string.lower(obj.Name):find("boat") then return true end
            local parent = obj.Parent
            while parent and parent ~= workspace do
                if string.lower(parent.Name):find("boat") then return true end
                parent = parent.Parent
            end
            return false
        end
        if hasBoat(seat) then
            -- Cari root model boat
            local root = seat
            while root.Parent and root.Parent ~= workspace do
                root = root.Parent
            end
            return root
        end
    end

    -- Fallback: scan workspace untuk seat dekat player
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj.ClassName == "VehicleSeat" or obj.ClassName == "Seat") then
            local nameLower = string.lower(obj.Name)
            local parentLower = obj.Parent and string.lower(obj.Parent.Name) or ""
            if nameLower:find("boat") or parentLower:find("boat") then
                -- Cek apakah player duduk di sini
                if obj.Occupant then
                    local occ = obj.Occupant
                    if occ.Parent == char then
                        local root = obj
                        while root.Parent and root.Parent ~= workspace do
                            root = root.Parent
                        end
                        return root
                    end
                end
            end
        end
    end
    return nil
end

local function moveBoatToIsland()
    local boat = findBoat()
    if not boat then
        updateStatus("Boat tidak ditemukan / tidak sedang duduk", Color3.fromRGB(220,160,60))
        return false
    end

    -- Cari PrimaryPart atau BasePart pertama
    local rootPart = nil
    if boat:IsA("Model") and boat.PrimaryPart then
        rootPart = boat.PrimaryPart
    elseif boat:IsA("BasePart") then
        rootPart = boat
    else
        rootPart = boat:FindFirstChildWhichIsA("BasePart", true)
    end

    if not rootPart then
        updateStatus("Tidak bisa gerak boat - tidak ada BasePart", Color3.fromRGB(220,80,80))
        return false
    end

    -- Simpan offset player dari boat
    local hrp    = getHRP()
    local offset = hrp and (hrp.Position - rootPart.Position) or Vector3.new(0,5,0)

    -- Pindahkan boat ke dekat island
    if boat:IsA("Model") and boat.PrimaryPart then
        boat:SetPrimaryPartCFrame(CFrame.new(ISLAND_BOAT_POS))
    else
        rootPart.CFrame = CFrame.new(ISLAND_BOAT_POS)
    end

    -- Pindahkan player juga supaya tidak terlempar
    if hrp then
        hrp.CFrame = CFrame.new(ISLAND_BOAT_POS + offset)
    end

    updateStatus("Boat dipindah ke dekat island!", Color3.fromRGB(100,200,140))
    return true
end

-- ================================================================
--  MOVEMENT — walk + auto noclip saat stuck
-- ================================================================
local function runTo(target, timeout)
    local hu = getHum(); local h = getHRP()
    if not hu or not h then return false end
    if (h.Position - target).Magnitude <= CFG.wpReach then return true end

    hu.WalkSpeed    = CFG.speed
    hu.UseJumpPower = true
    hu.JumpPower    = CFG.jumpPower
    hu:MoveTo(target)

    local elapsed   = 0
    local limit     = timeout or CFG.moveTimeout
    local lastPos   = h.Position
    local stuckTime = 0
    local noclipT   = 0

    while elapsed < limit do
        task.wait(0.1); elapsed += 0.1
        if not COLLECT_ON then
            autoNoclipActive = false; return false
        end
        local cur = getHRP(); if not cur then return false end
        local hu2 = getHum()
        if hu2 then
            hu2.WalkSpeed    = CFG.speed
            hu2.UseJumpPower = true
            hu2.JumpPower    = CFG.jumpPower
        end
        if (cur.Position - target).Magnitude <= CFG.wpReach then
            autoNoclipActive = false
            if not NOCLIP_ON then applyNoclip(false) end
            return true
        end
        if elapsed % 0.6 < 0.11 then
            if hu2 then hu2:MoveTo(target) end
        end
        local moved = (cur.Position - lastPos).Magnitude
        if moved < 0.5 then
            stuckTime += 0.1
            if stuckTime >= 0.5 and not autoNoclipActive then
                autoNoclipActive = true; noclipT = 0
            end
            if stuckTime >= 0.8 then
                if hu2 then hu2.Jump = true end
            end
            if stuckTime >= 4 then
                local hrp2 = getHRP()
                if hrp2 then hrp2.CFrame = CFrame.new(target + Vector3.new(0,4,0)) end
                task.wait(0.3)
                autoNoclipActive = false
                if not NOCLIP_ON then applyNoclip(false) end
                return true
            end
        else
            stuckTime = 0
            if autoNoclipActive then
                noclipT += 0.1
                if noclipT >= 0.5 then
                    autoNoclipActive = false; noclipT = 0
                    if not NOCLIP_ON then applyNoclip(false) end
                end
            end
        end
        lastPos = cur.Position
    end

    autoNoclipActive = false
    if not NOCLIP_ON then applyNoclip(false) end
    return false
end

-- ================================================================
--  COLLECT NEARBY — khusus lobby
-- ================================================================
local function collectNearby()
    if collected >= CFG.maxEvidence then return end
    local folder = getEvidenceFolder(); if not folder then return end
    local h = getHRP(); if not h then return end

    local nearby = {}
    for _, model in ipairs(folder:GetChildren()) do
        local pr = getPromptFromModel(model)
        if pr then
            local bp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
            if bp then
                local d = (bp.Position - h.Position).Magnitude
                if d <= CFG.collectRadius then
                    table.insert(nearby, {prompt=pr, pos=bp.Position, d=d, name=model.Name})
                end
            end
        end
    end

    if #nearby == 0 then return end
    table.sort(nearby, function(a, b) return a.d < b.d end)

    for _, ev in ipairs(nearby) do
        if not COLLECT_ON then return end
        if collected >= CFG.maxEvidence then break end
        updateStatus("Collect: " .. ev.name, Color3.fromRGB(100,220,140))
        pcall(function() fireproximityprompt(ev.prompt) end)
        task.wait(0.2)
        collected += 1
        updateCount(collected)
        task.wait(0.2)
    end
end

-- ================================================================
--  AUTO COLLECT LOOP — lobby only, pakai WP_LOBBY
-- ================================================================
local function runCollect()
    collected = 0
    updateCount(0)
    wpIdx = 1

    -- Snap ke WP terdekat dulu
    local h0 = getHRP()
    if h0 then wpIdx = nearestWpIndex(WP_LOBBY, h0.Position) end

    updateStatus("Auto collect lobby aktif", Color3.fromRGB(120,160,220))

    while COLLECT_ON do
        if CLOSED then break end

        local h = getHRP()
        if not h then task.wait(0.5); continue end

        -- Reset kalau sudah penuh
        if collected >= CFG.maxEvidence then
            updateStatus("Penuh " .. collected .. "/8 — tunggu deposit manual", Color3.fromRGB(100,200,140))
            task.wait(1); continue
        end

        -- Loop WP
        if wpIdx > #WP_LOBBY then
            wpIdx = 1
        end

        -- Cari WP terdekat yang lebih maju — forward tracking
        local nearIdx = nearestWpIndex(WP_LOBBY, h.Position)
        if nearIdx > wpIdx then wpIdx = nearIdx end

        local target = WP_LOBBY[wpIdx]
        updateStatus(string.format("WP %d/%d  ev%d/8", wpIdx, #WP_LOBBY, collected),
            Color3.fromRGB(120,160,220))

        runTo(target, CFG.moveTimeout)
        if not COLLECT_ON then break end

        collectNearby()
        if not COLLECT_ON then break end

        wpIdx += 1
        task.wait(0.05)
    end

    autoNoclipActive = false
    if not NOCLIP_ON then applyNoclip(false) end
    updateStatus("Auto collect stop", Color3.fromRGB(90,90,100))
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
Instance.new("UIStroke", mainFrame).Color = C.border

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
titleTxt.Text = "SQ Tool v12"
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

-- Float
local floatContainer = Instance.new("Frame", gui)
floatContainer.Size = UDim2.new(0,44,0,44)
floatContainer.Position = UDim2.new(0,14,0,14)
floatContainer.BackgroundTransparency = 1
floatContainer.Visible = false; floatContainer.ZIndex = 14

local floatBtn = Instance.new("TextButton", floatContainer)
floatBtn.Size = UDim2.new(0,44,0,44)
floatBtn.BackgroundColor3 = C.bg1; floatBtn.TextColor3 = C.accent
floatBtn.Font = Enum.Font.GothamBold; floatBtn.TextSize = 14; floatBtn.Text = "SQ"
floatBtn.AutoButtonColor = false; floatBtn.BorderSizePixel = 0; floatBtn.ZIndex = 15
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", floatBtn).Color = C.border

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

-- Info
local infoRow = Instance.new("Frame", mainFrame)
infoRow.Size = UDim2.new(1,-16,0,20); infoRow.Position = UDim2.new(0,8,0,76)
infoRow.BackgroundTransparency = 1; infoRow.ZIndex = 3

local evTxt = Instance.new("TextLabel", infoRow)
evTxt.Size = UDim2.new(1,0,1,0); evTxt.BackgroundTransparency = 1
evTxt.Text = "Evidence: 0/8"; evTxt.TextColor3 = C.ok
evTxt.Font = Enum.Font.GothamBold; evTxt.TextSize = 10
evTxt.TextXAlignment = Enum.TextXAlignment.Left; evTxt.ZIndex = 4

local divLine = Instance.new("Frame", mainFrame)
divLine.Size = UDim2.new(1,-16,0,1); divLine.Position = UDim2.new(0,8,0,100)
divLine.BackgroundColor3 = C.border; divLine.BorderSizePixel = 0; divLine.ZIndex = 3

-- Toggle rows
local ROW_H = 34; local ROW_GAP = 4; local ROW_Y = 108
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

local hlPill,      hlBtn      = mkRow("Highlight",       "H",  rY(1))
local spPill,      spBtn      = mkRow("Speed + Jump",    "S",  rY(2))
local ncPill,      ncBtn      = mkRow("Noclip",          "N",  rY(3))
local collectPill, collectBtn = mkRow("Auto Collect Lobby","C", rY(4))
local autoPill,    autoBtn    = mkRow("Auto Collect Scan","AC", rY(5))
local babyPill,    babyBtn    = mkRow("Auto Baby",       "B",  rY(6))
setPill(hlPill, true)

local AY = rY(7)
local function mkActBtn(txt, y, col)
    local b = Instance.new("TextButton", mainFrame)
    b.Size = UDim2.new(1,-16,0,30); b.Position = UDim2.new(0,8,0,y)
    b.BackgroundColor3 = col or C.bg2; b.TextColor3 = C.accent
    b.Font = Enum.Font.Gotham; b.TextSize = 11; b.Text = txt
    b.AutoButtonColor = false; b.BorderSizePixel = 0; b.ZIndex = 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", b).Color = C.border
    return b
end

local tpBtn      = mkActBtn("Teleport ke Terdekat", AY)
local boatBtn    = mkActBtn("Boat ke Island",        AY + 34, Color3.fromRGB(20,70,140))
local respawnBtn = mkActBtn("Respawn",               AY + 68)
mainFrame.Size   = UDim2.new(0, 260, 0, AY + 68 + 30 + 14)

local hintTxt = Instance.new("TextLabel", mainFrame)
hintTxt.Size = UDim2.new(1,-16,0,12); hintTxt.Position = UDim2.new(0,8,1,-14)
hintTxt.BackgroundTransparency = 1; hintTxt.Text = "RightCtrl = hide/show"
hintTxt.TextColor3 = Color3.fromRGB(35,35,45); hintTxt.Font = Enum.Font.Gotham
hintTxt.TextSize = 9; hintTxt.TextXAlignment = Enum.TextXAlignment.Left; hintTxt.ZIndex = 3

-- Confirm
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
function updateStatus(t, col)
    statusTxt.Text       = t or ""
    statusTxt.TextColor3 = col or C.dim
end
function updateCount(n)
    evTxt.Text = "Evidence: " .. n .. "/" .. CFG.maxEvidence
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
    CLOSED = true; COLLECT_ON = false; SPEED_ON = false
    NOCLIP_ON = false; HL_ON = false; autoNoclipActive = false
    applyNoclip(false); clearHighlights(); resetSpeed()
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
    if not NOCLIP_ON and not autoNoclipActive then applyNoclip(false) end
end)
babyBtn.MouseButton1Click:Connect(function()
    BABY_ON = not BABY_ON; setPill(babyPill, BABY_ON)
end)
autoBtn.MouseButton1Click:Connect(function()
    AUTO_COLLECT = not AUTO_COLLECT; setPill(autoPill, AUTO_COLLECT)
end)

-- Auto Collect Lobby toggle
collectBtn.MouseButton1Click:Connect(function()
    COLLECT_ON = not COLLECT_ON
    setPill(collectPill, COLLECT_ON)
    if COLLECT_ON then
        collected = 0; updateCount(0)
        task.spawn(runCollect)
    else
        updateStatus("Auto collect stop", C.dim)
    end
end)

-- Teleport ke terdekat
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

-- Boat ke island
boatBtn.MouseButton1Click:Connect(function()
    updateStatus("Mencari boat...", C.info)
    moveBoatToIsland()
end)

respawnBtn.MouseButton1Click:Connect(doRespawn)

-- ================================================================
--  SCAN LOOP
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
                        if AUTO_COLLECT and not COLLECT_ON then
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
    if COLLECT_ON then
        task.wait(1)
        collected = 0; updateCount(0)
        task.spawn(runCollect)
    end
end)

-- ================================================================
--  INIT
-- ================================================================
updateStatus("Ready v12", C.ok)
