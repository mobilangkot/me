-- ================================================================
--  WAYPOINT RECORDER v2 — untuk SQ Tool AI v8
--  Output langsung kompatibel: WP_ISLAND_TO_LIFT / WP_LOBBY / WP_ISLAND_BACK
--  By menzcreate | discord: menzcreate
-- ================================================================
--
--  ALUR RECORD:
--
--  SECTION 1 — "Island → Lift Lobby"
--    Mulai dari spawn island, jalan ke arah lift lobby,
--    rekam titik-titik sepanjang jalan, STOP tepat di depan pintu lift.
--    → Tekan [Ganti Section] setelah selesai.
--
--  SECTION 2 — "Lobby Farming Route"
--    Keluar dari lift lobby, jalan mengelilingi area evidence,
--    rekam semua titik farming, akhiri tepat di depan pintu lift Facility.
--    → Tekan [Ganti Section] setelah selesai.
--
--  SECTION 3 — "Island (Balik) → Deposit"
--    Keluar dari lift Facility di island, jalan ke titik deposit,
--    rekam jalurnya, STOP tepat di titik deposit.
--    → Tekan [Generate & Copy] setelah selesai.
--
--  TIPS:
--  - Jalan PELAN, rekam tiap 5-10 studs
--  - Di tikungan / tanjakan rekam lebih rapat
--  - Gunakan [↩ Undo] kalau salah rekam
--  - Setelah copy, paste GANTIKAN 3 array di script AI v8
--
-- ================================================================

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- =============================================
--  STATE
-- =============================================
local sectionList = {
    { key = "SEG1", varName = "WP_ISLAND_TO_LIFT", label = "Island → Lift Lobby",       color = Color3.fromRGB(255,160,60)  },
    { key = "SEG2", varName = "WP_LOBBY",           label = "Lobby Farming Route",       color = Color3.fromRGB(60,190,255)  },
    { key = "SEG3", varName = "WP_ISLAND_BACK",     label = "Island (Balik) → Deposit",  color = Color3.fromRGB(180,100,255) },
}

local sectionData = {}   -- sectionData[i] = { pos=Vector3, ... }[]
for i = 1, #sectionList do sectionData[i] = {} end

local activeSec    = 1   -- 1 / 2 / 3
local totalPoints  = 0

local function getHRP()
    local c = LP.Character; if not c then return nil end
    return c:FindFirstChild("HumanoidRootPart")
        or c:FindFirstChild("UpperTorso")
        or c:FindFirstChild("Torso")
end

-- =============================================
--  GUI
-- =============================================
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "WPRecorder"; gui.ResetOnSpawn = false

local BG   = Color3.fromRGB(13,13,17)
local BG1  = Color3.fromRGB(18,18,24)
local BG2  = Color3.fromRGB(22,22,30)
local DIM  = Color3.fromRGB(60,60,75)
local WHT  = Color3.fromRGB(220,220,220)

local frame = Instance.new("Frame", gui)
frame.Size             = UDim2.new(0,300,0,450)
frame.Position         = UDim2.new(0,10,0,10)
frame.BackgroundColor3 = BG
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- accent bar atas
local accentBar = Instance.new("Frame", frame)
accentBar.Size             = UDim2.new(1,0,0,3)
accentBar.BackgroundColor3 = Color3.fromRGB(255,180,30)
accentBar.BorderSizePixel  = 0; accentBar.ZIndex = 5
Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0,12)

-- title bar
local titleBar = Instance.new("Frame", frame)
titleBar.Size             = UDim2.new(1,0,0,38)
titleBar.Position         = UDim2.new(0,0,0,3)
titleBar.BackgroundColor3 = BG1
titleBar.BorderSizePixel  = 0; titleBar.ZIndex = 4

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size = UDim2.new(1,-12,1,0); titleLbl.Position = UDim2.new(0,12,0,0)
titleLbl.BackgroundTransparency = 1
titleLbl.TextColor3 = WHT; titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 13; titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.Text = "📍  WP Recorder  ·  SQ Tool v8"; titleLbl.ZIndex = 5

-- ─── Section tabs ─────────────────────────────────────────────
local tabRow = Instance.new("Frame", frame)
tabRow.Size = UDim2.new(1,-16,0,30); tabRow.Position = UDim2.new(0,8,0,48)
tabRow.BackgroundTransparency = 1; tabRow.ZIndex = 3

local tabBtns = {}
for i, sec in ipairs(sectionList) do
    local btn = Instance.new("TextButton", tabRow)
    btn.Size             = UDim2.new(0.31,0,1,0)
    btn.Position         = UDim2.new((i-1)*0.335,0,0,0)
    btn.BackgroundColor3 = BG2
    btn.TextColor3       = DIM
    btn.Font             = Enum.Font.GothamBold; btn.TextSize = 10
    btn.Text             = "SEG" .. i
    btn.AutoButtonColor  = false; btn.BorderSizePixel = 0; btn.ZIndex = 4
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    local st = Instance.new("UIStroke", btn); st.Color = DIM; st.Thickness = 1
    tabBtns[i] = { btn=btn, stroke=st }

    btn.MouseButton1Click:Connect(function()
        activeSec = i
        refreshTabs()
        refreshInfo()
    end)
end

function refreshTabs()
    for i, t in ipairs(tabBtns) do
        local col = sectionList[i].color
        local cnt = #sectionData[i]
        local cntStr = cnt > 0 and (" ("..cnt..")") or ""
        if i == activeSec then
            t.btn.BackgroundColor3 = Color3.fromRGB(20,20,32)
            t.btn.TextColor3       = col
            t.stroke.Color         = col
            t.btn.Text             = "SEG"..i..cntStr
        else
            t.btn.BackgroundColor3 = BG2
            t.btn.TextColor3       = cnt > 0 and Color3.fromRGB(100,100,120) or DIM
            t.stroke.Color         = cnt > 0 and Color3.fromRGB(50,50,65) or DIM
            t.btn.Text             = "SEG"..i..cntStr
        end
    end
end

-- ─── Info box ─────────────────────────────────────────────────
local infoBox = Instance.new("Frame", frame)
infoBox.Size = UDim2.new(1,-16,0,44); infoBox.Position = UDim2.new(0,8,0,84)
infoBox.BackgroundColor3 = BG1; infoBox.BorderSizePixel = 0; infoBox.ZIndex = 3
Instance.new("UICorner", infoBox).CornerRadius = UDim.new(0,8)

local infoLine1 = Instance.new("TextLabel", infoBox)
infoLine1.Size = UDim2.new(1,-12,0,20); infoLine1.Position = UDim2.new(0,8,0,3)
infoLine1.BackgroundTransparency = 1; infoLine1.Font = Enum.Font.GothamBold
infoLine1.TextSize = 11; infoLine1.TextXAlignment = Enum.TextXAlignment.Left
infoLine1.TextColor3 = WHT; infoLine1.ZIndex = 4

local infoLine2 = Instance.new("TextLabel", infoBox)
infoLine2.Size = UDim2.new(1,-12,0,16); infoLine2.Position = UDim2.new(0,8,0,24)
infoLine2.BackgroundTransparency = 1; infoLine2.Font = Enum.Font.Gotham
infoLine2.TextSize = 10; infoLine2.TextXAlignment = Enum.TextXAlignment.Left
infoLine2.TextColor3 = DIM; infoLine2.ZIndex = 4

function refreshInfo()
    local sec = sectionList[activeSec]
    local pts = sectionData[activeSec]
    infoLine1.TextColor3 = sec.color
    infoLine1.Text = "▸ " .. sec.label
    infoLine2.Text = string.format(
        "%d titik  |  Total semua seg: %d  |  varName: %s",
        #pts, totalPoints, sec.varName
    )
end

-- ─── Last point bar ───────────────────────────────────────────
local lastBar = Instance.new("Frame", frame)
lastBar.Size = UDim2.new(1,-16,0,22); lastBar.Position = UDim2.new(0,8,0,134)
lastBar.BackgroundColor3 = BG2; lastBar.BorderSizePixel = 0; lastBar.ZIndex = 3
Instance.new("UICorner", lastBar).CornerRadius = UDim.new(0,6)

local lastLbl = Instance.new("TextLabel", lastBar)
lastLbl.Size = UDim2.new(1,-10,1,0); lastLbl.Position = UDim2.new(0,8,0,0)
lastLbl.BackgroundTransparency = 1; lastLbl.Font = Enum.Font.Code
lastLbl.TextSize = 10; lastLbl.TextXAlignment = Enum.TextXAlignment.Left
lastLbl.TextColor3 = DIM; lastLbl.ZIndex = 4
lastLbl.Text = "Last: —"

-- ─── Preview scroll ───────────────────────────────────────────
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,-16,0,90); scroll.Position = UDim2.new(0,8,0,162)
scroll.BackgroundColor3 = Color3.fromRGB(10,10,14); scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3; scroll.ScrollBarImageColor3 = Color3.fromRGB(255,180,30)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0,0,0,0); scroll.ZIndex = 3
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0,7)
local scrollLayout = Instance.new("UIListLayout", scroll)
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder; scrollLayout.Padding = UDim.new(0,1)
local scrollPad = Instance.new("UIPadding", scroll)
scrollPad.PaddingLeft = UDim.new(0,5); scrollPad.PaddingTop = UDim.new(0,3)

local previewLines = {}; local previewOrder = 0
local function addPreview(text, color)
    previewOrder += 1
    local l = Instance.new("TextLabel", scroll)
    l.Size = UDim2.new(1,-4,0,14); l.BackgroundTransparency = 1
    l.TextColor3 = color or WHT; l.Font = Enum.Font.Code
    l.TextSize = 10; l.TextXAlignment = Enum.TextXAlignment.Left
    l.Text = text; l.LayoutOrder = previewOrder; l.ZIndex = 4
    table.insert(previewLines, l)
    task.defer(function() scroll.CanvasPosition = Vector2.new(0,math.huge) end)
end

-- ─── Buttons ──────────────────────────────────────────────────
local function newBtn(text, posY, col, tc)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-16,0,36); b.Position = UDim2.new(0,8,0,posY)
    b.BackgroundColor3 = col; b.TextColor3 = tc or WHT
    b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.Text = text
    b.AutoButtonColor = false; b.BorderSizePixel = 0; b.ZIndex = 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local function newHalfBtn(text, posY, xPos, col, tc)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.47,0,0,34); b.Position = UDim2.new(xPos,0,0,posY)
    b.BackgroundColor3 = col; b.TextColor3 = tc or WHT
    b.Font = Enum.Font.GothamBold; b.TextSize = 12; b.Text = text
    b.AutoButtonColor = false; b.BorderSizePixel = 0; b.ZIndex = 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local Y = 258
local btnRecord   = newBtn(     "⏺  Rekam Titik Sekarang",         Y,      Color3.fromRGB(15,80,30),   Color3.fromRGB(80,230,120))
local btnNextSec  = newBtn(     "⏭  Lanjut Section Berikutnya",    Y+42,   Color3.fromRGB(100,75,10),  Color3.fromRGB(255,200,60))
local btnUndo     = newHalfBtn( "↩ Undo",                          Y+84,   0.055, Color3.fromRGB(40,30,10),   Color3.fromRGB(220,160,60))
local btnClearSeg = newHalfBtn( "🗑 Clear Seg",                     Y+84,   0.525, Color3.fromRGB(50,15,15),   Color3.fromRGB(220,80,80))
local btnCopy     = newBtn(     "📋  Generate & Copy Output",       Y+126,  Color3.fromRGB(15,40,90),   Color3.fromRGB(80,160,255))

local hintLbl = Instance.new("TextLabel", frame)
hintLbl.Size = UDim2.new(1,-16,0,12); hintLbl.Position = UDim2.new(0,8,1,-14)
hintLbl.BackgroundTransparency = 1; hintLbl.TextColor3 = Color3.fromRGB(40,40,55)
hintLbl.Font = Enum.Font.Gotham; hintLbl.TextSize = 9
hintLbl.TextXAlignment = Enum.TextXAlignment.Left; hintLbl.ZIndex = 3
hintLbl.Text = "Jalan pelan, rekam tiap 5-10 studs. Tikungan lebih rapat."

-- =============================================
--  LOGIC
-- =============================================
local function recordPoint()
    local h = getHRP(); if not h then return end
    local pos = h.Position
    local pts = sectionData[activeSec]
    table.insert(pts, pos)
    totalPoints += 1

    local n     = #pts
    local sec   = sectionList[activeSec]
    local txt   = string.format("#%d  %.1f, %.1f, %.1f", n, pos.X, pos.Y, pos.Z)
    lastLbl.Text      = "Last [SEG"..activeSec.."] " .. txt
    lastLbl.TextColor3 = sec.color

    addPreview("[SEG"..activeSec.."] " .. txt, sec.color)
    refreshTabs()
    refreshInfo()
end

local function nextSection()
    if activeSec >= #sectionList then
        lastLbl.Text = "✅ Semua section selesai! Tekan Generate."
        lastLbl.TextColor3 = Color3.fromRGB(80,230,120)
        return
    end
    activeSec += 1
    addPreview("── SEG"..activeSec.." : "..sectionList[activeSec].label.." ──",
        Color3.fromRGB(255,220,60))
    refreshTabs()
    refreshInfo()
    lastLbl.Text = "📌 Pindah ke SEG"..activeSec
    lastLbl.TextColor3 = sectionList[activeSec].color
end

local function undoLast()
    local pts = sectionData[activeSec]
    if #pts == 0 then
        lastLbl.Text = "⚠ Tidak ada titik di SEG"..activeSec
        lastLbl.TextColor3 = Color3.fromRGB(220,80,80)
        return
    end
    table.remove(pts)
    totalPoints = math.max(0, totalPoints - 1)
    if #previewLines > 0 then
        local l = table.remove(previewLines); l:Destroy()
    end
    refreshTabs(); refreshInfo()
    lastLbl.Text = "↩ Undo SEG"..activeSec.." → "..#pts.." titik"
    lastLbl.TextColor3 = Color3.fromRGB(220,160,60)
end

local function clearSeg()
    local pts = sectionData[activeSec]
    totalPoints = math.max(0, totalPoints - #pts)
    sectionData[activeSec] = {}
    -- Hapus preview lines yang milik seg ini (semua untuk simplicity)
    for _, l in ipairs(previewLines) do l:Destroy() end
    previewLines = {}; previewOrder = 0
    refreshTabs(); refreshInfo()
    lastLbl.Text = "🗑 SEG"..activeSec.." di-clear"
    lastLbl.TextColor3 = Color3.fromRGB(220,80,80)
end

local function generateOutput()
    -- Cek semua segment terisi
    local missing = {}
    for i, sec in ipairs(sectionList) do
        if #sectionData[i] == 0 then
            table.insert(missing, "SEG"..i.." ("..sec.label..")")
        end
    end

    local lines = {}

    -- Header komentar
    table.insert(lines, "-- ================================================")
    table.insert(lines, "-- PATH RECORDER v2 EXPORT — paste ke script AI v8")
    table.insert(lines, "-- Total: SEG1="..#sectionData[1].." | SEG2="..#sectionData[2].." | SEG3="..#sectionData[3])
    if #missing > 0 then
        table.insert(lines, "-- ⚠ KOSONG: " .. table.concat(missing, ", "))
    end
    table.insert(lines, "-- ================================================")
    table.insert(lines, "")

    -- 3 array terpisah sesuai AI v8
    for i, sec in ipairs(sectionList) do
        local pts = sectionData[i]
        table.insert(lines, "local " .. sec.varName .. " = {")
        if #pts == 0 then
            table.insert(lines, "    -- ⚠ KOSONG — rekam section ini dulu!")
        else
            for j, pos in ipairs(pts) do
                table.insert(lines, string.format(
                    "    Vector3.new(%.2f, %.2f, %.2f), -- %d",
                    pos.X, pos.Y, pos.Z, j
                ))
            end
        end
        table.insert(lines, "}")
        table.insert(lines, "")
    end

    local result = table.concat(lines, "\n")

    -- Copy ke clipboard
    local ok = pcall(function() setclipboard(result) end)

    -- Refresh preview dengan output
    for _, l in ipairs(previewLines) do l:Destroy() end
    previewLines = {}; previewOrder = 0

    for _, line in ipairs(lines) do
        local col = line:find("^local ") and Color3.fromRGB(255,200,60)
            or line:find("Vector3") and Color3.fromRGB(80,220,130)
            or line:find("⚠") and Color3.fromRGB(220,80,80)
            or Color3.fromRGB(100,100,120)
        addPreview(line, col)
    end

    if ok then
        lastLbl.Text = "✅ Tersalin ke clipboard! Paste ke script AI v8."
        lastLbl.TextColor3 = Color3.fromRGB(80,230,120)
    else
        lastLbl.Text = "⚠ setclipboard tidak support — screenshot preview di atas."
        lastLbl.TextColor3 = Color3.fromRGB(255,200,60)
    end
end

-- =============================================
--  CONNECT
-- =============================================
btnRecord.MouseButton1Click:Connect(recordPoint)
btnNextSec.MouseButton1Click:Connect(nextSection)
btnUndo.MouseButton1Click:Connect(undoLast)
btnClearSeg.MouseButton1Click:Connect(clearSeg)
btnCopy.MouseButton1Click:Connect(generateOutput)

-- =============================================
--  INIT
-- =============================================
refreshTabs()
refreshInfo()
addPreview("── SEG1 : "..sectionList[1].label.." ──", Color3.fromRGB(255,220,60))
