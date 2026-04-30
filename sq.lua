-- ================================================================
--  SQUID GAME TOOL v8 — SIMPLIFIED AI FARMING
--  UI: Carbon/Glass Minimalis
--  By menzcreate | discord: menzcreate
-- ================================================================

local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local LP = Players.LocalPlayer

-- ================================================================
--  HELPERS CHARACTER
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
--  WAYPOINTS ISLAND → LIFT (WP 1-35)
-- ================================================================
local WP_ISLAND_TO_LIFT = {
    Vector3.new(-2844.08, -786.00, 15535.26),
    Vector3.new(-2841.83, -786.00, 15469.03),
    Vector3.new(-2839.82, -786.00, 15407.23),
    Vector3.new(-2823.95, -783.30, 15352.84),
    Vector3.new(-2793.47, -786.61, 15310.43),
    Vector3.new(-2753.06, -787.00, 15280.31),
    Vector3.new(-2712.10, -787.00, 15243.69),
    Vector3.new(-2678.25, -787.00, 15219.84),
    Vector3.new(-2630.84, -783.01, 15229.19),
    Vector3.new(-2602.03, -779.05, 15267.92),
    Vector3.new(-2586.28, -783.02, 15296.52),
    Vector3.new(-2574.96, -784.50, 15324.83),
    Vector3.new(-2562.13, -787.10, 15352.45),
    Vector3.new(-2549.69, -787.04, 15384.58),
    Vector3.new(-2534.85, -786.99, 15444.39),
    Vector3.new(-2521.96, -775.79, 15521.11),
    Vector3.new(-2488.75, -782.81, 15518.27),
    Vector3.new(-2450.98, -785.41, 15526.71),
    Vector3.new(-2406.13, -783.92, 15557.54),
    Vector3.new(-2370.37, -787.00, 15562.21),
    Vector3.new(-2338.27, -787.00, 15560.76),
    Vector3.new(-2312.04, -784.49, 15579.04),
    Vector3.new(-2305.59, -772.94, 15607.23),
    Vector3.new(-2302.71, -766.74, 15642.35),
    Vector3.new(-2284.36, -774.73, 15695.58),
    Vector3.new(-2259.05, -787.92, 15733.13),
    Vector3.new(-2222.14, -795.63, 15773.63),
    Vector3.new(-2190.23, -807.28, 15805.32),
    Vector3.new(-2145.58, -819.91, 15851.93),
    Vector3.new(-2121.03, -819.91, 15896.32),
    Vector3.new(-2096.41, -820.35, 15937.70),
    Vector3.new(-2056.80, -839.85, 15969.66),
    Vector3.new(-2035.75, -850.47, 15948.00),
    Vector3.new(-2006.17, -859.85, 15913.94),
    Vector3.new(-1978.29, -859.52, 15893.26), -- dekat lift Lobby
}

-- ================================================================
--  WAYPOINTS LOBBY FARMING (WP 36-77)
-- ================================================================
local WP_LOBBY = {
    Vector3.new( 8161.05,  100.88,  3460.91), -- spawn lobby
    Vector3.new( 8158.37,  100.64,  3494.41),
    Vector3.new( 8159.02,  100.64,  3522.74),
    Vector3.new( 8158.81,  100.64,  3558.08),
    Vector3.new( 8159.73,  100.64,  3590.28),
    Vector3.new( 8158.61,  100.83,  3625.13),
    Vector3.new( 8159.46,  100.84,  3645.38),
    Vector3.new( 8167.38,  100.84,  3648.28),
    Vector3.new( 8193.05,  100.62,  3649.47),
    Vector3.new( 8208.83,  100.62,  3649.71),
    Vector3.new( 8210.56,  100.62,  3649.66),
    Vector3.new( 8161.44,  100.84,  3648.02),
    Vector3.new( 8159.56,  109.26,  3672.78),
    Vector3.new( 8160.63,  113.94,  3690.39),
    Vector3.new( 8159.15,  113.82,  3705.11),
    Vector3.new( 8187.98,  116.25,  3733.73),
    Vector3.new( 8203.98,  117.37,  3747.99),
    Vector3.new( 8183.32,  116.26,  3735.35),
    Vector3.new( 8163.39,  100.84,  3650.50),
    Vector3.new( 8125.96,  100.84,  3650.04),
    Vector3.new( 8127.00,  100.64,  3684.04),
    Vector3.new( 8125.35,   96.02,  3630.31),
    Vector3.new( 8123.20,   81.51,  3583.60),
    Vector3.new( 8119.04,   81.47,  3548.72),
    Vector3.new( 8079.37,   88.86,  3650.81),
    Vector3.new( 8072.47,   88.97,  3676.20),
    Vector3.new( 8091.54,   88.97,  3697.91),
    Vector3.new( 8053.94,   89.01,  3704.00),
    Vector3.new( 8039.06,   89.01,  3725.00),
    Vector3.new( 8023.40,   89.01,  3729.14),
    Vector3.new( 8012.42,   88.97,  3697.87),
    Vector3.new( 7976.78,   88.86,  3648.18),
    Vector3.new( 7971.02,   88.79,  3631.04),
    Vector3.new( 7992.12,   88.86,  3660.91),
    Vector3.new( 8047.43,   88.97,  3692.23),
    Vector3.new( 8074.60,   88.86,  3657.15),
    Vector3.new( 8111.98,  100.77,  3645.79),
    Vector3.new( 8153.76,  100.84,  3644.37),
    Vector3.new( 8163.99,  100.64,  3502.53),
    Vector3.new( 8163.24,  100.64,  3471.31),
    Vector3.new( 8160.69,  100.88,  3458.90), -- dekat lift Facility
}

-- ================================================================
--  WAYPOINTS ISLAND BALIK → DEPOSIT (WP 78-117)
-- ================================================================
local WP_ISLAND_BACK = {
    Vector3.new(-1981.01, -859.52, 15893.56), -- spawn island balik
    Vector3.new(-2008.04, -859.85, 15927.52),
    Vector3.new(-2023.92, -855.97, 15946.54),
    Vector3.new(-2035.30, -847.92, 15957.90),
    Vector3.new(-2043.15, -842.55, 15965.24),
    Vector3.new(-2082.77, -834.38, 15961.06),
    Vector3.new(-2116.49, -819.91, 15913.80),
    Vector3.new(-2127.41, -819.91, 15886.51),
    Vector3.new(-2144.26, -819.91, 15863.94),
    Vector3.new(-2166.86, -819.91, 15844.50),
    Vector3.new(-2189.64, -811.90, 15820.16),
    Vector3.new(-2208.76, -800.92, 15798.07),
    Vector3.new(-2232.80, -793.25, 15773.20),
    Vector3.new(-2252.08, -787.91, 15751.42),
    Vector3.new(-2282.99, -781.24, 15712.87),
    Vector3.new(-2301.43, -767.72, 15673.85),
    Vector3.new(-2309.92, -765.72, 15635.92),
    Vector3.new(-2316.02, -771.55, 15600.49),
    Vector3.new(-2338.61, -787.00, 15559.64),
    Vector3.new(-2367.72, -787.12, 15553.06),
    Vector3.new(-2439.47, -783.65, 15545.67),
    Vector3.new(-2465.73, -786.78, 15525.41),
    Vector3.new(-2485.76, -787.01, 15502.58),
    Vector3.new(-2510.66, -786.13, 15469.42),
    Vector3.new(-2539.26, -786.84, 15435.74),
    Vector3.new(-2551.99, -786.51, 15406.05),
    Vector3.new(-2565.88, -787.24, 15365.58),
    Vector3.new(-2577.78, -784.05, 15319.32),
    Vector3.new(-2592.48, -781.93, 15288.03),
    Vector3.new(-2613.13, -779.35, 15258.68),
    Vector3.new(-2655.81, -784.01, 15243.21),
    Vector3.new(-2686.39, -785.45, 15255.93),
    Vector3.new(-2721.29, -784.54, 15271.93),
    Vector3.new(-2751.75, -787.01, 15285.89),
    Vector3.new(-2783.55, -787.00, 15300.46),
    Vector3.new(-2827.74, -784.35, 15362.66),
    Vector3.new(-2834.13, -786.00, 15434.92),
    Vector3.new(-2838.56, -786.00, 15493.48),
    Vector3.new(-2851.38, -786.00, 15524.46),
    Vector3.new(-2875.53, -787.19, 15550.73), -- ujung, deposit lalu reset
}

-- ================================================================
--  CONFIG
-- ================================================================
local CFG = {
    maxEvidence    = 8,
    collectRadius  = 30,
    promptReach    = 8,
    wpReach        = 7,
    moveTimeout    = 12,
    liftWait       = 8,
    depositWait    = 3,
    stopTimeout    = 0.5,
    scanInterval   = 0.5,
    speed          = 120,
    jumpPower      = 70,
}

-- ================================================================
--  STATE
-- ================================================================
local AI_ON       = false
local SPEED_ON    = false
local NOCLIP_ON   = false
local HL_ON       = true
local BABY_ON     = false
local AUTO_COLLECT = false
local collected   = 0
local foundModels = {}
local highlights  = {}
local CLOSED      = false

-- AI Phase:
-- "ISLAND_TO_LIFT" → jalan dari island ke lift lobby
-- "LOBBY_FARM"     → farming di lobby
-- "LOBBY_TO_LIFT"  → jalan ke lift facility (kembali)
-- "ISLAND_DEPOSIT" → jalan di island, cari deposit
local aiPhase   = "ISLAND_TO_LIFT"
local aiWpIndex = 1

-- ================================================================
--  ZONE DETECTION
-- ================================================================
local function getZone(pos)
    if not pos then return "UNKNOWN" end
    if pos.Y > 50   then return "LOBBY"  end
    if pos.Y < -100 then return "ISLAND" end
    return "UNKNOWN"
end

-- ================================================================
--  SPEED
-- ================================================================
local speedConn
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

local function getEvidenceFolder()
    local ok, r = pcall(function()
        return workspace:WaitForChild("Data",3)
            :WaitForChild("Detective",3)
            :WaitForChild("Evidence",3)
            :WaitForChild("Instances",3)
    end)
    return ok and r or nil
end

-- ================================================================
--  WALK TO
-- ================================================================
local function walkTo(target, timeoutSec)
    local hu = getHum(); local h = getHRP()
    if not hu or not h then return false end

    local dist = (h.Position - target).Magnitude
    if dist <= CFG.wpReach then return true end

    hu:MoveTo(target)

    local t = 0
    local limit = timeoutSec or CFG.moveTimeout
    local lastPos = h.Position
    local stuckTimer = 0

    while t < limit do
        task.wait(0.1); t += 0.1
        if not AI_ON then return false end

        local cur = getHRP(); if not cur then return false end
        if (cur.Position - target).Magnitude <= CFG.wpReach then return true end

        -- Re-issue MoveTo tiap 1s
        if t % 1.0 < 0.11 then
            local hu2 = getHum()
            if hu2 then hu2:MoveTo(target) end
        end

        -- Anti-stuck: cek apakah karakter bergerak
        local moved = (cur.Position - lastPos).Magnitude
        if moved < 0.5 then
            stuckTimer += 0.1
            if stuckTimer >= 2.5 then
                -- Stuck! coba jump
                local hu2 = getHum()
                if hu2 then
                    hu2.Jump = true
                end
                stuckTimer = 0
            end
        else
            stuckTimer = 0
        end
        lastPos = cur.Position
    end

    return false
end

-- ================================================================
--  FIRE PROMPT
-- ================================================================
local function firePromptAt(prompt, pos, label)
    if not prompt or not pos then return false end
    local hu = getHum(); local h = getHRP()
    if not hu or not h then return false end

    -- Jalan ke prompt jika terlalu jauh
    if (h.Position - pos).Magnitude > CFG.promptReach then
        hu:MoveTo(pos)
        local t = 0
        while t < 8 do
            task.wait(0.1); t += 0.1
            if not AI_ON then return false end
            local cur = getHRP(); if not cur then return false end
            if (cur.Position - pos).Magnitude <= CFG.promptReach then break end
        end
    end

    -- Berhenti sebentar
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
-- ================================================================
local function collectNearby()
    if collected >= CFG.maxEvidence then return end
    local folder = getEvidenceFolder(); if not folder then return end
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
        updateStatus("📦 " .. ev.name, nil)
        pcall(function() fireproximityprompt(ev.prompt) end)
        task.wait(0.15)
        -- Jalan kalau masih jauh
        if ev.d > 10 then
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
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
end

-- ================================================================
--  GUI
-- ================================================================
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "SQv8"; gui.ResetOnSpawn = false

local C = {
    bg0    = Color3.fromRGB(8,   8,  10),
    bg1    = Color3.fromRGB(14,  14, 18),
    bg2    = Color3.fromRGB(20,  20, 26),
    border = Color3.fromRGB(32,  32, 40),
    accent = Color3.fromRGB(220,220,220),
    dim    = Color3.fromRGB(90,  90,100),
    on     = Color3.fromRGB(200,200,200),
    off    = Color3.fromRGB(45,  45, 55),
    warn   = Color3.fromRGB(220,160, 60),
    ok     = Color3.fromRGB(100,200,140),
    info   = Color3.fromRGB(120,160,220),
    red    = Color3.fromRGB(200,  60, 60),
    green  = Color3.fromRGB( 60, 180, 80),
}

-- ─── Main Frame ───────────────────────────────────────────────
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size             = UDim2.new(0, 260, 0, 10) -- tinggi diset di akhir
mainFrame.Position         = UDim2.new(0, 14, 0, 14)
mainFrame.BackgroundColor3 = C.bg0
mainFrame.BorderSizePixel  = 0
mainFrame.Active           = true
mainFrame.Draggable        = true
mainFrame.ZIndex           = 2
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local mStroke = Instance.new("UIStroke", mainFrame)
mStroke.Color = C.border; mStroke.Thickness = 1

-- ─── Header ───────────────────────────────────────────────────
local header = Instance.new("Frame", mainFrame)
header.Size             = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = C.bg1
header.BorderSizePixel  = 0
header.ZIndex           = 3
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)
local hPatch = Instance.new("Frame", header)
hPatch.Size             = UDim2.new(1, 0, 0.5, 0)
hPatch.Position         = UDim2.new(0, 0, 0.5, 0)
hPatch.BackgroundColor3 = C.bg1
hPatch.BorderSizePixel  = 0
hPatch.ZIndex           = 3

local titleTxt = Instance.new("TextLabel", header)
titleTxt.Size              = UDim2.new(1,-100,0,22)
titleTxt.Position          = UDim2.new(0,14,0,4)
titleTxt.BackgroundTransparency = 1
titleTxt.Text              = "🦑  SQ Tool v8"
titleTxt.TextColor3        = C.accent
titleTxt.Font              = Enum.Font.GothamBold
titleTxt.TextSize          = 13
titleTxt.TextXAlignment    = Enum.TextXAlignment.Left
titleTxt.ZIndex            = 4

local subTxt = Instance.new("TextLabel", header)
subTxt.Size              = UDim2.new(1,-100,0,12)
subTxt.Position          = UDim2.new(0,14,0,27)
subTxt.BackgroundTransparency = 1
subTxt.Text              = "© menzcreate  |  discord: menzcreate"
subTxt.TextColor3        = Color3.fromRGB(130,130,145)
subTxt.Font              = Enum.Font.Gotham
subTxt.TextSize          = 9
subTxt.TextXAlignment    = Enum.TextXAlignment.Left
subTxt.ZIndex            = 4

-- ─── Minimize btn ─────────────────────────────────────────────
local minBtn = Instance.new("TextButton", header)
minBtn.Size             = UDim2.new(0,24,0,24)
minBtn.Position         = UDim2.new(1,-60,0,10)
minBtn.BackgroundColor3 = Color3.fromRGB(28,28,36)
minBtn.TextColor3       = C.dim
minBtn.Font             = Enum.Font.GothamBold
minBtn.TextSize         = 13
minBtn.Text             = "–"
minBtn.AutoButtonColor  = false
minBtn.BorderSizePixel  = 0
minBtn.ZIndex           = 5
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,6)

-- ─── Close btn ────────────────────────────────────────────────
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size             = UDim2.new(0,24,0,24)
closeBtn.Position         = UDim2.new(1,-32,0,10)
closeBtn.BackgroundColor3 = Color3.fromRGB(40,20,20)
closeBtn.TextColor3       = C.red
closeBtn.Font             = Enum.Font.GothamBold
closeBtn.TextSize         = 13
closeBtn.Text             = "✕"
closeBtn.AutoButtonColor  = false
closeBtn.BorderSizePixel  = 0
closeBtn.ZIndex           = 5
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

-- ─── Float button (minimize) ──────────────────────────────────
-- Container untuk float: icon squid + mini AI toggle
local floatContainer = Instance.new("Frame", gui)
floatContainer.Size             = UDim2.new(0, 44, 0, 96)  -- tinggi cukup untuk 2 tombol
floatContainer.Position         = UDim2.new(0, 14, 0, 14)
floatContainer.BackgroundTransparency = 1
floatContainer.Visible          = false
floatContainer.ZIndex           = 14

-- Tombol squid icon
local floatBtn = Instance.new("TextButton", floatContainer)
floatBtn.Size             = UDim2.new(0, 44, 0, 44)
floatBtn.Position         = UDim2.new(0, 0, 0, 0)
floatBtn.BackgroundColor3 = C.bg1
floatBtn.TextColor3       = C.accent
floatBtn.Font             = Enum.Font.GothamBold
floatBtn.TextSize         = 20
floatBtn.Text             = "🦑"
floatBtn.AutoButtonColor  = false
floatBtn.BorderSizePixel  = 0
floatBtn.ZIndex           = 15
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(0, 10)
local floatStroke = Instance.new("UIStroke", floatBtn)
floatStroke.Color = C.border; floatStroke.Thickness = 1

-- Mini AI toggle button (di bawah icon squid)
local miniAiBtn = Instance.new("TextButton", floatContainer)
miniAiBtn.Size             = UDim2.new(0, 44, 0, 44)
miniAiBtn.Position         = UDim2.new(0, 0, 0, 50)
miniAiBtn.BackgroundColor3 = C.off
miniAiBtn.TextColor3       = C.dim
miniAiBtn.Font             = Enum.Font.GothamBold
miniAiBtn.TextSize         = 18
miniAiBtn.Text             = "🤖"
miniAiBtn.AutoButtonColor  = false
miniAiBtn.BorderSizePixel  = 0
miniAiBtn.ZIndex           = 15
Instance.new("UICorner", miniAiBtn).CornerRadius = UDim.new(0, 10)
local miniAiStroke = Instance.new("UIStroke", miniAiBtn)
miniAiStroke.Color = C.border; miniAiStroke.Thickness = 1

local function updateMiniAiBtn()
    if AI_ON then
        miniAiBtn.BackgroundColor3 = C.green
        miniAiStroke.Color         = C.ok
    else
        miniAiBtn.BackgroundColor3 = C.off
        miniAiStroke.Color         = C.border
    end
end

-- ─── Status bar ───────────────────────────────────────────────
local statusBar = Instance.new("Frame", mainFrame)
statusBar.Size             = UDim2.new(1,-16,0,22)
statusBar.Position         = UDim2.new(0,8,0,50)
statusBar.BackgroundColor3 = C.bg2
statusBar.BorderSizePixel  = 0
statusBar.ZIndex           = 3
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0,6)

local statusTxt = Instance.new("TextLabel", statusBar)
statusTxt.Size              = UDim2.new(1,-10,1,0)
statusTxt.Position          = UDim2.new(0,8,0,0)
statusTxt.BackgroundTransparency = 1
statusTxt.Text              = "Ready"
statusTxt.TextColor3        = C.dim
statusTxt.Font              = Enum.Font.Gotham
statusTxt.TextSize          = 10
statusTxt.TextXAlignment    = Enum.TextXAlignment.Left
statusTxt.ZIndex            = 4

-- ─── Info row ─────────────────────────────────────────────────
local infoRow = Instance.new("Frame", mainFrame)
infoRow.Size             = UDim2.new(1,-16,0,20)
infoRow.Position         = UDim2.new(0,8,0,76)
infoRow.BackgroundTransparency = 1
infoRow.ZIndex           = 3

local evTxt = Instance.new("TextLabel", infoRow)
evTxt.Size              = UDim2.new(0.5,0,1,0)
evTxt.BackgroundTransparency = 1
evTxt.Text              = "Evidence: 0/8"
evTxt.TextColor3        = C.ok
evTxt.Font              = Enum.Font.GothamBold
evTxt.TextSize          = 10
evTxt.TextXAlignment    = Enum.TextXAlignment.Left
evTxt.ZIndex            = 4

local phaseTxt = Instance.new("TextLabel", infoRow)
phaseTxt.Size              = UDim2.new(0.5,0,1,0)
phaseTxt.Position          = UDim2.new(0.5,0,0,0)
phaseTxt.BackgroundTransparency = 1
phaseTxt.Text              = "Phase: —"
phaseTxt.TextColor3        = C.dim
phaseTxt.Font              = Enum.Font.Code
phaseTxt.TextSize          = 9
phaseTxt.TextXAlignment    = Enum.TextXAlignment.Right
phaseTxt.ZIndex            = 4

local div = Instance.new("Frame", mainFrame)
div.Size             = UDim2.new(1,-16,0,1)
div.Position         = UDim2.new(0,8,0,100)
div.BackgroundColor3 = C.border
div.BorderSizePixel  = 0
div.ZIndex           = 3

-- ─── Toggle row factory ───────────────────────────────────────
local ROW_H = 34; local ROW_GAP = 4; local ROW_Y = 108

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

local _, hlPill,   hlBtn   = mkToggleRow("Highlight",          "◈",  rowY(1))
local _, spPill,   spBtn   = mkToggleRow("Speed + Jump",       "⚡", rowY(2))
local _, ncPill,   ncBtn   = mkToggleRow("Noclip",             "◉",  rowY(3))
local _, aiPill,   aiBtn   = mkToggleRow("AI Farming",         "🤖", rowY(4))
local _, autoPill, autoBtn = mkToggleRow("Auto Collect",       "📦", rowY(5))
local _, babyPill, babyBtn = mkToggleRow("Auto Baby",          "🍼", rowY(6))

setToggle(hlPill, true)

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

mainFrame.Size = UDim2.new(0, 260, 0, ACT_Y + 34 + 30 + 14)

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
confirmFrame.Size             = UDim2.new(0,220,0,100)
confirmFrame.Position         = UDim2.new(0.5,-110,0.5,-50)
confirmFrame.BackgroundColor3 = C.bg1
confirmFrame.BorderSizePixel  = 0
confirmFrame.Visible          = false
confirmFrame.ZIndex           = 20
Instance.new("UICorner", confirmFrame).CornerRadius = UDim.new(0,12)
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
        ISLAND_TO_LIFT  = "Island→Lift",
        LOBBY_FARM      = "Lobby Farm",
        LOBBY_TO_LIFT   = "Lobby→Lift",
        ISLAND_DEPOSIT  = "Island→Dep",
    }
    phaseTxt.Text = "Phase: " .. (short[p] or p or "—")
end

-- ================================================================
--  MINIMIZE LOGIC
-- ================================================================
local MINIMIZED = false
local function setMinimized(val)
    MINIMIZED = val
    mainFrame.Visible      = not val
    floatContainer.Visible = val
end

minBtn.MouseButton1Click:Connect(function() setMinimized(true) end)
floatBtn.MouseButton1Click:Connect(function() setMinimized(false) end)

-- ================================================================
--  CLOSE LOGIC
-- ================================================================
local function shutdownAll()
    CLOSED    = true
    AI_ON     = false
    SPEED_ON  = false
    NOCLIP_ON = false
    HL_ON     = false
    BABY_ON   = false
    stopNoclip()
    clearHighlights()
    resetSpeed()
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
    if not SPEED_ON then resetSpeed() end
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

autoBtn.MouseButton1Click:Connect(function()
    AUTO_COLLECT = not AUTO_COLLECT
    setToggle(autoPill, AUTO_COLLECT)
end)

-- Teleport ke evidence terdekat
tpBtn.MouseButton1Click:Connect(function()
    if #foundModels == 0 then
        updateStatus("⚠ Tidak ada evidence", C.warn); return
    end
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
    h.CFrame = CFrame.new(nearest.Position + Vector3.new(0,4,0))
end)

respawnBtn.MouseButton1Click:Connect(doRespawn)

-- ================================================================
--  AI TOGGLE — shared function agar bisa dipanggil dari 2 tombol
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
--  SCAN LOOP — highlight + auto collect standalone
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

    -- Jika AI aktif, sesuaikan phase berdasarkan posisi spawn
    if AI_ON then
        task.wait(1)
        local h = getHRP(); if not h then return end
        local zone = getZone(h.Position)
        if zone == "LOBBY" then
            -- Respawn di lobby → lanjut farming
            aiPhase   = "LOBBY_FARM"
            aiWpIndex = 1
            updateStatus("🔄 Respawn lobby → farming", C.warn)
        elseif zone == "ISLAND" then
            if aiPhase == "ISLAND_DEPOSIT" or aiPhase == "LOBBY_TO_LIFT" then
                -- Sudah dari lobby, lanjut deposit
                aiPhase   = "ISLAND_DEPOSIT"
                aiWpIndex = 1
                updateStatus("🔄 Respawn island → deposit", C.warn)
            else
                -- Belum ke lobby, mulai dari awal
                aiPhase   = "ISLAND_TO_LIFT"
                aiWpIndex = 1
                updateStatus("🔄 Respawn island → ke lift", C.warn)
            end
        else
            aiPhase   = "ISLAND_TO_LIFT"
            aiWpIndex = 1
        end
        updatePhase(aiPhase)
    end
end)

-- ================================================================
--  MAIN AI LOOP — SIMPLIFIED
--
--  Alur:
--  1. ISLAND_TO_LIFT  → jalan di island menuju lift lobby (WP_ISLAND_TO_LIFT)
--  2. LOBBY_FARM      → jalan di lobby, collect evidence (WP_LOBBY)
--  3. LOBBY_TO_LIFT   → udah full / sudah semua WP, jalan ke lift island
--  4. ISLAND_DEPOSIT  → kembali ke island, deposit evidence, ulang
-- ================================================================
function runAI()
    task.wait(0.5)

    -- Deteksi posisi awal
    local h = getHRP()
    if h then
        local zone = getZone(h.Position)
        if zone == "LOBBY" then
            aiPhase   = "LOBBY_FARM"
            aiWpIndex = 1
        elseif zone == "ISLAND" then
            aiPhase   = "ISLAND_TO_LIFT"
            aiWpIndex = 1
        else
            aiPhase   = "ISLAND_TO_LIFT"
            aiWpIndex = 1
        end
    else
        aiPhase   = "ISLAND_TO_LIFT"
        aiWpIndex = 1
    end

    collected = 0
    updateCount(0)
    updatePhase(aiPhase)
    updateStatus("📍 Mulai: " .. aiPhase, C.warn)
    task.wait(0.5)

    while AI_ON do
        if CLOSED then break end

        local h2 = getHRP(); local hu = getHum()
        if not h2 or not hu then task.wait(0.5); continue end

        updatePhase(aiPhase)

        -- ──────────────────────────────────────────────────────
        --  PHASE 1: ISLAND → LIFT LOBBY
        -- ──────────────────────────────────────────────────────
        if aiPhase == "ISLAND_TO_LIFT" then
            -- Cek apakah sudah di lobby (kemungkinan teleport / respawn)
            if getZone(h2.Position) == "LOBBY" then
                aiPhase   = "LOBBY_FARM"
                aiWpIndex = 1
                updateStatus("✅ Sudah di lobby, mulai farming", C.ok)
                continue
            end

            if aiWpIndex > #WP_ISLAND_TO_LIFT then
                -- Semua WP island sudah dilalui, coba fire prompt lift
                updateStatus("🛗 Cari lift Lobby...", C.info)
                local pr, pos = findPromptByText("Lobby")
                if pr then
                    updateStatus("🛗 Masuk Lobby...", C.info)
                    firePromptAt(pr, pos, "Lobby")
                    task.wait(CFG.liftWait)
                    if not AI_ON then break end
                    -- Verifikasi apakah sudah di lobby
                    local nh = getHRP()
                    if nh and getZone(nh.Position) == "LOBBY" then
                        aiPhase   = "LOBBY_FARM"
                        aiWpIndex = 1
                        collected = 0; updateCount(0)
                        updateStatus("✅ Masuk lobby!", C.ok)
                    else
                        -- Belum berhasil, coba lagi dari WP terakhir
                        aiWpIndex = math.max(1, #WP_ISLAND_TO_LIFT - 3)
                        updateStatus("⚠ Lift gagal, coba lagi", C.warn)
                        task.wait(1)
                    end
                else
                    -- Prompt lift tidak ditemukan, mundur sedikit
                    aiWpIndex = math.max(1, #WP_ISLAND_TO_LIFT - 5)
                    updateStatus("⚠ Prompt lift tidak ada, balik", C.warn)
                    task.wait(1)
                end
                continue
            end

            local target = WP_ISLAND_TO_LIFT[aiWpIndex]
            updateStatus(string.format("🚶 Island→Lift WP %d/%d", aiWpIndex, #WP_ISLAND_TO_LIFT), C.info)
            walkTo(target, CFG.moveTimeout)
            if not AI_ON then break end
            aiWpIndex += 1

        -- ──────────────────────────────────────────────────────
        --  PHASE 2: LOBBY FARMING
        -- ──────────────────────────────────────────────────────
        elseif aiPhase == "LOBBY_FARM" then
            -- Cek apakah sudah ada di island (bisa terjadi disconnect/teleport)
            if getZone(h2.Position) == "ISLAND" then
                if collected > 0 then
                    aiPhase   = "ISLAND_DEPOSIT"
                    aiWpIndex = 1
                else
                    aiPhase   = "ISLAND_TO_LIFT"
                    aiWpIndex = 1
                end
                continue
            end

            -- Jika evidence penuh, langsung ke phase selanjutnya
            if collected >= CFG.maxEvidence then
                aiPhase   = "LOBBY_TO_LIFT"
                aiWpIndex = #WP_LOBBY  -- langsung ke WP terakhir (dekat lift)
                updateStatus("💼 Evidence penuh! Menuju lift...", C.ok)
                continue
            end

            if aiWpIndex > #WP_LOBBY then
                -- Sudah selesai satu putaran lobby, pergi ke lift
                aiPhase   = "LOBBY_TO_LIFT"
                aiWpIndex = #WP_LOBBY
                updateStatus("🔄 Selesai putaran lobby, ke lift...", C.warn)
                continue
            end

            local target = WP_LOBBY[aiWpIndex]
            updateStatus(string.format("🤖 Lobby Farm WP %d/%d  Ev:%d/%d",
                aiWpIndex, #WP_LOBBY, collected, CFG.maxEvidence), C.info)
            walkTo(target, CFG.moveTimeout)
            if not AI_ON then break end

            -- Collect di sekitar WP ini
            collectNearby()
            if not AI_ON then break end

            aiWpIndex += 1

        -- ──────────────────────────────────────────────────────
        --  PHASE 3: LOBBY → LIFT ISLAND
        -- ──────────────────────────────────────────────────────
        elseif aiPhase == "LOBBY_TO_LIFT" then
            -- Cek apakah sudah di island
            if getZone(h2.Position) == "ISLAND" then
                aiPhase   = "ISLAND_DEPOSIT"
                aiWpIndex = 1
                updateStatus("✅ Sudah di island, cari deposit", C.ok)
                continue
            end

            -- Cari prompt lift Facility
            updateStatus("🛗 Cari lift Facility...", C.info)
            local pr, pos = findPromptByText("Facility")
            if pr then
                -- Jalan ke lift dulu
                local h3 = getHRP()
                if h3 then
                    walkTo(pos, CFG.moveTimeout)
                    if not AI_ON then break end
                end
                updateStatus("🛗 Kembali via Facility...", C.info)
                firePromptAt(pr, pos, "Facility")
                task.wait(CFG.liftWait)
                if not AI_ON then break end
                -- Verifikasi
                local nh = getHRP()
                if nh and getZone(nh.Position) == "ISLAND" then
                    aiPhase   = "ISLAND_DEPOSIT"
                    aiWpIndex = 1
                    updateStatus("✅ Kembali ke island!", C.ok)
                else
                    -- Belum berhasil, coba fire lagi
                    updateStatus("⚠ Lift gagal, coba lagi", C.warn)
                    task.wait(1)
                    -- Coba jalan ke WP terakhir lobby (dekat lift)
                    local lastLobbyWP = WP_LOBBY[#WP_LOBBY]
                    walkTo(lastLobbyWP, CFG.moveTimeout)
                    task.wait(0.5)
                end
            else
                -- Prompt tidak ada, jalan ke WP terakhir lobby dulu
                local lastLobbyWP = WP_LOBBY[#WP_LOBBY]
                updateStatus("🚶 Menuju titik lift...", C.info)
                walkTo(lastLobbyWP, CFG.moveTimeout)
                if not AI_ON then break end
                task.wait(0.5)
            end
            continue

        -- ──────────────────────────────────────────────────────
        --  PHASE 4: ISLAND DEPOSIT
        -- ──────────────────────────────────────────────────────
        elseif aiPhase == "ISLAND_DEPOSIT" then
            -- Cek apakah masih di lobby
            if getZone(h2.Position) == "LOBBY" then
                aiPhase = "LOBBY_TO_LIFT"
                continue
            end

            -- Pertama coba cari deposit langsung
            local pr, pos = findPromptByText("Deposit Evidence")
            if pr then
                local h3 = getHRP()
                if h3 and (h3.Position - pos).Magnitude > 50 then
                    -- Teleport langsung ke deposit jika jauh banget
                    h3.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0))
                    task.wait(0.5)
                    if not AI_ON then break end
                end
                updateStatus("💼 Deposit " .. collected .. " evidence...", C.ok)
                firePromptAt(pr, pos, "Deposit")
                task.wait(CFG.depositWait)
                if not AI_ON then break end
                -- Reset dan mulai ulang
                collected = 0; updateCount(0)
                aiPhase   = "ISLAND_TO_LIFT"
                aiWpIndex = 1
                updateStatus("🔄 Siklus selesai! Mulai lagi...", C.ok)
                task.wait(1)
                continue
            end

            -- Deposit tidak ditemukan langsung, jalan lewat WP
            if aiWpIndex > #WP_ISLAND_BACK then
                -- Sudah di ujung tapi deposit belum ketemu
                updateStatus("⚠ Deposit tidak ditemukan!", C.red)
                -- Reset saja, mulai dari awal
                collected = 0; updateCount(0)
                aiPhase   = "ISLAND_TO_LIFT"
                aiWpIndex = 1
                task.wait(2)
                continue
            end

            local target = WP_ISLAND_BACK[aiWpIndex]
            updateStatus(string.format("🚶 Island→Deposit WP %d/%d", aiWpIndex, #WP_ISLAND_BACK), C.info)
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
updateStatus("✅ Ready", C.ok)
updateMiniAiBtn()
