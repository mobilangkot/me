-- ================================================================
--  AI FARMING v6
--  Fix: collect lebih reliable, respawn auto-resume dari WP terdekat
-- ================================================================

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LP               = Players.LocalPlayer

-- ================================================================
--  WAYPOINTS
-- ================================================================
local WAYPOINTS = {
    Vector3.new(-2844.08, -786.00, 15535.26), -- 1
    Vector3.new(-2841.83, -786.00, 15469.03), -- 2
    Vector3.new(-2839.82, -786.00, 15407.23), -- 3
    Vector3.new(-2823.95, -783.30, 15352.84), -- 4
    Vector3.new(-2793.47, -786.61, 15310.43), -- 5
    Vector3.new(-2753.06, -787.00, 15280.31), -- 6
    Vector3.new(-2712.10, -787.00, 15243.69), -- 7
    Vector3.new(-2678.25, -787.00, 15219.84), -- 8
    Vector3.new(-2630.84, -783.01, 15229.19), -- 9
    Vector3.new(-2602.03, -779.05, 15267.92), -- 10
    Vector3.new(-2586.28, -783.02, 15296.52), -- 11
    Vector3.new(-2574.96, -784.50, 15324.83), -- 12
    Vector3.new(-2562.13, -787.10, 15352.45), -- 13
    Vector3.new(-2549.69, -787.04, 15384.58), -- 14
    Vector3.new(-2534.85, -786.99, 15444.39), -- 15
    Vector3.new(-2521.96, -775.79, 15521.11), -- 16
    Vector3.new(-2488.75, -782.81, 15518.27), -- 17
    Vector3.new(-2450.98, -785.41, 15526.71), -- 18
    Vector3.new(-2406.13, -783.92, 15557.54), -- 19
    Vector3.new(-2370.37, -787.00, 15562.21), -- 20
    Vector3.new(-2338.27, -787.00, 15560.76), -- 21
    Vector3.new(-2312.04, -784.49, 15579.04), -- 22
    Vector3.new(-2305.59, -772.94, 15607.23), -- 23
    Vector3.new(-2302.71, -766.74, 15642.35), -- 24
    Vector3.new(-2284.36, -774.73, 15695.58), -- 25
    Vector3.new(-2259.05, -787.92, 15733.13), -- 26
    Vector3.new(-2222.14, -795.63, 15773.63), -- 27
    Vector3.new(-2190.23, -807.28, 15805.32), -- 28
    Vector3.new(-2145.58, -819.91, 15851.93), -- 29
    Vector3.new(-2121.03, -819.91, 15896.32), -- 30
    Vector3.new(-2096.41, -820.35, 15937.70), -- 31
    Vector3.new(-2056.80, -839.85, 15969.66), -- 32
    Vector3.new(-2035.75, -850.47, 15948.00), -- 33
    Vector3.new(-2006.17, -859.85, 15913.94), -- 34
    Vector3.new(-1978.29, -859.52, 15893.26), -- 35  ← dekat lift Lobby

    Vector3.new( 8161.05,  100.88,  3460.91), -- 36  ← spawn lobby
    Vector3.new( 8158.37,  100.64,  3494.41), -- 37
    Vector3.new( 8159.02,  100.64,  3522.74), -- 38
    Vector3.new( 8158.81,  100.64,  3558.08), -- 39
    Vector3.new( 8159.73,  100.64,  3590.28), -- 40
    Vector3.new( 8158.61,  100.83,  3625.13), -- 41
    Vector3.new( 8159.46,  100.84,  3645.38), -- 42
    Vector3.new( 8159.46,  100.84,  3645.38), -- 43
    Vector3.new( 8167.38,  100.84,  3648.28), -- 44
    Vector3.new( 8193.05,  100.62,  3649.47), -- 45
    Vector3.new( 8208.83,  100.62,  3649.71), -- 46
    Vector3.new( 8210.56,  100.62,  3649.66), -- 47
    Vector3.new( 8161.44,  100.84,  3648.02), -- 48
    Vector3.new( 8159.56,  109.26,  3672.78), -- 49
    Vector3.new( 8160.63,  113.94,  3690.39), -- 50
    Vector3.new( 8159.15,  113.82,  3705.11), -- 51
    Vector3.new( 8187.98,  116.25,  3733.73), -- 52
    Vector3.new( 8203.98,  117.37,  3747.99), -- 53
    Vector3.new( 8183.32,  116.26,  3735.35), -- 54
    Vector3.new( 8163.39,  100.84,  3650.50), -- 55
    Vector3.new( 8125.96,  100.84,  3650.04), -- 56
    Vector3.new( 8127.00,  100.64,  3684.04), -- 57
    Vector3.new( 8125.35,   96.02,  3630.31), -- 58
    Vector3.new( 8123.20,   81.51,  3583.60), -- 59
    Vector3.new( 8119.04,   81.47,  3548.72), -- 60
    Vector3.new( 8079.37,   88.86,  3650.81), -- 61
    Vector3.new( 8072.47,   88.97,  3676.20), -- 62
    Vector3.new( 8091.54,   88.97,  3697.91), -- 63
    Vector3.new( 8053.94,   89.01,  3704.00), -- 64
    Vector3.new( 8039.06,   89.01,  3725.00), -- 65
    Vector3.new( 8023.40,   89.01,  3729.14), -- 66
    Vector3.new( 8012.42,   88.97,  3697.87), -- 67
    Vector3.new( 7976.78,   88.86,  3648.18), -- 68
    Vector3.new( 7971.02,   88.79,  3631.04), -- 69
    Vector3.new( 7992.12,   88.86,  3660.91), -- 70
    Vector3.new( 8047.43,   88.97,  3692.23), -- 71
    Vector3.new( 8074.60,   88.86,  3657.15), -- 72
    Vector3.new( 8111.98,  100.77,  3645.79), -- 73
    Vector3.new( 8153.76,  100.84,  3644.37), -- 74
    Vector3.new( 8163.99,  100.64,  3502.53), -- 75
    Vector3.new( 8163.24,  100.64,  3471.31), -- 76

    Vector3.new( 8160.69,  100.88,  3458.90), -- 77  ← dekat lift Facility

    Vector3.new(-1981.01, -859.52, 15893.56), -- 78  ← spawn island balik
    Vector3.new(-2008.04, -859.85, 15927.52), -- 79
    Vector3.new(-2023.92, -855.97, 15946.54), -- 80
    Vector3.new(-2035.30, -847.92, 15957.90), -- 81
    Vector3.new(-2043.15, -842.55, 15965.24), -- 82
    Vector3.new(-2082.77, -834.38, 15961.06), -- 83
    Vector3.new(-2116.49, -819.91, 15913.80), -- 84
    Vector3.new(-2127.41, -819.91, 15886.51), -- 85
    Vector3.new(-2144.26, -819.91, 15863.94), -- 86
    Vector3.new(-2166.86, -819.91, 15844.50), -- 87
    Vector3.new(-2189.64, -811.90, 15820.16), -- 88
    Vector3.new(-2208.76, -800.92, 15798.07), -- 89
    Vector3.new(-2232.80, -793.25, 15773.20), -- 90
    Vector3.new(-2252.08, -787.91, 15751.42), -- 91
    Vector3.new(-2282.99, -781.24, 15712.87), -- 92
    Vector3.new(-2301.43, -767.72, 15673.85), -- 93
    Vector3.new(-2309.92, -765.72, 15635.92), -- 94
    Vector3.new(-2316.02, -771.55, 15600.49), -- 95
    Vector3.new(-2338.61, -787.00, 15559.64), -- 96
    Vector3.new(-2367.72, -787.12, 15553.06), -- 97
    Vector3.new(-2439.47, -783.65, 15545.67), -- 98
    Vector3.new(-2465.73, -786.78, 15525.41), -- 99
    Vector3.new(-2485.76, -787.01, 15502.58), -- 100
    Vector3.new(-2510.66, -786.13, 15469.42), -- 101
    Vector3.new(-2539.26, -786.84, 15435.74), -- 102
    Vector3.new(-2551.99, -786.51, 15406.05), -- 103
    Vector3.new(-2565.88, -787.24, 15365.58), -- 104
    Vector3.new(-2577.78, -784.05, 15319.32), -- 105
    Vector3.new(-2592.48, -781.93, 15288.03), -- 106
    Vector3.new(-2613.13, -779.35, 15258.68), -- 107
    Vector3.new(-2655.81, -784.01, 15243.21), -- 108
    Vector3.new(-2686.39, -785.45, 15255.93), -- 109
    Vector3.new(-2721.29, -784.54, 15271.93), -- 110
    Vector3.new(-2751.75, -787.01, 15285.89), -- 111
    Vector3.new(-2783.55, -787.00, 15300.46), -- 112
    Vector3.new(-2827.74, -784.35, 15362.66), -- 113
    Vector3.new(-2834.13, -786.00, 15434.92), -- 114
    Vector3.new(-2838.56, -786.00, 15493.48), -- 115
    Vector3.new(-2851.38, -786.00, 15524.46), -- 116
    Vector3.new(-2875.53, -787.19, 15550.73), -- 117  ← ujung, deposit lalu reset
}

-- ================================================================
--  ZONA — deteksi dari koordinat Y
--  Island: Y < -100  |  Lobby: Y > 50
-- ================================================================
local ZONE = {
    ISLAND = { wpStart = 1,  wpEnd = 35  },
    LOBBY  = { wpStart = 36, wpEnd = 77  },
    BACK   = { wpStart = 78, wpEnd = 117 },
}

local function getZone(pos)
    if not pos then return nil end
    if pos.Y > 50  then return "LOBBY"  end
    if pos.Y < -100 then return "ISLAND" end
    return nil  -- zona tidak dikenal
end

-- Cari WP terdekat dalam range index tertentu
local function nearestWP(pos, fromIdx, toIdx)
    local bestIdx, bestDist = fromIdx, math.huge
    for i = fromIdx, toIdx do
        local d = (WAYPOINTS[i] - pos).Magnitude
        if d < bestDist then
            bestDist = d
            bestIdx  = i
        end
    end
    return bestIdx
end

-- Dari posisi sekarang, tentukan WP terbaik untuk resume
local function resolveStartWP(pos, wentLobby)
    local zone = getZone(pos)
    if zone == "LOBBY" then
        -- Di lobby → cari WP terdekat di range lobby
        return nearestWP(pos, ZONE.LOBBY.wpStart, ZONE.LOBBY.wpEnd), true
    elseif zone == "ISLAND" then
        if wentLobby then
            -- Sudah pernah ke lobby → lagi di island balik ke deposit
            return nearestWP(pos, ZONE.BACK.wpStart, ZONE.BACK.wpEnd), true
        else
            -- Belum ke lobby → masih di island awal
            return nearestWP(pos, ZONE.ISLAND.wpStart, ZONE.ISLAND.wpEnd), false
        end
    else
        -- Zona tidak dikenal (jatuh ke luar?) → mulai dari WP 1
        return 1, false
    end
end

-- ================================================================
--  CONFIG
-- ================================================================
local CFG = {
    maxEvidence   = 8,
    collectRadius = 20,   -- studs radius collect sambil lewat
    promptReach   = 6,    -- studs jarak stop sebelum fire prompt
    wpReach       = 5,    -- studs dianggap sampai di WP
    moveTimeout   = 5,    -- detik max per WP sebelum skip
    liftWait      = 6,    -- detik tunggu lift
    depositWait   = 3,    -- detik tunggu deposit
    stopTimeout   = 1.0,  -- detik berhenti sebelum fire collect (biar terdaftar)
}

-- ================================================================
--  STATE
-- ================================================================
local AI_ON     = false
local collected = 0
local wentLobby = false
local currentWP = 1

-- ================================================================
--  HELPERS
-- ================================================================
local function ch()  return LP.Character end
local function hrp()
    local c = ch(); if not c then return nil end
    return c:FindFirstChild("HumanoidRootPart")
        or c:FindFirstChild("UpperTorso")
        or c:FindFirstChild("Torso")
end
local function hum()
    local c = ch()
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function wait01() task.wait(0.1) end

-- ================================================================
--  PROMPT HELPERS
-- ================================================================
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

local function collectPromptOf(model)
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            local a = d.ActionText:lower()
            local o = d.ObjectText:lower()
            if a == "collect" or o == "collect" then return d end
        end
    end
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
--  WALK TO — MoveTo murni, tidak ada pathfinding
--  Return true kalau sampai, false kalau timeout/AI mati
-- ================================================================
local function walkTo(target, timeoutSec)
    local hu = hum(); local h = hrp()
    if not hu or not h then return false end
    if (h.Position - target).Magnitude <= CFG.wpReach then return true end

    hu:MoveTo(target)
    local t = 0
    local limit = timeoutSec or CFG.moveTimeout
    while t < limit do
        wait01(); t += 0.1
        if not AI_ON then return false end
        local cur = hrp()
        if not cur then return false end
        if (cur.Position - target).Magnitude <= CFG.wpReach then return true end
    end
    return false  -- timeout → skip saja, tidak ada retry
end

-- ================================================================
--  FIRE PROXIMITY PROMPT — berhenti dulu, baru fire
--  Ini fix utama collect yang gagal di v5
-- ================================================================
local function firePromptAt(prompt, pos, label)
    if not prompt or not pos then return false end

    local hu = hum(); local h = hrp()
    if not hu or not h then return false end

    -- Jalan ke dekat prompt
    if (h.Position - pos).Magnitude > CFG.promptReach then
        hu:MoveTo(pos)
        local t = 0
        while t < 6 do
            wait01(); t += 0.1
            if not AI_ON then return false end
            local cur = hrp()
            if not cur then return false end
            if (cur.Position - pos).Magnitude <= CFG.promptReach then break end
        end
    end

    -- STOP — berhenti total sebelum fire
    -- Ini kunci: karakter harus berhenti bergerak agar prompt terdaftar
    local hu2 = hum(); local h2 = hrp()
    if hu2 and h2 then
        hu2:MoveTo(h2.Position)  -- berhenti di tempat
    end
    task.wait(CFG.stopTimeout)  -- tunggu sebentar

    if not AI_ON then return false end

    -- Fire prompt
    local ok = pcall(function() fireproximityprompt(prompt) end)
    task.wait(0.3)
    return ok
end

-- ================================================================
--  COLLECT EVIDENCE SAMBIL LEWAT
--  Dipanggil tiap sampai di WP — ambil semua dalam radius
-- ================================================================
local function collectNearby()
    if collected >= CFG.maxEvidence then return end
    local folder = getFolder()
    if not folder then return end

    local h = hrp()
    if not h then return end

    -- Kumpulkan evidence dalam radius
    local nearby = {}
    for _, model in ipairs(folder:GetChildren()) do
        local pr = collectPromptOf(model)
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

        setStatus("📦 " .. ev.name .. string.format(" (%.0fst)", ev.d), Color3.fromRGB(80,220,130))

        local ok = firePromptAt(ev.prompt, ev.pos, ev.name)
        if ok then
            collected += 1
            setCount(collected)
            setStatus("✅ " .. collected .. "/" .. CFG.maxEvidence, Color3.fromRGB(80,220,130))
        end
        task.wait(0.2)
    end
end

-- ================================================================
--  GUI — minimalis
-- ================================================================
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "AIv6"; gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size             = UDim2.new(0, 255, 0, 155)
frame.Position         = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(13,13,17)
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local strip = Instance.new("Frame", frame)
strip.Size=UDim2.new(1,0,0,3); strip.BackgroundColor3=Color3.fromRGB(30,180,120)
strip.BorderSizePixel=0; strip.ZIndex=5
Instance.new("UICorner",strip).CornerRadius=UDim.new(0,12)

local function mkLbl(txt, y, col, font, sz)
    local l = Instance.new("TextLabel", frame)
    l.Size=UDim2.new(1,-16,0,16); l.Position=UDim2.new(0,10,0,y)
    l.BackgroundTransparency=1; l.Text=txt
    l.TextColor3=col or Color3.fromRGB(180,180,180)
    l.Font=font or Enum.Font.Gotham; l.TextSize=sz or 11
    l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=4
    return l
end

mkLbl("🧠  AI Farming v6", 7, Color3.fromRGB(255,255,255), Enum.Font.GothamBold, 13)

local statusLbl = mkLbl("Idle",          26, Color3.fromRGB(160,160,180))
local countLbl  = mkLbl("Evidence: 0/8", 44, Color3.fromRGB(80,220,130), Enum.Font.GothamBold)
local wpLbl     = mkLbl("WP: —",         60, Color3.fromRGB(120,120,180), Enum.Font.Code, 10)
local zoneLbl   = mkLbl("Zona: —",       74, Color3.fromRGB(140,140,160), Enum.Font.Code, 10)

local btnAI = Instance.new("TextButton", frame)
btnAI.Size=UDim2.new(1,-16,0,36); btnAI.Position=UDim2.new(0,8,0,95)
btnAI.BackgroundColor3=Color3.fromRGB(32,32,42)
btnAI.TextColor3=Color3.new(1,1,1); btnAI.Font=Enum.Font.GothamBold
btnAI.TextSize=13; btnAI.Text="🧠  AI  :  OFF"
btnAI.AutoButtonColor=false; btnAI.BorderSizePixel=0; btnAI.ZIndex=3
Instance.new("UICorner",btnAI).CornerRadius=UDim.new(0,9)

local hintL = Instance.new("TextLabel",frame)
hintL.Size=UDim2.new(1,-16,0,10); hintL.Position=UDim2.new(0,8,1,-12)
hintL.BackgroundTransparency=1; hintL.Text="RightCtrl = hide/show"
hintL.TextColor3=Color3.fromRGB(45,45,60); hintL.Font=Enum.Font.Gotham
hintL.TextSize=9; hintL.TextXAlignment=Enum.TextXAlignment.Left; hintL.ZIndex=3

UserInputService.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode==Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)

-- GUI updaters — didefinisikan setelah label dibuat
function setStatus(t, col)
    statusLbl.Text=t; statusLbl.TextColor3=col or Color3.fromRGB(160,160,180)
end
function setCount(n)
    countLbl.Text="Evidence: "..n.."/"..CFG.maxEvidence
end
function setWPLabel(i)
    wpLbl.Text="WP: "..i.."/"..#WAYPOINTS
end
function setZone(z)
    local col = z=="LOBBY" and Color3.fromRGB(80,180,255)
             or z=="ISLAND" and Color3.fromRGB(80,220,130)
             or Color3.fromRGB(200,100,100)
    zoneLbl.Text="Zona: "..(z or "?"); zoneLbl.TextColor3=col
end

-- ================================================================
--  RESPAWN HANDLER
--  Kalau karakter respawn (jatuh dll), deteksi zona baru dan
--  resume dari WP terdekat di zona tersebut
-- ================================================================
LP.CharacterAdded:Connect(function()
    if not AI_ON then return end
    -- Tunggu karakter load
    task.wait(2)
    local h = hrp()
    if not h then return end

    local newWP, newLobby = resolveStartWP(h.Position, wentLobby)
    currentWP = newWP
    wentLobby = newLobby

    local z = getZone(h.Position)
    setZone(z or "?")
    setStatus("🔄 Respawn — resume WP "..newWP, Color3.fromRGB(255,200,60))
end)

-- ================================================================
--  MAIN AI LOOP
-- ================================================================
local function runAI()
    -- Deteksi posisi awal
    task.wait(0.5)
    local h = hrp()
    if h then
        currentWP, wentLobby = resolveStartWP(h.Position, false)
        local z = getZone(h.Position)
        setZone(z or "?")
        setStatus("📍 Mulai dari WP "..currentWP, Color3.fromRGB(255,220,60))
    else
        currentWP = 1
        wentLobby = false
    end

    collected = 0; setCount(0)
    task.wait(0.5)

    while AI_ON do
        local h2 = hrp(); local hu = hum()
        if not h2 or not hu then task.wait(0.5); continue end

        local total = #WAYPOINTS

        -- Pastikan currentWP valid
        if currentWP < 1 or currentWP > total then
            currentWP = 1; wentLobby = false
        end

        setWPLabel(currentWP)
        setZone(getZone(h2.Position) or "?")

        -- ──────────────────────────────────────────────────────────────────
        --  KEPUTUSAN KHUSUS DI WP KRITIS
        -- ──────────────────────────────────────────────────────────────────

        -- WP 35: ujung island → coba masuk lobby kalau belum & belum penuh
        if currentWP == 35 and not wentLobby and collected < CFG.maxEvidence then
            local pr, pos = findPromptByText("Lobby")
            if pr then
                setStatus("🛗 Masuk Lobby...", Color3.fromRGB(255,220,60))
                firePromptAt(pr, pos, "Lobby")
                task.wait(CFG.liftWait)
                if not AI_ON then break end
                wentLobby = true
                currentWP = 36
                setZone("LOBBY")
                continue
            end
        end

        -- WP 77: ujung lobby → kembali ke island via Facility
        if currentWP == 77 and wentLobby then
            local pr, pos = findPromptByText("Facility")
            if pr then
                setStatus("🛗 Kembali via Facility...", Color3.fromRGB(255,220,60))
                firePromptAt(pr, pos, "Facility")
                task.wait(CFG.liftWait)
                if not AI_ON then break end
                currentWP = 78
                setZone("ISLAND")
                continue
            end
        end

        -- WP 117: akhir jalur → deposit, reset
        if currentWP >= total then
            if collected > 0 then
                local pr, pos = findPromptByText("Deposit Evidence")
                if pr then
                    setStatus("💼 Deposit "..collected.." evidence...", Color3.fromRGB(80,220,130))
                    firePromptAt(pr, pos, "Deposit")
                    task.wait(CFG.depositWait)
                end
            end
            collected=0; setCount(0)
            wentLobby=false; currentWP=1
            setStatus("🔄 Siklus selesai, ulang...", Color3.fromRGB(255,220,60))
            task.wait(1)
            continue
        end

        -- ──────────────────────────────────────────────────────────────────
        --  KOREKSI ZONA — kalau karakter ada di zona salah
        --  (misal: spawn acak di island tapi WP lagi di lobby range)
        -- ──────────────────────────────────────────────────────────────────
        local curZone = getZone(h2.Position)
        if curZone == "LOBBY" and (currentWP < 36 or currentWP > 77) then
            -- Di lobby tapi WP bukan range lobby → snap ke WP terdekat di lobby
            currentWP = nearestWP(h2.Position, 36, 77)
            setStatus("📍 Snap ke WP lobby "..currentWP, Color3.fromRGB(255,200,60))
            continue
        end
        if curZone == "ISLAND" and currentWP >= 36 and currentWP <= 77 then
            -- Di island tapi WP di range lobby → snap ke island
            if wentLobby then
                currentWP = nearestWP(h2.Position, 78, total)
            else
                currentWP = nearestWP(h2.Position, 1, 35)
            end
            setStatus("📍 Snap ke WP island "..currentWP, Color3.fromRGB(255,200,60))
            continue
        end

        -- ──────────────────────────────────────────────────────────────────
        --  JALAN KE WP
        -- ──────────────────────────────────────────────────────────────────
        local target = WAYPOINTS[currentWP]
        setStatus(string.format("🚶 WP %d", currentWP), Color3.fromRGB(100,160,255))
        walkTo(target, CFG.moveTimeout)

        if not AI_ON then break end

        -- ──────────────────────────────────────────────────────────────────
        --  COLLECT SAMBIL LEWAT
        -- ──────────────────────────────────────────────────────────────────
        collectNearby()

        -- ──────────────────────────────────────────────────────────────────
        --  MAJU KE WP BERIKUTNYA
        -- ──────────────────────────────────────────────────────────────────
        currentWP += 1
    end

    setStatus("⏹ Dihentikan", Color3.fromRGB(160,160,180))
    wpLbl.Text="WP: —"; zoneLbl.Text="Zona: —"
end

-- ================================================================
--  TOMBOL
-- ================================================================
local C_ON  = Color3.fromRGB(15,130,90)
local C_OFF = Color3.fromRGB(32,32,42)

btnAI.MouseButton1Click:Connect(function()
    AI_ON = not AI_ON
    if AI_ON then
        btnAI.Text="🧠  AI  :  ON"; btnAI.BackgroundColor3=C_ON
        task.spawn(runAI)
    else
        btnAI.Text="🧠  AI  :  OFF"; btnAI.BackgroundColor3=C_OFF
        local hu=hum(); local h=hrp()
        if hu and h then hu:MoveTo(h.Position) end
        setStatus("⏹ Dihentikan", Color3.fromRGB(160,160,180))
        wpLbl.Text="WP: —"; zoneLbl.Text="Zona: —"
    end
end)

setStatus("✅ Ready — tekan AI ON", Color3.fromRGB(80,220,130))
