local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")
local LP                = Players.LocalPlayer

local function matchKW(str)
    if not str then return false end
    local s = string.lower(tostring(str))
    return string.find(s, "detective") ~= nil
        or string.find(s, "evidence")  ~= nil
end

-- GUI
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "DetEvDebug"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size             = UDim2.new(0, 520, 0, 580)
frame.Position         = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local titleBar = Instance.new("Frame", frame)
titleBar.Size             = UDim2.new(1, 0, 0, 34)
titleBar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
titleBar.BorderSizePixel  = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size               = UDim2.new(1, -12, 1, 0)
titleLbl.Position           = UDim2.new(0, 12, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.TextColor3         = Color3.fromRGB(255, 255, 255)
titleLbl.Font               = Enum.Font.GothamBold
titleLbl.TextSize           = 13
titleLbl.TextXAlignment     = Enum.TextXAlignment.Left
titleLbl.Text               = "Detective / Evidence — Full Debug"

local countBar = Instance.new("Frame", frame)
countBar.Size             = UDim2.new(1, -16, 0, 22)
countBar.Position         = UDim2.new(0, 8, 0, 40)
countBar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
countBar.BorderSizePixel  = 0
Instance.new("UICorner", countBar).CornerRadius = UDim.new(0, 6)

local countLbl = Instance.new("TextLabel", countBar)
countLbl.Size               = UDim2.new(1, -10, 1, 0)
countLbl.Position           = UDim2.new(0, 8, 0, 0)
countLbl.BackgroundTransparency = 1
countLbl.TextColor3         = Color3.fromRGB(100, 200, 255)
countLbl.Font               = Enum.Font.Gotham
countLbl.TextSize           = 11
countLbl.TextXAlignment     = Enum.TextXAlignment.Left
countLbl.Text               = "Belum scan"

local function makeBtn(text, x, w, col)
    local b = Instance.new("TextButton", frame)
    b.Position         = UDim2.new(0, x, 0, 68)
    b.Size             = UDim2.new(0, w, 0, 26)
    b.BackgroundColor3 = col
    b.TextColor3       = Color3.new(1, 1, 1)
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 11
    b.Text             = text
    b.AutoButtonColor  = false
    b.BorderSizePixel  = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local btnScan  = makeBtn("Scan Semua", 8,   120, Color3.fromRGB(20, 80, 180))
local btnClear = makeBtn("Clear",      134, 70,  Color3.fromRGB(140, 25, 25))
local btnRescan= makeBtn("Rescan",     210, 70,  Color3.fromRGB(40, 100, 40))

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Position             = UDim2.new(0, 8, 0, 100)
scroll.Size                 = UDim2.new(1, -16, 1, -108)
scroll.BackgroundColor3     = Color3.fromRGB(8, 8, 12)
scroll.BorderSizePixel      = 0
scroll.ScrollBarThickness   = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 140, 255)
scroll.AutomaticCanvasSize  = Enum.AutomaticSize.Y
scroll.CanvasSize           = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 7)

local layout = Instance.new("UIListLayout", scroll)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding   = UDim.new(0, 1)

local scrollPad = Instance.new("UIPadding", scroll)
scrollPad.PaddingLeft  = UDim.new(0, 5)
scrollPad.PaddingTop   = UDim.new(0, 4)
scrollPad.PaddingRight = UDim.new(0, 5)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)

-- Log system
local logLines = {}
local order    = 0

local C = {
    header  = Color3.fromRGB(255, 200, 60),
    match   = Color3.fromRGB(255, 80,  255),
    remote  = Color3.fromRGB(80,  200, 255),
    prompt  = Color3.fromRGB(80,  255, 140),
    value   = Color3.fromRGB(255, 220, 80),
    attr    = Color3.fromRGB(255, 120, 100),
    prop    = Color3.fromRGB(180, 180, 200),
    path    = Color3.fromRGB(90,  90,  110),
    div     = Color3.fromRGB(28,  28,  42),
    grey    = Color3.fromRGB(100, 100, 120),
    white   = Color3.fromRGB(200, 200, 200),
}

local function log(text, color)
    order += 1
    local l = Instance.new("TextLabel", scroll)
    l.Size               = UDim2.new(1, -4, 0, 0)
    l.AutomaticSize      = Enum.AutomaticSize.Y
    l.BackgroundTransparency = 1
    l.TextColor3         = color or C.white
    l.Font               = Enum.Font.Code
    l.TextSize           = 11
    l.TextWrapped        = true
    l.TextXAlignment     = Enum.TextXAlignment.Left
    l.Text               = text
    l.LayoutOrder        = order
    task.defer(function()
        scroll.CanvasPosition = Vector2.new(0, math.huge)
    end)
    table.insert(logLines, l)
    if #logLines > 800 then
        table.remove(logLines, 1):Destroy()
    end
end

local function divider(text)
    local t = text or ""
    log("-- " .. t .. " " .. string.rep("-", math.max(0, 46 - #t)), C.div)
end

local function clearLog()
    for _, l in ipairs(logLines) do
        pcall(function() l:Destroy() end)
    end
    logLines = {}
    order    = 0
end

-- Value classes
local VALUE_CLASSES = {
    StringValue  = true,
    IntValue     = true,
    NumberValue  = true,
    BoolValue    = true,
    Color3Value  = true,
    Vector3Value = true,
    ObjectValue  = true,
    CFrameValue  = true,
}

-- Print detail satu object
local function printDetail(obj, indent)
    local ind = indent or "  "

    -- Full path
    log(ind .. "path: " .. obj:GetFullName(), C.path)
    log(ind .. "class: " .. obj.ClassName,    C.grey)

    -- Attributes
    local okA, attrs = pcall(function() return obj:GetAttributes() end)
    if okA then
        local hasAttr = false
        for k, v in pairs(attrs) do
            hasAttr = true
            local col = matchKW(k) and C.match or C.attr
            log(ind .. "[ATTR] " .. k .. " = " .. tostring(v), col)
        end
        if not hasAttr then
            log(ind .. "(no attributes)", C.grey)
        end
    end

    -- .Value untuk value objects
    if VALUE_CLASSES[obj.ClassName] then
        local okV, val = pcall(function() return obj.Value end)
        if okV then
            local col = matchKW(tostring(val)) and C.match or C.value
            log(ind .. "[VALUE] = " .. tostring(val), col)
        end
    end

    -- ProximityPrompt
    if obj.ClassName == "ProximityPrompt" then
        local props = {
            "ActionText", "ObjectText", "MaxActivationDistance",
            "Enabled", "HoldDuration", "RequiresLineOfSight"
        }
        for _, p in ipairs(props) do
            local ok2, v = pcall(function() return obj[p] end)
            if ok2 then
                local col = matchKW(tostring(v)) and C.match or C.prompt
                log(ind .. "[PP] " .. p .. " = " .. tostring(v), col)
            end
        end
    end

    -- Remote/Bindable
    if obj.ClassName:find("Remote") or obj.ClassName:find("Bindable") then
        log(ind .. "[REMOTE] " .. obj.ClassName, C.remote)
    end

    -- Text property
    local okT, textVal = pcall(function() return obj.Text end)
    if okT and type(textVal) == "string" and #textVal > 0 then
        local col = matchKW(textVal) and C.match or C.prop
        log(ind .. "[TEXT] = \"" .. textVal:sub(1, 120) .. "\"", col)
    end

    -- PlaceholderText
    local okPH, phVal = pcall(function() return obj.PlaceholderText end)
    if okPH and type(phVal) == "string" and #phVal > 0 then
        local col = matchKW(phVal) and C.match or C.prop
        log(ind .. "[PLACEHOLDER] = \"" .. phVal:sub(1, 120) .. "\"", col)
    end

    -- Children yang relevan
    local okC, children = pcall(function() return obj:GetChildren() end)
    if okC then
        for _, child in ipairs(children) do
            local cn = child.ClassName
            local isData = VALUE_CLASSES[cn]
                or cn:find("Remote") ~= nil
                or cn:find("Bindable") ~= nil
                or cn == "ProximityPrompt"
                or cn == "Folder"

            if isData or matchKW(child.Name) then
                log(ind .. "  child [" .. cn .. "] " .. child.Name, C.grey)

                -- Attribute child
                local okCA, cattrs = pcall(function() return child:GetAttributes() end)
                if okCA then
                    for k, v in pairs(cattrs) do
                        local col = matchKW(k) and C.match or C.attr
                        log(ind .. "    [ATTR] " .. k .. " = " .. tostring(v), col)
                    end
                end

                -- Value child
                if VALUE_CLASSES[cn] then
                    local okV2, val2 = pcall(function() return child.Value end)
                    if okV2 then
                        local col = matchKW(tostring(val2)) and C.match or C.value
                        log(ind .. "    [VALUE] = " .. tostring(val2), col)
                    end
                end

                -- Text child
                local okTC, tv = pcall(function() return child.Text end)
                if okTC and type(tv) == "string" and #tv > 0 then
                    local col = matchKW(tv) and C.match or C.prop
                    log(ind .. "    [TEXT] = \"" .. tv:sub(1, 80) .. "\"", col)
                end
            end
        end
    end
end

-- Deep scan
local totalFound = 0

local function deepScan(root, maxDepth)
    maxDepth = maxDepth or 12

    local function walk(obj, depth)
        if depth > maxDepth then return end
        if not obj then return end

        -- Cek semua kemungkinan match
        local nameMatch = matchKW(obj.Name)

        local textMatch = false
        local okT, tv = pcall(function() return obj.Text end)
        if okT and type(tv) == "string" then
            textMatch = matchKW(tv)
        end

        local valMatch = false
        local okV, vv = pcall(function() return obj.Value end)
        if okV and type(vv) == "string" then
            valMatch = matchKW(vv)
        end

        if nameMatch or textMatch or valMatch then
            totalFound += 1
            local tag = "(*)"
            if nameMatch  then tag = "[NAME]"  end
            if textMatch  then tag = "[TEXT]"  end
            if valMatch   then tag = "[VALUE]" end
            if nameMatch and (textMatch or valMatch) then tag = "[NAME+]" end

            divider(tag .. " " .. obj.ClassName .. " : " .. obj.Name)
            printDetail(obj, "  ")
        end

        -- Rekursif
        local okC, ch = pcall(function() return obj:GetChildren() end)
        if okC then
            for _, c in ipairs(ch) do
                walk(c, depth + 1)
            end
        end
    end

    walk(root, 0)
end

-- Scan semua sumber
local function doScanAll()
    clearLog()
    totalFound = 0
    countLbl.Text = "Scanning..."

    log("Keyword: detective | evidence", C.match)
    log("[NAME]=nama match  [TEXT]=teks match  [VALUE]=value match", C.grey)
    divider()

    local sources = {
        {
            label = "WORKSPACE",
            fn    = function() deepScan(workspace, 12) end
        },
        {
            label = "REPLICATED STORAGE",
            fn    = function() deepScan(ReplicatedStorage, 12) end
        },
        {
            label = "PLAYER GUI",
            fn    = function()
                local pg = LP:FindFirstChild("PlayerGui")
                if pg then deepScan(pg, 12) end
            end
        },
        {
            label = "BACKPACK",
            fn    = function()
                local bp = LP:FindFirstChild("Backpack")
                if bp then deepScan(bp, 8) end
            end
        },
        {
            label = "CHARACTER",
            fn    = function()
                local char = LP.Character
                if char then deepScan(char, 8) end
            end
        },
        {
            label = "PLAYER OBJECT",
            fn    = function() deepScan(LP, 6) end
        },
        {
            label = "TEAMS",
            fn    = function()
                pcall(function()
                    local tm = game:GetService("Teams")
                    if tm then deepScan(tm, 6) end
                end)
            end
        },
    }

    for _, src in ipairs(sources) do
        log("", C.grey)
        log("=== " .. src.label .. " ===", C.header)
        local before = totalFound
        src.fn()
        local found = totalFound - before
        if found == 0 then
            log("  (tidak ada match)", C.grey)
        else
            log("  match: " .. found, C.match)
        end
        task.wait(0.05) -- biar tidak freeze
    end

    divider()
    local msg = "Selesai — total " .. totalFound .. " match"
    log(msg, C.match)
    countLbl.Text = msg
end

-- Buttons
btnScan.MouseButton1Click:Connect(function()
    task.spawn(doScanAll)
end)

btnRescan.MouseButton1Click:Connect(function()
    task.spawn(doScanAll)
end)

btnClear.MouseButton1Click:Connect(function()
    clearLog()
    totalFound = 0
    countLbl.Text = "Log dibersihkan"
    log("cleared", C.grey)
end)

-- Auto scan
task.delay(1, function()
    task.spawn(doScanAll)
end)

log("Auto scan dalam 1 detik...", C.match)
