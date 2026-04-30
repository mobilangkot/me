-- ================================================================
--  SQUID GAME TOOL + AI FARMING v7 — COMBINED
--  UI: Carbon/Glass Minimalis
--  By menzcreate | discord: menzcreate
-- ================================================================

local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local LP        = Players.LocalPlayer
local character = LP.Character or LP.CharacterAdded:Wait()

local function resolveHRP(char)
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
end
local function resolveHumanoid(char)
    return char:FindFirstChildOfClass("Humanoid")
end

local hrp      = resolveHRP(character)
local humanoid = resolveHumanoid(character)

-- ================================================================
--  WAYPOINTS
-- ================================================================
local WAYPOINTS = {
    -- === Boat → Lift Lobby ===
    Vector3.new(-2849.79, -785.99, 15537.20), -- 1
    Vector3.new(-2845.64, -786.00, 15507.81), -- 2
    Vector3.new(-2852.10, -786.00, 15458.68), -- 3
    Vector3.new(-2850.28, -786.00, 15430.09), -- 4
    Vector3.new(-2840.33, -785.33, 15388.17), -- 5
    Vector3.new(-2829.10, -783.86, 15357.26), -- 6
    Vector3.new(-2812.48, -782.44, 15324.15), -- 7
    Vector3.new(-2788.16, -787.00, 15300.20), -- 8
    Vector3.new(-2759.54, -787.00, 15286.12), -- 9
    Vector3.new(-2728.20, -785.71, 15270.95), -- 10
    Vector3.new(-2704.90, -787.00, 15235.33), -- 11
    Vector3.new(-2682.07, -787.00, 15214.79), -- 12
    Vector3.new(-2654.12, -786.08, 15224.16), -- 13
    Vector3.new(-2619.57, -782.87, 15244.74), -- 14
    Vector3.new(-2599.90, -779.23, 15277.44), -- 15
    Vector3.new(-2580.23, -783.48, 15315.30), -- 16
    Vector3.new(-2565.05, -786.95, 15351.70), -- 17
    Vector3.new(-2553.00, -787.05, 15386.36), -- 18
    Vector3.new(-2539.95, -786.82, 15431.95), -- 19
    Vector3.new(-2528.58, -786.90, 15471.80), -- 20
    Vector3.new(-2522.40, -780.02, 15511.19), -- 21
    Vector3.new(-2524.13, -770.14, 15540.47), -- 22
    Vector3.new(-2529.18, -764.59, 15559.40), -- 23
    Vector3.new(-2507.16, -771.31, 15552.18), -- 24
    Vector3.new(-2484.71, -779.32, 15539.44), -- 25
    Vector3.new(-2458.49, -786.68, 15528.49), -- 26
    Vector3.new(-2431.40, -784.19, 15536.85), -- 27
    Vector3.new(-2406.83, -782.74, 15551.00), -- 28
    Vector3.new(-2374.65, -787.55, 15548.69), -- 29
    Vector3.new(-2347.90, -787.01, 15549.12), -- 30
    Vector3.new(-2318.73, -787.04, 15553.46), -- 31
    Vector3.new(-2303.91, -787.00, 15567.26), -- 32
    Vector3.new(-2301.65, -777.40, 15594.97), -- 33
    Vector3.new(-2303.11, -770.67, 15619.13), -- 34
    Vector3.new(-2304.38, -766.94, 15646.55), -- 35
    Vector3.new(-2262.26, -787.96, 15734.27), -- 36
    Vector3.new(-2240.34, -787.91, 15757.39), -- 37
    Vector3.new(-2215.39, -796.91, 15780.31), -- 38
    Vector3.new(-2211.06, -796.91, 15784.74), -- 39
    Vector3.new(-2158.19, -819.91, 15839.30), -- 40
    Vector3.new(-2142.14, -819.91, 15853.75), -- 41
    Vector3.new(-2123.68, -819.91, 15868.24), -- 42
    Vector3.new(-2119.27, -819.91, 15891.31), -- 43
    Vector3.new(-2110.26, -819.91, 15920.27), -- 44
    Vector3.new(-2069.17, -839.85, 15968.62), -- 45
    Vector3.new(-2063.70, -839.85, 15974.80), -- 46
    Vector3.new(-2052.87, -839.97, 15961.35), -- 47
    Vector3.new(-2013.18, -859.85, 15931.16), -- 48
    Vector3.new(-1996.22, -859.85, 15913.27), -- 49
    Vector3.new(-1985.98, -859.85, 15901.00), -- 50
    Vector3.new(-1981.55, -859.74, 15897.86), -- 51
    -- === Lobby → Area Evidence ===
    Vector3.new(8161.05, 100.88, 3460.91), -- 52
    Vector3.new(8158.72, 100.64, 3481.85), -- 53
    Vector3.new(8161.06, 100.64, 3508.64), -- 54
    Vector3.new(8159.12, 100.64, 3540.78), -- 55
    Vector3.new(8160.81, 100.64, 3569.90), -- 56
    Vector3.new(8160.79, 100.64, 3571.51), -- 57
    Vector3.new(8162.46, 100.64, 3606.13), -- 58
    Vector3.new(8159.96, 100.84, 3628.22), -- 59
    Vector3.new(8160.55, 100.84, 3644.99), -- 60
    Vector3.new(8177.89, 100.79, 3648.69), -- 61
    Vector3.new(8193.00, 100.62, 3648.62), -- 62
    Vector3.new(8213.15, 100.62, 3644.08), -- 63
    Vector3.new(8213.75, 100.62, 3647.82), -- 64
    Vector3.new(8185.10, 100.63, 3655.74), -- 65
    Vector3.new(8160.11, 100.84, 3648.55), -- 66
    Vector3.new(8161.38, 105.65, 3667.85), -- 67
    Vector3.new(8161.12, 109.22, 3672.68), -- 68
    Vector3.new(8160.98, 112.85, 3678.20), -- 69
    Vector3.new(8160.63, 113.92, 3684.64), -- 70
    Vector3.new(8159.28, 113.82, 3702.08), -- 71
    Vector3.new(8167.90, 114.60, 3712.77), -- 72
    Vector3.new(8178.87, 115.06, 3720.25), -- 73
    Vector3.new(8195.67, 116.26, 3734.64), -- 74
    Vector3.new(8195.67, 116.26, 3734.64), -- 75
    Vector3.new(8166.60, 116.26, 3733.68), -- 76
    Vector3.new(8158.67, 100.84, 3650.24), -- 77
    Vector3.new(8139.74, 100.84, 3649.11), -- 78
    Vector3.new(8127.72, 100.84, 3648.49), -- 79
    Vector3.new(8125.64, 100.64, 3675.35), -- 80
    Vector3.new(8125.24, 100.64, 3689.57), -- 81
    Vector3.new(8121.29, 100.65, 3671.99), -- 82
    Vector3.new(8105.67, 99.72, 3649.20), -- 83
    Vector3.new(8072.35, 88.86, 3648.74), -- 84
    Vector3.new(8073.89, 88.97, 3670.38), -- 85
    Vector3.new(8063.86, 88.97, 3678.60), -- 86
    Vector3.new(8054.45, 88.97, 3695.75), -- 87
    Vector3.new(8044.78, 89.01, 3708.63), -- 88
    Vector3.new(8029.73, 89.01, 3705.94), -- 89
    Vector3.new(8020.66, 88.97, 3698.23), -- 90
    Vector3.new(8013.14, 88.97, 3683.35), -- 91
    Vector3.new(8002.38, 88.95, 3667.21), -- 92
    Vector3.new(7999.09, 88.86, 3659.80), -- 93
    Vector3.new(7975.76, 88.86, 3654.25), -- 94
    Vector3.new(7976.69, 88.79, 3628.31), -- 95
    Vector3.new(7975.29, 88.79, 3618.66), -- 96
    Vector3.new(7974.36, 88.79, 3614.55), -- 97
    Vector3.new(7975.52, 88.79, 3638.99), -- 98
    Vector3.new(8016.35, 88.97, 3704.20), -- 99
    Vector3.new(8032.17, 88.97, 3697.22), -- 100
    Vector3.new(8084.74, 88.86, 3649.77), -- 101
    Vector3.new(8090.06, 91.09, 3648.81), -- 102
    Vector3.new(8094.41, 93.48, 3648.54), -- 103
    Vector3.new(8101.00, 97.00, 3648.36), -- 104
    Vector3.new(8111.27, 100.81, 3648.41), -- 105
    Vector3.new(8122.17, 100.84, 3648.19), -- 106
    Vector3.new(8125.70, 81.45, 3604.12), -- 107
    Vector3.new(8122.06, 81.51, 3583.53), -- 108
    Vector3.new(8118.19, 81.51, 3570.75), -- 109
    Vector3.new(8119.25, 81.48, 3553.45), -- 110
    Vector3.new(8122.59, 81.47, 3550.81), -- 111
    Vector3.new(8160.61, 100.84, 3646.77), -- 112
    -- === Area Evidence → Lift Island ===
    Vector3.new(8160.11, 100.84, 3642.63), -- 113
    Vector3.new(8161.30, 100.84, 3623.34), -- 114
    Vector3.new(8162.80, 100.64, 3592.60), -- 115
    Vector3.new(8163.13, 100.64, 3567.87), -- 116
    Vector3.new(8161.68, 100.64, 3543.19), -- 117
    Vector3.new(8160.33, 100.64, 3516.81), -- 118
    Vector3.new(8159.18, 100.64, 3490.63), -- 119
    Vector3.new(8160.90, 100.59, 3468.02), -- 120
    -- === Lift Island → Boat ===
    Vector3.new(-1979.72, -859.79, 15894.86), -- 121
    Vector3.new(-1993.31, -859.85, 15907.08), -- 122
    Vector3.new(-2015.11, -859.84, 15921.20), -- 123
    Vector3.new(-2022.38, -859.85, 15931.91), -- 124
    Vector3.new(-2025.29, -857.19, 15939.90), -- 125
    Vector3.new(-2031.66, -852.39, 15947.11), -- 126
    Vector3.new(-2036.33, -848.91, 15952.29), -- 127
    Vector3.new(-2048.16, -840.22, 15965.02), -- 128
    Vector3.new(-2062.72, -839.85, 15976.80), -- 129
    Vector3.new(-2077.59, -835.80, 15961.69), -- 130
    Vector3.new(-2085.29, -830.27, 15953.74), -- 131
    Vector3.new(-2092.52, -824.53, 15944.75), -- 132
    Vector3.new(-2111.20, -819.91, 15928.31), -- 133
    Vector3.new(-2126.19, -819.91, 15913.42), -- 134
    Vector3.new(-2118.79, -819.91, 15882.92), -- 135
    Vector3.new(-2143.87, -819.91, 15857.68), -- 136
    Vector3.new(-2160.05, -819.91, 15841.90), -- 137
    Vector3.new(-2172.33, -818.67, 15829.92), -- 138
    Vector3.new(-2182.27, -813.19, 15818.38), -- 139
    Vector3.new(-2190.27, -808.57, 15809.09), -- 140
    Vector3.new(-2198.80, -803.66, 15799.18), -- 141
    Vector3.new(-2206.38, -799.30, 15790.38), -- 142
    Vector3.new(-2244.61, -787.92, 15761.63), -- 143
    Vector3.new(-2261.02, -787.91, 15747.86), -- 144
    Vector3.new(-2296.44, -771.51, 15685.03), -- 145
    Vector3.new(-2310.62, -761.37, 15619.17), -- 146
    Vector3.new(-2369.00, -788.00, 15533.28), -- 147
    Vector3.new(-2408.36, -782.72, 15525.04), -- 148
    Vector3.new(-2452.61, -784.43, 15518.52), -- 149
    Vector3.new(-2491.66, -786.77, 15488.79), -- 150
    Vector3.new(-2553.73, -786.94, 15392.51), -- 151
    Vector3.new(-2570.64, -786.49, 15348.68), -- 152
    Vector3.new(-2590.23, -782.84, 15301.06), -- 153
    Vector3.new(-2609.42, -778.49, 15265.65), -- 154
    Vector3.new(-2675.81, -785.59, 15250.93), -- 155
    Vector3.new(-2730.06, -785.47, 15273.70), -- 156
    Vector3.new(-2752.34, -787.00, 15285.00), -- 157
    Vector3.new(-2778.60, -786.98, 15301.85), -- 158
    Vector3.new(-2814.03, -782.15, 15343.33), -- 159
    Vector3.new(-2841.35, -786.00, 15437.61), -- 160
    Vector3.new(-2841.05, -786.00, 15452.05), -- 161
    Vector3.new(-2840.74, -786.00, 15466.64), -- 162
    Vector3.new(-2840.53, -786.00, 15476.26), -- 163
    Vector3.new(-2840.34, -786.00, 15485.74), -- 164
    Vector3.new(-2840.20, -786.00, 15495.21), -- 165
    Vector3.new(-2840.31, -786.00, 15503.77), -- 166
    Vector3.new(-2840.95, -786.00, 15513.33), -- 167
}

-- ================================================================
--  ZONA
-- ================================================================
local ZONE = {
    ISLAND = { wpStart = 1,  wpEnd = 35  },
    LOBBY  = { wpStart = 36, wpEnd = 77  },
    BACK   = { wpStart = 78, wpEnd = 117 },
}

local function getZone(pos)
    if not pos then return nil end
    if pos.Y > 50   then return "LOBBY"  end
    if pos.Y < -100 then return "ISLAND" end
    return nil
end

-- ================================================================
--  SANITY CHECK — deteksi posisi tidak masuk akal
--  Kembalikan ke WP sebelumnya jika terlalu jauh dari path
-- ================================================================
local SANITY_MAX_DIST   = 200  -- studs max dari WP target sebelum dianggap nyasar
local SANITY_Y_MIN      = -1200 -- Y terlalu rendah = keluar dunia
local SANITY_Y_MAX      = 500   -- Y terlalu tinggi = naik genting
local SANITY_CHECK_FREQ = 1.5   -- detik antar sanity check

local lastSaneWP = 1
local lastSanePos = nil

local function isPositionSane(pos, expectedWP)
    if not pos then return false end
    -- Cek Y keluar dunia
    if pos.Y < SANITY_Y_MIN then return false, "OUT_WORLD_LOW" end
    if pos.Y > SANITY_Y_MAX then return false, "OUT_WORLD_HIGH" end
    -- Cek zona tidak cocok dengan WP
    local zone = getZone(pos)
    if expectedWP >= 1 and expectedWP <= 35 and zone ~= "ISLAND" then
        return false, "WRONG_ZONE_EXPECT_ISLAND"
    end
    if expectedWP >= 36 and expectedWP <= 77 and zone ~= "LOBBY" then
        return false, "WRONG_ZONE_EXPECT_LOBBY"
    end
    if expectedWP >= 78 and expectedWP <= 117 and zone ~= "ISLAND" then
        return false, "WRONG_ZONE_EXPECT_ISLAND_BACK"
    end
    -- Cek jarak dari WP target tidak terlalu gila
    local wp = WAYPOINTS[expectedWP]
    if wp then
        local dist = (pos - wp).Magnitude
        if dist > SANITY_MAX_DIST then return false, "TOO_FAR_FROM_PATH" end
    end
    return true, "OK"
end

local function nearestWP(pos, fromIdx, toIdx)
    local bestIdx, bestDist = fromIdx, math.huge
    for i = fromIdx, toIdx do
        local d = (WAYPOINTS[i] - pos).Magnitude
        if d < bestDist then bestDist = d; bestIdx = i end
    end
    return bestIdx
end

local function resolveStartWP(pos, wentLobby)
    local zone = getZone(pos)
    if zone == "LOBBY" then
        return nearestWP(pos, ZONE.LOBBY.wpStart, ZONE.LOBBY.wpEnd), true
    elseif zone == "ISLAND" then
        if wentLobby then
            return nearestWP(pos, ZONE.BACK.wpStart, ZONE.BACK.wpEnd), true
        else
            return nearestWP(pos, ZONE.ISLAND.wpStart, ZONE.ISLAND.wpEnd), false
        end
    else
        return 1, false
    end
end

-- ================================================================
--  CONFIG
-- ================================================================
local CFG = {
    maxEvidence    = 8,
    collectRadius  = 25,
    promptReach    = 7,
    wpReach        = 6,
    moveTimeout    = 8,
    liftWait       = 6,
    depositWait    = 3,
    stopTimeout    = 0.6,
    scanInterval   = 0.5,

    -- Speed tiers
    speedFlat      = 120,  -- datar / turun (naik sedikit dari 100)
    speedFlat      = 100,  -- datar / turun (naik sedikit dari 100)
    speedSlope     = 65,   -- nanjak sedang
    speedSteep     = 32,   -- nanjak curam
    jumpNormal     = 50,   -- jump dinormalkan saat AI farming
    jumpNormal     = 25,   -- jump dinormalkan saat AI farming
    jumpSlope      = 50,   -- sama, tidak dikurangi
    jumpSteep      = 50,   -- sama

    -- Slope thresholds (rasio deltaY / hDist)
    slopeThreshMed  = 0.10,  -- 10% = sedang
    slopeThreshHigh = 0.25,  -- 25% = curam

    -- Micro-step: jarak per langkah saat noclip+nanjak
    microStepDist   = 12,   -- studs per step
    microStepWait   = 0.08, -- detik antar step

    -- Y-drift guard: kalau Y drop > nilai ini dalam 1 step → koreksi
    yDriftMax       = 8,    -- studs
}

-- ================================================================
--  STATE
-- ================================================================
local AI_ON       = false
local SPEED_ON    = false
local NOCLIP_ON   = false
local HL_ON       = true
local BABY_ON     = false
local collected   = 0
local wentLobby   = false
local currentWP   = 1
local foundModels = {}
local highlights  = {}
local CLOSED      = false

-- Slope state — diupdate tiap walkTo
local currentSlope = "FLAT"  -- "FLAT" | "SLOPE" | "STEEP"
local currentSpeed = 100
local currentJump  = 80

-- ================================================================
--  HELPERS
-- ================================================================
local function ch()  return LP.Character end
local function getHRP()
    local c = ch(); if not c then return nil end
    return c:FindFirstChild("HumanoidRootPart")
        or c:FindFirstChild("UpperTorso")
        or c:FindFirstChild("Torso")
end
local function getHum()
    local c = ch()
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- ================================================================
--  SLOPE DETECTION
--  Hitung rasio kemiringan dari posisi sekarang ke target WP
--  Return: "FLAT" | "SLOPE" | "STEEP", speed, jumpPower
-- ================================================================
local function calcSlope(fromPos, toPos)
    local hDist = Vector2.new(toPos.X - fromPos.X, toPos.Z - fromPos.Z).Magnitude
    if hDist < 1 then return "FLAT", CFG.speedFlat, CFG.jumpNormal end
    local deltaY = toPos.Y - fromPos.Y  -- positif = nanjak, negatif = turun

    -- Hanya peduli nanjak (negatif = turun, aman)
    if deltaY <= 0 then
        return "FLAT", CFG.speedFlat, CFG.jumpNormal
    end

    local ratio = deltaY / hDist
    if ratio >= CFG.slopeThreshHigh then
        return "STEEP", CFG.speedSteep, CFG.jumpSteep
    elseif ratio >= CFG.slopeThreshMed then
        return "SLOPE", CFG.speedSlope, CFG.jumpSlope
    else
        return "FLAT", CFG.speedFlat, CFG.jumpNormal
    end
end

-- Label slope untuk UI
local SLOPE_ICON = { FLAT="—", SLOPE="↗", STEEP="⬆" }

-- ================================================================
--  SPEED — dinamis berdasarkan slope
-- ================================================================
local speedConn
local function startSpeedLoop()
    if speedConn then speedConn:Disconnect() end
    speedConn = RunService.Heartbeat:Connect(function()
        if not SPEED_ON then return end
        local c = LP.Character; if not c then return end
        local hum = resolveHumanoid(c); if not hum then return end
        hum.UseJumpPower = true
        -- Saat AI aktif, pakai speed slope-aware; saat manual, full speed
        if AI_ON then
            hum.WalkSpeed = currentSpeed
            hum.JumpPower = currentJump
        else
            hum.WalkSpeed = CFG.speedFlat
            hum.JumpPower = CFG.jumpNormal
        end
    end)
end

local function applySpeed(char)
    local hum = resolveHumanoid(char); if not hum then return end
    hum.UseJumpPower = true
    if SPEED_ON then
        hum.WalkSpeed = AI_ON and currentSpeed or CFG.speedFlat
        hum.JumpPower = AI_ON and currentJump  or CFG.jumpNormal
    else
        hum.WalkSpeed = 16
        hum.JumpPower = 50
    end
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
    h.FillColor           = isNearest and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,180,180)
    h.OutlineColor        = isNearest and Color3.fromRGB(255,255,255) or Color3.fromRGB(120,120,120)
    h.FillTransparency    = isNearest and 0.25 or 0.6
    h.OutlineTransparency = 0
    h.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    table.insert(highlights, h)
end

-- ================================================================
--  PROMPT HELPERS
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
                if m then p = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart",true) end
            end
            if p then return o, p.Position end
        end
    end
    return nil, nil
end

local function getFolder()
    local ok, r = pcall(function()
        return workspace:WaitForChild("Data",3)
            :WaitForChild("Detective",3)
            :WaitForChild("Evidence",3)
            :WaitForChild("Instances",3)
    end)
    return ok and r or nil
end

-- ================================================================
--  TELEPORT SAFETY — paksa kembali ke WP terakhir yang sane
-- ================================================================
local function teleportToWP(wpIdx)
    local h = getHRP(); if not h then return end
    local target = WAYPOINTS[wpIdx]
    if not target then return end
    -- Teleport dengan sedikit offset Y agar tidak stuck di ground
    h.CFrame = CFrame.new(target + Vector3.new(0, 3, 0))
    task.wait(0.3)
end

-- ================================================================
--  WALK TO — slope-aware dengan micro-step & Y-drift guard
-- ================================================================
local function walkTo(target, timeoutSec)
    local hu = getHum(); local h = getHRP()
    if not hu or not h then return false end
    if (h.Position - target).Magnitude <= CFG.wpReach then return true end

    -- Hitung slope ke target
    local slope, spd, jmp = calcSlope(h.Position, target)
    currentSlope = slope
    currentSpeed = spd
    currentJump  = jmp

    local isSteepOrSlope = (slope == "STEEP" or slope == "SLOPE")
    local useNoclip      = NOCLIP_ON and isSteepOrSlope

    -- Update speed humanoid langsung
    if SPEED_ON then
        hu.UseJumpPower = true
        hu.WalkSpeed    = spd
        hu.JumpPower    = jmp
    end

    -- ── MICRO-STEP MODE (noclip + nanjak) ────────────────────────
    -- Jalan dalam langkah kecil agar tidak tembus lantai/dinding
    if useNoclip then
        local limit     = timeoutSec or CFG.moveTimeout
        local elapsed   = 0
        local prevY     = h.Position.Y

        while elapsed < limit do
            if not AI_ON then return false end
            local cur = getHRP(); if not cur then return false end

            local dist = (cur.Position - target).Magnitude
            if dist <= CFG.wpReach then return true end

            -- Re-hitung slope secara berkala (bisa berubah di tengah jalan)
            local newSlope, newSpd, newJmp = calcSlope(cur.Position, target)
            if newSlope ~= currentSlope then
                currentSlope = newSlope; currentSpeed = newSpd; currentJump = newJmp
                local hum2 = getHum()
                if hum2 and SPEED_ON then
                    hum2.WalkSpeed = newSpd; hum2.JumpPower = newJmp
                end
            end

            -- Hitung arah micro-step
            local dir    = (target - cur.Position).Unit
            local stepTarget = cur.Position + dir * math.min(CFG.microStepDist, dist)

            -- Y-drift guard: pertahankan Y WP jika drop terlalu jauh
            local expectedY = cur.Position.Y + (target.Y - cur.Position.Y) *
                              (CFG.microStepDist / math.max(dist, 1))
            local hu2 = getHum()
            if hu2 then hu2:MoveTo(stepTarget) end

            task.wait(CFG.microStepWait)
            elapsed += CFG.microStepWait

            -- Cek Y drift (tembus lantai?)
            local afterH = getHRP()
            if afterH then
                local yDrop = prevY - afterH.Position.Y
                if yDrop > CFG.yDriftMax then
                    -- Koreksi: angkat kembali ke Y yang diharapkan + buffer
                    afterH.CFrame = CFrame.new(
                        afterH.Position.X,
                        prevY + 2,  -- angkat ke Y sebelumnya + buffer kecil
                        afterH.Position.Z
                    )
                    updateStatus("⚠ Y-drift → koreksi", C.warn)
                    task.wait(0.1)
                end
                prevY = afterH.Position.Y
            end
        end
        return false

    -- ── NORMAL MODE (flat / turun / noclip off) ───────────────────
    else
        hu:MoveTo(target)
        local t = 0
        local limit = timeoutSec or CFG.moveTimeout
        while t < limit do
            task.wait(0.1); t += 0.1
            if not AI_ON then return false end
            local cur = getHRP(); if not cur then return false end
            if (cur.Position - target).Magnitude <= CFG.wpReach then return true end
            -- Re-issue MoveTo tiap 1.5 detik agar tidak drift
            if t % 1.5 < 0.11 then
                -- Re-hitung slope (karena Y berubah saat jalan)
                local newSlope, newSpd, newJmp = calcSlope(cur.Position, target)
                currentSlope = newSlope; currentSpeed = newSpd; currentJump = newJmp
                local hu2 = getHum()
                if hu2 then
                    hu2:MoveTo(target)
                    if SPEED_ON then
                        hu2.UseJumpPower = true
                        hu2.WalkSpeed    = newSpd
                        hu2.JumpPower    = newJmp
                    end
                end
            end
        end
        return false
    end
end

-- ================================================================
--  FIRE PROMPT — berhenti dulu, baru fire
-- ================================================================
local function firePromptAt(prompt, pos, label)
    if not prompt or not pos then return false end
    local hu = getHum(); local h = getHRP()
    if not hu or not h then return false end

    if (h.Position - pos).Magnitude > CFG.promptReach then
        hu:MoveTo(pos)
        local t = 0
        while t < 7 do
            task.wait(0.1); t += 0.1
            if not AI_ON then return false end
            local cur = getHRP()
            if not cur then return false end
            if (cur.Position - pos).Magnitude <= CFG.promptReach then break end
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
--  COLLECT NEARBY — gabungan walk + auto collect
-- ================================================================
local function collectNearby()
    if collected >= CFG.maxEvidence then return end
    local folder = getFolder(); if not folder then return end
    local h = getHRP(); if not h then return end

    local nearby = {}
    for _, model in ipairs(folder:GetChildren()) do
        local pr = getPromptFromModel(model)
        if pr then
            local bp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart",true)
            if bp then
                local d = (bp.Position - h.Position).Magnitude
                if d <= CFG.collectRadius then
                    table.insert(nearby, { prompt=pr, pos=bp.Position, d=d, name=model.Name })
                end
            end
        end
    end

    if #nearby == 0 then return end
    table.sort(nearby, function(a,b) return a.d < b.d end)

    for _, ev in ipairs(nearby) do
        if not AI_ON then return end
        if collected >= CFG.maxEvidence then break end
        updateStatus("📦 " .. ev.name)
        -- Coba auto-fire langsung dulu (tanpa jalan)
        local quickOk = pcall(function() fireproximityprompt(ev.prompt) end)
        task.wait(0.15)
        -- Kalau tidak berhasil (terlalu jauh), jalan dulu
        if ev.d > 8 then
            firePromptAt(ev.prompt, ev.pos, ev.name)
        end
        collected += 1
        updateCount(collected)
        task.wait(0.15)
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
            local args = {...}
            if args[1] == "dropBaby" and BABY_ON then
                task.wait(0.15)
                fireAllBabyPrompts()
            end
        end)
    end)
end

-- ================================================================
--  RESPAWN
-- ================================================================
local function doRespawn()
    local c = LP.Character; if not c then return end
    local hum = resolveHumanoid(c)
    if hum then hum.Health = 0 end
end

-- ================================================================
--  GUI — Carbon/Glass Minimalis
-- ================================================================
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "SQv7"; gui.ResetOnSpawn = false

-- ─── Warna tema ───────────────────────────────────────────────
local C = {
    bg0     = Color3.fromRGB(8,  8,  10),   -- bg utama
    bg1     = Color3.fromRGB(14, 14, 18),   -- panel
    bg2     = Color3.fromRGB(20, 20, 26),   -- row
    border  = Color3.fromRGB(32, 32, 40),   -- border halus
    accent  = Color3.fromRGB(220,220,220),  -- putih soft
    dim     = Color3.fromRGB(90, 90,100),   -- teks redup
    on      = Color3.fromRGB(200,200,200),  -- toggle ON
    off     = Color3.fromRGB(45,  45, 55),  -- toggle OFF
    warn    = Color3.fromRGB(220,160, 60),  -- kuning warning
    ok      = Color3.fromRGB(100,200,140),  -- hijau ok
    info    = Color3.fromRGB(120,160,220),  -- biru info
    red     = Color3.fromRGB(200, 60, 60),  -- merah
}

-- ─── Frame utama ──────────────────────────────────────────────
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size             = UDim2.new(0, 260, 0, 430)
mainFrame.Position         = UDim2.new(0, 14, 0, 14)
mainFrame.BackgroundColor3 = C.bg0
mainFrame.BorderSizePixel  = 0
mainFrame.Active           = true
mainFrame.Draggable        = true
mainFrame.ZIndex           = 2
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Glass border stroke
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color       = C.border
stroke.Thickness   = 1
stroke.Transparency = 0

-- ─── Header bar ───────────────────────────────────────────────
local header = Instance.new("Frame", mainFrame)
header.Size             = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = C.bg1
header.BorderSizePixel  = 0
header.ZIndex           = 3
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

-- patch bawah header (agar corner hanya atas)
local hPatch = Instance.new("Frame", header)
hPatch.Size             = UDim2.new(1, 0, 0.5, 0)
hPatch.Position         = UDim2.new(0, 0, 0.5, 0)
hPatch.BackgroundColor3 = C.bg1
hPatch.BorderSizePixel  = 0
hPatch.ZIndex           = 3

local titleTxt = Instance.new("TextLabel", header)
titleTxt.Size              = UDim2.new(1, -100, 0, 22)
titleTxt.Position          = UDim2.new(0, 14, 0, 4)
titleTxt.BackgroundTransparency = 1
titleTxt.Text              = "🦑  SQ Tool"
titleTxt.TextColor3        = C.accent
titleTxt.Font              = Enum.Font.GothamBold
titleTxt.TextSize          = 13
titleTxt.TextXAlignment    = Enum.TextXAlignment.Left
titleTxt.ZIndex            = 4

local subTxt = Instance.new("TextLabel", header)
subTxt.Size              = UDim2.new(1, -100, 0, 12)
subTxt.Position          = UDim2.new(0, 14, 0, 27)
subTxt.BackgroundTransparency = 1
subTxt.Text              = "© menzcreate  |  discord: menzcreate"
subTxt.TextColor3        = Color3.fromRGB(130, 130, 145)
subTxt.Font              = Enum.Font.Gotham
subTxt.TextSize          = 9
subTxt.TextXAlignment    = Enum.TextXAlignment.Left
subTxt.ZIndex            = 4

-- ─── Tombol Minimize ──────────────────────────────────────────
local minBtn = Instance.new("TextButton", header)
minBtn.Size             = UDim2.new(0, 24, 0, 24)
minBtn.Position         = UDim2.new(1, -60, 0, 10)
minBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
minBtn.TextColor3       = C.dim
minBtn.Font             = Enum.Font.GothamBold
minBtn.TextSize         = 13
minBtn.Text             = "–"
minBtn.AutoButtonColor  = false
minBtn.BorderSizePixel  = 0
minBtn.ZIndex           = 5
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- ─── Float button (saat minimize) ─────────────────────────────
local floatBtn = Instance.new("TextButton", gui)
floatBtn.Size             = UDim2.new(0, 44, 0, 44)
floatBtn.Position         = UDim2.new(0, 14, 0, 14)
floatBtn.BackgroundColor3 = C.bg1
floatBtn.TextColor3       = C.accent
floatBtn.Font             = Enum.Font.GothamBold
floatBtn.TextSize         = 20
floatBtn.Text             = "🦑"
floatBtn.AutoButtonColor  = false
floatBtn.BorderSizePixel  = 0
floatBtn.Visible          = false
floatBtn.ZIndex           = 15
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(0, 10)
local floatStroke = Instance.new("UIStroke", floatBtn)
floatStroke.Color = C.border; floatStroke.Thickness = 1

local MINIMIZED = false
local function setMinimized(val)
    MINIMIZED = val
    mainFrame.Visible = not val
    floatBtn.Visible  = val
end

minBtn.MouseButton1Click:Connect(function() setMinimized(true) end)
floatBtn.MouseButton1Click:Connect(function() setMinimized(false) end)

-- ─── Tombol X (close) ─────────────────────────────────────────
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size             = UDim2.new(0, 24, 0, 24)
closeBtn.Position         = UDim2.new(1, -32, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
closeBtn.TextColor3       = C.red
closeBtn.Font             = Enum.Font.GothamBold
closeBtn.TextSize         = 13
closeBtn.Text             = "✕"
closeBtn.AutoButtonColor  = false
closeBtn.BorderSizePixel  = 0
closeBtn.ZIndex           = 5
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- ─── Status bar ───────────────────────────────────────────────
local statusBar = Instance.new("Frame", mainFrame)
statusBar.Size             = UDim2.new(1, -16, 0, 22)
statusBar.Position         = UDim2.new(0, 8, 0, 50)
statusBar.BackgroundColor3 = C.bg2
statusBar.BorderSizePixel  = 0
statusBar.ZIndex           = 3
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0, 6)

local statusTxt = Instance.new("TextLabel", statusBar)
statusTxt.Size              = UDim2.new(1, -10, 1, 0)
statusTxt.Position          = UDim2.new(0, 8, 0, 0)
statusTxt.BackgroundTransparency = 1
statusTxt.Text              = "Ready"
statusTxt.TextColor3        = C.dim
statusTxt.Font              = Enum.Font.Gotham
statusTxt.TextSize          = 10
statusTxt.TextXAlignment    = Enum.TextXAlignment.Left
statusTxt.ZIndex            = 4

-- ─── Evidence / WP info row ───────────────────────────────────
local infoRow = Instance.new("Frame", mainFrame)
infoRow.Size             = UDim2.new(1, -16, 0, 20)
infoRow.Position         = UDim2.new(0, 8, 0, 76)
infoRow.BackgroundTransparency = 1
infoRow.ZIndex           = 3

local evTxt = Instance.new("TextLabel", infoRow)
evTxt.Size              = UDim2.new(0.5, 0, 1, 0)
evTxt.BackgroundTransparency = 1
evTxt.Text              = "Evidence: 0/8"
evTxt.TextColor3        = C.ok
evTxt.Font              = Enum.Font.GothamBold
evTxt.TextSize          = 10
evTxt.TextXAlignment    = Enum.TextXAlignment.Left
evTxt.ZIndex            = 4

local wpTxt = Instance.new("TextLabel", infoRow)
wpTxt.Size              = UDim2.new(0.5, 0, 1, 0)
wpTxt.Position          = UDim2.new(0.5, 0, 0, 0)
wpTxt.BackgroundTransparency = 1
wpTxt.Text              = "WP: — | Zona: —"
wpTxt.TextColor3        = C.dim
wpTxt.Font              = Enum.Font.Code
wpTxt.TextSize          = 9
wpTxt.TextXAlignment    = Enum.TextXAlignment.Right
wpTxt.ZIndex            = 4

-- divider
local div = Instance.new("Frame", mainFrame)
div.Size             = UDim2.new(1,-16,0,1)
div.Position         = UDim2.new(0,8,0,100)
div.BackgroundColor3 = C.border
div.BorderSizePixel  = 0
div.ZIndex           = 3

-- ─── Toggle row factory ───────────────────────────────────────
local ROW_H   = 34
local ROW_GAP = 4
local ROW_Y   = 108

local toggleBtns = {}

local function mkToggleRow(label, icon, yPos)
    local row = Instance.new("Frame", mainFrame)
    row.Size             = UDim2.new(1,-16,0,ROW_H)
    row.Position         = UDim2.new(0,8,0,yPos)
    row.BackgroundColor3 = C.bg1
    row.BorderSizePixel  = 0
    row.ZIndex           = 3
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size              = UDim2.new(1,-50,1,0)
    lbl.Position          = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text              = icon .. "  " .. label
    lbl.TextColor3        = C.accent
    lbl.Font              = Enum.Font.Gotham
    lbl.TextSize          = 11
    lbl.TextXAlignment    = Enum.TextXAlignment.Left
    lbl.ZIndex            = 4

    -- pill toggle
    local pill = Instance.new("TextButton", row)
    pill.Size             = UDim2.new(0,38,0,20)
    pill.Position         = UDim2.new(1,-46,0.5,-10)
    pill.BackgroundColor3 = C.off
    pill.TextColor3       = C.dim
    pill.Font             = Enum.Font.GothamBold
    pill.TextSize         = 9
    pill.Text             = "OFF"
    pill.AutoButtonColor  = false
    pill.BorderSizePixel  = 0
    pill.ZIndex           = 5
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)

    -- invisible full-row button
    local rowBtn = Instance.new("TextButton", row)
    rowBtn.Size             = UDim2.new(1,0,1,0)
    rowBtn.BackgroundTransparency = 1
    rowBtn.Text             = ""
    rowBtn.ZIndex           = 6

    return row, pill, rowBtn
end

local function setToggle(pill, state)
    if state then
        pill.BackgroundColor3 = C.on
        pill.TextColor3       = C.bg0
        pill.Text             = "ON"
    else
        pill.BackgroundColor3 = C.off
        pill.TextColor3       = C.dim
        pill.Text             = "OFF"
    end
end

local function rowY(i) return ROW_Y + (i-1)*(ROW_H+ROW_GAP) end

-- Baris toggle
local _, hlPill,   hlBtn   = mkToggleRow("Highlight",          "◈",  rowY(1))
local _, spPill,   spBtn   = mkToggleRow("Speed + Jump",       "⚡", rowY(2))
local _, ncPill,   ncBtn   = mkToggleRow("Noclip",             "◉",  rowY(3))
local _, aiPill,   aiBtn   = mkToggleRow("AI Farming  (beta)", "🤖", rowY(4))
local _, autoPill, autoBtn = mkToggleRow("Auto Collect",       "📦", rowY(5))
local _, babyPill, babyBtn = mkToggleRow("Auto Baby",          "🍼", rowY(6))

setToggle(hlPill, true)  -- highlight default ON

-- ─── Action buttons ───────────────────────────────────────────
local ACT_Y = rowY(7)

local function mkActionBtn(label, yPos)
    local b = Instance.new("TextButton", mainFrame)
    b.Size             = UDim2.new(1,-16,0,30)
    b.Position         = UDim2.new(0,8,0,yPos)
    b.BackgroundColor3 = C.bg2
    b.TextColor3       = C.accent
    b.Font             = Enum.Font.Gotham
    b.TextSize         = 11
    b.Text             = label
    b.AutoButtonColor  = false
    b.BorderSizePixel  = 0
    b.ZIndex           = 3
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)
    local s = Instance.new("UIStroke",b)
    s.Color = C.border; s.Thickness = 1
    return b
end

local tpBtn      = mkActionBtn("Teleport ke Terdekat",  ACT_Y)
local respawnBtn = mkActionBtn("Respawn",                ACT_Y + 34)

-- Resize frame
mainFrame.Size = UDim2.new(0, 260, 0, ACT_Y + 34 + 30 + 14)

-- hint
local hintTxt = Instance.new("TextLabel", mainFrame)
hintTxt.Size              = UDim2.new(1,-16,0,12)
hintTxt.Position          = UDim2.new(0,8,1,-14)
hintTxt.BackgroundTransparency = 1
hintTxt.Text              = "RightCtrl = hide/show"
hintTxt.TextColor3        = Color3.fromRGB(35,35,45)
hintTxt.Font              = Enum.Font.Gotham
hintTxt.TextSize          = 9
hintTxt.TextXAlignment    = Enum.TextXAlignment.Left
hintTxt.ZIndex            = 3

-- ─── Confirm Dialog ───────────────────────────────────────────
local confirmFrame = Instance.new("Frame", gui)
confirmFrame.Size             = UDim2.new(0, 220, 0, 100)
confirmFrame.Position         = UDim2.new(0.5,-110,0.5,-50)
confirmFrame.BackgroundColor3 = C.bg1
confirmFrame.BorderSizePixel  = 0
confirmFrame.Visible          = false
confirmFrame.ZIndex           = 20
Instance.new("UICorner", confirmFrame).CornerRadius = UDim.new(0, 12)
local cStroke = Instance.new("UIStroke", confirmFrame)
cStroke.Color = C.red; cStroke.Thickness = 1

local confirmTxt = Instance.new("TextLabel", confirmFrame)
confirmTxt.Size              = UDim2.new(1,-16,0,40)
confirmTxt.Position          = UDim2.new(0,8,0,10)
confirmTxt.BackgroundTransparency = 1
confirmTxt.Text              = "Tutup semua fitur?\nWindow tidak bisa dibuka lagi."
confirmTxt.TextColor3        = C.accent
confirmTxt.Font              = Enum.Font.Gotham
confirmTxt.TextSize          = 11
confirmTxt.TextWrapped        = true
confirmTxt.ZIndex            = 21

local confirmYes = Instance.new("TextButton", confirmFrame)
confirmYes.Size             = UDim2.new(0.45,0,0,26)
confirmYes.Position         = UDim2.new(0.05,0,0,60)
confirmYes.BackgroundColor3 = Color3.fromRGB(40,12,12)
confirmYes.TextColor3       = C.red
confirmYes.Font             = Enum.Font.GothamBold
confirmYes.TextSize         = 11
confirmYes.Text             = "Tutup"
confirmYes.BorderSizePixel  = 0
confirmYes.ZIndex           = 22
Instance.new("UICorner", confirmYes).CornerRadius = UDim.new(0,6)

local confirmNo = Instance.new("TextButton", confirmFrame)
confirmNo.Size             = UDim2.new(0.45,0,0,26)
confirmNo.Position         = UDim2.new(0.5,0,0,60)
confirmNo.BackgroundColor3 = C.bg2
confirmNo.TextColor3       = C.accent
confirmNo.Font             = Enum.Font.GothamBold
confirmNo.TextSize         = 11
confirmNo.Text             = "Batal"
confirmNo.BorderSizePixel  = 0
confirmNo.ZIndex           = 22
Instance.new("UICorner", confirmNo).CornerRadius = UDim.new(0,6)

-- ─── GUI updaters ─────────────────────────────────────────────
function updateStatus(t, col)
    statusTxt.Text      = t or ""
    statusTxt.TextColor3 = col or C.dim
end
function updateCount(n)
    evTxt.Text = "Evidence: " .. n .. "/" .. CFG.maxEvidence
end
function updateWP(i, zone)
    wpTxt.Text = "WP:" .. (i or "—") .. " " .. (zone or "—")
end

-- ─── Close logic ──────────────────────────────────────────────
local function shutdownAll()
    CLOSED    = true
    AI_ON     = false
    SPEED_ON  = false
    NOCLIP_ON = false
    HL_ON     = false
    BABY_ON   = false
    stopNoclip()
    clearHighlights()
    applySpeed(LP.Character)
    if speedConn  then speedConn:Disconnect()  end
    if noclipConn then noclipConn:Disconnect() end
    gui:Destroy()
end

closeBtn.MouseButton1Click:Connect(function()
    confirmFrame.Visible = true
end)
confirmYes.MouseButton1Click:Connect(function()
    confirmFrame.Visible = false
    shutdownAll()
end)
confirmNo.MouseButton1Click:Connect(function()
    confirmFrame.Visible = false
end)

-- ─── Hide/show ────────────────────────────────────────────────
UserInputService.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightControl then
        if not CLOSED then
            if MINIMIZED then
                setMinimized(false)
            else
                mainFrame.Visible = not mainFrame.Visible
            end
        end
    end
end)

-- ================================================================
--  TOGGLE HANDLERS
-- ================================================================
hlBtn.MouseButton1Click:Connect(function()
    HL_ON = not HL_ON
    setToggle(hlPill, HL_ON)
    if not HL_ON then clearHighlights() end
end)

spBtn.MouseButton1Click:Connect(function()
    SPEED_ON = not SPEED_ON
    setToggle(spPill, SPEED_ON)
    if not SPEED_ON then applySpeed(LP.Character) end
end)

ncBtn.MouseButton1Click:Connect(function()
    NOCLIP_ON = not NOCLIP_ON
    setToggle(ncPill, NOCLIP_ON)
    if not NOCLIP_ON then stopNoclip() end
end)

babyBtn.MouseButton1Click:Connect(function()
    BABY_ON = not BABY_ON
    setToggle(babyPill, BABY_ON)
end)

-- Auto Collect (standalone, tanpa AI farming)
local AUTO_COLLECT = false
autoBtn.MouseButton1Click:Connect(function()
    AUTO_COLLECT = not AUTO_COLLECT
    setToggle(autoPill, AUTO_COLLECT)
end)

-- Teleport
local isTeleporting = false
tpBtn.MouseButton1Click:Connect(function()
    if isTeleporting then return end
    if #foundModels == 0 then updateStatus("⚠ Tidak ada collect", C.warn); return end
    local h = getHRP(); if not h then return end
    local nearest, bestDist = nil, math.huge
    for _, model in ipairs(foundModels) do
        local bp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart",true)
        if bp then
            local d = (bp.Position - h.Position).Magnitude
            if d < bestDist then nearest, bestDist = bp, d end
        end
    end
    if not nearest then return end
    isTeleporting = true
    h.CFrame = CFrame.new(nearest.Position + Vector3.new(0,4,0))
    task.wait(0.5)
    isTeleporting = false
end)

respawnBtn.MouseButton1Click:Connect(doRespawn)

-- ================================================================
--  AI FARMING TOGGLE
-- ================================================================
aiBtn.MouseButton1Click:Connect(function()
    AI_ON = not AI_ON
    setToggle(aiPill, AI_ON)
    if AI_ON then
        updateStatus("🤖 AI Farming aktif", C.info)
        task.spawn(runAI)
    else
        local hu = getHum(); local h = getHRP()
        if hu and h then hu:MoveTo(h.Position) end
        updateStatus("⏹ AI dihentikan", C.dim)
    end
end)

-- ================================================================
--  SCAN LOOP — berjalan terus (untuk highlight + auto collect)
-- ================================================================
task.spawn(function()
    while true do
        task.wait(CFG.scanInterval)
        if CLOSED then break end
        local h = getHRP()
        if not h or not h.Parent then
            character = LP.Character or LP.CharacterAdded:Wait()
            hrp       = resolveHRP(character)
            humanoid  = resolveHumanoid(character)
            task.wait(1); continue
        end

        local folder = getFolder()
        if not folder then
            statusTxt.Text = "⚠ Path tidak ditemukan"; continue
        end

        clearHighlights()
        foundModels = {}
        local nearest, bestDist = nil, math.huge

        for _, model in ipairs(folder:GetChildren()) do
            local prompt = getPromptFromModel(model)
            if prompt then
                local bp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart",true)
                if bp then
                    local d = (bp.Position - h.Position).Magnitude
                    if d <= 15000 then
                        table.insert(foundModels, model)
                        if d < bestDist then nearest, bestDist = model, d end
                        -- Auto collect standalone (tanpa AI)
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

        if nearest then
            local tags = (AUTO_COLLECT and " 📦" or "") .. (BABY_ON and " 🍼" or "") .. (AI_ON and " 🤖" or "")
            statusTxt.Text = string.format("📦 %d | %.0fst%s", #foundModels, bestDist, tags)
            statusTxt.TextColor3 = C.dim
        end
    end
end)

-- ================================================================
--  RESPAWN HANDLER
-- ================================================================
LP.CharacterAdded:Connect(function(char)
    character = char
    hrp       = resolveHRP(char)
    humanoid  = resolveHumanoid(char)
    task.wait(1.5)
    applySpeed(char)

    if not AI_ON then return end
    task.wait(1)
    local h = getHRP(); if not h then return end
    local newWP, newLobby = resolveStartWP(h.Position, wentLobby)
    currentWP = newWP
    wentLobby = newLobby
    lastSaneWP  = newWP
    lastSanePos = h.Position
    local z = getZone(h.Position)
    updateWP(newWP, z or "?")
    updateStatus("🔄 Respawn → resume WP " .. newWP, C.warn)
end)

-- ================================================================
--  MAIN AI LOOP
-- ================================================================
function runAI()
    task.wait(0.5)
    local h = getHRP()
    if h then
        currentWP, wentLobby = resolveStartWP(h.Position, false)
        lastSaneWP  = currentWP
        lastSanePos = h.Position
        local z = getZone(h.Position)
        updateWP(currentWP, z or "?")
        updateStatus("📍 Mulai WP " .. currentWP, C.warn)
    else
        currentWP = 1; wentLobby = false
    end

    collected = 0; updateCount(0)
    local lastSanityCheck = tick()
    task.wait(0.5)

    while AI_ON do
        if CLOSED then break end

        local h2 = getHRP(); local hu = getHum()
        if not h2 or not hu then task.wait(0.5); continue end

        local total = #WAYPOINTS
        if currentWP < 1 or currentWP > total then
            currentWP = 1; wentLobby = false
        end

        -- ──────────────────────────────────────────────────────
        --  SANITY CHECK — cek posisi masuk akal
        -- ──────────────────────────────────────────────────────
        if tick() - lastSanityCheck >= SANITY_CHECK_FREQ then
            lastSanityCheck = tick()
            local sane, reason = isPositionSane(h2.Position, currentWP)
            if not sane then
                updateStatus("⚠ Nyasar: " .. reason .. " → TP balik", C.red)
                task.wait(0.3)
                -- Teleport ke WP terakhir yang sane
                teleportToWP(lastSaneWP)
                task.wait(0.5)
                -- Re-resolve WP dari posisi baru
                local nh = getHRP()
                if nh then
                    local newWP, newLobby = resolveStartWP(nh.Position, wentLobby)
                    currentWP = newWP
                    wentLobby = newLobby
                end
                continue
            else
                -- Update posisi sane terakhir
                lastSaneWP  = currentWP
                lastSanePos = h2.Position
            end
        end

        updateWP(currentWP, getZone(h2.Position) or "?")

        -- ──────────────────────────────────────────────────────
        --  KOREKSI ZONA
        -- ──────────────────────────────────────────────────────
        local curZone = getZone(h2.Position)
        if curZone == "LOBBY" and (currentWP < 36 or currentWP > 77) then
            currentWP = nearestWP(h2.Position, 36, 77)
            updateStatus("📍 Snap lobby WP " .. currentWP, C.warn)
            continue
        end
        if curZone == "ISLAND" and currentWP >= 36 and currentWP <= 77 then
            if wentLobby then
                currentWP = nearestWP(h2.Position, 78, total)
            else
                currentWP = nearestWP(h2.Position, 1, 35)
            end
            updateStatus("📍 Snap island WP " .. currentWP, C.warn)
            continue
        end

        -- ──────────────────────────────────────────────────────
        --  SHORTCUT: evidence penuh → langsung deposit tanpa
        --  ikut jalur. Cari prompt deposit, teleport & fire.
        -- ──────────────────────────────────────────────────────
        if collected >= CFG.maxEvidence then
            updateStatus("💼 Evidence penuh! Cari deposit...", C.ok)
            local pr, pos = findPromptByText("Deposit Evidence")
            if pr then
                -- Teleport langsung ke deposit jika jauh
                local h3 = getHRP()
                if h3 and (h3.Position - pos).Magnitude > 50 then
                    h3.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0))
                    task.wait(0.5)
                end
                firePromptAt(pr, pos, "Deposit")
                task.wait(CFG.depositWait)
            else
                -- Deposit belum ditemukan → tetap ikut jalur sampai WP 117
                updateStatus("⚠ Deposit tidak ditemukan, lanjut jalur", C.warn)
                -- Jika masih di island awal, skip ke jalur balik (WP 78)
                local curZone2 = getZone(h2.Position)
                if curZone2 == "ISLAND" and currentWP <= 35 then
                    currentWP = 78; wentLobby = true
                end
                task.wait(0.5)
            end
            if not AI_ON then break end
            -- Reset setelah deposit
            collected = 0; updateCount(0)
            wentLobby = false; currentWP = 1
            updateStatus("🔄 Deposit selesai, ulang...", C.warn)
            task.wait(1); continue
        end

        -- ──────────────────────────────────────────────────────
        --  WP KRITIS
        -- ──────────────────────────────────────────────────────
        if currentWP == 35 and not wentLobby and collected < CFG.maxEvidence then
            local pr, pos = findPromptByText("Lobby")
            if pr then
                updateStatus("🛗 Masuk Lobby...", C.info)
                firePromptAt(pr, pos, "Lobby")
                task.wait(CFG.liftWait)
                if not AI_ON then break end
                wentLobby = true; currentWP = 36
                continue
            end
        end

        if currentWP == 77 and wentLobby then
            local pr, pos = findPromptByText("Facility")
            if pr then
                updateStatus("🛗 Kembali via Facility...", C.info)
                firePromptAt(pr, pos, "Facility")
                task.wait(CFG.liftWait)
                if not AI_ON then break end
                currentWP = 78
                continue
            end
        end

        if currentWP >= total then
            if collected > 0 then
                local pr, pos = findPromptByText("Deposit Evidence")
                if pr then
                    updateStatus("💼 Deposit " .. collected .. " evidence...", C.ok)
                    firePromptAt(pr, pos, "Deposit")
                    task.wait(CFG.depositWait)
                end
            end
            collected = 0; updateCount(0)
            wentLobby = false; currentWP = 1
            updateStatus("🔄 Siklus selesai", C.warn)
            task.wait(1); continue
        end

        -- ──────────────────────────────────────────────────────
        --  JALAN KE WP
        -- ──────────────────────────────────────────────────────
        local target = WAYPOINTS[currentWP]

        -- Hitung slope SEBELUM jalan → tampil di status
        local preSlope, _, _ = calcSlope(h2.Position, target)
        local slopeIcon = SLOPE_ICON[preSlope] or "—"
        updateStatus(string.format("🚶 WP %d  %s", currentWP, slopeIcon), C.info)

        walkTo(target, CFG.moveTimeout)

        if not AI_ON then break end

        -- ──────────────────────────────────────────────────────
        --  COLLECT
        -- ──────────────────────────────────────────────────────
        collectNearby()

        -- ──────────────────────────────────────────────────────
        --  ADVANCE
        -- ──────────────────────────────────────────────────────
        currentWP += 1
    end

    updateStatus("⏹ AI dihentikan", C.dim)
    updateWP("—", "—")
end

-- ================================================================
--  INIT
-- ================================================================
updateStatus("✅ Ready", C.ok)
