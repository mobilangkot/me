local Players          = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- =============================================
-- GUI
-- =============================================
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name         = "RemoteViewer"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size             = UDim2.new(0, 400, 0, 520)
frame.Position         = UDim2.new(0, 14, 0, 14)
frame.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Accent
local accent = Instance.new("Frame", frame)
accent.Size             = UDim2.new(1, 0, 0, 3)
accent.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
accent.BorderSizePixel  = 0
accent.ZIndex           = 5
Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 12)

-- Title bar
local titleBar = Instance.new("Frame", frame)
titleBar.Size             = UDim2.new(1, 0, 0, 40)
titleBar.Position         = UDim2.new(0, 0, 0, 3)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
titleBar.BorderSizePixel  = 0
titleBar.ZIndex           = 4

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size            = UDim2.new(1, -12, 0, 21)
titleLbl.Position        = UDim2.new(0, 12, 0, 4)
titleLbl.BackgroundTransparency = 1
titleLbl.TextColor3      = Color3.fromRGB(255, 255, 255)
titleLbl.Font            = Enum.Font.GothamBold
titleLbl.TextSize        = 14
titleLbl.TextXAlignment  = Enum.TextXAlignment.Left
titleLbl.Text            = "🔎  Remote Viewer  —  ReplicatedStorage"
titleLbl.ZIndex          = 5

local subLbl = Instance.new("TextLabel", titleBar)
subLbl.Size            = UDim2.new(1, -12, 0, 13)
subLbl.Position        = UDim2.new(0, 12, 0, 24)
subLbl.BackgroundTransparency = 1
subLbl.TextColor3      = Color3.fromRGB(80, 120, 255)
subLbl.Font            = Enum.Font.Gotham
subLbl.TextSize        = 11
subLbl.TextXAlignment  = Enum.TextXAlignment.Left
subLbl.Text            = "by menzcreate  •  discord: menzcreate"
subLbl.ZIndex          = 5

-- Counter bar
local counterBar = Instance.new("Frame", frame)
counterBar.Size             = UDim2.new(1, -16, 0, 26)
counterBar.Position         = UDim2.new(0, 8, 0, 50)
counterBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
counterBar.BorderSizePixel  = 0
counterBar.ZIndex           = 3
Instance.new("UICorner", counterBar).CornerRadius = UDim.new(0, 7)

local counterLbl = Instance.new("TextLabel", counterBar)
counterLbl.Size               = UDim2.new(1, -10, 1, 0)
counterLbl.Position           = UDim2.new(0, 8, 0, 0)
counterLbl.BackgroundTransparency = 1
counterLbl.TextColor3         = Color3.fromRGB(160, 180, 255)
counterLbl.Font               = Enum.Font.Gotham
counterLbl.TextSize           = 12
counterLbl.TextXAlignment     = Enum.TextXAlignment.Left
counterLbl.Text               = "Total: 0 RemoteEvent  |  0 RemoteFunction"
counterLbl.ZIndex             = 4

-- Scan button
local scanBtn = Instance.new("TextButton", frame)
scanBtn.Size             = UDim2.new(1, -16, 0, 32)
scanBtn.Position         = UDim2.new(0, 8, 0, 82)
scanBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 200)
scanBtn.TextColor3       = Color3.new(1, 1, 1)
scanBtn.Font             = Enum.Font.GothamBold
scanBtn.TextSize         = 13
scanBtn.Text             = "🔄  Scan Ulang"
scanBtn.AutoButtonColor  = false
scanBtn.BorderSizePixel  = 0
scanBtn.ZIndex           = 3
Instance.new("UICorner", scanBtn).CornerRadius = UDim.new(0, 8)

-- Scroll area
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size                = UDim2.new(1, -16, 1, -130)
scroll.Position            = UDim2.new(0, 8, 0, 122)
scroll.BackgroundColor3    = Color3.fromRGB(14, 14, 20)
scroll.BorderSizePixel     = 0
scroll.ScrollBarThickness  = 5
scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 120, 255)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize          = UDim2.new(0, 0, 0, 0)
scroll.ZIndex              = 3
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 7)

local layout = Instance.new("UIListLayout", scroll)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding   = UDim.new(0, 3)

local padInner = Instance.new("UIPadding", scroll)
padInner.PaddingLeft   = UDim.new(0, 6)
padInner.PaddingRight  = UDim.new(0, 6)
padInner.PaddingTop    = UDim.new(0, 6)
padInner.PaddingBottom = UDim.new(0, 6)

local hintLbl = Instance.new("TextLabel", frame)
hintLbl.Size               = UDim2.new(1, -16, 0, 14)
hintLbl.Position           = UDim2.new(0, 8, 1, -16)
hintLbl.BackgroundTransparency = 1
hintLbl.TextColor3         = Color3.fromRGB(50, 50, 65)
hintLbl.Font               = Enum.Font.Gotham
hintLbl.TextSize           = 11
hintLbl.TextXAlignment     = Enum.TextXAlignment.Left
hintLbl.Text               = "RightCtrl = hide/show"
hintLbl.ZIndex             = 3

-- Toggle
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)

-- =============================================
-- Warna per tipe
-- =============================================
local typeColor = {
    RemoteEvent    = Color3.fromRGB(80,  180, 255),
    RemoteFunction = Color3.fromRGB(255, 160, 60),
    BindableEvent  = Color3.fromRGB(120, 255, 140),
    BindableFunction = Color3.fromRGB(200, 120, 255),
}
local typeIcon = {
    RemoteEvent      = "🔵",
    RemoteFunction   = "🟠",
    BindableEvent    = "🟢",
    BindableFunction = "🟣",
}

-- =============================================
-- Buat row per item
-- =============================================
local logLines = {}
local lineOrder = 0

local function clearLog()
    for _, l in ipairs(logLines) do
        pcall(function() l:Destroy() end)
    end
    logLines  = {}
    lineOrder = 0
end

local function addHeader(text, color)
    lineOrder += 1
    local lbl = Instance.new("TextLabel", scroll)
    lbl.Size               = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundColor3   = Color3.fromRGB(22, 22, 32)
    lbl.TextColor3         = color
    lbl.Font               = Enum.Font.GothamBold
    lbl.TextSize           = 12
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.Text               = "  " .. text
    lbl.LayoutOrder        = lineOrder
    lbl.ZIndex             = 4
    lbl.BorderSizePixel    = 0
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 5)
    table.insert(logLines, lbl)
end

local function addRow(icon, name, fullPath, color)
    lineOrder += 1
    local row = Instance.new("Frame", scroll)
    row.Size             = UDim2.new(1, 0, 0, 36)
    row.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    row.BorderSizePixel  = 0
    row.LayoutOrder      = lineOrder
    row.ZIndex           = 4
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    -- Icon
    local iconLbl = Instance.new("TextLabel", row)
    iconLbl.Size               = UDim2.new(0, 28, 1, 0)
    iconLbl.Position           = UDim2.new(0, 4, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.TextColor3         = color
    iconLbl.Font               = Enum.Font.Gotham
    iconLbl.TextSize           = 16
    iconLbl.Text               = icon
    iconLbl.ZIndex             = 5

    -- Nama
    local nameLbl = Instance.new("TextLabel", row)
    nameLbl.Size               = UDim2.new(0.55, 0, 0, 18)
    nameLbl.Position           = UDim2.new(0, 34, 0, 2)
    nameLbl.BackgroundTransparency = 1
    nameLbl.TextColor3         = Color3.fromRGB(220, 220, 220)
    nameLbl.Font               = Enum.Font.GothamBold
    nameLbl.TextSize           = 12
    nameLbl.TextXAlignment     = Enum.TextXAlignment.Left
    nameLbl.TextTruncate       = Enum.TextTruncate.AtEnd
    nameLbl.Text               = name
    nameLbl.ZIndex             = 5

    -- Full path
    local pathLbl = Instance.new("TextLabel", row)
    pathLbl.Size               = UDim2.new(1, -38, 0, 14)
    pathLbl.Position           = UDim2.new(0, 34, 0, 20)
    pathLbl.BackgroundTransparency = 1
    pathLbl.TextColor3         = Color3.fromRGB(90, 90, 110)
    pathLbl.Font               = Enum.Font.Code
    pathLbl.TextSize           = 10
    pathLbl.TextXAlignment     = Enum.TextXAlignment.Left
    pathLbl.TextTruncate       = Enum.TextTruncate.AtEnd
    pathLbl.Text               = fullPath
    pathLbl.ZIndex             = 5

    table.insert(logLines, row)
end

local function addEmpty(text)
    lineOrder += 1
    local lbl = Instance.new("TextLabel", scroll)
    lbl.Size               = UDim2.new(1, 0, 0, 26)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3         = Color3.fromRGB(70, 70, 90)
    lbl.Font               = Enum.Font.Gotham
    lbl.TextSize           = 12
    lbl.Text               = text
    lbl.LayoutOrder        = lineOrder
    lbl.ZIndex             = 4
    table.insert(logLines, lbl)
end

-- =============================================
-- Scan
-- =============================================
local function doScan()
    clearLog()

    local counts = {
        RemoteEvent      = 0,
        RemoteFunction   = 0,
        BindableEvent    = 0,
        BindableFunction = 0,
    }

    local groups = {
        RemoteEvent      = {},
        RemoteFunction   = {},
        BindableEvent    = {},
        BindableFunction = {},
    }

    -- Rekursif ke seluruh ReplicatedStorage
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        local cn = obj.ClassName
        if groups[cn] then
            table.insert(groups[cn], obj)
            counts[cn] += 1
        end
    end

    -- Tampilkan per kategori
    local order = {"RemoteEvent","RemoteFunction","BindableEvent","BindableFunction"}
    for _, className in ipairs(order) do
        local list = groups[className]
        local col  = typeColor[className]
        local icon = typeIcon[className]

        addHeader(icon .. "  " .. className .. "  (" .. #list .. ")", col)

        if #list == 0 then
            addEmpty("    (tidak ada)")
        else
            -- Sort by name
            table.sort(list, function(a, b) return a.Name < b.Name end)
            for _, obj in ipairs(list) do
                addRow(icon, obj.Name, obj:GetFullName(), col)
            end
        end

        -- Spacer
        lineOrder += 1
        local sp = Instance.new("Frame", scroll)
        sp.Size             = UDim2.new(1, 0, 0, 4)
        sp.BackgroundTransparency = 1
        sp.LayoutOrder      = lineOrder
        table.insert(logLines, sp)
    end

    -- Update counter
    counterLbl.Text = string.format(
        "🔵 RemoteEvent: %d   🟠 RemoteFunction: %d   🟢 Bindable: %d",
        counts.RemoteEvent,
        counts.RemoteFunction,
        counts.BindableEvent + counts.BindableFunction
    )
end

-- Scan button
scanBtn.MouseButton1Click:Connect(function()
    scanBtn.BackgroundColor3 = Color3.fromRGB(20, 50, 150)
    scanBtn.Text = "⏳  Scanning..."
    task.wait(0.1)
    doScan()
    scanBtn.Text = "🔄  Scan Ulang"
    scanBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 200)
end)

-- Auto scan pertama kali
task.delay(1, doScan)
