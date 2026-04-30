-- ================================================================
--  AI FARMING v5  —  SMART WAYPOINT LOOP
--  Satu jalur, jalan terus, collect sambil lewat.
--  Lobby/Facility/Deposit di-trigger otomatis sesuai kondisi.
-- ================================================================

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LP               = Players.LocalPlayer

-- ================================================================
--  WAYPOINT DATA
-- ================================================================
local WAYPOINTS = {
    -- === Island → Lift Lobby ===
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
    Vector3.new(-1978.29, -859.52, 15893.26), -- 35  ← ujung: dekat lift lobby

    -- === Lobby → Area Evidence ===
    Vector3.new( 8161.05,  100.88,  3460.91), -- 36  ← spawn setelah lift
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

    -- === Kembali ke Lift Island ===
    Vector3.new( 8160.69,  100.88,  3458.90), -- 77  ← dekat lift facility

    -- === Island → Deposit ===
    Vector3.new(-1981.01, -859.52, 15893.56), -- 78  ← spawn setelah lift
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
    Vector3.new(-2875.53, -787.19, 15550.73), -- 117
}

-- ================================================================
--  DETEKSI ZONA dari koordinat
--  Island: Y sekitar -786, X sekitar -2000 s/d -2900
--  Lobby:  Y sekitar 100,  X sekitar 7900 s/d 8300
-- ================================================================
local function isLobbyZone(pos)
    return pos.Y > 50  -- lobby jauh lebih tinggi dari island
end

-- WP 35 = ujung island sebelum lift lobby
-- WP 36 = pertama di lobby
-- WP 77 = ujung lobby sebelum lift facility
-- WP 78 = pertama di island setelah lift
local WP_LIFT_LOBBY    = 35   -- waypoint terdekat ke prompt Lobby
local WP_LIFT_FACILITY = 77   -- waypoint terdekat ke prompt Facility
local WP_DEPOSIT_AREA  = 110  -- mulai dekat deposit (island, balik)

-- ================================================================
--  CONFIG
-- ================================================================
local CFG = {
    maxEvidence   = 8,
    collectRadius = 20,   -- studs — radius ambil evidence sambil lewat
    promptReach   = 10,   -- studs — jarak fire prompt
    wpReach       = 5,    -- studs — dianggap sampai di waypoint
    moveTimeout   = 4,    -- detik max per waypoint
    liftWait      = 6,    -- detik tunggu lift/teleport
    depositWait   = 3,    -- detik tunggu animasi deposit
}

-- ================================================================
--  STATE
-- ================================================================
local AI_ON      = false
local collected  = 0        -- evidence terkumpul cycle ini
local wentLobby  = false    -- sudah ke lobby cycle ini?
local didDeposit = false    -- sudah deposit cycle ini?

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

-- ================================================================
--  EVIDENCE HELPERS
-- ================================================================
local function getFolder()
    local ok, r = pcall(function()
        return workspace:WaitForChild("Data",3)
            :WaitForChild("Detective",3)
            :WaitForChild("Evidence",3)
            :WaitForChild("Instances",3)
    end)
    return ok and r or nil
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

-- ================================================================
--  GUI — minimalis, hanya status + tombol ON/OFF
-- ================================================================
local gui   = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name    = "AIv5"; gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size             = UDim2.new(0, 260, 0, 160)
frame.Position         = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local accentLine = Instance.new("Frame", frame)
accentLine.Size             = UDim2.new(1, 0, 0, 3)
accentLine.BackgroundColor3 = Color3.fromRGB(30, 180, 120)
accentLine.BorderSizePixel  = 0; accentLine.ZIndex = 5
Instance.new("UICorner", accentLine).CornerRadius = UDim.new(0, 12)

local titleLbl = Instance.new("TextLabel", frame)
titleLbl.Size              = UDim2.new(1, -16, 0, 18)
titleLbl.Position          = UDim2.new(0, 12, 0, 8)
titleLbl.BackgroundTransparency = 1
titleLbl.Text              = "🧠  AI Farming v5"
titleLbl.TextColor3        = Color3.fromRGB(255, 255, 255)
titleLbl.Font              = Enum.Font.GothamBold
titleLbl.TextSize          = 13
titleLbl.TextXAlignment    = Enum.TextXAlignment.Left
titleLbl.ZIndex            = 4

-- Status
local statusLbl = Instance.new("TextLabel", frame)
statusLbl.Size             = UDim2.new(1, -16, 0, 14)
statusLbl.Position         = UDim2.new(0, 12, 0, 30)
statusLbl.BackgroundTransparency = 1
statusLbl.Text             = "Idle"
statusLbl.TextColor3       = Color3.fromRGB(160, 160, 180)
statusLbl.Font             = Enum.Font.Gotham
statusLbl.TextSize         = 11
statusLbl.TextXAlignment   = Enum.TextXAlignment.Left
statusLbl.ZIndex           = 4

-- Evidence count
local countLbl = Instance.new("TextLabel", frame)
countLbl.Size             = UDim2.new(1, -16, 0, 13)
countLbl.Position         = UDim2.new(0, 12, 0, 47)
countLbl.BackgroundTransparency = 1
countLbl.Text             = "Evidence: 0 / " .. CFG.maxEvidence
countLbl.TextColor3       = Color3.fromRGB(80, 220, 130)
countLbl.Font             = Enum.Font.GothamBold
countLbl.TextSize         = 11
countLbl.TextXAlignment   = Enum.TextXAlignment.Left
countLbl.ZIndex           = 4

-- WP info
local wpLbl = Instance.new("TextLabel", frame)
wpLbl.Size             = UDim2.new(1, -16, 0, 12)
wpLbl.Position         = UDim2.new(0, 12, 0, 63)
wpLbl.BackgroundTransparency = 1
wpLbl.Text             = "WP: —"
wpLbl.TextColor3       = Color3.fromRGB(120, 120, 160)
wpLbl.Font             = Enum.Font.Code
wpLbl.TextSize         = 10
wpLbl.TextXAlignment   = Enum.TextXAlignment.Left
wpLbl.ZIndex           = 4

-- Tombol ON/OFF
local btnAI = Instance.new("TextButton", frame)
btnAI.Size             = UDim2.new(1, -16, 0, 36)
btnAI.Position         = UDim2.new(0, 8, 0, 84)
btnAI.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
btnAI.TextColor3       = Color3.new(1, 1, 1)
btnAI.Font             = Enum.Font.GothamBold
btnAI.TextSize         = 13
btnAI.Text             = "🧠  AI  :  OFF"
btnAI.AutoButtonColor  = false
btnAI.BorderSizePixel  = 0
btnAI.ZIndex           = 3
Instance.new("UICorner", btnAI).CornerRadius = UDim.new(0, 9)

local hint = Instance.new("TextLabel", frame)
hint.Size               = UDim2.new(1, -16, 0, 11)
hint.Position           = UDim2.new(0, 8, 1, -13)
hint.BackgroundTransparency = 1
hint.Text               = "RightCtrl = hide/show"
hint.TextColor3         = Color3.fromRGB(45, 45, 60)
hint.Font               = Enum.Font.Gotham
hint.TextSize           = 9
hint.TextXAlignment     = Enum.TextXAlignment.Left
hint.ZIndex             = 3

UserInputService.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)

local function setStatus(t, col)
    statusLbl.Text      = t
    statusLbl.TextColor3 = col or Color3.fromRGB(160, 160, 180)
end
local function setCount(n)
    countLbl.Text = "Evidence: " .. n .. " / " .. CFG.maxEvidence
end
local function setWP(i, total)
    wpLbl.Text = "WP: " .. i .. " / " .. total
end

-- ================================================================
--  FIRE PROMPT — jalan ke posisi lalu trigger
-- ================================================================
local function fireAt(prompt, pos, label)
    if not prompt or not pos then return false end
    local h = hrp(); local hu = hum()
    if not h or not hu then return false end

    -- Jalan ke posisi prompt
    if (h.Position - pos).Magnitude > CFG.promptReach then
        setStatus("🚶 → " .. label, Color3.fromRGB(80, 180, 255))
        hu:MoveTo(pos)
        local t = 0
        repeat
            task.wait(0.1); t += 0.1
            if not AI_ON then return false end
            local c = hrp()
            if c and (c.Position - pos).Magnitude <= CFG.promptReach then break end
        until t >= 6
    end

    task.wait(0.2)
    local ok = pcall(function() fireproximityprompt(prompt) end)
    return ok
end

-- ================================================================
--  COLLECT EVIDENCE TERDEKAT dari posisi sekarang
--  Dipanggil setiap kali karakter sampai di waypoint
-- ================================================================
local function tryCollectNearby()
    if collected >= CFG.maxEvidence then return end
    local folder = getFolder()
    if not folder then return end

    local h = hrp()
    if not h then return end

    -- Kumpulkan semua evidence dalam radius
    local nearby = {}
    for _, model in ipairs(folder:GetChildren()) do
        local pr = collectPromptOf(model)
        if pr then
            local bp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
            if bp then
                local d = (bp.Position - h.Position).Magnitude
                if d <= CFG.collectRadius then
                    table.insert(nearby, { prompt = pr, pos = bp.Position, d = d, name = model.Name })
                end
            end
        end
    end

    if #nearby == 0 then return end
    table.sort(nearby, function(a, b) return a.d < b.d end)

    local hu = hum()
    if not hu then return end

    for _, ev in ipairs(nearby) do
        if not AI_ON then return end
        if collected >= CFG.maxEvidence then break end

        -- Jalan ke evidence
        setStatus(string.format("📦 %s (%.0fst)", ev.name, ev.d), Color3.fromRGB(80, 220, 130))
        hu:MoveTo(ev.pos)

        local t = 0
        repeat
            task.wait(0.1); t += 0.1
            if not AI_ON then return end
            local c = hrp()
            if c and (c.Position - ev.pos).Magnitude <= CFG.promptReach then break end
        until t >= 5

        local ok = pcall(function() fireproximityprompt(ev.prompt) end)
        if ok then
            collected += 1
            setCount(collected)
        end
        task.wait(0.3)
    end
end

-- ================================================================
--  MAIN AI LOOP
--  Satu loop besar: jalan waypoint 1→117, lalu ulang.
--  Keputusan lift/deposit dibuat berdasarkan index WP + kondisi.
-- ================================================================
local function runAI()
    collected  = 0
    wentLobby  = false
    didDeposit = false
    setCount(0)
    setStatus("🤖 Mulai...", Color3.fromRGB(255, 220, 60))
    task.wait(1)

    local totalWP   = #WAYPOINTS
    local currentWP = 1   -- mulai dari awal

    -- Deteksi posisi awal: kalau sudah di lobby, mulai dari WP 36
    local startH = hrp()
    if startH and isLobbyZone(startH.Position) then
        currentWP = 36
        wentLobby = true
    end

    while AI_ON do

        -- ── Ambil waypoint saat ini ───────────────────────────────────────
        local target = WAYPOINTS[currentWP]
        if not target then
            -- Selesai satu putaran → reset
            currentWP  = 1
            collected  = 0
            wentLobby  = false
            didDeposit = false
            setCount(0)
            setStatus("🔄 Ulang siklus...", Color3.fromRGB(255, 220, 60))
            task.wait(1)
            continue
        end

        local h  = hrp()
        local hu = hum()
        if not h or not hu then task.wait(0.5); continue end

        setWP(currentWP, totalWP)

        -- ── Logika khusus di WP tertentu ─────────────────────────────────

        -- WP 35: ujung island → trigger Lobby lift (kalau belum ke lobby & belum penuh)
        if currentWP == WP_LIFT_LOBBY and not wentLobby and collected < CFG.maxEvidence then
            local pr, pos = findPromptByText("Lobby")
            if pr then
                setStatus("🛗 Masuk lift Lobby...", Color3.fromRGB(255, 220, 60))
                fireAt(pr, pos, "Lobby Lift")
                task.wait(CFG.liftWait)
                if not AI_ON then break end
                -- Setelah lift, lompat ke WP 36 (lobby)
                wentLobby = true
                currentWP = 36
                continue
            end
        end

        -- WP 77: ujung lobby → trigger Facility lift (kalau sudah penuh ATAU sudah keliling lobby)
        if currentWP == WP_LIFT_FACILITY and wentLobby then
            -- Selalu balik ke island setelah selesai lobby
            local pr, pos = findPromptByText("Facility")
            if pr then
                setStatus("🛗 Kembali via Facility lift...", Color3.fromRGB(255, 220, 60))
                fireAt(pr, pos, "Facility Lift")
                task.wait(CFG.liftWait)
                if not AI_ON then break end
                -- Setelah lift, lompat ke WP 78 (island, balik ke deposit)
                currentWP = 78
                continue
            end
        end

        -- WP 117: sudah kembali ke boat/deposit area → deposit kalau ada evidence
        if currentWP == totalWP then
            if collected > 0 then
                local pr, pos = findPromptByText("Deposit Evidence")
                if pr then
                    setStatus("💼 Deposit " .. collected .. " evidence...", Color3.fromRGB(80, 220, 130))
                    fireAt(pr, pos, "Deposit Evidence")
                    task.wait(CFG.depositWait)
                end
            end
            -- Reset siklus
            currentWP  = 1
            collected  = 0
            wentLobby  = false
            setCount(0)
            setStatus("🔄 Siklus selesai, ulang...", Color3.fromRGB(255, 220, 60))
            task.wait(1)
            continue
        end

        -- ── Skip waypoint yang tidak relevan dengan zona saat ini ─────────
        -- Kalau di island tapi WP masuk range lobby (36-77), skip ke 78
        if not isLobbyZone(h.Position) and currentWP >= 36 and currentWP <= 77 then
            currentWP = 78
            continue
        end
        -- Kalau di lobby tapi WP masuk range island (1-35 atau 78-117), skip ke 36
        if isLobbyZone(h.Position) and (currentWP <= 35 or currentWP >= 78) then
            currentWP = 36
            continue
        end

        -- ── Jalan ke waypoint ─────────────────────────────────────────────
        -- Skip kalau sudah dekat
        if (h.Position - target).Magnitude > CFG.wpReach then
            setStatus(string.format("🚶 WP %d", currentWP), Color3.fromRGB(100, 160, 255))
            hu:MoveTo(target)

            local elapsed = 0
            while elapsed < CFG.moveTimeout do
                task.wait(0.1)
                elapsed += 0.1
                if not AI_ON then break end
                local cur = hrp()
                if cur and (cur.Position - target).Magnitude <= CFG.wpReach then break end
            end
        end

        if not AI_ON then break end

        -- ── Collect evidence sambil lewat ─────────────────────────────────
        tryCollectNearby()

        -- ── Maju ke waypoint berikutnya ───────────────────────────────────
        currentWP += 1
    end

    setStatus("⏹ Dihentikan", Color3.fromRGB(160, 160, 180))
    wpLbl.Text = "WP: —"
end

-- ================================================================
--  TOMBOL
-- ================================================================
local C_ON  = Color3.fromRGB(15, 130, 90)
local C_OFF = Color3.fromRGB(32, 32, 42)

btnAI.MouseButton1Click:Connect(function()
    AI_ON = not AI_ON
    if AI_ON then
        btnAI.Text             = "🧠  AI  :  ON"
        btnAI.BackgroundColor3 = C_ON
        task.spawn(runAI)
    else
        AI_ON = false
        btnAI.Text             = "🧠  AI  :  OFF"
        btnAI.BackgroundColor3 = C_OFF
        local hu = hum(); local h = hrp()
        if hu and h then hu:MoveTo(h.Position) end
        setStatus("⏹ Dihentikan", Color3.fromRGB(160, 160, 180))
        wpLbl.Text = "WP: —"
    end
end)

LP.CharacterAdded:Connect(function() end)
setStatus("✅ Ready — tekan AI ON", Color3.fromRGB(80, 220, 130))
