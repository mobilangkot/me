-- ============================================================
--  AI FARMING v3  —  Pure Waypoint MoveTo (no pathfinding)
--  Jalur ikut waypoint recorder persis, tidak ada pathfinding
--  yang bikin kedut / lurus bypass jalur.
--
--  CARA PAKAI:
--  1. Paste hasil recorder ke WAYPOINT_DATA di bawah
--  2. Isi SECTION_START sesuai index awal tiap section
--  3. Scan prompt → Start AI
-- ============================================================

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer

-- ============================================================
--  PASTE WAYPOINTS DI SINI (hasil Generate & Copy dari recorder)
-- ============================================================
local WAYPOINTS = {
    -- === Boat → Lift Lobby ===
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
    Vector3.new(-1978.29, -859.52, 15893.26), -- 35
    -- === Lobby → Area Evidence ===
    Vector3.new(8161.05, 100.88, 3460.91), -- 36
    Vector3.new(8158.37, 100.64, 3494.41), -- 37
    Vector3.new(8159.02, 100.64, 3522.74), -- 38
    Vector3.new(8158.81, 100.64, 3558.08), -- 39
    Vector3.new(8159.73, 100.64, 3590.28), -- 40
    Vector3.new(8158.61, 100.83, 3625.13), -- 41
    Vector3.new(8159.46, 100.84, 3645.38), -- 42
    Vector3.new(8159.46, 100.84, 3645.38), -- 43
    Vector3.new(8167.38, 100.84, 3648.28), -- 44
    Vector3.new(8193.05, 100.62, 3649.47), -- 45
    Vector3.new(8208.83, 100.62, 3649.71), -- 46
    Vector3.new(8210.56, 100.62, 3649.66), -- 47
    Vector3.new(8161.44, 100.84, 3648.02), -- 48
    Vector3.new(8159.56, 109.26, 3672.78), -- 49
    Vector3.new(8160.63, 113.94, 3690.39), -- 50
    Vector3.new(8159.15, 113.82, 3705.11), -- 51
    Vector3.new(8187.98, 116.25, 3733.73), -- 52
    Vector3.new(8203.98, 117.37, 3747.99), -- 53
    Vector3.new(8183.32, 116.26, 3735.35), -- 54
    Vector3.new(8163.39, 100.84, 3650.50), -- 55
    Vector3.new(8125.96, 100.84, 3650.04), -- 56
    Vector3.new(8127.00, 100.64, 3684.04), -- 57
    Vector3.new(8125.35, 96.02, 3630.31), -- 58
    Vector3.new(8123.20, 81.51, 3583.60), -- 59
    Vector3.new(8119.04, 81.47, 3548.72), -- 60
    Vector3.new(8079.37, 88.86, 3650.81), -- 61
    Vector3.new(8072.47, 88.97, 3676.20), -- 62
    Vector3.new(8091.54, 88.97, 3697.91), -- 63
    Vector3.new(8053.94, 89.01, 3704.00), -- 64
    Vector3.new(8039.06, 89.01, 3725.00), -- 65
    Vector3.new(8023.40, 89.01, 3729.14), -- 66
    Vector3.new(8012.42, 88.97, 3697.87), -- 67
    Vector3.new(7976.78, 88.86, 3648.18), -- 68
    Vector3.new(7971.02, 88.79, 3631.04), -- 69
    Vector3.new(7992.12, 88.86, 3660.91), -- 70
    Vector3.new(8047.43, 88.97, 3692.23), -- 71
    Vector3.new(8074.60, 88.86, 3657.15), -- 72
    Vector3.new(8111.98, 100.77, 3645.79), -- 73
    Vector3.new(8153.76, 100.84, 3644.37), -- 74
    Vector3.new(8163.99, 100.64, 3502.53), -- 75
    Vector3.new(8163.24, 100.64, 3471.31), -- 76
    -- === Area Evidence → Lift Island ===
    Vector3.new(8160.69, 100.88, 3458.90), -- 77
    -- === Lift Island → Boat ===
    Vector3.new(-1981.01, -859.52, 15893.56), -- 78
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

-- Index awal tiap section di WAYPOINT_DATA
-- Lihat komentar "-- ===" di output recorder untuk tahu index-nya
local SECTION_START = {
    ["Boat → Lift Lobby"]            = 1,
    ["Lobby → Area Evidence"]        = 1,  -- ganti sesuai index kamu
    ["Area Evidence → Lift Island"]  = 1,  -- ganti sesuai index kamu
    ["Lift Island → Boat"]           = 1,  -- ganti sesuai index kamu
}

-- ============================================================
--  CONFIG
-- ============================================================
local MAX_COL        = 8     -- max evidence per cycle
local WP_REACH       = 5     -- radius "sampai" per waypoint (studs)
local COLLECT_RADIUS = 20    -- radius collect evidence dari posisi saat ini
local PROMPT_REACH   = 8     -- jarak max trigger proximity prompt
local LIFT_WAIT      = 5     -- detik tunggu lift
local DEPOSIT_WAIT   = 4     -- detik tunggu deposit
local MOVETO_TIMEOUT = 3     -- detik timeout per waypoint MoveTo

-- ============================================================
--  STATE
-- ============================================================
local AI_ON     = false
local COL_COUNT = 0

local savedPrompts = { deposit = nil, lobby = nil, facility = nil }
local savedPos     = { deposit = nil, lobby = nil, facility = nil }

-- ============================================================
--  HELPERS
-- ============================================================
local function getChar() return LP.Character end
local function getHRP()
    local c = getChar()
    if not c then return nil end
    return c:FindFirstChild("HumanoidRootPart")
        or c:FindFirstChild("UpperTorso")
        or c:FindFirstChild("Torso")
end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- Ambil slice waypoints untuk satu section
local function getSectionWP(sectionName)
    -- Urutkan section berdasarkan index start
    local ordered = {}
    for name, idx in pairs(SECTION_START) do
        table.insert(ordered, { name = name, idx = idx })
    end
    table.sort(ordered, function(a, b) return a.idx < b.idx end)

    local startIdx, endIdx = nil, #WAYPOINT_DATA
    for i, entry in ipairs(ordered) do
        if entry.name == sectionName then
            startIdx = entry.idx
            if ordered[i + 1] then
                endIdx = ordered[i + 1].idx - 1
            end
            break
        end
    end

    if not startIdx then return {} end

    local result = {}
    for i = startIdx, endIdx do
        if WAYPOINT_DATA[i] then
            table.insert(result, WAYPOINT_DATA[i])
        end
    end
    return result
end

-- ============================================================
--  GUI
-- ============================================================
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name         = "AIFarming_v3"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size             = UDim2.new(0, 300, 0, 480)
frame.Position         = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Accent strip
local accent = Instance.new("Frame", frame)
accent.Size             = UDim2.new(1, 0, 0, 3)
accent.BackgroundColor3 = Color3.fromRGB(30, 180, 120)
accent.BorderSizePixel  = 0
accent.ZIndex           = 5
Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 12)

-- Title bar
local titleBar = Instance.new("Frame", frame)
titleBar.Size             = UDim2.new(1, 0, 0, 40)
titleBar.Position         = UDim2.new(0, 0, 0, 3)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
titleBar.BorderSizePixel  = 0
titleBar.ZIndex           = 4

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size              = UDim2.new(1, -12, 0, 21)
titleLbl.Position          = UDim2.new(0, 12, 0, 4)
titleLbl.BackgroundTransparency = 1
titleLbl.TextColor3        = Color3.fromRGB(255, 255, 255)
titleLbl.Font              = Enum.Font.GothamBold
titleLbl.TextSize          = 14
titleLbl.TextXAlignment    = Enum.TextXAlignment.Left
titleLbl.Text              = "🧠  AI Farming v3"
titleLbl.ZIndex            = 5

local subLbl = Instance.new("TextLabel", titleBar)
subLbl.Size              = UDim2.new(1, -12, 0, 13)
subLbl.Position          = UDim2.new(0, 12, 0, 24)
subLbl.BackgroundTransparency = 1
subLbl.TextColor3        = Color3.fromRGB(30, 180, 120)
subLbl.Font              = Enum.Font.Gotham
subLbl.TextSize          = 11
subLbl.TextXAlignment    = Enum.TextXAlignment.Left
subLbl.Text              = "Pure Waypoint — No Pathfinding"
subLbl.ZIndex            = 5

-- Info bars
local function makeInfoBar(posY, h)
    local b = Instance.new("Frame", frame)
    b.Size             = UDim2.new(1, -16, 0, h or 24)
    b.Position         = UDim2.new(0, 8, 0, posY)
    b.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    b.BorderSizePixel  = 0
    b.ZIndex           = 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    return b
end
local function makeInfoLabel(parent, col, size)
    local l = Instance.new("TextLabel", parent)
    l.Size               = UDim2.new(1, -10, 1, 0)
    l.Position           = UDim2.new(0, 8, 0, 0)
    l.BackgroundTransparency = 1
    l.TextColor3         = col or Color3.fromRGB(160, 160, 180)
    l.Font               = Enum.Font.Gotham
    l.TextSize           = size or 11
    l.TextXAlignment     = Enum.TextXAlignment.Left
    l.ZIndex             = 4
    return l
end

local statusBar  = makeInfoBar(50, 26)
local statusLbl  = makeInfoLabel(statusBar, Color3.fromRGB(160, 160, 180))
statusLbl.Text   = "Idle"

local countBar   = makeInfoBar(82, 22)
local countLbl   = makeInfoLabel(countBar, Color3.fromRGB(80, 220, 130), 11)
countLbl.Font    = Enum.Font.GothamBold
countLbl.Text    = "Evidence: 0 / " .. MAX_COL

local phaseBar   = makeInfoBar(110, 22)
local phaseLbl   = makeInfoLabel(phaseBar, Color3.fromRGB(255, 220, 60))
phaseLbl.Text    = "Phase: —"

local wpBar      = makeInfoBar(138, 22)
local wpLbl      = makeInfoLabel(wpBar, Color3.fromRGB(140, 140, 200), 10)
wpLbl.Font       = Enum.Font.Code
wpLbl.Text       = "WP: —"

-- Prompt panel
local posPanel = Instance.new("Frame", frame)
posPanel.Size             = UDim2.new(1, -16, 0, 80)
posPanel.Position         = UDim2.new(0, 8, 0, 168)
posPanel.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
posPanel.BorderSizePixel  = 0
posPanel.ZIndex           = 3
Instance.new("UICorner", posPanel).CornerRadius = UDim.new(0, 8)

local function makePromptLbl(posY, txt)
    local l = Instance.new("TextLabel", posPanel)
    l.Position           = UDim2.new(0, 8, 0, posY)
    l.Size               = UDim2.new(1, -8, 0, 18)
    l.BackgroundTransparency = 1
    l.TextColor3         = Color3.fromRGB(100, 100, 120)
    l.Font               = Enum.Font.Gotham
    l.TextSize           = 11
    l.TextXAlignment     = Enum.TextXAlignment.Left
    l.Text               = "  ❌  " .. txt
    l.ZIndex             = 4
    return l
end
local ptHdr = makePromptLbl(4, "")
ptHdr.Text      = "Prompt Status:"
ptHdr.TextColor3 = Color3.fromRGB(120, 120, 140)
ptHdr.Font      = Enum.Font.GothamBold

local lblDeposit  = makePromptLbl(22, "Deposit Evidence")
local lblLobby    = makePromptLbl(42, "Lobby (Lift)")
local lblFacility = makePromptLbl(62, "Facility (Lift)")

-- Buttons
local C_TEAL  = Color3.fromRGB(15, 130, 90)
local C_GREY  = Color3.fromRGB(32, 32, 42)
local C_AMBER = Color3.fromRGB(160, 110, 10)
local C_RED   = Color3.fromRGB(160, 25, 25)

local function newBtn(text, posY, col)
    local b = Instance.new("TextButton", frame)
    b.Size             = UDim2.new(1, -16, 0, 32)
    b.Position         = UDim2.new(0, 8, 0, posY)
    b.BackgroundColor3 = col
    b.TextColor3       = Color3.new(1, 1, 1)
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 12
    b.Text             = text
    b.AutoButtonColor  = false
    b.BorderSizePixel  = 0
    b.ZIndex           = 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local btnScan     = newBtn("🔍  Scan Prompt Otomatis",     256, C_TEAL)
local btnDeposit2 = newBtn("📍  Simpan: Deposit Evidence", 294, C_GREY)
local btnLobby2   = newBtn("📍  Simpan: Lobby Lift",       332, C_GREY)
local btnFacility2= newBtn("📍  Simpan: Facility Lift",    370, C_GREY)
local btnAI       = newBtn("🧠  AI Farming  :  OFF",       408, C_GREY)
local btnStop     = newBtn("⏹  Stop",                      446, C_RED)

local hint = Instance.new("TextLabel", frame)
hint.Size               = UDim2.new(1, -16, 0, 14)
hint.Position           = UDim2.new(0, 8, 1, -16)
hint.BackgroundTransparency = 1
hint.TextColor3         = Color3.fromRGB(50, 50, 65)
hint.Font               = Enum.Font.Gotham
hint.TextSize           = 10
hint.TextXAlignment     = Enum.TextXAlignment.Left
hint.Text               = "RightCtrl = hide/show"
hint.ZIndex             = 3

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)

-- ============================================================
--  GUI UPDATERS
-- ============================================================
local function setStatus(txt, col)
    statusLbl.Text       = txt
    statusLbl.TextColor3 = col or Color3.fromRGB(160, 160, 180)
end
local function setPhase(txt, col)
    phaseLbl.Text       = "Phase: " .. txt
    phaseLbl.TextColor3 = col or Color3.fromRGB(255, 220, 60)
end
local function setWP(txt)
    wpLbl.Text = "WP: " .. txt
end
local function setCount(n)
    countLbl.Text = "Evidence: " .. n .. " / " .. MAX_COL
end
local function markPrompt(lbl, found)
    local raw = lbl.Text:match("  [✅❌]  (.+)$") or ""
    lbl.Text       = (found and "  ✅  " or "  ❌  ") .. raw
    lbl.TextColor3 = found and Color3.fromRGB(80,220,130) or Color3.fromRGB(100,100,120)
end

-- ============================================================
--  CORE: WALK WAYPOINTS — pure MoveTo, smooth, tidak kedut
--  Karakter jalan lurus dari titik ke titik sesuai rekaman.
--  Tidak ada pathfind = tidak ada recompute = tidak kedut.
-- ============================================================
local function walkWaypoints(wpList, label)
    if not wpList or #wpList == 0 then return true end

    local total = #wpList
    setPhase(label or "Walking", Color3.fromRGB(255, 220, 60))

    for i, target in ipairs(wpList) do
        if not AI_ON then return false end

        local hrp = getHRP()
        local hum = getHum()
        if not hrp or not hum then return false end

        -- Skip kalau sudah dekat
        if (hrp.Position - target).Magnitude < WP_REACH then
            continue
        end

        setWP(string.format("%d/%d", i, total))
        hum:MoveTo(target)

        -- Tunggu sampai atau timeout
        local t = 0
        repeat
            task.wait(0.1)
            t += 0.1
            if not AI_ON then return false end
            local cur = getHRP()
            if cur and (cur.Position - target).Magnitude < WP_REACH then break end
        until t >= MOVETO_TIMEOUT

        -- Jump kalau stuck (tidak maju)
        local cur = getHRP()
        if cur and (cur.Position - target).Magnitude > WP_REACH * 2 then
            local hum2 = getHum()
            if hum2 then hum2.Jump = true end
            task.wait(0.3)
        end
    end

    setWP("✓")
    return true
end

-- ============================================================
--  CORE: TRIGGER PROXIMITY PROMPT
--  Jalan dekat dulu (ikut waypoint terdekat), lalu fire
-- ============================================================
local function triggerPrompt(prompt, promptPos, label)
    if not prompt or not promptPos then return false end

    -- Jalan ke posisi prompt via MoveTo langsung
    -- (posisi ini sudah direkam, jadi aman)
    local hrp = getHRP()
    local hum = getHum()
    if hrp and hum and (hrp.Position - promptPos).Magnitude > PROMPT_REACH then
        setStatus("🚶 Menuju " .. (label or "prompt") .. "...",
            Color3.fromRGB(80, 180, 255))
        hum:MoveTo(promptPos)
        local t = 0
        repeat
            task.wait(0.1)
            t += 0.1
            if not AI_ON then return false end
            local cur = getHRP()
            if cur and (cur.Position - promptPos).Magnitude <= PROMPT_REACH then break end
        until t >= 5
    end

    task.wait(0.3)
    local ok = pcall(function() fireproximityprompt(prompt) end)
    if not ok then
        -- Coba sekali lagi lebih dekat
        task.wait(0.5)
        ok = pcall(function() fireproximityprompt(prompt) end)
    end
    return ok
end

-- ============================================================
--  PROMPT FINDER
-- ============================================================
local function findPromptByText(text)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            if obj.ActionText == text or obj.ObjectText == text then
                local part = obj:FindFirstAncestorWhichIsA("BasePart")
                if not part then
                    local mdl = obj:FindFirstAncestorWhichIsA("Model")
                    if mdl then
                        part = mdl.PrimaryPart or mdl:FindFirstChildWhichIsA("BasePart", true)
                    end
                end
                if part then return obj, part.Position end
            end
        end
    end
    return nil, nil
end

local function getCollectPrompt(model)
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            local at = string.lower(d.ActionText)
            local ot = string.lower(d.ObjectText)
            if at == "collect" or ot == "collect" then return d end
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

-- ============================================================
--  SCAN & SAVE MANUAL
-- ============================================================
local function doScan()
    setStatus("🔍 Scanning...", Color3.fromRGB(80, 180, 255))
    local n = 0
    local function tryFind(text, key, lbl, btn)
        local p, pos = findPromptByText(text)
        if p then
            savedPrompts[key] = p
            savedPos[key]     = pos
            markPrompt(lbl, true)
            btn.BackgroundColor3 = C_TEAL
            n += 1
        else
            markPrompt(lbl, false)
        end
    end
    tryFind("Deposit Evidence", "deposit",  lblDeposit,  btnDeposit2)
    tryFind("Lobby",            "lobby",    lblLobby,    btnLobby2)
    tryFind("Facility",         "facility", lblFacility, btnFacility2)
    setStatus("✅ Scan: " .. n .. "/3 ditemukan",
        n == 3 and Color3.fromRGB(80,220,130) or Color3.fromRGB(255,200,60))
end

local function saveManual(key, lbl, btn, displayName)
    local hrp = getHRP()
    if not hrp then return end
    local bestP, bestPos, bestD = nil, nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            if obj.ActionText == displayName or obj.ObjectText == displayName then
                local part = obj:FindFirstAncestorWhichIsA("BasePart")
                if part then
                    local d = (part.Position - hrp.Position).Magnitude
                    if d < bestD then bestP=obj; bestPos=part.Position; bestD=d end
                end
            end
        end
    end
    if bestP then
        savedPrompts[key] = bestP
        savedPos[key]     = bestPos
        markPrompt(lbl, true)
        btn.BackgroundColor3 = C_TEAL
        setStatus("✅ Saved: " .. displayName, Color3.fromRGB(80,220,130))
    else
        setStatus("⚠ Tidak ditemukan: " .. displayName, Color3.fromRGB(255,80,80))
    end
end

btnScan.MouseButton1Click:Connect(doScan)
btnDeposit2.MouseButton1Click:Connect(function()
    saveManual("deposit", lblDeposit, btnDeposit2, "Deposit Evidence")
end)
btnLobby2.MouseButton1Click:Connect(function()
    saveManual("lobby", lblLobby, btnLobby2, "Lobby")
end)
btnFacility2.MouseButton1Click:Connect(function()
    saveManual("facility", lblFacility, btnFacility2, "Facility")
end)

-- ============================================================
--  COLLECT EVIDENCE — hanya ambil yang DEKAT dari posisi saat ini
--  Tidak jalan lurus ke evidence jauh (itu yang bikin bypass rail)
-- ============================================================
local function collectNearby()
    local folder = getInstancesFolder()
    if not folder then
        setStatus("⚠ Folder evidence tidak ada", Color3.fromRGB(255,80,80))
        return
    end

    setPhase("Collecting", Color3.fromRGB(80, 220, 130))

    local maxAttempts = MAX_COL * 3  -- batas loop biar tidak infinite
    local attempts    = 0

    while COL_COUNT < MAX_COL and AI_ON and attempts < maxAttempts do
        attempts += 1

        local hrp = getHRP()
        local hum = getHum()
        if not hrp or not hum then break end

        -- Cari evidence HANYA dalam radius COLLECT_RADIUS dari posisi saat ini
        local targets = {}
        for _, model in ipairs(folder:GetChildren()) do
            local prompt = getCollectPrompt(model)
            if prompt then
                local bp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
                if bp then
                    local dist = (bp.Position - hrp.Position).Magnitude
                    if dist <= COLLECT_RADIUS then
                        table.insert(targets, {
                            prompt = prompt,
                            pos    = bp.Position,
                            dist   = dist,
                            name   = model.Name,
                        })
                    end
                end
            end
        end

        if #targets == 0 then
            -- Tidak ada evidence di radius ini → selesai di area ini
            break
        end

        -- Ambil yang terdekat
        table.sort(targets, function(a, b) return a.dist < b.dist end)
        local t = targets[1]

        setStatus(string.format("🔍 [%d/%d] %s (%.0f st)",
            COL_COUNT + 1, MAX_COL, t.name, t.dist),
            Color3.fromRGB(80, 180, 255))

        -- Jalan ke evidence pakai MoveTo biasa (bukan pathfind)
        hum:MoveTo(t.pos)
        local elapsed = 0
        repeat
            task.wait(0.15)
            elapsed += 0.15
            if not AI_ON then return end
            local cur = getHRP()
            if cur and (cur.Position - t.pos).Magnitude <= PROMPT_REACH then break end
        until elapsed >= 6

        if not AI_ON then return end
        task.wait(0.2)

        -- Trigger collect
        local cur = getHRP()
        if cur and (cur.Position - t.pos).Magnitude <= PROMPT_REACH + 3 then
            local ok = pcall(function() fireproximityprompt(t.prompt) end)
            if ok then
                COL_COUNT += 1
                setCount(COL_COUNT)
                setStatus("✅ Collected " .. COL_COUNT .. "/" .. MAX_COL,
                    Color3.fromRGB(80, 220, 130))
            end
        end

        task.wait(0.4)
    end
end

-- ============================================================
--  AI MAIN LOOP
-- ============================================================
local function runAI()
    COL_COUNT = 0
    setCount(0)
    setStatus("🤖 AI dimulai...", Color3.fromRGB(255, 220, 60))
    task.wait(1)

    while AI_ON do

        -- ── 1. Collect di Island (area awal) ──────────────────────────────
        setPhase("Island Collect", Color3.fromRGB(80, 220, 130))
        setWP("—")
        collectNearby()
        if not AI_ON then break end

        -- ── 2. Kalau masih butuh evidence → ke Lobby via waypoint rail ────
        if COL_COUNT < MAX_COL then

            -- Jalan ke lift (Boat → Lift Lobby) pakai waypoint
            walkWaypoints(getSectionWP("Boat → Lift Lobby"), "Boat → Lift")
            if not AI_ON then break end

            -- Trigger lift lobby
            setStatus("🛗 Naik lift...", Color3.fromRGB(80, 180, 255))
            triggerPrompt(savedPrompts.lobby, savedPos.lobby, "Lobby Lift")
            task.wait(LIFT_WAIT)
            if not AI_ON then break end

            -- Jalan ke area evidence (Lobby → Area Evidence)
            walkWaypoints(getSectionWP("Lobby → Area Evidence"), "Lobby → Evidence")
            if not AI_ON then break end

            -- Collect di lobby area
            setPhase("Lobby Collect", Color3.fromRGB(80, 220, 130))
            collectNearby()
            if not AI_ON then break end

            -- Jalan ke lift balik (Area Evidence → Lift Island)
            walkWaypoints(getSectionWP("Area Evidence → Lift Island"), "Evidence → Lift")
            if not AI_ON then break end

            -- Trigger lift balik
            setStatus("🛗 Turun lift...", Color3.fromRGB(80, 180, 255))
            triggerPrompt(savedPrompts.facility, savedPos.facility, "Facility Lift")
            task.wait(LIFT_WAIT)
            if not AI_ON then break end

            -- Jalan balik ke boat area (Lift Island → Boat)
            walkWaypoints(getSectionWP("Lift Island → Boat"), "Island → Boat")
            if not AI_ON then break end
        end

        -- ── 3. Deposit ─────────────────────────────────────────────────────
        if savedPos.deposit then
            setPhase("Deposit", Color3.fromRGB(80, 220, 130))
            local ok = triggerPrompt(savedPrompts.deposit, savedPos.deposit, "Deposit")
            task.wait(DEPOSIT_WAIT)
            setStatus(ok and "✅ Deposit berhasil!" or "❌ Deposit gagal — coba lagi",
                ok and Color3.fromRGB(80,220,130) or Color3.fromRGB(255,80,80))
            task.wait(2)
        end

        -- Reset
        COL_COUNT = 0
        setCount(0)
        setPhase("Idle", Color3.fromRGB(160, 160, 180))
        setStatus("🔄 Siklus selesai — ulang...", Color3.fromRGB(255, 220, 60))
        task.wait(2)
    end

    setPhase("Stopped", Color3.fromRGB(160, 160, 180))
    setStatus("⏹ AI dihentikan", Color3.fromRGB(160, 160, 180))
    setWP("—")
end

-- ============================================================
--  TOMBOL
-- ============================================================
local function stopAI()
    AI_ON = false
    btnAI.Text             = "🧠  AI Farming  :  OFF"
    btnAI.BackgroundColor3 = C_GREY
    local hum = getHum()
    local hrp = getHRP()
    if hum and hrp then hum:MoveTo(hrp.Position) end
    setPhase("Stopped", Color3.fromRGB(160, 160, 180))
    setStatus("⏹ Dihentikan", Color3.fromRGB(160, 160, 180))
    setWP("—")
end

btnAI.MouseButton1Click:Connect(function()
    AI_ON = not AI_ON
    if AI_ON then
        btnAI.Text             = "🧠  AI Farming  :  ON"
        btnAI.BackgroundColor3 = C_AMBER
        task.spawn(runAI)
    else
        stopAI()
    end
end)

btnStop.MouseButton1Click:Connect(stopAI)

LP.CharacterAdded:Connect(function() end)

task.delay(2, doScan)
setStatus("✅ Ready — scan lalu start AI", Color3.fromRGB(80, 220, 130))
setPhase("Ready", Color3.fromRGB(80, 220, 130))
