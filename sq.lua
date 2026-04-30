-- ================================================================
--  SQUID GAME TOOL v9.2 — EMERGENCY TELEPORT EDITION
--  Prinsip: darurat = teleport langsung, bukan jalan-jalan linglung
--  Fix: collect radius normal, atap = teleport turun, nyasar = teleport WP
--  By menzcreate | discord: menzcreate
-- ================================================================

local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer

-- ================================================================
--  CHARACTER HELPERS
-- ================================================================
local function getChar()  return LP.Character end
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
--  ZONE
-- ================================================================
local ZONE_ISLAND_Y_MAX = -100
local ZONE_LOBBY_Y_MIN  =  50

local function getZone(pos)
    if not pos then return "UNKNOWN" end
    if pos.Y >= ZONE_LOBBY_Y_MIN  then return "LOBBY"  end
    if pos.Y <= ZONE_ISLAND_Y_MAX then return "ISLAND" end
    -- TRANSITION: cek jarak ke WP untuk tentukan zona terdekat
    local dLobby, dIsland = math.huge, math.huge
    for _, wp in ipairs(WP_LOBBY) do
        local d = (wp - pos).Magnitude
        if d < dLobby then dLobby = d end
    end
    for _, wp in ipairs(WP_ISLAND_TO_LIFT) do
        local d = (wp - pos).Magnitude
        if d < dIsland then dIsland = d end
    end
    return dLobby < dIsland and "LOBBY" or "ISLAND"
end

local function isInLobbyBounds(pos)
    if not pos then return false end
    return pos.X >= 8095 and pos.X <= 8230
       and pos.Z >= 3455 and pos.Z <= 3760
       and pos.Y >= 75   and pos.Y <= 130
end

-- ================================================================
--  NEAREST WP
-- ================================================================
local function nearestWpIndex(wpArray, pos, fromIdx, toIdx)
    fromIdx = fromIdx or 1
    toIdx   = toIdx   or #wpArray
    local best, bestDist = fromIdx, math.huge
    for i = fromIdx, toIdx do
        local d = (wpArray[i] - pos).Magnitude
        if d < bestDist then bestDist = d; best = i end
    end
    return best
end

-- ================================================================
--  CONFIG
-- ================================================================
local CFG = {
    maxEvidence   = 8,
    collectRadius = 30,   -- radius scan evidence (asli v9)
    promptReach   = 8,
    wpReach       = 7,
    moveTimeout   = 14,
    liftWait      = 9,
    depositWait   = 3,
    stopTimeout   = 0.5,
    scanInterval  = 0.5,
    speed         = 100,
    jumpPower     = 70,
    sanityMaxDist = 250,
    sanityYMin    = -1200,
    sanityYMax    =  500,
    lobbyXMin = 8095, lobbyXMax = 8230,
    lobbyZMin = 3455, lobbyZMax = 3760,
    lobbyYMin = 75,   lobbyYMax = 130,

    -- Y lantai normal untuk tiap zone — dipakai saat deteksi "di atap"
    lobbyFloorY  = 100.64,
    islandFloorY = -787.0,
    -- Toleransi Y: kalau karakter lebih dari ini di atas floor = dianggap di atap
    roofThreshold = 10,
}

-- ================================================================
--  AI STATE
-- ================================================================
local AI_ON        = false
local aiPhase      = "ISLAND_TO_LIFT"
local aiWpIndex    = 1
local collected    = 0
local liftAttempts = 0
local lastSafePhase   = "ISLAND_TO_LIFT"
local lastSafeWpIndex = 1

-- ================================================================
--  FEATURE FLAGS
-- ================================================================
local SPEED_ON     = false
local NOCLIP_ON    = false
local HL_ON        = true
local BABY_ON      = false
local AUTO_COLLECT = false
local CLOSED       = false

local foundModels = {}
local highlights  = {}

-- ================================================================
--  SPEED / NOCLIP
-- ================================================================
local speedConn, noclipConn

local function startSpeedLoop()
    if speedConn then speedConn:Disconnect() end
    speedConn = RunService.Heartbeat:Connect(function()
        if not SPEED_ON then return end
        local c = LP.Character; if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return end
        hum.UseJumpPower = true
        hum.WalkSpeed    = CFG.speed
        hum.JumpPower    = CFG.jumpPower
    end)
end

local function resetSpeed()
    local c = LP.Character; if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return end
    hum.WalkSpeed = 16; hum.JumpPower = 50
end

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

startSpeedLoop()
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
    h.FillColor           = isNearest and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,180,180)
    h.OutlineColor        = isNearest and Color3.fromRGB(255,255,255) or Color3.fromRGB(120,120,120)
    h.FillTransparency    = isNearest and 0.25 or 0.6
    h.OutlineTransparency = 0
    h.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    table.insert(highlights, h)
end

-- ================================================================
--  PROMPT / EVIDENCE HELPERS
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

-- ================================================================
--  TELEPORT DARURAT — INTI DARI FIX INI
--  Langsung pindahkan karakter ke WP aman, tanpa jalan dulu
-- ================================================================
local function emergencyTeleport(targetPos, reason)
    local hrp = getHRP()
    if not hrp then return end
    updateStatus("🚨 " .. (reason or "Darurat") .. " → TP!", Color3.fromRGB(220,60,60))
    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 4, 0))
    task.wait(0.4)  -- beri waktu server acknowledge posisi baru
end

-- Teleport ke WP terdekat untuk phase tertentu, return index WP
local function emergencySnapToPhase(phase, currentPos)
    local arr = nil
    if phase == "LOBBY_FARM" or phase == "LOBBY_TO_LIFT" then
        arr = WP_LOBBY
    elseif phase == "ISLAND_TO_LIFT" then
        arr = WP_ISLAND_TO_LIFT
    elseif phase == "ISLAND_DEPOSIT" then
        arr = WP_ISLAND_BACK
    end
    if not arr then return 1 end

    local idx = nearestWpIndex(arr, currentPos)
    emergencyTeleport(arr[idx], "Snap " .. phase .. " WP" .. idx)
    return idx
end

-- ================================================================
--  CEK APAKAH KARAKTER DI ATAP
--  Bandingkan Y karakter dengan Y floor normal zone-nya
-- ================================================================
local function isOnRoof(pos)
    if not pos then return false end
    local zone = getZone(pos)
    local floorY = (zone == "LOBBY") and CFG.lobbyFloorY or CFG.islandFloorY
    -- Kalau Y karakter jauh DI ATAS floor normal = di atap
    return (pos.Y - floorY) > CFG.roofThreshold
end

-- ================================================================
--  SANITY CHECK
-- ================================================================
local function isSane(pos, phase, wpIdx)
    if not pos then return false, "NO_POS" end
    if pos.Y < CFG.sanityYMin then return false, "FALL_OUT" end
    if pos.Y > CFG.sanityYMax then return false, "TOO_HIGH" end

    local zone = getZone(pos)
    if (phase == "ISLAND_TO_LIFT" or phase == "ISLAND_DEPOSIT") and zone == "LOBBY" then
        return false, "WRONG_ZONE_LOBBY"
    end
    if (phase == "LOBBY_FARM" or phase == "LOBBY_TO_LIFT") and zone == "ISLAND" then
        return false, "WRONG_ZONE_ISLAND"
    end
    if (phase == "LOBBY_FARM" or phase == "LOBBY_TO_LIFT") and zone == "LOBBY" then
        if not isInLobbyBounds(pos) then
            return false, "OUT_LOBBY_BOUNDS"
        end
    end

    local wpArray = nil
    if phase == "ISLAND_TO_LIFT"  then wpArray = WP_ISLAND_TO_LIFT end
    if phase == "LOBBY_FARM"      then wpArray = WP_LOBBY          end
    if phase == "LOBBY_TO_LIFT"   then wpArray = WP_LOBBY          end
    if phase == "ISLAND_DEPOSIT"  then wpArray = WP_ISLAND_BACK    end

    if wpArray and wpIdx and wpIdx >= 1 and wpIdx <= #wpArray then
        local dist = (pos - wpArray[wpIdx]).Magnitude
        if dist > CFG.sanityMaxDist then
            return false, "TOO_FAR:" .. math.floor(dist)
        end
    end

    return true, "OK"
end

-- ================================================================
--  PHASE DETECTION
-- ================================================================
local function detectPhaseFromPosition(pos, prevPhase, prevCollected)
    if not pos then return "ISLAND_TO_LIFT", 1 end
    local zone = getZone(pos)

    if zone == "LOBBY" then
        if prevCollected and prevCollected >= CFG.maxEvidence then
            local idx = nearestWpIndex(WP_LOBBY, pos, 30, #WP_LOBBY)
            return "LOBBY_TO_LIFT", idx
        else
            return "LOBBY_FARM", nearestWpIndex(WP_LOBBY, pos)
        end
    elseif zone == "ISLAND" then
        if prevPhase == "ISLAND_DEPOSIT" or prevPhase == "LOBBY_TO_LIFT" or prevPhase == "LOBBY_FARM" then
            return "ISLAND_DEPOSIT", nearestWpIndex(WP_ISLAND_BACK, pos)
        else
            return "ISLAND_TO_LIFT", nearestWpIndex(WP_ISLAND_TO_LIFT, pos)
        end
    end
    return prevPhase or "ISLAND_TO_LIFT", 1
end

-- ================================================================
--  WALK TO — dengan deteksi stuck, langsung TP kalau stuck lama
-- ================================================================
local function walkTo(target, timeoutSec)
    local hu = getHum(); local h = getHRP()
    if not hu or not h then return false end
    if (h.Position - target).Magnitude <= CFG.wpReach then return true end

    hu:MoveTo(target)

    local t          = 0
    local limit      = timeoutSec or CFG.moveTimeout
    local lastPos    = h.Position
    local stuckTimer = 0

    while t < limit do
        task.wait(0.1); t += 0.1
        if not AI_ON then return false end
        local cur = getHRP(); if not cur then return false end
        if (cur.Position - target).Magnitude <= CFG.wpReach then return true end

        if t % 1.0 < 0.11 then
            local hu2 = getHum()
            if hu2 then hu2:MoveTo(target) end
        end

        local moved = (cur.Position - lastPos).Magnitude
        if moved < 0.4 then
            stuckTimer += 0.1
            if stuckTimer >= 2.0 then
                -- Coba jump dulu
                local hu2 = getHum()
                if hu2 then hu2.Jump = true end
                stuckTimer = 0
            end
            -- Kalau stuck lebih dari 5 detik → teleport langsung ke target
            if stuckTimer == 0 and t > 5 and (cur.Position - target).Magnitude > CFG.wpReach * 2 then
                emergencyTeleport(target, "Stuck >5s")
                return true
            end
        else
            stuckTimer = 0
        end
        lastPos = cur.Position
    end

    -- Timeout habis → teleport langsung ke target daripada linglung
    local finalHrp = getHRP()
    if finalHrp and (finalHrp.Position - target).Magnitude > CFG.wpReach * 3 then
        emergencyTeleport(target, "Timeout TP")
    end
    return false
end

-- ================================================================
--  FIRE PROMPT
-- ================================================================
local function firePromptAt(prompt, pos)
    if not prompt or not pos then return false end
    local hu = getHum(); local h = getHRP()
    if not hu or not h then return false end

    if (h.Position - pos).Magnitude > CFG.promptReach then
        -- Kalau jauh → teleport langsung ke sana, bukan jalan
        local hrp = getHRP()
        if hrp and (hrp.Position - pos).Magnitude > CFG.promptReach * 3 then
            emergencyTeleport(pos, "TP ke prompt")
        else
            hu:MoveTo(pos)
            local t = 0
            while t < 5 do
                task.wait(0.1); t += 0.1
                if not AI_ON then return false end
                local cur = getHRP(); if not cur then return false end
                if (cur.Position - pos).Magnitude <= CFG.promptReach then break end
            end
        end
    end

    local hu2 = getHum(); local h2 = getHRP()
    if hu2 and h2 then hu2:MoveTo(h2.Position) end
    task.wait(CFG.stopTimeout)
    if not AI_ON then return false end

    local ok = pcall(function() fireproximityprompt(prompt) end)
    task.wait(0.3)
    return ok
end

-- ================================================================
--  COLLECT NEARBY
--  Kembali ke logika v9 asli yang terbukti bekerja,
--  ditambah: kalau di atap → teleport turun dulu sebelum collect
-- ================================================================
local function collectNearby()
    if collected >= CFG.maxEvidence then return end
    local folder = getEvidenceFolder(); if not folder then return end
    local h = getHRP(); if not h then return end

    -- Cek dulu apakah karakter di atap
    if isOnRoof(h.Position) then
        updateStatus("🚨 Di atap! TP turun...", Color3.fromRGB(220,60,60))
        -- Teleport ke posisi sama tapi Y = floor normal + 4
        local zone = getZone(h.Position)
        local floorY = (zone == "LOBBY") and CFG.lobbyFloorY or CFG.islandFloorY
        local safePos = Vector3.new(h.Position.X, floorY + 4, h.Position.Z)
        local hrp = getHRP()
        if hrp then
            hrp.CFrame = CFrame.new(safePos)
            task.wait(0.5)
        end
        -- Refresh posisi setelah teleport
        h = getHRP()
        if not h then return end
        -- Kalau masih di atap setelah teleport → snap ke WP terdekat
        if isOnRoof(h.Position) then
            aiWpIndex = emergencySnapToPhase(aiPhase, h.Position)
            return
        end
    end

    local nearby = {}
    for _, model in ipairs(folder:GetChildren()) do
        local pr = getPromptFromModel(model)
        if pr then
            local bp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
            if bp then
                local d = (bp.Position - h.Position).Magnitude
                if d <= CFG.collectRadius then
                    local inSafeZone = true
                    if aiPhase == "LOBBY_FARM" or aiPhase == "LOBBY_TO_LIFT" then
                        inSafeZone = isInLobbyBounds(bp.Position)
                    end
                    if inSafeZone then
                        table.insert(nearby, { prompt=pr, pos=bp.Position, d=d, name=model.Name })
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

        if aiPhase == "LOBBY_FARM" or aiPhase == "LOBBY_TO_LIFT" then
            if not isInLobbyBounds(ev.pos) then continue end
        end

        updateStatus("📦 " .. ev.name, nil)

        -- Coba fire langsung dulu (biasa)
        pcall(function() fireproximityprompt(ev.prompt) end)
        task.wait(0.15)

        -- Kalau masih ada (jauh) → fire dengan approach
        if ev.d > 10 then
            firePromptAt(ev.prompt, ev.pos)
        end

        collected += 1
        updateCount(collected)
        task.wait(0.15)

        -- Cek posisi setelah collect — kalau tiba-tiba di atap, TP turun
        local postH = getHRP()
        if postH and isOnRoof(postH.Position) then
            updateStatus("🚨 Naik atap saat collect! TP turun...", Color3.fromRGB(220,60,60))
            local zone = getZone(postH.Position)
            local floorY = (zone == "LOBBY") and CFG.lobbyFloorY or CFG.islandFloorY
            postH.CFrame = CFrame.new(postH.Position.X, floorY + 4, postH.Position.Z)
            task.wait(0.4)
        end

        -- Cek keluar lobby bounds
        local checkH = getHRP()
        if checkH then
            if (aiPhase == "LOBBY_FARM" or aiPhase == "LOBBY_TO_LIFT") and
               not isInLobbyBounds(checkH.Position) then
                updateStatus("🚨 Keluar bounds! TP balik...", Color3.fromRGB(220,60,60))
                aiWpIndex = emergencySnapToPhase(aiPhase, checkH.Position)
                break
            end
        end
    end
end

-- ================================================================
--  AUTO BABY
-- ================================================================
local function fireAllBabyPrompts()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            if obj.ActionText == "Baby" or obj.ObjectText == "Baby" then
                pcall(function()
                    obj.MaxActivationDistance = 9999
                    obj.RequiresLineOfSight   = false
                end)
                pcall(function() fireproximityprompt(obj) end)
            end
        end
    end
end

local remotes    = ReplicatedStorage:FindFirstChild("Remotes")
local babyAction = remotes and remotes:FindFirstChild("BabyAction")
if babyAction then
    pcall(function()
        babyAction.OnClientEvent:Connect(function(...)
            if select(1, ...) == "dropBaby" and BABY_ON then
                task.wait(0.15); fireAllBabyPrompts()
            end
        end)
    end)
end

local function doRespawn()
    local c = LP.Character; if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
end

-- ================================================================
--  GUI
-- ================================================================
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "SQv9"; gui.ResetOnSpawn = false

local C = {
    bg0    = Color3.fromRGB(8,   8,  10),
    bg1    = Color3.fromRGB(14,  14, 18),
    bg2    = Color3.fromRGB(20,  20, 26),
    border = Color3.fromRGB(32,  32, 40),
    accent = Color3.fromRGB(220, 220, 220),
    dim    = Color3.fromRGB(90,  90, 100),
    on     = Color3.fromRGB(200, 200, 200),
    off    = Color3.fromRGB(45,  45,  55),
    warn   = Color3.fromRGB(220, 160,  60),
    ok     = Color3.fromRGB(100, 200, 140),
    info   = Color3.fromRGB(120, 160, 220),
    red    = Color3.fromRGB(200,  60,  60),
    green  = Color3.fromRGB( 60, 180,  80),
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
header.Size             = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = C.bg1
header.BorderSizePixel  = 0; header.ZIndex = 3
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)
local hPatch = Instance.new("Frame", header)
hPatch.Size = UDim2.new(1,0,0.5,0); hPatch.Position = UDim2.new(0,0,0.5,0)
hPatch.BackgroundColor3 = C.bg1; hPatch.BorderSizePixel = 0; hPatch.ZIndex = 3

local titleTxt = Instance.new("TextLabel", header)
titleTxt.Size = UDim2.new(1,-100,0,22); titleTxt.Position = UDim2.new(0,14,0,4)
titleTxt.BackgroundTransparency = 1; titleTxt.Text = "🦑  SQ Tool v9.2"
titleTxt.TextColor3 = C.accent; titleTxt.Font = Enum.Font.GothamBold
titleTxt.TextSize = 13; titleTxt.TextXAlignment = Enum.TextXAlignment.Left; titleTxt.ZIndex = 4

local subTxt = Instance.new("TextLabel", header)
subTxt.Size = UDim2.new(1,-100,0,12); subTxt.Position = UDim2.new(0,14,0,27)
subTxt.BackgroundTransparency = 1; subTxt.Text = "© menzcreate  |  discord: menzcreate"
subTxt.TextColor3 = Color3.fromRGB(130,130,145); subTxt.Font = Enum.Font.Gotham
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
floatBtn.Size = UDim2.new(0,44,0,44); floatBtn.Position = UDim2.new(0,0,0,0)
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

local function updateMiniAiBtn()
    if AI_ON then
        miniAiBtn.BackgroundColor3 = C.green; miniAiStroke.Color = C.ok
    else
        miniAiBtn.BackgroundColor3 = C.off;   miniAiStroke.Color = C.border
    end
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
phaseTxt.BackgroundTransparency = 1; phaseTxt.Text = "Phase: —"
phaseTxt.TextColor3 = C.dim; phaseTxt.Font = Enum.Font.Code
phaseTxt.TextSize = 9; phaseTxt.TextXAlignment = Enum.TextXAlignment.Right; phaseTxt.ZIndex = 4

local div = Instance.new("Frame", mainFrame)
div.Size = UDim2.new(1,-16,0,1); div.Position = UDim2.new(0,8,0,100)
div.BackgroundColor3 = C.border; div.BorderSizePixel = 0; div.ZIndex = 3

local ROW_H = 34; local ROW_GAP = 4; local ROW_Y = 108
local function mkToggleRow(label, icon, yPos)
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
    local rowBtn = Instance.new("TextButton", row)
    rowBtn.Size = UDim2.new(1,0,1,0); rowBtn.BackgroundTransparency = 1
    rowBtn.Text = ""; rowBtn.ZIndex = 6
    return row, pill, rowBtn
end

local function setToggle(pill, state)
    if state then
        pill.BackgroundColor3 = C.on; pill.TextColor3 = C.bg0; pill.Text = "ON"
    else
        pill.BackgroundColor3 = C.off; pill.TextColor3 = C.dim; pill.Text = "OFF"
    end
end

local function rowY(i) return ROW_Y + (i-1)*(ROW_H+ROW_GAP) end

local _, hlPill,   hlBtn   = mkToggleRow("Highlight",    "◈",  rowY(1))
local _, spPill,   spBtn   = mkToggleRow("Speed + Jump", "⚡", rowY(2))
local _, ncPill,   ncBtn   = mkToggleRow("Noclip",       "◉",  rowY(3))
local _, aiPill,   aiBtn   = mkToggleRow("AI Farming",   "🤖", rowY(4))
local _, autoPill, autoBtn = mkToggleRow("Auto Collect", "📦", rowY(5))
local _, babyPill, babyBtn = mkToggleRow("Auto Baby",    "🍼", rowY(6))
setToggle(hlPill, true)

local ACT_Y = rowY(7)
local function mkActionBtn(label, yPos)
    local b = Instance.new("TextButton", mainFrame)
    b.Size = UDim2.new(1,-16,0,30); b.Position = UDim2.new(0,8,0,yPos)
    b.BackgroundColor3 = C.bg2; b.TextColor3 = C.accent
    b.Font = Enum.Font.Gotham; b.TextSize = 11; b.Text = label
    b.AutoButtonColor = false; b.BorderSizePixel = 0; b.ZIndex = 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    local s = Instance.new("UIStroke", b); s.Color = C.border; s.Thickness = 1
    return b
end

local tpBtn      = mkActionBtn("Teleport ke Terdekat", ACT_Y)
local respawnBtn = mkActionBtn("Respawn",               ACT_Y + 34)
mainFrame.Size   = UDim2.new(0, 260, 0, ACT_Y + 34 + 30 + 14)

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
local cStroke = Instance.new("UIStroke", confirmFrame)
cStroke.Color = C.red; cStroke.Thickness = 1

local confirmTxt = Instance.new("TextLabel", confirmFrame)
confirmTxt.Size = UDim2.new(1,-16,0,40); confirmTxt.Position = UDim2.new(0,8,0,10)
confirmTxt.BackgroundTransparency = 1
confirmTxt.Text = "Tutup semua fitur?\nWindow tidak bisa dibuka lagi."
confirmTxt.TextColor3 = C.accent; confirmTxt.Font = Enum.Font.Gotham
confirmTxt.TextSize = 11; confirmTxt.TextWrapped = true; confirmTxt.ZIndex = 21

local confirmYes = Instance.new("TextButton", confirmFrame)
confirmYes.Size = UDim2.new(0.45,0,0,26); confirmYes.Position = UDim2.new(0.05,0,0,60)
confirmYes.BackgroundColor3 = Color3.fromRGB(40,12,12); confirmYes.TextColor3 = C.red
confirmYes.Font = Enum.Font.GothamBold; confirmYes.TextSize = 11; confirmYes.Text = "Tutup"
confirmYes.BorderSizePixel = 0; confirmYes.ZIndex = 22
Instance.new("UICorner", confirmYes).CornerRadius = UDim.new(0,6)

local confirmNo = Instance.new("TextButton", confirmFrame)
confirmNo.Size = UDim2.new(0.45,0,0,26); confirmNo.Position = UDim2.new(0.5,0,0,60)
confirmNo.BackgroundColor3 = C.bg2; confirmNo.TextColor3 = C.accent
confirmNo.Font = Enum.Font.GothamBold; confirmNo.TextSize = 11; confirmNo.Text = "Batal"
confirmNo.BorderSizePixel = 0; confirmNo.ZIndex = 22
Instance.new("UICorner", confirmNo).CornerRadius = UDim.new(0,6)

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
function updatePhase(p)
    local short = {
        ISLAND_TO_LIFT = "Island→Lift",
        LOBBY_FARM     = "Lobby Farm",
        LOBBY_TO_LIFT  = "Lobby→Lift",
        ISLAND_DEPOSIT = "Island→Dep",
    }
    phaseTxt.Text = "Phase: " .. (short[p] or p or "—")
end

-- ================================================================
--  MINIMIZE / CLOSE
-- ================================================================
local MINIMIZED = false
local function setMinimized(val)
    MINIMIZED = val
    mainFrame.Visible      = not val
    floatContainer.Visible = val
end
minBtn.MouseButton1Click:Connect(function() setMinimized(true) end)
floatBtn.MouseButton1Click:Connect(function() setMinimized(false) end)

local function shutdownAll()
    CLOSED = true; AI_ON = false; SPEED_ON = false
    NOCLIP_ON = false; HL_ON = false; BABY_ON = false
    stopNoclip(); clearHighlights(); resetSpeed()
    if speedConn  then speedConn:Disconnect()  end
    if noclipConn then noclipConn:Disconnect() end
    gui:Destroy()
end
closeBtn.MouseButton1Click:Connect(function() confirmFrame.Visible = true end)
confirmYes.MouseButton1Click:Connect(function() confirmFrame.Visible = false; shutdownAll() end)
confirmNo.MouseButton1Click:Connect(function() confirmFrame.Visible = false end)

UserInputService.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightControl and not CLOSED then
        if MINIMIZED then setMinimized(false)
        else mainFrame.Visible = not mainFrame.Visible end
    end
end)

-- ================================================================
--  TOGGLE HANDLERS
-- ================================================================
hlBtn.MouseButton1Click:Connect(function()
    HL_ON = not HL_ON; setToggle(hlPill, HL_ON)
    if not HL_ON then clearHighlights() end
end)
spBtn.MouseButton1Click:Connect(function()
    SPEED_ON = not SPEED_ON; setToggle(spPill, SPEED_ON)
    if not SPEED_ON then resetSpeed() end
end)
ncBtn.MouseButton1Click:Connect(function()
    NOCLIP_ON = not NOCLIP_ON; setToggle(ncPill, NOCLIP_ON)
    if not NOCLIP_ON then stopNoclip() end
end)
babyBtn.MouseButton1Click:Connect(function()
    BABY_ON = not BABY_ON; setToggle(babyPill, BABY_ON)
end)
autoBtn.MouseButton1Click:Connect(function()
    AUTO_COLLECT = not AUTO_COLLECT; setToggle(autoPill, AUTO_COLLECT)
end)

tpBtn.MouseButton1Click:Connect(function()
    if #foundModels == 0 then updateStatus("⚠ Tidak ada evidence", C.warn); return end
    local h = getHRP(); if not h then return end
    local nearest, bestDist = nil, math.huge
    for _, model in ipairs(foundModels) do
        local bp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
        if bp then
            local d = (bp.Position - h.Position).Magnitude
            if d < bestDist then nearest, bestDist = bp, d end
        end
    end
    if nearest then h.CFrame = CFrame.new(nearest.Position + Vector3.new(0,4,0)) end
end)
respawnBtn.MouseButton1Click:Connect(doRespawn)

-- ================================================================
--  AI TOGGLE
-- ================================================================
local function toggleAI()
    AI_ON = not AI_ON
    setToggle(aiPill, AI_ON)
    updateMiniAiBtn()
    if AI_ON then
        updateStatus("🤖 AI Farming aktif", C.info)
        task.spawn(runAI)
    else
        local hu = getHum(); local h = getHRP()
        if hu and h then hu:MoveTo(h.Position) end
        updateStatus("⏹ AI dihentikan", C.dim)
        updatePhase(nil)
    end
end
aiBtn.MouseButton1Click:Connect(toggleAI)
miniAiBtn.MouseButton1Click:Connect(toggleAI)

-- ================================================================
--  SCAN LOOP
-- ================================================================
task.spawn(function()
    while true do
        task.wait(CFG.scanInterval)
        if CLOSED then break end
        local h = getHRP()
        if not h or not h.Parent then task.wait(1); continue end
        local folder = getEvidenceFolder()
        if not folder then continue end

        clearHighlights()
        foundModels = {}
        local nearest, bestDist = nil, math.huge

        for _, model in ipairs(folder:GetChildren()) do
            local prompt = getPromptFromModel(model)
            if prompt then
                local bp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
                if bp then
                    local d = (bp.Position - h.Position).Magnitude
                    if d <= 15000 then
                        table.insert(foundModels, model)
                        if d < bestDist then nearest, bestDist = model, d end
                        if AUTO_COLLECT and not AI_ON then
                            pcall(function() fireproximityprompt(prompt) end)
                        end
                    end
                end
            end
        end

        if HL_ON then
            for _, model in ipairs(foundModels) do
                addHighlight(model, model == nearest)
            end
        end
    end
end)

-- ================================================================
--  RESPAWN HANDLER
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
    task.wait(1.2)

    local h = getHRP(); if not h then return end
    local newPhase, newWp = detectPhaseFromPosition(h.Position, aiPhase, collected)
    aiPhase      = newPhase
    aiWpIndex    = newWp
    liftAttempts = 0
    updatePhase(aiPhase)
    updateStatus(string.format("🔄 Respawn → %s WP%d", aiPhase, aiWpIndex), C.warn)
end)

-- ================================================================
--  MAIN AI LOOP
-- ================================================================
function runAI()
    task.wait(0.5)

    local h = getHRP()
    if h then
        local newPhase, newWp = detectPhaseFromPosition(h.Position, aiPhase, collected)
        aiPhase   = newPhase
        aiWpIndex = newWp
        liftAttempts = 0
        updateStatus(string.format("📍 Deteksi: %s WP%d", aiPhase, aiWpIndex), C.warn)
    end
    updatePhase(aiPhase)
    updateCount(collected)
    task.wait(0.5)

    local lastSanityCheck = tick()
    local SANITY_INTERVAL = 0.5

    while AI_ON do
        if CLOSED then break end

        local h2 = getHRP(); local hu = getHum()
        if not h2 or not hu then task.wait(0.5); continue end

        -- ────────────────────────────────────────────────────
        --  CEK ATAP — prioritas tinggi, sebelum sanity lainnya
        --  Kalau di atap → langsung teleport turun
        -- ────────────────────────────────────────────────────
        if isOnRoof(h2.Position) then
            local zone = getZone(h2.Position)
            local floorY = (zone == "LOBBY") and CFG.lobbyFloorY or CFG.islandFloorY
            emergencyTeleport(
                Vector3.new(h2.Position.X, floorY, h2.Position.Z),
                "Di atap! TP lantai"
            )
            task.wait(0.3)
            continue
        end

        -- ────────────────────────────────────────────────────
        --  SANITY CHECK — kalau nyasar, teleport langsung
        -- ────────────────────────────────────────────────────
        if tick() - lastSanityCheck >= SANITY_INTERVAL then
            lastSanityCheck = tick()
            local sane, reason = isSane(h2.Position, aiPhase, aiWpIndex)
            if not sane then
                updateStatus("⚠ Nyasar [" .. reason .. "]", C.red)
                task.wait(0.2)

                local newPhase, newWp = detectPhaseFromPosition(h2.Position, lastSafePhase, collected)
                aiPhase      = newPhase
                aiWpIndex    = newWp
                liftAttempts = 0

                -- TELEPORT langsung ke WP aman, tidak jalan dulu
                local hrpNow = getHRP()
                if hrpNow then
                    aiWpIndex = emergencySnapToPhase(newPhase, hrpNow.Position)
                end

                updatePhase(aiPhase)
                task.wait(0.3)
                continue
            else
                lastSafePhase   = aiPhase
                lastSafeWpIndex = aiWpIndex
            end
        end

        updatePhase(aiPhase)

        -- ════════════════════════════════════════════════════
        --  PHASE 1: ISLAND → LIFT LOBBY
        -- ════════════════════════════════════════════════════
        if aiPhase == "ISLAND_TO_LIFT" then

            if getZone(h2.Position) == "LOBBY" then
                aiPhase   = "LOBBY_FARM"
                aiWpIndex = nearestWpIndex(WP_LOBBY, h2.Position)
                liftAttempts = 0
                collected = 0; updateCount(0)
                updateStatus("✅ Masuk lobby → farming WP" .. aiWpIndex, C.ok)
                continue
            end

            if aiWpIndex > #WP_ISLAND_TO_LIFT then
                if liftAttempts >= 4 then
                    updateStatus("❌ Lift gagal 4x → reset", C.red)
                    aiWpIndex    = nearestWpIndex(WP_ISLAND_TO_LIFT, h2.Position)
                    liftAttempts = 0
                    task.wait(1); continue
                end

                updateStatus("🛗 Lift Lobby... (" .. liftAttempts .. ")", C.info)
                local pr, pos = findPromptByText("Lobby")
                if pr then
                    firePromptAt(pr, pos)
                    local waited = 0
                    while waited < CFG.liftWait do
                        task.wait(0.3); waited += 0.3
                        if not AI_ON then break end
                        if getZone(getHRP() and getHRP().Position) == "LOBBY" then break end
                    end
                    if not AI_ON then break end

                    local nh = getHRP()
                    if nh and getZone(nh.Position) == "LOBBY" then
                        aiPhase   = "LOBBY_FARM"
                        aiWpIndex = nearestWpIndex(WP_LOBBY, nh.Position)
                        liftAttempts = 0
                        collected = 0; updateCount(0)
                        updateStatus("✅ Masuk lobby!", C.ok)
                    else
                        liftAttempts += 1
                        aiWpIndex = math.max(1, #WP_ISLAND_TO_LIFT - 2)
                        task.wait(1)
                    end
                else
                    liftAttempts += 1
                    aiWpIndex = math.max(1, #WP_ISLAND_TO_LIFT - 4)
                    task.wait(1)
                end
                continue
            end

            local target = WP_ISLAND_TO_LIFT[aiWpIndex]
            updateStatus(string.format("🚶 Island→Lift %d/%d", aiWpIndex, #WP_ISLAND_TO_LIFT), C.info)
            walkTo(target, CFG.moveTimeout)
            if not AI_ON then break end
            aiWpIndex += 1

        -- ════════════════════════════════════════════════════
        --  PHASE 2: LOBBY FARMING
        -- ════════════════════════════════════════════════════
        elseif aiPhase == "LOBBY_FARM" then

            if getZone(h2.Position) == "ISLAND" then
                local p, w = detectPhaseFromPosition(h2.Position, aiPhase, collected)
                aiPhase = p; aiWpIndex = w
                updateStatus("⚠ Terpental ke island → TP balik", C.warn)
                -- Teleport ke WP lobby terdekat
                aiWpIndex = emergencySnapToPhase("LOBBY_FARM", h2.Position)
                continue
            end

            if not isInLobbyBounds(h2.Position) then
                updateStatus("🚨 Keluar lobby bounds! TP balik...", C.red)
                aiWpIndex = emergencySnapToPhase("LOBBY_FARM", h2.Position)
                continue
            end

            if collected >= CFG.maxEvidence then
                aiPhase   = "LOBBY_TO_LIFT"
                aiWpIndex = nearestWpIndex(WP_LOBBY, h2.Position, 33, #WP_LOBBY)
                liftAttempts = 0
                updateStatus("💼 Penuh! → lift WP" .. aiWpIndex, C.ok)
                continue
            end

            if aiWpIndex > #WP_LOBBY then
                aiPhase   = "LOBBY_TO_LIFT"
                aiWpIndex = nearestWpIndex(WP_LOBBY, h2.Position, 33, #WP_LOBBY)
                liftAttempts = 0
                updateStatus("🔄 Putaran selesai → lift", C.warn)
                continue
            end

            local target = WP_LOBBY[aiWpIndex]
            updateStatus(string.format("🤖 Farming WP%d/%d  Ev%d/%d",
                aiWpIndex, #WP_LOBBY, collected, CFG.maxEvidence), C.info)
            walkTo(target, CFG.moveTimeout)
            if not AI_ON then break end

            -- Cek lagi setelah jalan — kalau keluar bounds, TP
            local postW = getHRP()
            if postW and not isInLobbyBounds(postW.Position) then
                updateStatus("🚨 Keluar setelah jalan! TP...", C.red)
                aiWpIndex = emergencySnapToPhase("LOBBY_FARM", postW.Position)
                continue
            end

            collectNearby()
            if not AI_ON then break end
            aiWpIndex += 1

        -- ════════════════════════════════════════════════════
        --  PHASE 3: LOBBY → LIFT FACILITY
        -- ════════════════════════════════════════════════════
        elseif aiPhase == "LOBBY_TO_LIFT" then

            if getZone(h2.Position) == "ISLAND" then
                aiPhase   = "ISLAND_DEPOSIT"
                aiWpIndex = nearestWpIndex(WP_ISLAND_BACK, h2.Position)
                liftAttempts = 0
                updateStatus("✅ Di island → deposit WP" .. aiWpIndex, C.ok)
                continue
            end

            if not isInLobbyBounds(h2.Position) then
                updateStatus("🚨 Keluar lobby (lift phase)! TP...", C.red)
                aiWpIndex = emergencySnapToPhase("LOBBY_TO_LIFT", h2.Position)
                continue
            end

            if liftAttempts >= 4 then
                updateStatus("❌ Lift Facility gagal 4x → ulang farm", C.red)
                aiPhase   = "LOBBY_FARM"
                aiWpIndex = nearestWpIndex(WP_LOBBY, h2.Position)
                liftAttempts = 0
                task.wait(1); continue
            end

            if aiWpIndex <= #WP_LOBBY then
                local target = WP_LOBBY[aiWpIndex]
                updateStatus(string.format("🚶 Menuju lift WP%d/%d", aiWpIndex, #WP_LOBBY), C.info)
                walkTo(target, CFG.moveTimeout)
                if not AI_ON then break end
                local postW2 = getHRP()
                if postW2 and not isInLobbyBounds(postW2.Position) then
                    aiWpIndex = emergencySnapToPhase("LOBBY_TO_LIFT", postW2.Position)
                    continue
                end
                aiWpIndex += 1
                continue
            end

            updateStatus("🛗 Lift Facility... (" .. liftAttempts .. ")", C.info)
            local pr, pos = findPromptByText("Facility")
            if pr then
                firePromptAt(pr, pos)
                local waited = 0
                while waited < CFG.liftWait do
                    task.wait(0.3); waited += 0.3
                    if not AI_ON then break end
                    if getZone(getHRP() and getHRP().Position) == "ISLAND" then break end
                end
                if not AI_ON then break end

                local nh = getHRP()
                if nh and getZone(nh.Position) == "ISLAND" then
                    aiPhase   = "ISLAND_DEPOSIT"
                    aiWpIndex = 1
                    liftAttempts = 0
                    updateStatus("✅ Kembali ke island!", C.ok)
                else
                    liftAttempts += 1
                    aiWpIndex = math.max(33, #WP_LOBBY - 2)
                    task.wait(1)
                end
            else
                liftAttempts += 1
                aiWpIndex = math.max(33, #WP_LOBBY - 4)
                task.wait(1)
            end
            continue

        -- ════════════════════════════════════════════════════
        --  PHASE 4: ISLAND → DEPOSIT
        -- ════════════════════════════════════════════════════
        elseif aiPhase == "ISLAND_DEPOSIT" then

            if getZone(h2.Position) == "LOBBY" then
                aiPhase   = "LOBBY_TO_LIFT"
                aiWpIndex = nearestWpIndex(WP_LOBBY, h2.Position, 33, #WP_LOBBY)
                updateStatus("⚠ Masih di lobby → cari lift", C.warn)
                continue
            end

            local pr, pos = findPromptByText("Deposit Evidence")
            if pr then
                local h3 = getHRP()
                if h3 and (h3.Position - pos).Magnitude > 60 then
                    -- Langsung teleport ke deposit point
                    emergencyTeleport(pos, "TP ke deposit")
                    if not AI_ON then break end
                end
                updateStatus("💼 Deposit " .. collected .. " evidence...", C.ok)
                firePromptAt(pr, pos)
                task.wait(CFG.depositWait)
                if not AI_ON then break end

                collected = 0; updateCount(0)
                aiPhase   = "ISLAND_TO_LIFT"
                local hrpNow = getHRP()
                aiWpIndex = nearestWpIndex(WP_ISLAND_TO_LIFT,
                    hrpNow and hrpNow.Position or WP_ISLAND_TO_LIFT[1])
                liftAttempts = 0
                updateStatus("🔄 Siklus selesai! → WP" .. aiWpIndex, C.ok)
                task.wait(1)
                continue
            end

            if aiWpIndex > #WP_ISLAND_BACK then
                updateStatus("⚠ Deposit tidak ketemu!", C.red)
                aiWpIndex = math.max(1, #WP_ISLAND_BACK - 5)
                task.wait(1.5); continue
            end

            local target = WP_ISLAND_BACK[aiWpIndex]
            updateStatus(string.format("🚶 Island→Deposit %d/%d", aiWpIndex, #WP_ISLAND_BACK), C.info)
            walkTo(target, CFG.moveTimeout)
            if not AI_ON then break end
            aiWpIndex += 1
        end

        task.wait(0.05)
    end

    updateStatus("⏹ AI dihentikan", C.dim)
    updatePhase(nil)
end

-- ================================================================
--  INIT
-- ================================================================
updateStatus("✅ Ready v9.2 — emergency TP edition", C.ok)
updateMiniAiBtn()
