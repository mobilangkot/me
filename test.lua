-- ================================================================
--  AI FARMING v4  —  WAYPOINT FIRST, COLLECT SAMBIL LEWAT
--  Karakter SELALU ikuti waypoint rekaman.
--  Evidence diambil hanya kalau ada dalam radius X studs
--  dari posisi karakter SAAT INI (sambil lewat).
--  Tidak ada pathfinding. Tidak ada fallback loncat-loncat.
-- ================================================================

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LP               = Players.LocalPlayer

-- ================================================================
--  PASTE WAYPOINTS HASIL RECORDER DI SINI
-- ================================================================
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

-- Index awal tiap section (lihat angka di komentar output recorder)
-- Contoh: kalau "Lobby → Area Evidence" mulai di baris ke-18:
--   ["Lobby → Area Evidence"] = 18,
local SEC = {
    ["Boat → Lift Lobby"]           = 1,
    ["Lobby → Area Evidence"]       = 1,  -- ← ganti
    ["Area Evidence → Lift Island"] = 1,  -- ← ganti
    ["Lift Island → Boat"]          = 1,  -- ← ganti
}

-- ================================================================
--  CONFIG — ubah sesuai kebutuhan
-- ================================================================
local CFG = {
    maxEvidence    = 8,    -- target evidence per cycle
    collectRadius  = 15,   -- studs — ambil evidence kalau sedekat ini dari jalur
    promptReach    = 7,    -- studs — jarak fire proximity prompt
    wpReach        = 4,    -- studs — dianggap "sampai" di waypoint
    moveTimeout    = 4,    -- detik max per waypoint sebelum skip
    liftWait       = 5,    -- detik tunggu setelah trigger lift
    depositWait    = 3,    -- detik tunggu setelah deposit
}

-- ================================================================
--  STATE
-- ================================================================
local AI_ON     = false
local COL_COUNT = 0
local savedP    = { deposit=nil, lobby=nil, facility=nil }
local savedPos  = { deposit=nil, lobby=nil, facility=nil }

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
local function dist(a, b) return (a - b).Magnitude end

-- Slice WAYPOINTS untuk satu section
local function secWP(name)
    local order = {}
    for k, v in pairs(SEC) do table.insert(order, {k=k, v=v}) end
    table.sort(order, function(a,b) return a.v < b.v end)

    local si, ei = nil, #WAYPOINTS
    for i, e in ipairs(order) do
        if e.k == name then
            si = e.v
            if order[i+1] then ei = order[i+1].v - 1 end
            break
        end
    end
    if not si then return {} end

    local r = {}
    for i = si, ei do
        if WAYPOINTS[i] then r[#r+1] = WAYPOINTS[i] end
    end
    return r
end

-- ================================================================
--  GUI
-- ================================================================
local gui   = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name    = "AIv4"; gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size             = UDim2.new(0,290,0,420)
frame.Position         = UDim2.new(0,10,0,10)
frame.BackgroundColor3 = Color3.fromRGB(13,13,17)
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)

local function stripe(col)
    local f = Instance.new("Frame",frame)
    f.Size=UDim2.new(1,0,0,3); f.BackgroundColor3=col
    f.BorderSizePixel=0; f.ZIndex=5
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,12)
end
stripe(Color3.fromRGB(30,180,120))

local tb = Instance.new("Frame",frame)
tb.Size=UDim2.new(1,0,0,38); tb.Position=UDim2.new(0,0,0,3)
tb.BackgroundColor3=Color3.fromRGB(18,18,24); tb.BorderSizePixel=0; tb.ZIndex=4

local function lbl(parent,txt,x,y,w,h,col,font,sz,ax)
    local l=Instance.new("TextLabel",parent)
    l.Position=UDim2.new(0,x,0,y); l.Size=UDim2.new(0,w,0,h)
    l.BackgroundTransparency=1; l.Text=txt
    l.TextColor3=col or Color3.fromRGB(200,200,200)
    l.Font=font or Enum.Font.Gotham; l.TextSize=sz or 11
    l.TextXAlignment=ax or Enum.TextXAlignment.Left; l.ZIndex=5
    return l
end

lbl(tb,"🧠  AI Farming v4",12,5,260,18,Color3.fromRGB(255,255,255),Enum.Font.GothamBold,13)
lbl(tb,"Waypoint-First  •  Collect Sambil Lewat",12,23,260,13,Color3.fromRGB(30,180,120),Enum.Font.Gotham,10)

local function infoBar(posY, h)
    local b=Instance.new("Frame",frame)
    b.Size=UDim2.new(1,-16,0,h or 22)
    b.Position=UDim2.new(0,8,0,posY)
    b.BackgroundColor3=Color3.fromRGB(18,18,26)
    b.BorderSizePixel=0; b.ZIndex=3
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    local l=Instance.new("TextLabel",b)
    l.Size=UDim2.new(1,-8,1,0); l.Position=UDim2.new(0,6,0,0)
    l.BackgroundTransparency=1; l.TextXAlignment=Enum.TextXAlignment.Left
    l.ZIndex=4; l.TextSize=11; l.Font=Enum.Font.Gotham
    l.TextColor3=Color3.fromRGB(160,160,180); l.Text=""
    return l
end

local lblStatus = infoBar(48, 24)
local lblCount  = infoBar(78, 20); lblCount.Font=Enum.Font.GothamBold
lblCount.TextColor3=Color3.fromRGB(80,220,130)
local lblPhase  = infoBar(104, 20)
lblPhase.TextColor3=Color3.fromRGB(255,220,60)
local lblWP     = infoBar(130, 18); lblWP.Font=Enum.Font.Code
lblWP.TextColor3=Color3.fromRGB(140,140,200); lblWP.TextSize=10

-- Prompt status panel
local pp = Instance.new("Frame",frame)
pp.Size=UDim2.new(1,-16,0,72); pp.Position=UDim2.new(0,8,0,155)
pp.BackgroundColor3=Color3.fromRGB(16,16,22); pp.BorderSizePixel=0; pp.ZIndex=3
Instance.new("UICorner",pp).CornerRadius=UDim.new(0,8)
lbl(pp,"Prompt Status:",8,4,200,14,Color3.fromRGB(120,120,140),Enum.Font.GothamBold,10)
local pDeposit  = lbl(pp,"  ❌  Deposit Evidence",8,20,260,14,Color3.fromRGB(100,100,120))
local pLobby    = lbl(pp,"  ❌  Lobby (Lift)",    8,38,260,14,Color3.fromRGB(100,100,120))
local pFacility = lbl(pp,"  ❌  Facility (Lift)",  8,54,260,14,Color3.fromRGB(100,100,120))

-- Buttons
local function btn(text, posY, col)
    local b=Instance.new("TextButton",frame)
    b.Size=UDim2.new(1,-16,0,30); b.Position=UDim2.new(0,8,0,posY)
    b.BackgroundColor3=col; b.TextColor3=Color3.new(1,1,1)
    b.Font=Enum.Font.GothamBold; b.TextSize=12; b.Text=text
    b.AutoButtonColor=false; b.BorderSizePixel=0; b.ZIndex=3
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
    return b
end

local TEAL  = Color3.fromRGB(15,130,90)
local GREY  = Color3.fromRGB(32,32,42)
local AMBER = Color3.fromRGB(160,110,10)
local RED   = Color3.fromRGB(160,25,25)

local bScan     = btn("🔍  Scan Prompt",          235, TEAL)
local bDeposit  = btn("📍  Simpan: Deposit",       271, GREY)
local bLobby    = btn("📍  Simpan: Lobby Lift",    307, GREY)
local bFacility = btn("📍  Simpan: Facility Lift", 343, GREY)
local bAI       = btn("🧠  AI  :  OFF",            379, GREY)
local bStop     = btn("⏹  Stop",                   415, RED)

lbl(frame,"RightCtrl = hide/show",8,0,260,14,Color3.fromRGB(50,50,65),Enum.Font.Gotham,9)
    :Clone().Parent = frame  -- dummy, posisi di bawah

local hint2 = Instance.new("TextLabel",frame)
hint2.Size=UDim2.new(1,-16,0,12); hint2.Position=UDim2.new(0,8,1,-13)
hint2.BackgroundTransparency=1; hint2.Text="RightCtrl = hide/show"
hint2.TextColor3=Color3.fromRGB(50,50,65); hint2.Font=Enum.Font.Gotham
hint2.TextSize=9; hint2.TextXAlignment=Enum.TextXAlignment.Left; hint2.ZIndex=3

UserInputService.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode==Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)

-- ================================================================
--  GUI UPDATE HELPERS
-- ================================================================
local function setStatus(t, col) lblStatus.Text=t; lblStatus.TextColor3=col or Color3.fromRGB(160,160,180) end
local function setPhase(t, col)  lblPhase.Text="▶ "..t; lblPhase.TextColor3=col or Color3.fromRGB(255,220,60) end
local function setWP(t)          lblWP.Text="WP: "..t end
local function setCount(n)       lblCount.Text="Evidence: "..n.." / "..CFG.maxEvidence end

local function markPrompt(lbl2, name, found)
    lbl2.Text      = (found and "  ✅  " or "  ❌  ") .. name
    lbl2.TextColor3 = found and Color3.fromRGB(80,220,130) or Color3.fromRGB(100,100,120)
end

-- ================================================================
--  EVIDENCE FOLDER & PROMPT HELPERS
-- ================================================================
local function evidenceFolder()
    local ok, r = pcall(function()
        return workspace:WaitForChild("Data",5)
            :WaitForChild("Detective",5)
            :WaitForChild("Evidence",5)
            :WaitForChild("Instances",5)
    end)
    return ok and r or nil
end

local function collectPromptOf(model)
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            local a = d.ActionText:lower(); local o = d.ObjectText:lower()
            if a=="collect" or o=="collect" then return d end
        end
    end
end

local function findPromptByText(text)
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("ProximityPrompt") and (o.ActionText==text or o.ObjectText==text) then
            local p = o:FindFirstAncestorWhichIsA("BasePart")
            if not p then
                local m = o:FindFirstAncestorWhichIsA("Model")
                if m then p = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart",true) end
            end
            if p then return o, p.Position end
        end
    end
end

-- ================================================================
--  SCAN & MANUAL SAVE
-- ================================================================
local function doScan()
    setStatus("🔍 Scanning...", Color3.fromRGB(80,180,255))
    local n = 0
    local function try(text, key, plbl, pname)
        local pr, pos = findPromptByText(text)
        if pr then
            savedP[key]=pr; savedPos[key]=pos
            markPrompt(plbl, pname, true); n+=1
        else
            markPrompt(plbl, pname, false)
        end
    end
    try("Deposit Evidence","deposit",pDeposit, "Deposit Evidence")
    try("Lobby",           "lobby",  pLobby,   "Lobby (Lift)")
    try("Facility",        "facility",pFacility,"Facility (Lift)")
    setStatus("Scan: "..n.."/3", n==3 and Color3.fromRGB(80,220,130) or Color3.fromRGB(255,200,60))
end

local function saveManual(key, plbl, pname, searchText, btn2)
    local h = hrp(); if not h then return end
    local bestP, bestPos, bestD = nil, nil, math.huge
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("ProximityPrompt") and (o.ActionText==searchText or o.ObjectText==searchText) then
            local p = o:FindFirstAncestorWhichIsA("BasePart")
            if p then
                local d = dist(p.Position, h.Position)
                if d < bestD then bestP=o; bestPos=p.Position; bestD=d end
            end
        end
    end
    if bestP then
        savedP[key]=bestP; savedPos[key]=bestPos
        markPrompt(plbl, pname, true)
        btn2.BackgroundColor3 = TEAL
        setStatus("✅ Saved: "..searchText, Color3.fromRGB(80,220,130))
    else
        setStatus("⚠ Tidak ditemukan: "..searchText, Color3.fromRGB(255,80,80))
    end
end

bScan.MouseButton1Click:Connect(doScan)
bDeposit.MouseButton1Click:Connect(function()  saveManual("deposit","Deposit Evidence","Deposit Evidence",pDeposit,bDeposit) end)
bLobby.MouseButton1Click:Connect(function()    saveManual("lobby",  "Lobby (Lift)",   "Lobby",           pLobby,  bLobby)   end)
bFacility.MouseButton1Click:Connect(function() saveManual("facility","Facility (Lift)","Facility",        pFacility,bFacility) end)

-- ================================================================
--  CORE: WALK RAIL + COLLECT SAMBIL LEWAT
--
--  Karakter berjalan waypoint ke waypoint.
--  Di SETIAP waypoint, cek evidence dalam radius collectRadius.
--  Kalau ada → gerak ke sana, collect, kembali ke jalur.
--  Setelah selesai → lanjut waypoint berikutnya.
--  Tidak ada pathfinding. Tidak ada fallback. Tidak ada loncat gajelas.
-- ================================================================
local function walkAndCollect(wpList, label)
    if not wpList or #wpList == 0 then return end

    local folder = evidenceFolder()
    local total  = #wpList

    setPhase(label, Color3.fromRGB(255,220,60))

    for i, target in ipairs(wpList) do
        if not AI_ON then return end

        local h = hrp(); local hu = hum()
        if not h or not hu then return end

        -- Skip waypoint yang sudah dekat
        if dist(h.Position, target) < CFG.wpReach then
            setWP(i.."/"..total.." (skip)")
            continue
        end

        -- ── Jalan ke waypoint ini ──────────────────────────────
        setWP(i.."/"..total)
        setStatus(string.format("🚶 %s [%d/%d]", label, i, total),
            Color3.fromRGB(80,180,255))

        hu:MoveTo(target)

        local elapsed = 0
        while elapsed < CFG.moveTimeout do
            task.wait(0.1)
            elapsed += 0.1
            if not AI_ON then return end
            local cur = hrp()
            if not cur then break end
            if dist(cur.Position, target) <= CFG.wpReach then break end
        end
        -- Catatan: tidak ada jump, tidak ada retry.
        -- Kalau waypoint direkam dengan benar, karakter PASTI sampai.
        -- Kalau tidak sampai, dia skip ke waypoint berikutnya (yang lebih jauh) — ini justru baik.

        -- ── Cek evidence sambil lewat ─────────────────────────
        if folder and COL_COUNT < CFG.maxEvidence then
            local curH = hrp()
            if curH then
                -- Cari semua evidence dalam radius collectRadius dari posisi saat ini
                local nearby = {}
                for _, model in ipairs(folder:GetChildren()) do
                    local pr = collectPromptOf(model)
                    if pr then
                        local bp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart",true)
                        if bp then
                            local d = dist(curH.Position, bp.Position)
                            if d <= CFG.collectRadius then
                                table.insert(nearby, {prompt=pr, pos=bp.Position, d=d, name=model.Name})
                            end
                        end
                    end
                end

                -- Ambil semua yang dalam radius, terdekat dulu
                table.sort(nearby, function(a,b) return a.d < b.d end)

                for _, ev in ipairs(nearby) do
                    if not AI_ON then return end
                    if COL_COUNT >= CFG.maxEvidence then break end

                    local curH2 = hrp(); local hu2 = hum()
                    if not curH2 or not hu2 then break end

                    -- Jalan ke evidence
                    setStatus(string.format("📦 Ambil: %s (%.0f st)", ev.name, ev.d),
                        Color3.fromRGB(80,220,130))
                    hu2:MoveTo(ev.pos)

                    local t2 = 0
                    while t2 < 4 do
                        task.wait(0.1); t2+=0.1
                        if not AI_ON then return end
                        local c2 = hrp()
                        if c2 and dist(c2.Position, ev.pos) <= CFG.promptReach then break end
                    end

                    -- Collect
                    local ok = pcall(function() fireproximityprompt(ev.prompt) end)
                    if ok then
                        COL_COUNT += 1
                        setCount(COL_COUNT)
                        setStatus("✅ "..COL_COUNT.."/"..CFG.maxEvidence.." — lanjut jalur",
                            Color3.fromRGB(80,220,130))
                    end
                    task.wait(0.3)

                    -- Kembali ke waypoint jalur saat ini sebelum lanjut
                    -- (supaya tidak meleset terlalu jauh dari jalur)
                    local backH = hrp(); local backHu = hum()
                    if backH and backHu and dist(backH.Position, target) > CFG.wpReach * 2 then
                        backHu:MoveTo(target)
                        local t3=0
                        while t3 < 2 do
                            task.wait(0.1); t3+=0.1
                            if not AI_ON then return end
                            local c3 = hrp()
                            if c3 and dist(c3.Position, target) <= CFG.wpReach then break end
                        end
                    end
                end
            end
        end
    end

    setWP("✓ " .. label)
end

-- ================================================================
--  TRIGGER LIFT / DEPOSIT — jalan MoveTo ke posisi, lalu fire
-- ================================================================
local function doPrompt(key, label)
    if not savedP[key] or not savedPos[key] then
        setStatus("⚠ "..label.." belum di-save!", Color3.fromRGB(255,80,80))
        return false
    end

    local h = hrp(); local hu = hum()
    if not h or not hu then return false end

    setStatus("🚶 Menuju "..label.."...", Color3.fromRGB(80,180,255))
    hu:MoveTo(savedPos[key])

    local t = 0
    while t < 6 do
        task.wait(0.1); t+=0.1
        if not AI_ON then return false end
        local cur = hrp()
        if cur and dist(cur.Position, savedPos[key]) <= CFG.promptReach then break end
    end

    task.wait(0.2)
    local ok = pcall(function() fireproximityprompt(savedP[key]) end)
    setStatus((ok and "✅" or "❌").." "..label, ok and Color3.fromRGB(80,220,130) or Color3.fromRGB(255,80,80))
    return ok
end

-- ================================================================
--  MAIN AI LOOP
-- ================================================================
local function runAI()
    COL_COUNT = 0; setCount(0)
    setStatus("🤖 Mulai...", Color3.fromRGB(255,220,60))
    task.wait(1)

    while AI_ON do

        -- FASE 1: Jalan Boat→Lift sambil collect di island
        setPhase("Island → Lift", Color3.fromRGB(255,180,60))
        walkAndCollect(secWP("Boat → Lift Lobby"), "Boat→Lift")
        if not AI_ON then break end

        -- Kalau masih butuh evidence, naik ke lobby
        if COL_COUNT < CFG.maxEvidence then
            doPrompt("lobby", "Lobby Lift")
            task.wait(CFG.liftWait)
            if not AI_ON then break end

            -- FASE 2: Jalan di area lobby sambil collect
            setPhase("Lobby Collect", Color3.fromRGB(80,180,255))
            walkAndCollect(secWP("Lobby → Area Evidence"), "Lobby→Evidence")
            if not AI_ON then break end

            -- FASE 3: Balik ke island via lift
            walkAndCollect(secWP("Area Evidence → Lift Island"), "Evidence→LiftIsland")
            if not AI_ON then break end

            doPrompt("facility", "Facility Lift")
            task.wait(CFG.liftWait)
            if not AI_ON then break end

            -- FASE 4: Jalan balik ke boat sambil collect sisa
            walkAndCollect(secWP("Lift Island → Boat"), "Island→Boat")
            if not AI_ON then break end
        end

        -- FASE 5: Deposit
        setPhase("Deposit", Color3.fromRGB(80,220,130))
        doPrompt("deposit", "Deposit Evidence")
        task.wait(CFG.depositWait)
        if not AI_ON then break end

        -- Reset cycle
        COL_COUNT = 0; setCount(0)
        setPhase("Idle", Color3.fromRGB(160,160,180))
        setStatus("🔄 Siklus selesai, ulang...", Color3.fromRGB(255,220,60))
        task.wait(2)
    end

    setPhase("Stopped", Color3.fromRGB(160,160,180))
    setStatus("⏹ Dihentikan", Color3.fromRGB(160,160,180))
    setWP("—")
end

-- ================================================================
--  TOMBOL
-- ================================================================
local function stopAI()
    AI_ON = false
    bAI.Text="🧠  AI  :  OFF"; bAI.BackgroundColor3=GREY
    local hu=hum(); local h=hrp()
    if hu and h then hu:MoveTo(h.Position) end
    setPhase("Stopped",Color3.fromRGB(160,160,180))
    setStatus("⏹ Dihentikan",Color3.fromRGB(160,160,180)); setWP("—")
end

bAI.MouseButton1Click:Connect(function()
    AI_ON = not AI_ON
    if AI_ON then
        bAI.Text="🧠  AI  :  ON"; bAI.BackgroundColor3=AMBER
        task.spawn(runAI)
    else stopAI() end
end)
bStop.MouseButton1Click:Connect(stopAI)

LP.CharacterAdded:Connect(function() end)

task.delay(2, doScan)
setStatus("✅ Ready", Color3.fromRGB(80,220,130))
setPhase("Ready", Color3.fromRGB(80,220,130))
