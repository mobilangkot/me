-- Remote Scanner: Detective & Evidence
-- Tampilkan semua remote yang mengandung kata "detective" atau "evidence"

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- ================================================================
--  GUI
-- ================================================================
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "RemoteScanner"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 500)
frame.Position = UDim2.new(0.5, -210, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(40, 40, 55)
stroke.Thickness = 1

-- Header
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 38)
header.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)
-- patch bawah header biar tidak ada gap
local patch = Instance.new("Frame", header)
patch.Size = UDim2.new(1,0,0.5,0); patch.Position = UDim2.new(0,0,0.5,0)
patch.BackgroundColor3 = Color3.fromRGB(18,18,26); patch.BorderSizePixel = 0

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🔍  Remote Scanner — detective / evidence"
title.TextColor3 = Color3.fromRGB(210, 210, 210)
title.Font = Enum.Font.GothamBold
title.TextSize = 11
title.TextXAlignment = Enum.TextXAlignment.Left

-- Close button
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -30, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 15)
closeBtn.TextColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.Text = "✕"
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Counter label
local counterLbl = Instance.new("TextLabel", frame)
counterLbl.Size = UDim2.new(1, -16, 0, 18)
counterLbl.Position = UDim2.new(0, 8, 0, 42)
counterLbl.BackgroundTransparency = 1
counterLbl.Text = "Ditemukan: 0 remote"
counterLbl.TextColor3 = Color3.fromRGB(100, 200, 140)
counterLbl.Font = Enum.Font.GothamBold
counterLbl.TextSize = 10
counterLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Scan button
local scanBtn = Instance.new("TextButton", frame)
scanBtn.Size = UDim2.new(1, -16, 0, 28)
scanBtn.Position = UDim2.new(0, 8, 0, 464)
scanBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
scanBtn.TextColor3 = Color3.fromRGB(120, 160, 220)
scanBtn.Font = Enum.Font.GothamBold
scanBtn.TextSize = 11
scanBtn.Text = "🔄  Scan Ulang"
scanBtn.BorderSizePixel = 0
scanBtn.AutoButtonColor = false
Instance.new("UICorner", scanBtn).CornerRadius = UDim.new(0, 8)
local scanStroke = Instance.new("UIStroke", scanBtn)
scanStroke.Color = Color3.fromRGB(40, 40, 60)
scanStroke.Thickness = 1

-- Log scroll area
local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1, -16, 0, 400)
scrollFrame.Position = UDim2.new(0, 8, 0, 62)
scrollFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 70)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", scrollFrame).CornerRadius = UDim.new(0, 6)

local listLayout = Instance.new("UIListLayout", scrollFrame)
listLayout.Padding = UDim.new(0, 2)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local padding = Instance.new("UIPadding", scrollFrame)
padding.PaddingLeft = UDim.new(0, 6)
padding.PaddingTop = UDim.new(0, 4)
padding.PaddingRight = UDim.new(0, 6)

-- ================================================================
--  LOG HELPERS
-- ================================================================
local logCount = 0

local function clearLog()
    for _, c in ipairs(scrollFrame:GetChildren()) do
        if c:IsA("TextLabel") then c:Destroy() end
    end
    logCount = 0
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
end

-- type: "found_remote" | "found_other" | "header" | "info" | "none"
local typeColors = {
    found_remote = Color3.fromRGB(100, 220, 140),  -- hijau  = RemoteEvent/Function
    found_other  = Color3.fromRGB(180, 150, 255),  -- ungu   = Instance lain
    header       = Color3.fromRGB(120, 160, 220),  -- biru   = section header
    info         = Color3.fromRGB(90, 90, 110),    -- abu    = info
    none         = Color3.fromRGB(200, 80, 80),    -- merah  = tidak ada
}

local function addLog(text, logType)
    logCount += 1
    local lbl = Instance.new("TextLabel", scrollFrame)
    lbl.Size = UDim2.new(1, -4, 0, 0)
    lbl.AutomaticSize = Enum.AutomaticSize.Y
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = typeColors[logType] or typeColors.info
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.RichText = false
    lbl.LayoutOrder = logCount

    -- Update canvas height
    task.defer(function()
        local h = listLayout.AbsoluteContentSize.Y + 10
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, h)
        scrollFrame.CanvasPosition = Vector2.new(0, h)
    end)
end

-- ================================================================
--  SCANNER
-- ================================================================
local KEYWORDS = { "detective", "evidence" }

local function containsKeyword(name)
    local lower = string.lower(name)
    for _, kw in ipairs(KEYWORDS) do
        if string.find(lower, kw) then return true, kw end
    end
    return false, nil
end

local function getClassName(obj)
    local ok, cn = pcall(function() return obj.ClassName end)
    return ok and cn or "Unknown"
end

local function getFullPath(obj)
    local parts = {}
    local cur = obj
    while cur and cur ~= game do
        table.insert(parts, 1, cur.Name)
        local ok, parent = pcall(function() return cur.Parent end)
        if not ok or parent == nil then break end
        cur = parent
    end
    return table.concat(parts, " › ")
end

local function scan()
    clearLog()
    local found = 0
    local scanned = 0

    addLog("▸ Mulai scan seluruh game...", "header")
    addLog("  Keywords: detective, evidence", "info")
    addLog(string.rep("─", 52), "info")

    -- Tempat-tempat yang dicari
    local roots = {
        game:GetService("ReplicatedStorage"),
        game:GetService("ReplicatedFirst"),
        workspace,
        game:GetService("ServerScriptService"), -- mungkin tidak accessible, pcall aman
        game:GetService("Players"),
        game:GetService("Lighting"),
        game:GetService("StarterGui"),
        game:GetService("StarterPack"),
        game:GetService("StarterPlayer"),
        game:GetService("SoundService"),
        game:GetService("Chat"),
        game:GetService("LocalizationService"),
        game:GetService("TestService"),
    }

    for _, root in ipairs(roots) do
        local ok, descendants = pcall(function() return root:GetDescendants() end)
        if not ok then continue end

        local sectionPrinted = false

        for _, obj in ipairs(descendants) do
            scanned += 1
            local nameOk, objName = pcall(function() return obj.Name end)
            if not nameOk then continue end

            local has, matchedKw = containsKeyword(objName)
            if not has then continue end

            -- Print section header sekali per root
            if not sectionPrinted then
                addLog("", "info")
                addLog("📁 " .. root.Name, "header")
                sectionPrinted = true
            end

            found += 1
            local cn = getClassName(obj)
            local path = getFullPath(obj)

            -- Tentukan icon dan type
            local icon = "◦"
            local logType = "found_other"
            if cn == "RemoteEvent" then
                icon = "📡"; logType = "found_remote"
            elseif cn == "RemoteFunction" then
                icon = "📞"; logType = "found_remote"
            elseif cn == "BindableEvent" then
                icon = "🔔"; logType = "found_other"
            elseif cn == "BindableFunction" then
                icon = "🔁"; logType = "found_other"
            elseif cn == "Folder" or cn == "Model" then
                icon = "📂"; logType = "found_other"
            elseif cn == "Script" or cn == "LocalScript" or cn == "ModuleScript" then
                icon = "📜"; logType = "found_other"
            end

            addLog(string.format("  %s [%s] %s", icon, cn, objName), logType)
            addLog(string.format("     Path: %s", path), "info")
        end
    end

    addLog("", "info")
    addLog(string.rep("─", 52), "info")

    if found == 0 then
        addLog("⚠ Tidak ada yang ditemukan.", "none")
    else
        addLog(string.format("✅ Total ditemukan: %d item (scan %d obj)", found, scanned), "header")
    end

    counterLbl.Text = string.format("Ditemukan: %d remote/instance", found)
end

-- ================================================================
--  BIND
-- ================================================================
scanBtn.MouseButton1Click:Connect(function()
    scanBtn.Text = "⏳ Scanning..."
    task.wait(0.05)
    scan()
    scanBtn.Text = "🔄  Scan Ulang"
end)

-- Auto scan saat pertama kali
task.spawn(function()
    task.wait(0.5)
    scan()
end)
