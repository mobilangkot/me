-- ================================================================
--  SQUID GAME TOOL v11 — SMART FORWARD-TRACKING AI
--  By menzcreate | discord: menzcreate
-- ================================================================

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
--  WAYPOINTS
-- ================================================================
local WP_ISLAND_TO_LIFT = {
    Vector3.new(-2842.02, -786.00, 15529.18),
    Vector3.new(-2846.11, -786.00, 15466.30),
    Vector3.new(-2833.31, -784.52, 15366.45),
    Vector3.new(-2781.71, -787.00, 15295.65),
    Vector3.new(-2707.08, -786.14, 15253.95),
    Vector3.new(-2621.60, -783.01, 15240.23),
    Vector3.new(-2576.10, -784.10, 15317.57),
    Vector3.new(-2545.14, -787.12, 15411.84),
    Vector3.new(-2491.56, -787.00, 15496.89),
    Vector3.new(-2397.33, -784.45, 15524.12),
    Vector3.new(-2315.92, -787.00, 15565.41),
    Vector3.new(-2307.51, -780.40, 15588.89),
    Vector3.new(-2308.04, -771.05, 15616.46),
    Vector3.new(-2303.03, -767.01, 15656.55),
    Vector3.new(-2263.70, -787.58, 15732.08),
    Vector3.new(-2219.15, -796.91, 15785.29),
    Vector3.new(-2154.50, -819.91, 15846.91),
    Vector3.new(-2105.35, -819.91, 15923.98),
    Vector3.new(-2057.44, -839.85, 15974.76),
    Vector3.new(-2004.69, -859.85, 15921.29),
    Vector3.new(-1987.20, -859.85, 15902.84),
}
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
local WP_ISLAND_BACK = {
    Vector3.new(-1984.38, -859.85, 15899.42),
    Vector3.new(-2016.32, -859.85, 15933.43),
    Vector3.new(-2029.56, -853.96, 15944.76),
    Vector3.new(-2043.25, -845.33, 15955.49),
    Vector3.new(-2058.51, -839.85, 15971.30),
    Vector3.new(-2069.83, -838.64, 15961.96),
    Vector3.new(-2082.45, -829.80, 15949.59),
    Vector3.new(-2092.59, -822.30, 15938.50),
    Vector3.new(-2104.37, -819.91, 15927.43),
    Vector3.new(-2121.75, -819.91, 15884.60),
    Vector3.new(-2164.93, -819.91, 15838.55),
    Vector3.new(-2178.81, -815.22, 15823.58),
    Vector3.new(-2187.16, -809.64, 15811.01),
    Vector3.new(-2207.33, -798.76, 15790.41),
    Vector3.new(-2225.31, -795.43, 15775.74),
    Vector3.new(-2237.65, -788.95, 15763.77),
    Vector3.new(-2258.62, -787.91, 15744.98),
    Vector3.new(-2278.58, -783.43, 15718.80),
    Vector3.new(-2287.15, -776.21, 15701.49),
    Vector3.new(-2295.59, -769.24, 15677.14),
    Vector3.new(-2304.53, -766.94, 15647.01),
    Vector3.new(-2305.65, -771.51, 15611.41),
    Vector3.new(-2322.81, -787.02, 15552.62),
    Vector3.new(-2386.11, -784.93, 15527.34),
    Vector3.new(-2445.95, -783.66, 15525.65),
    Vector3.new(-2511.29, -786.15, 15473.00),
    Vector3.new(-2549.71, -787.01, 15392.79),
    Vector3.new(-2575.29, -784.39, 15323.17),
    Vector3.new(-2603.83, -779.32, 15259.90),
    Vector3.new(-2669.45, -787.00, 15221.66),
    Vector3.new(-2745.30, -786.96, 15276.71),
    Vector3.new(-2814.26, -782.43, 15333.71),
    Vector3.new(-2842.96, -786.00, 15431.43),
    Vector3.new(-2838.73, -786.00, 15522.74),
    Vector3.new(-2869.57, -787.22, 15550.17),
}

-- ================================================================
--  CONFIG
-- ================================================================
local CFG = {
    maxEvidence    = 8,
    collectRadius  = 35,
    wpReach        = 7,
    promptReach    = 8,
    moveTimeout    = 10,
    liftWait       = 10,
    depositWait    = 3,
    speed          = 100,
    jumpPower      = 70,
    lobbyFloorY    = 100.64,
    islandFloorY   = -787.0,
    roofThreshold  = 14,
    -- Lobby bounds
    lobbyXMin = 8090, lobbyXMax = 8235,
    lobbyZMin = 3450, lobbyZMax = 3760,
    lobbyYMin = 70,   lobbyYMax = 135,
}

-- ================================================================
--  ZONE
-- ================================================================
local function getZone(pos)
    if not pos then return "UNKNOWN" end
    if pos.Y >= 50  then return "LOBBY"  end
    if pos.Y <= -100 then return "ISLAND" end
    return "TRANSITION"
end

local function isInLobby(pos)
    if not pos then return false end
    return pos.X >= CFG.lobbyXMin and pos.X <= CFG.lobbyXMax
       and pos.Z >= CFG.lobbyZMin and pos.Z <= CFG.lobbyZMax
       and pos.Y >= CFG.lobbyYMin and pos.Y <= CFG.lobbyYMax
end

local function isOnRoof(pos)
    if not pos then return false end
    local zone = getZone(pos)
    local floor = zone == "LOBBY" and CFG.lobbyFloorY or CFG.islandFloorY
    return (pos.Y - floor) > CFG.roofThreshold
end

-- ================================================================
--  SMART WP FINDER
--  Kunci utama: selalu cari WP terdekat yang LEBIH MAJU dari posisi
--  Kalau game teleport ke WP 20, langsung lanjut dari sana
-- ================================================================
local function findBestWpIndex(arr, pos, currentIdx)
    if not pos then return currentIdx end

    -- Cek apakah kita sudah lompat jauh ke depan (game teleport)
    -- Scan semua WP, cari yang paling dekat dengan posisi sekarang
    local nearestIdx, nearestDist = 1, math.huge
    for i = 1, #arr do
        local d = (arr[i] - pos).Magnitude
        if d < nearestDist then
            nearestDist = d
            nearestIdx  = i
        end
    end

    -- Kalau WP terdekat LEBIH MAJU dari currentIdx → pakai itu
    -- Ini yang fix masalah: game teleport ke WP 20, langsung dari 20
    if nearestIdx > currentIdx then
        return nearestIdx + 1  -- lanjut dari WP berikutnya
    end

    -- Kalau WP terdekat sama atau di belakang → tetap di currentIdx
    -- (tidak mundur, lanjut maju)
    return currentIdx
end

local function nearestIdx(arr, pos)
    local best, bestD = 1, math.huge
    for i = 1, #arr do
        local d = (arr[i] - pos).Magnitude
        if d < bestD then bestD = d; best = i end
    end
    return best
end

-- ================================================================
--  STATE
-- ================================================================
local AI_ON     = false
local aiPhase   = "ISLAND_TO_LIFT"
local aiWpIdx   = 1
local collected = 0
local liftFail  = 0

local SPEED_ON     = false
local NOCLIP_ON    = false
local HL_ON        = true
local BABY_ON      = false
local AUTO_COLLECT = false
local CLOSED       = false

local foundModels      = {}
local highlights       = {}
local autoNoclipActive = false

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
--  NOCLIP — auto enable/disable
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
--  HIGHLIGHT — terang benderang
-- ================================================================
local function clearHighlights()
    for _, h in ipairs(highlights) do pcall(function() h:Destroy() end) end
    highlights = {}
end
local function addHighlight(target, isNearest)
    local h = Instance.new("Highlight")
    h.Parent              = target
    h.FillColor           = isNearest and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(0, 255, 255)
    h.OutlineColor        = isNearest and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(0, 150, 255)
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

local function findPromptByText(text)
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("ProximityPrompt") and (o.ActionText == text or o.ObjectText == text) then
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

local function tpTo(pos, reason)
    local hrp = getHRP(); if not hrp then return end
    if reason then updateStatus("🚨 " .. reason, Color3.fromRGB(220,80,80)) end
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0))
    task.wait(0.35)
end

-- ================================================================
--  SMART PHASE DETECTION
--  Tentukan phase terbaik berdasarkan zona + collected
-- ================================================================
local function detectPhase(pos)
    if not pos then return aiPhase, aiWpIdx end
    local zone = getZone(pos)

    if zone == "LOBBY" then
        if not isInLobby(pos) then
            -- Di lobby zone tapi out of bounds → snap ke lobby WP terdekat
            local idx = nearestIdx(WP_LOBBY, pos)
            tpTo(WP_LOBBY[idx], "Out bounds → snap lobby")
            return collected >= CFG.maxEvidence and "LOBBY_TO_LIFT" or "LOBBY_FARM",
                   math.min(idx + 1, #WP_LOBBY)
        end
        if collected >= CFG.maxEvidence then
            return "LOBBY_TO_LIFT", nearestIdx(WP_LOBBY, pos)
        end
        return "LOBBY_FARM", nearestIdx(WP_LOBBY, pos)

    elseif zone == "ISLAND" then
        if collected >= CFG.maxEvidence then
            return "ISLAND_DEPOSIT", nearestIdx(WP_ISLAND_BACK, pos)
        end
        -- Cek mana yang lebih dekat: route ke lift atau route deposit
        local idxLift = nearestIdx(WP_ISLAND_TO_LIFT, pos)
        local idxBack = nearestIdx(WP_ISLAND_BACK, pos)
        local dLift   = (WP_ISLAND_TO_LIFT[idxLift] - pos).Magnitude
        local dBack   = (WP_ISLAND_BACK[idxBack] - pos).Magnitude
        if aiPhase == "ISLAND_DEPOSIT" and dBack < 200 then
            return "ISLAND_DEPOSIT", idxBack
        end
        return "ISLAND_TO_LIFT", idxLift

    else -- TRANSITION
        -- Cari zone terdekat
        local idxL = nearestIdx(WP_LOBBY, pos)
        local idxI = nearestIdx(WP_ISLAND_TO_LIFT, pos)
        local dL   = (WP_LOBBY[idxL] - pos).Magnitude
        local dI   = (WP_ISLAND_TO_LIFT[idxI] - pos).Magnitude
        if dL < dI then
            return collected >= CFG.maxEvidence and "LOBBY_TO_LIFT" or "LOBBY_FARM", idxL
        end
        return "ISLAND_TO_LIFT", idxI
    end
end

-- ================================================================
--  MOVEMENT — run + auto noclip cepat
-- ================================================================
local function runTo(target, timeout)
    local hu = getHum(); local h = getHRP()
    if not hu or not h then return false end

    local dist = (h.Position - target).Magnitude
    if dist <= CFG.wpReach then return true end

    -- Force speed
    hu.WalkSpeed    = CFG.speed
    hu.UseJumpPower = true
    hu.JumpPower    = CFG.jumpPower
    hu:MoveTo(target)

    local elapsed    = 0
    local limit      = timeout or CFG.moveTimeout
    local lastPos    = h.Position
    local stuckTime  = 0
    local noclipTime = 0

    while elapsed < limit do
        task.wait(0.1); elapsed += 0.1
        if not AI_ON then
            autoNoclipActive = false
            return false
        end

        local cur = getHRP(); if not cur then return false end
        local hu2 = getHum()

        -- Force speed tiap tick
        if hu2 then
            hu2.WalkSpeed    = CFG.speed
            hu2.UseJumpPower = true
            hu2.JumpPower    = CFG.jumpPower
        end

        -- Sampai?
        if (cur.Position - target).Magnitude <= CFG.wpReach then
            autoNoclipActive = false
            if not NOCLIP_ON then applyNoclip(false) end
            return true
        end

        -- Re-issue MoveTo tiap 0.6 detik
        if elapsed % 0.6 < 0.11 then
            if hu2 then hu2:MoveTo(target) end
        end

        local moved = (cur.Position - lastPos).Magnitude

        if moved < 0.5 then
            stuckTime += 0.1

            -- 0.5 detik stuck → langsung noclip
            if stuckTime >= 0.5 and not autoNoclipActive then
                autoNoclipActive = true
                noclipTime       = 0
                updateStatus("👻 Noclip ON", Color3.fromRGB(200,100,255))
            end

            -- Jump tiap 0.8 detik stuck
            if stuckTime >= 0.8 then
                if hu2 then hu2.Jump = true end
            end

            -- 4 detik stuck → teleport langsung
            if stuckTime >= 4 then
                tpTo(target, "Stuck 4s → TP")
                autoNoclipActive = false
                if not NOCLIP_ON then applyNoclip(false) end
                return true
            end
        else
            stuckTime = 0
            -- Bergerak lagi → matikan noclip setelah 0.5 detik bergerak
            if autoNoclipActive then
                noclipTime += 0.1
                if noclipTime >= 0.5 then
                    autoNoclipActive = false
                    noclipTime       = 0
                    if not NOCLIP_ON then applyNoclip(false) end
                    updateStatus("✅ Noclip OFF", Color3.fromRGB(100,220,140))
                end
            end
        end

        lastPos = cur.Position
    end

    -- Timeout: teleport kalau masih jauh
    local final = getHRP()
    if final and (final.Position - target).Magnitude > CFG.wpReach * 4 then
        tpTo(target, "Timeout → TP")
    end
    autoNoclipActive = false
    if not NOCLIP_ON then applyNoclip(false) end
    return false
end

-- ================================================================
--  FIRE PROMPT
-- ================================================================
local function fireAt(prompt, pos)
    if not prompt or not pos then return false end
    local h = getHRP(); if not h then return false end

    local d = (h.Position - pos).Magnitude
    if d > CFG.promptReach * 4 then
        tpTo(pos, "TP ke prompt")
    elseif d > CFG.promptReach then
        local hu = getHum()
        if hu then
            hu.WalkSpeed = CFG.speed
            hu:MoveTo(pos)
            local t = 0
            while t < 4 do
                task.wait(0.1); t += 0.1
                if not AI_ON then return false end
                local cur = getHRP(); if not cur then return false end
                if (cur.Position - pos).Magnitude <= CFG.promptReach then break end
            end
        end
    end

    local hu = getHum(); local h2 = getHRP()
    if hu and h2 then hu:MoveTo(h2.Position) end
    task.wait(0.3)
    if not AI_ON then return false end
    local ok = pcall(function() fireproximityprompt(prompt) end)
    task.wait(0.3)
    return ok
end

-- ================================================================
--  COLLECT NEARBY
-- ================================================================
local function collectNearby()
    if collected >= CFG.maxEvidence then return end
    local folder = getEvidenceFolder(); if not folder then return end
    local h = getHRP(); if not h then return end

    if isOnRoof(h.Position) then
        local zone   = getZone(h.Position)
        local floorY = zone == "LOBBY" and CFG.lobbyFloorY or CFG.islandFloorY
        local hrp = getHRP()
        if hrp then
            hrp.CFrame = CFrame.new(Vector3.new(hrp.Position.X, floorY + 4, hrp.Position.Z))
            task.wait(0.4)
        end
        h = getHRP(); if not h then return end
    end

    local nearby = {}
    for _, model in ipairs(folder:GetChildren()) do
        local pr = getPromptFromModel(model)
        if pr then
            local bp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
            if bp then
                local d = (bp.Position - h.Position).Magnitude
                if d <= CFG.collectRadius then
                    local valid = true
                    if aiPhase == "LOBBY_FARM" or aiPhase == "LOBBY_TO_LIFT" then
                        valid = isInLobby(bp.Position)
                    end
                    if valid then
                        table.insert(nearby, {prompt=pr, pos=bp.Position, d=d, name=model.Name})
                    end
                end
            end
        end
    end

    if #nearby == 0 then return end
    table.sort(nearby, function(a, b) return a.d < b.d end)

    for _, ev in ipairs(nearby) do
        if not AI_ON then return end
        if collected >= CFG.maxEvidence then break end
        updateStatus("📦 " .. ev.name, Color3.fromRGB(100,220,140))
        pcall(function() fireproximityprompt(ev.prompt) end)
        task.wait(0.15)
        if ev.d > 10 then fireAt(ev.prompt, ev.pos) end
        collected += 1
        updateCount(collected)
        task.wait(0.15)
    end
end

-- ================================================================
--  AUTO BABY
-- ================================================================
local function fireAllBaby()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and (obj.ActionText == "Baby" or obj.ObjectText == "Baby") then
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
gui.Name = "SQv11"; gui.ResetOnSpawn = false

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
titleTxt.BackgroundTransparency = 1; titleTxt.Text = "🦑  SQ Tool v11"
titleTxt.TextColor3 = C.accent; titleTxt.Font = Enum.Font.GothamBold
titleTxt.TextSize = 13; titleTxt.TextXAlignment = Enum.TextXAlignment.Left; titleTxt.ZIndex = 4

local subTxt = Instance.new("TextLabel", header)
subTxt.Size = UDim2.new(1,-100,0,12); subTxt.Position = UDim2.new(0,14,0,27)
subTxt.BackgroundTransparency = 1; subTxt.Text = "menzcreate  |  discord: menzcreate"
subTxt.TextColor3 = Color3.fromRGB(100,100,120); subTxt.Font = Enum.Font.Gotham
subTxt.TextSize = 9; subTxt.TextXAlignment = Enum.TextXAlignment.Left; subTxt.ZIndex = 4

local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.new(0,24,0,24); minBtn.Position = UDim2.new(1,-60,0,10)
minBtn.BackgroundColor3 = Color3.fromRGB(28,28,36); minBtn.TextColor3 = C.dim
minBtn.Font = Enum.Font.GothamBold; minBtn.TextSize = 13; minBtn.Text = "–"
minBtn.AutoButtonColor = false; minBtn.BorderSizePixel = 0; minBtn.ZIndex = 5
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,6)

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0,24,0,24); closeBtn.Position = UDim2.new(1,-32,0,10)
closeBtn.BackgroundColor3 = Color3.fromRGB(40,20,20); closeBtn.TextColor3 = C.red
closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 13; closeBtn.Text = "✕"
closeBtn.AutoButtonColor = false; closeBtn.BorderSizePixel = 0; closeBtn.ZIndex = 5
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

local floatContainer = Instance.new("Frame", gui)
floatContainer.Size = UDim2.new(0,44,0,98)
floatContainer.Position = UDim2.new(0,14,0,14)
floatContainer.BackgroundTransparency = 1
floatContainer.Visible = false; floatContainer.ZIndex = 14

local floatBtn = Instance.new("TextButton", floatContainer)
floatBtn.Size = UDim2.new(0,44,0,44)
floatBtn.BackgroundColor3 = C.bg1; floatBtn.TextColor3 = C.accent
floatBtn.Font = Enum.Font.GothamBold; floatBtn.TextSize = 20; floatBtn.Text = "🦑"
floatBtn.AutoButtonColor = false; floatBtn.BorderSizePixel = 0; floatBtn.ZIndex = 15
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", floatBtn).Color = C.border

local miniAiBtn = Instance.new("TextButton", floatContainer)
miniAiBtn.Size = UDim2.new(0,44,0,44); miniAiBtn.Position = UDim2.new(0,0,0,50)
miniAiBtn.BackgroundColor3 = C.off; miniAiBtn.TextColor3 = C.dim
miniAiBtn.Font = Enum.Font.GothamBold; miniAiBtn.TextSize = 18; miniAiBtn.Text = "🤖"
miniAiBtn.AutoButtonColor = false; miniAiBtn.BorderSizePixel = 0; miniAiBtn.ZIndex = 15
Instance.new("UICorner", miniAiBtn).CornerRadius = UDim.new(0,10)
local miniAiStroke = Instance.new("UIStroke", miniAiBtn)
miniAiStroke.Color = C.border; miniAiStroke.Thickness = 1

local function updateMiniAI()
    miniAiBtn.BackgroundColor3 = AI_ON and C.green or C.off
    miniAiStroke.Color         = AI_ON and C.ok    or C.border
end

local statusBar = Instance.new("Frame", mainFrame)
statusBar.Size = UDim2.new(1,-16,0,22); statusBar.Position = UDim2.new(0,8,0,50)
statusBar.BackgroundColor3 = C.bg2; statusBar.BorderSizePixel = 0; statusBar.ZIndex = 3
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0,6)

local statusTxt = Instance.new("TextLabel", statusBar)
statusTxt.Size = UDim2.new(1,-10,1,0); statusTxt.Position = UDim2.new(0,8,0,0)
statusTxt.BackgroundTransparency = 1; statusTxt.Text = "Ready"
statusTxt.TextColor3 = C.dim; statusTxt.Font = Enum.Font.Gotham
statusTxt.TextSize = 10; statusTxt.TextXAlignment = Enum.TextXAlignment.Left; statusTxt.ZIndex = 4

local infoRow = Instance.new("Frame", mainFrame)
infoRow.Size = UDim2.new(1,-16,0,20); infoRow.Position = UDim2.new(0,8,0,76)
infoRow.BackgroundTransparency = 1; infoRow.ZIndex = 3

local evTxt = Instance.new("TextLabel", infoRow)
evTxt.Size = UDim2.new(0.5,0,1,0); evTxt.BackgroundTransparency = 1
evTxt.Text = "Evidence: 0/8"; evTxt.TextColor3 = C.ok
evTxt.Font = Enum.Font.GothamBold; evTxt.TextSize = 10
evTxt.TextXAlignment = Enum.TextXAlignment.Left; evTxt.ZIndex = 4

local phaseTxt = Instance.new("TextLabel", infoRow)
phaseTxt.Size = UDim2.new(0.5,0,1,0); phaseTxt.Position = UDim2.new(0.5,0,0,0)
phaseTxt.BackgroundTransparency = 1; phaseTxt.Text = "—"
phaseTxt.TextColor3 = C.dim; phaseTxt.Font = Enum.Font.Code
phaseTxt.TextSize = 9; phaseTxt.TextXAlignment = Enum.TextXAlignment.Right; phaseTxt.ZIndex = 4

local divLine = Instance.new("Frame", mainFrame)
divLine.Size = UDim2.new(1,-16,0,1); divLine.Position = UDim2.new(0,8,0,100)
divLine.BackgroundColor3 = C.border; divLine.BorderSizePixel = 0; divLine.ZIndex = 3

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

local hlPill,   hlBtn   = mkRow("Highlight",    "◈",  rY(1))
local spPill,   spBtn   = mkRow("Speed + Jump", "⚡", rY(2))
local ncPill,   ncBtn   = mkRow("Noclip",       "◉",  rY(3))
local aiPill,   aiBtn   = mkRow("AI Farming",   "🤖", rY(4))
local autoPill, autoBtn = mkRow("Auto Collect", "📦", rY(5))
local babyPill, babyBtn = mkRow("Auto Baby",    "🍼", rY(6))
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

local confirmFrame = Instance.new("Frame", gui)
confirmFrame.Size = UDim2.new(0,220,0,100); confirmFrame.Position = UDim2.new(0.5,-110,0.5,-50)
confirmFrame.BackgroundColor3 = C.bg1; confirmFrame.BorderSizePixel = 0
confirmFrame.Visible = false; confirmFrame.ZIndex = 20
Instance.new("UICorner", confirmFrame).CornerRadius = UDim.new(0,12)
Instance.new("UIStroke", confirmFrame).Color = C.red

local cTxt = Instance.new("TextLabel", confirmFrame)
cTxt.Size = UDim2.new(1,-16,0,40); cTxt.Position = UDim2.new(0,8,0,10)
cTxt.BackgroundTransparency = 1; cTxt.Text = "Tutup semua fitur?\nWindow tidak bisa dibuka lagi."
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
function updatePhaseUI(p)
    local s = {
        ISLAND_TO_LIFT = "Island→Lift",
        LOBBY_FARM     = "Lobby Farm",
        LOBBY_TO_LIFT  = "Lobby→Lift",
        ISLAND_DEPOSIT = "→Deposit",
    }
    phaseTxt.Text = s[p] or p or "—"
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
--  AI TOGGLE
-- ================================================================
local function toggleAI()
    AI_ON = not AI_ON
    setPill(aiPill, AI_ON); updateMiniAI()
    if AI_ON then
        updateStatus("🤖 AI aktif", C.info)
        task.spawn(runAI)
    else
        autoNoclipActive = false
        if not NOCLIP_ON then applyNoclip(false) end
        local hu = getHum(); local h = getHRP()
        if hu and h then hu:MoveTo(h.Position) end
        updateStatus("⏹ AI stop", C.dim)
        updatePhaseUI(nil)
    end
end
aiBtn.MouseButton1Click:Connect(toggleAI)
miniAiBtn.MouseButton1Click:Connect(toggleAI)

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
    if not AI_ON then return end
    task.wait(1)
    local h = getHRP(); if not h then return end
    local p, w = detectPhase(h.Position)
    aiPhase = p; aiWpIdx = w
    updatePhaseUI(aiPhase)
    updateStatus("🔄 Respawn → " .. aiPhase, C.warn)
end)

-- ================================================================
--  MAIN AI LOOP — FORWARD TRACKING
--  Prinsip: selalu cari WP terdekat yang ada di DEPAN
--  Tidak pernah mundur ke WP yang sudah lewat
-- ================================================================
function runAI()
    task.wait(0.5)

    -- Deteksi phase awal dari posisi sekarang
    local h = getHRP()
    if h then
        local p, w = detectPhase(h.Position)
        aiPhase = p; aiWpIdx = w
    end
    updatePhaseUI(aiPhase); updateCount(collected)
    task.wait(0.3)

    while AI_ON do
        if CLOSED then break end

        local h2 = getHRP()
        if not h2 then task.wait(0.5); continue end

        -- ── Roof fix ──
        if isOnRoof(h2.Position) then
            local zone = getZone(h2.Position)
            local fy   = zone == "LOBBY" and CFG.lobbyFloorY or CFG.islandFloorY
            tpTo(Vector3.new(h2.Position.X, fy, h2.Position.Z), "Di atap")
            task.wait(0.3); continue
        end

        -- ── Auto phase correction ──
        local zone = getZone(h2.Position)
        local needCorrect = false

        if aiPhase == "ISLAND_TO_LIFT" and zone == "LOBBY" then
            -- Sampai lobby! Langsung masuk
            aiPhase = collected >= CFG.maxEvidence and "LOBBY_TO_LIFT" or "LOBBY_FARM"
            aiWpIdx = nearestIdx(WP_LOBBY, h2.Position)
            liftFail = 0
            if aiPhase == "LOBBY_FARM" then collected = 0; updateCount(0) end
            needCorrect = true

        elseif aiPhase == "LOBBY_FARM" and zone == "ISLAND" then
            needCorrect = true
            local p, w = detectPhase(h2.Position); aiPhase = p; aiWpIdx = w

        elseif aiPhase == "LOBBY_FARM" and not isInLobby(h2.Position) then
            -- Keluar bounds → snap kembali
            local snapIdx = nearestIdx(WP_LOBBY, h2.Position)
            tpTo(WP_LOBBY[snapIdx], "Out bounds")
            aiWpIdx = math.min(snapIdx + 1, #WP_LOBBY)
            needCorrect = true

        elseif aiPhase == "LOBBY_TO_LIFT" and zone == "ISLAND" then
            aiPhase = "ISLAND_DEPOSIT"
            aiWpIdx = nearestIdx(WP_ISLAND_BACK, h2.Position)
            liftFail = 0
            needCorrect = true

        elseif aiPhase == "ISLAND_DEPOSIT" and zone == "LOBBY" then
            local p, w = detectPhase(h2.Position); aiPhase = p; aiWpIdx = w
            needCorrect = true

        elseif aiPhase == "LOBBY_FARM" and collected >= CFG.maxEvidence then
            aiPhase = "LOBBY_TO_LIFT"
            aiWpIdx = nearestIdx(WP_LOBBY, h2.Position)
            needCorrect = true
        end

        if needCorrect then
            updatePhaseUI(aiPhase); task.wait(0.1); continue
        end

        updatePhaseUI(aiPhase)

        -- ════════════════════════════════════
        --  ISLAND → LIFT
        -- ════════════════════════════════════
        if aiPhase == "ISLAND_TO_LIFT" then

            if aiWpIdx > #WP_ISLAND_TO_LIFT then
                -- Sudah di ujung route → coba lift
                if liftFail >= 4 then
                    updateStatus("❌ Lift 4x gagal → reset", C.red)
                    aiWpIdx  = nearestIdx(WP_ISLAND_TO_LIFT, h2.Position)
                    liftFail = 0; task.wait(1); continue
                end
                updateStatus("🛗 Lift Lobby (" .. liftFail .. ")", C.info)
                local pr, pos = findPromptByText("Lobby")
                if pr then
                    fireAt(pr, pos)
                    local w = 0
                    while w < CFG.liftWait do
                        task.wait(0.3); w += 0.3
                        if not AI_ON then break end
                        if getZone(getHRP() and getHRP().Position) == "LOBBY" then break end
                    end
                    local nh = getHRP()
                    if nh and getZone(nh.Position) == "LOBBY" then
                        aiPhase = collected >= CFG.maxEvidence and "LOBBY_TO_LIFT" or "LOBBY_FARM"
                        aiWpIdx = nearestIdx(WP_LOBBY, nh.Position)
                        liftFail = 0
                        if aiPhase == "LOBBY_FARM" then collected = 0; updateCount(0) end
                    else
                        liftFail += 1
                        aiWpIdx = math.max(1, #WP_ISLAND_TO_LIFT - 3)
                        task.wait(1)
                    end
                else
                    liftFail += 1
                    aiWpIdx = math.max(1, #WP_ISLAND_TO_LIFT - 4)
                    task.wait(1)
                end
                continue
            end

            -- *** KUNCI: update aiWpIdx ke WP terdekat yang lebih maju ***
            local smartIdx = findBestWpIndex(WP_ISLAND_TO_LIFT, h2.Position, aiWpIdx)
            aiWpIdx = smartIdx

            local target = WP_ISLAND_TO_LIFT[aiWpIdx]
            updateStatus(string.format("🏃 Island→Lift %d/%d  ev%d",
                aiWpIdx, #WP_ISLAND_TO_LIFT, collected), C.info)
            runTo(target, CFG.moveTimeout)
            if not AI_ON then break end
            collectNearby()
            if not AI_ON then break end
            aiWpIdx += 1

        -- ════════════════════════════════════
        --  LOBBY FARMING
        -- ════════════════════════════════════
        elseif aiPhase == "LOBBY_FARM" then

            if collected >= CFG.maxEvidence then
                aiPhase = "LOBBY_TO_LIFT"
                aiWpIdx = nearestIdx(WP_LOBBY, h2.Position)
                continue
            end
            if aiWpIdx > #WP_LOBBY then
                -- Selesai satu putaran, ulang
                aiWpIdx = nearestIdx(WP_LOBBY, h2.Position)
                task.wait(0.5); continue
            end

            local smartIdx = findBestWpIndex(WP_LOBBY, h2.Position, aiWpIdx)
            aiWpIdx = smartIdx

            local target = WP_LOBBY[aiWpIdx]
            updateStatus(string.format("🏃 Farm %d/%d  ev%d/%d",
                aiWpIdx, #WP_LOBBY, collected, CFG.maxEvidence), C.info)
            runTo(target, CFG.moveTimeout)
            if not AI_ON then break end

            -- Bounds check setelah jalan
            local pw = getHRP()
            if pw and not isInLobby(pw.Position) then
                local snapIdx = nearestIdx(WP_LOBBY, pw.Position)
                tpTo(WP_LOBBY[snapIdx], "Keluar bounds post-walk")
                aiWpIdx = math.min(snapIdx + 1, #WP_LOBBY)
                continue
            end

            collectNearby()
            if not AI_ON then break end
            aiWpIdx += 1

        -- ════════════════════════════════════
        --  LOBBY → LIFT FACILITY
        -- ════════════════════════════════════
        elseif aiPhase == "LOBBY_TO_LIFT" then

            if liftFail >= 4 then
                updateStatus("❌ Facility 4x gagal → farm", C.red)
                aiPhase = "LOBBY_FARM"
                aiWpIdx = nearestIdx(WP_LOBBY, h2.Position)
                liftFail = 0; task.wait(1); continue
            end

            if aiWpIdx <= #WP_LOBBY then
                local smartIdx = findBestWpIndex(WP_LOBBY, h2.Position, aiWpIdx)
                aiWpIdx = smartIdx
                updateStatus(string.format("🏃 →Lift %d/%d", aiWpIdx, #WP_LOBBY), C.info)
                runTo(WP_LOBBY[aiWpIdx], CFG.moveTimeout)
                if not AI_ON then break end
                local pw = getHRP()
                if pw and not isInLobby(pw.Position) then
                    local s = nearestIdx(WP_LOBBY, pw.Position)
                    tpTo(WP_LOBBY[s], "Keluar bounds →lift")
                    aiWpIdx = math.min(s + 1, #WP_LOBBY); continue
                end
                aiWpIdx += 1; continue
            end

            updateStatus("🛗 Facility lift (" .. liftFail .. ")", C.info)
            local pr, pos = findPromptByText("Facility")
            if pr then
                fireAt(pr, pos)
                local w = 0
                while w < CFG.liftWait do
                    task.wait(0.3); w += 0.3
                    if not AI_ON then break end
                    if getZone(getHRP() and getHRP().Position) == "ISLAND" then break end
                end
                local nh = getHRP()
                if nh and getZone(nh.Position) == "ISLAND" then
                    aiPhase = "ISLAND_DEPOSIT"
                    aiWpIdx = nearestIdx(WP_ISLAND_BACK, nh.Position)
                    liftFail = 0
                else
                    liftFail += 1
                    aiWpIdx = math.max(33, #WP_LOBBY - 2)
                    task.wait(1)
                end
            else
                liftFail += 1
                aiWpIdx = math.max(33, #WP_LOBBY - 4)
                task.wait(1)
            end
            continue

        -- ════════════════════════════════════
        --  ISLAND → DEPOSIT
        -- ════════════════════════════════════
        elseif aiPhase == "ISLAND_DEPOSIT" then

            local pr, pos = findPromptByText("Deposit Evidence")
            if pr then
                local h3 = getHRP()
                if h3 and (h3.Position - pos).Magnitude > 50 then
                    tpTo(pos, "TP deposit")
                end
                updateStatus("💼 Deposit " .. collected .. " evidence...", C.ok)
                fireAt(pr, pos)
                task.wait(CFG.depositWait)
                if not AI_ON then break end
                collected = 0; updateCount(0)
                aiPhase = "ISLAND_TO_LIFT"
                local hn = getHRP()
                aiWpIdx = nearestIdx(WP_ISLAND_TO_LIFT, hn and hn.Position or WP_ISLAND_TO_LIFT[1])
                liftFail = 0
                updateStatus("✅ Deposit! Siklus baru", C.ok)
                task.wait(1); continue
            end

            if aiWpIdx > #WP_ISLAND_BACK then
                updateStatus("⚠ Deposit tidak ketemu", C.warn)
                aiWpIdx = math.max(1, #WP_ISLAND_BACK - 4)
                task.wait(1.5); continue
            end

            local smartIdx = findBestWpIndex(WP_ISLAND_BACK, h2.Position, aiWpIdx)
            aiWpIdx = smartIdx

            updateStatus(string.format("🏃 →Deposit %d/%d  ev%d",
                aiWpIdx, #WP_ISLAND_BACK, collected), C.info)
            runTo(WP_ISLAND_BACK[aiWpIdx], CFG.moveTimeout)
            if not AI_ON then break end
            aiWpIdx += 1
        end

        task.wait(0.05)
    end

    updateStatus("⏹ AI stop", C.dim); updatePhaseUI(nil)
    autoNoclipActive = false
    if not NOCLIP_ON then applyNoclip(false) end
end

-- ================================================================
--  INIT
-- ================================================================
updateStatus("✅ v11 — Forward Tracking AI", C.ok)
updateMiniAI()
