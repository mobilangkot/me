-- WAYPOINT RECORDER — Mobile Friendly
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local waypoints = {}
local sections  = {} -- nama section per titik
local currentSection = "Boat → Lift Lobby"

local sectionList = {
    "Boat → Lift Lobby",
    "Lobby → Area Evidence",
    "Area Evidence → Lift Island",
    "Lift Island → Boat",
}
local sectionIndex = 1

-- =============================================
-- GUI
-- =============================================
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "WPRecorder"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size             = UDim2.new(0, 300, 0, 420)
frame.Position         = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(13,13,17)
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local accent = Instance.new("Frame", frame)
accent.Size             = UDim2.new(1,0,0,3)
accent.BackgroundColor3 = Color3.fromRGB(255,180,30)
accent.BorderSizePixel  = 0
accent.ZIndex           = 5
Instance.new("UICorner", accent).CornerRadius = UDim.new(0,12)

local titleBar = Instance.new("Frame", frame)
titleBar.Size             = UDim2.new(1,0,0,38)
titleBar.Position         = UDim2.new(0,0,0,3)
titleBar.BackgroundColor3 = Color3.fromRGB(18,18,24)
titleBar.BorderSizePixel  = 0
titleBar.ZIndex           = 4

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size            = UDim2.new(1,-12,1,0)
titleLbl.Position        = UDim2.new(0,12,0,0)
titleLbl.BackgroundTransparency = 1
titleLbl.TextColor3      = Color3.fromRGB(255,255,255)
titleLbl.Font            = Enum.Font.GothamBold
titleLbl.TextSize        = 13
titleLbl.TextXAlignment  = Enum.TextXAlignment.Left
titleLbl.Text            = "📍  Waypoint Recorder"
titleLbl.ZIndex          = 5

-- Section bar
local secBar = Instance.new("Frame", frame)
secBar.Size             = UDim2.new(1,-16,0,34)
secBar.Position         = UDim2.new(0,8,0,48)
secBar.BackgroundColor3 = Color3.fromRGB(20,20,30)
secBar.BorderSizePixel  = 0
secBar.ZIndex           = 3
Instance.new("UICorner", secBar).CornerRadius = UDim.new(0,8)

local secLbl = Instance.new("TextLabel", secBar)
secLbl.Size               = UDim2.new(1,-10,1,0)
secLbl.Position           = UDim2.new(0,8,0,0)
secLbl.BackgroundTransparency = 1
secLbl.TextColor3         = Color3.fromRGB(255,200,60)
secLbl.Font               = Enum.Font.GothamBold
secLbl.TextSize           = 12
secLbl.TextXAlignment     = Enum.TextXAlignment.Left
secLbl.Text               = "📌 Section: " .. currentSection
secLbl.ZIndex             = 4

-- Count bar
local cntBar = Instance.new("Frame", frame)
cntBar.Size             = UDim2.new(1,-16,0,26)
cntBar.Position         = UDim2.new(0,8,0,88)
cntBar.BackgroundColor3 = Color3.fromRGB(18,18,26)
cntBar.BorderSizePixel  = 0
cntBar.ZIndex           = 3
Instance.new("UICorner", cntBar).CornerRadius = UDim.new(0,7)

local cntLbl = Instance.new("TextLabel", cntBar)
cntLbl.Size               = UDim2.new(1,-10,1,0)
cntLbl.Position           = UDim2.new(0,8,0,0)
cntLbl.BackgroundTransparency = 1
cntLbl.TextColor3         = Color3.fromRGB(80,220,130)
cntLbl.Font               = Enum.Font.Gotham
cntLbl.TextSize           = 12
cntLbl.TextXAlignment     = Enum.TextXAlignment.Left
cntLbl.Text               = "Total titik: 0"
cntLbl.ZIndex             = 4

-- Last point bar
local lastBar = Instance.new("Frame", frame)
lastBar.Size             = UDim2.new(1,-16,0,26)
lastBar.Position         = UDim2.new(0,8,0,120)
lastBar.BackgroundColor3 = Color3.fromRGB(18,18,26)
lastBar.BorderSizePixel  = 0
lastBar.ZIndex           = 3
Instance.new("UICorner", lastBar).CornerRadius = UDim.new(0,7)

local lastLbl = Instance.new("TextLabel", lastBar)
lastLbl.Size               = UDim2.new(1,-10,1,0)
lastLbl.Position           = UDim2.new(0,8,0,0)
lastLbl.BackgroundTransparency = 1
lastLbl.TextColor3         = Color3.fromRGB(160,160,180)
lastLbl.Font               = Enum.Font.Code
lastLbl.TextSize           = 11
lastLbl.TextXAlignment     = Enum.TextXAlignment.Left
lastLbl.Text               = "Last: —"
lastLbl.ZIndex             = 4

-- Output scroll (untuk preview)
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size                = UDim2.new(1,-16,0,80)
scroll.Position            = UDim2.new(0,8,0,152)
scroll.BackgroundColor3    = Color3.fromRGB(10,10,14)
scroll.BorderSizePixel     = 0
scroll.ScrollBarThickness  = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(255,180,30)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize          = UDim2.new(0,0,0,0)
scroll.ZIndex              = 3
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0,7)

local scrollLayout = Instance.new("UIListLayout", scroll)
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.Padding   = UDim.new(0,1)

local scrollPad = Instance.new("UIPadding", scroll)
scrollPad.PaddingLeft  = UDim.new(0,5)
scrollPad.PaddingTop   = UDim.new(0,3)

local previewLines = {}
local previewOrder = 0

local function addPreview(text, color)
    previewOrder += 1
    local l = Instance.new("TextLabel", scroll)
    l.Size               = UDim2.new(1,-4,0,14)
    l.BackgroundTransparency = 1
    l.TextColor3         = color or Color3.fromRGB(160,160,180)
    l.Font               = Enum.Font.Code
    l.TextSize           = 10
    l.TextXAlignment     = Enum.TextXAlignment.Left
    l.Text               = text
    l.LayoutOrder        = previewOrder
    l.ZIndex             = 4
    table.insert(previewLines, l)
    task.defer(function() scroll.CanvasPosition = Vector2.new(0,math.huge) end)
end

-- Buttons
local function newBtn(text, posY, col)
    local b = Instance.new("TextButton", frame)
    b.Size             = UDim2.new(1,-16,0,34)
    b.Position         = UDim2.new(0,8,0,posY)
    b.BackgroundColor3 = col
    b.TextColor3       = Color3.new(1,1,1)
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 13
    b.Text             = text
    b.AutoButtonColor  = false
    b.BorderSizePixel  = 0
    b.ZIndex           = 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local C_GREEN  = Color3.fromRGB(20,110,40)
local C_GREY   = Color3.fromRGB(32,32,42)
local C_AMBER  = Color3.fromRGB(160,110,10)
local C_BLUE   = Color3.fromRGB(20,70,160)
local C_RED    = Color3.fromRGB(160,25,25)
local C_PURPLE = Color3.fromRGB(100,30,160)

local btnRecord   = newBtn("⏺  Rekam Titik Sekarang",    240, C_GREEN)
local btnNextSec  = newBtn("⏭  Ganti Section Berikutnya", 280, C_AMBER)
local btnUndo     = newBtn("↩  Hapus Titik Terakhir",     320, C_GREY)
local btnCopy     = newBtn("📋  Generate & Copy Output",   360, C_BLUE)
local btnClearAll = newBtn("🗑  Clear Semua",              400, C_RED)

local hintLbl = Instance.new("TextLabel", frame)
hintLbl.Size               = UDim2.new(1,-16,0,12)
hintLbl.Position           = UDim2.new(0,8,1,-14)
hintLbl.BackgroundTransparency = 1
hintLbl.TextColor3         = Color3.fromRGB(50,50,65)
hintLbl.Font               = Enum.Font.Gotham
hintLbl.TextSize           = 10
hintLbl.TextXAlignment     = Enum.TextXAlignment.Left
hintLbl.Text               = "Rekam jalur lalu copy hasilnya"
hintLbl.ZIndex             = 3

-- =============================================
-- Logic
-- =============================================
local function updateCount()
    cntLbl.Text = "Total titik: " .. #waypoints ..
        "  |  Section " .. sectionIndex .. "/" .. #sectionList
end

local function recordPoint()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local p = hrp.Position
    table.insert(waypoints, { pos = p, section = currentSection })

    local n = #waypoints
    updateCount()

    local txt = string.format("#%d [%s] %.1f,%.1f,%.1f",
        n, currentSection:sub(1,8), p.X, p.Y, p.Z)
    lastLbl.Text = txt

    local col = sectionIndex == 1 and Color3.fromRGB(80,220,130)
        or sectionIndex == 2 and Color3.fromRGB(80,180,255)
        or sectionIndex == 3 and Color3.fromRGB(255,180,80)
        or Color3.fromRGB(255,100,100)
    addPreview(txt, col)
end

local function nextSection()
    if sectionIndex >= #sectionList then
        secLbl.Text = "📌 Semua section selesai ✅"
        return
    end
    sectionIndex += 1
    currentSection = sectionList[sectionIndex]
    secLbl.Text = "📌 Section: " .. currentSection
    addPreview("── " .. currentSection .. " ──", Color3.fromRGB(255,220,60))
    updateCount()
end

local function undoLast()
    if #waypoints == 0 then return end
    table.remove(waypoints)
    -- Hapus preview terakhir
    if #previewLines > 0 then
        local l = table.remove(previewLines)
        l:Destroy()
    end
    updateCount()
    lastLbl.Text = #waypoints > 0
        and string.format("Last #%d: undo", #waypoints)
        or "Last: —"
end

local function generateOutput()
    if #waypoints == 0 then
        lastLbl.Text = "⚠ Belum ada titik!"
        return
    end

    -- Build string output
    local lines = {}
    table.insert(lines, "local WAYPOINTS = {")

    local lastSec = ""
    for i, wp in ipairs(waypoints) do
        if wp.section ~= lastSec then
            table.insert(lines, "    -- === " .. wp.section .. " ===")
            lastSec = wp.section
        end
        table.insert(lines, string.format(
            "    Vector3.new(%.2f, %.2f, %.2f), -- %d",
            wp.pos.X, wp.pos.Y, wp.pos.Z, i
        ))
    end
    table.insert(lines, "}")

    local result = table.concat(lines, "\n")

    -- Copy ke clipboard
    local ok = pcall(function()
        setclipboard(result)
    end)

    -- Tampilkan di preview juga
    for _, l in ipairs(previewLines) do l:Destroy() end
    previewLines = {}
    previewOrder = 0

    for _, line in ipairs(lines) do
        addPreview(line, Color3.fromRGB(200,200,200))
    end

    lastLbl.Text = ok
        and "✅ Tersalin! Paste ke script AI"
        or  "⚠ setclipboard tidak support — screenshot output"
    lastLbl.TextColor3 = ok
        and Color3.fromRGB(80,220,130)
        or  Color3.fromRGB(255,200,60)
end

local function clearAll()
    waypoints = {}
    sectionIndex = 1
    currentSection = sectionList[1]
    secLbl.Text = "📌 Section: " .. currentSection
    for _, l in ipairs(previewLines) do l:Destroy() end
    previewLines = {}
    previewOrder = 0
    updateCount()
    lastLbl.Text = "—"
    lastLbl.TextColor3 = Color3.fromRGB(160,160,180)
end

btnRecord.MouseButton1Click:Connect(recordPoint)
btnNextSec.MouseButton1Click:Connect(nextSection)
btnUndo.MouseButton1Click:Connect(undoLast)
btnCopy.MouseButton1Click:Connect(generateOutput)
btnClearAll.MouseButton1Click:Connect(clearAll)

updateCount()
addPreview("── " .. currentSection .. " ──", Color3.fromRGB(255,220,60))
