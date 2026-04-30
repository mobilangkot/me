local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")

local LP = Players.LocalPlayer

local function matchKW(str)
    if not str then return false end
    local s = string.lower(str)
    return string.find(s, "detective") ~= nil
        or string.find(s, "evidence")  ~= nil
end

local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "DetEvDebug"; gui.ResetOnSpawn = false

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
titleLbl.Size            = UDim2.new(1, -12, 1, 0)
titleLbl.Position        = UDim2.new(0, 12, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.TextColor3      = Color3.fromRGB(255, 255, 255)
titleLbl.Font            = Enum.Font.GothamBold
titleLbl.TextSize        = 13
titleLbl.TextXAlignment  = Enum.TextXAlignment.Left
titleLbl.Text            = "🔍  Detective / Evidence — Full Debug"

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
    b.TextColor3       = Color3.new(1,1,1)
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 11
    b.Text             = text
    b.AutoButtonColor  = false
    b.BorderSizePixel  = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local btnScan  = makeBtn("🔍 Scan Semua", 8,   130, Color3.fromRGB(20,80,180))
local btnClear = makeBtn("🗑 Clear",       144, 80,  Color3.fromRGB(140,25,25))
local btnRescan= makeBtn("🔄 Rescan",      230, 80,  Color3.fromRGB(60,100,40))

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Position            = UDim2.new(0, 8, 0, 100)
scroll.Size                = UDim2.new(1, -16, 1, -108)
scroll.BackgroundColor3    = Color3.fromRGB(8, 8, 12)
scroll.BorderSizePixel     = 0
scroll.ScrollBarThickness  = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(80,140,255)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize          = UDim2.new(0,0,0,0)
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 7)

local layout = Instance.new("UIListLayout", scroll)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding   = UDim.new(0, 1)

local pad = Instance.new("UIPadding", scroll)
pad.PaddingLeft  = UDim.new(0, 5)
pad.PaddingTop   = UDim.new(0, 4)
pad.PaddingRight = UDim.new(0, 5)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)

local logLines = {}
local order    = 0

local C = {
    header   = Color3.fromRGB(255, 200, 60),
    match    = Color3.fromRGB(255, 80,  255),
    remote   = Color3.fromRGB(80,  200, 255),
    bindable = Color3.fromRGB(180, 100, 255),
    prompt   = Color3.fromRGB(80,  255, 140),
    value    = Color3.fromRGB(255, 220, 80),
    attr     = Color3.fromRGB(255, 120, 100),
    prop     = Color3.fromRGB(180, 180, 200),
    path     = Color3.fromRGB(90,  90,  110),
    div      = Color3.fromRGB(28,  28,  42),
    grey     = Color3.fromRGB(100, 100, 120),
    text     = Color3.fromRGB(200, 200, 200),
}

local function log(text, color)
    order += 1
    local l = Instance.new("TextLabel", scroll)
    l.Size               = UDim2.new(1, -4, 0, 0)
    l.AutomaticSize      = Enum.AutomaticSize.Y
    l.BackgroundTransparency = 1
    l.TextColor3         = color or C.text
    l.Font               = Enum.Font.Code
    l.TextSize           = 11
    l.TextWrapped        = true
    l.TextXAlignment     = Enum.TextXAlignment.Left
    l.Text               = text
    l.LayoutOrder        = order
    task.defer(function() scroll.CanvasPosition = Vector2.new(0, math.huge) end)
    table.insert(logLines, l)
    if #logLines > 800 then table.remove(logLines, 1):Destroy() end
end

local function div(text)
    local t = text or ""
    log("── " .. t .. " " .. string.rep("─", math.max(0, 50 - #t)), C.div)
end

local function clearLog()
    for _, l in ipairs(logLines) do pcall(function() l:Destroy() end) end
    logLines = {}; order = 0
end

local valueClasses = {
    "StringValue","IntValue","NumberValue","BoolValue",
    "Color3Value","Vector3Value","ObjectValue","CFrameValue"
}

local function printAllProps(obj, indent)
    local ind = indent or "  "

    log(ind .. "📍 " .. obj:GetFullName(), C.path)
    log(ind .. "class: " .. obj.ClassName, C.grey)

    -- Attributes
    local okA, attrs = pcall(function() return obj:GetAttributes() end)
    if okA then
        local any = false
        for k, v in pairs(attrs) do
            any = true
            log(ind .. "🔴 attr  " .. k .. " = " .. tostring(v), C.attr)
        end
        if not any then log(ind .. "(attributes kosong)", C.grey) end
    end

    -- .Value
    for _, vc in ipairs(valueClasses) do
        if obj.ClassName == vc then
            local okV, val = pcall(function() return obj.Value end)
            if okV then
                log(ind .. "🟡 .Value = " .. tostring(val), C.value)
            end
        end
    end

    -- ProximityPrompt
    if obj.ClassName == "ProximityPrompt" then
        local ppProps = {
            "ActionText","ObjectText","MaxActivationDistance",
            "Enabled","HoldDuration","RequiresLineOfSight"
        }
        for _, p in ipairs(ppProps) do
            local ok2, v = pcall(function() return obj[p] end)
            if ok2 then
                log(ind .. "🟢 " .. p .. " = " .. tostring(v), C.prompt)
            end
        end
    end

    -- Remote
    if obj.ClassName:find("Remote") or obj.ClassName:find("Bindable") then
        local col = obj.ClassName:find("Remote") and C.remote or C.bindable
        log(ind .. "📡 " .. obj.ClassName .. " → " .. obj:GetFullName(), col)
    end

    -- Text props
    local textProps = {"Text", "PlaceholderText"}
    for _, p in ipairs(textProps) do
        local ok3, v = pcall(function() return obj[p] end)
        if ok3 and type(v) == "string" and #v > 0 then
            local col = matchKW(v) and C.match or C.prop
            local tag = matchKW(v) and "⭐ " or "  "
            log(ind .. tag .. "." .. p .. ' = "' .. v:sub(1, 100) .. '"', col)
        end
    end

    -- Children data
    local okC, children = pcall(function() return obj:GetChildren() end)
    if okC then
        for _, child in ipairs(children) do
            local cn = child.ClassName
            local isData = false
            for _, vc in ipairs(valueClasses) do
                if cn == vc then isData = true; break end
            end
            if isData or cn:find("Remote") or cn:find("Bindable")
            or cn == "ProximityPrompt" or matchKW(child.Name) then
                log(ind .. "  └─ [" .. cn .. "] " .. child.Name, C.grey)

                local okCA, cattrs = pcall(function() return child:GetAttributes() end)
                if okCA then
                    for k, v in pairs(cattrs) do
                        log(ind .. "      🔴 " .. k .. " = " .. tostring(v), C.attr)
                    end
                end

                for _, vc in ipairs(valueClasses) do
                    if child.ClassName == vc then
                        local okV2, val2 = pcall(function() return child.Value end)
                        if okV2 then
                            log(ind .. "      🟡 .Value = " .. tostring(val2), C.value)
                        end
                    end
                end

                local okT2, tv = pcall(function() return child.Text end)
                if okT2 and type(tv) == "string" and #tv > 0 then
                    local col2 = matchKW(tv) and C.match or C.prop
                    log(ind .. '      .Text = "' .. tv:sub(1,80) .. '"', col2)
                end
            end
        end
    end
end

local totalFound = 0

local function deepScan(root, maxDepth)
    maxDepth = maxDepth or 15

    local function walk(obj, depth)
        if depth > maxDepth then return end
        if not obj then return end

        local nameMatch = matchKW(obj.Name)

        local textMatch = false
        local okT, textVal = pcall(function() return obj.Text end)
        if okT and type(textVal) == "string" then
            textMatch = matchKW(textVal)
        end

        local valMatch = false
        local okVV, valVal = pcall(function() return obj.Value end)
        if okVV and type(valVal) == "string" then
            valMatch = matchKW(valVal)
        end

        if nameMatch or textMatch or valMatch then
            totalFound += 1
            local tag = nameMatch and "⭐" or (textMatch and "📝" or "💾")
            div(tag .. " [" .. obj.ClassName .. "]  " .. obj.Name)
            printAllProps(obj, "  ")
        end

        local okC, ch = pcall(function() return obj:GetChildren() end)
        if okC then
            for _, c in ipairs(ch) do
                walk(c, depth + 1)
            end
        end
    end

    walk(root, 0)
end

local function doScanAll()
    clearLog()
    totalFound = 0
    countLbl.Text = "⏳ Scanning..."
    log("🔍 Keyword: detective | evidence", C.match)
    log("⭐=nama  📝=teks  💾=value", C.grey)
    div()

    local sources = {
        { name = "WORKSPACE",          fn = function() deepScan(workspace, 12) end },
        { name = "REPLICATED STORAGE", fn = function() deepScan(ReplicatedStorage, 12) end },
        { name = "PLAYER GUI",         fn = function()
            local pg = LP:FindFirstChild("PlayerGui")
            if pg then deepScan(pg, 12) end
        end },
        { name = "BACKPACK",           fn = function()
            local bp = LP:FindFirstChild("Backpack")
            if bp then deepScan(bp, 8) end
        end },
        { name = "CHARACTER",          fn = function()
            local char = LP.Character
            if char then deepScan(char, 8) end
        end },
        { name = "PLAYER OBJECT",      fn = function() deepScan(LP, 8) end },
        { name = "TEAMS",              fn = function()
            pcall(function()
                local tm = game:GetService("Teams")
                if tm then deepScan(tm, 6) end
            end)
        end },
    }

    for _, src in ipairs(sources) do
        log("", C.grey)
        log("═══ " .. src.name .. " ═══", C.header)
        local before = totalFound
        src.fn()
        local found = totalFound - before
        if found == 0 then
            log("  (tidak ada match)", C.grey)
        end
    end

    div()
    local msg = "✅ Selesai — " .. totalFound .. " match ditemukan"
    log(msg, C.match)
    countLbl.Text = msg
end

btnScan.MouseButton1Click:Connect(function()  task.spawn(doScanAll) end)
btnRescan.MouseButton1Click:Connect(function() task.spawn(doScanAll) end)
btnClear.MouseButton1Click:Connect(function()
    clearLog(); totalFound = 0
    countLbl.Text = "Log dibersihkan"
    log("🗑 cleared", C.grey)
end)

task.delay(1, function() task.spawn(doScanAll) end)
log("🟢 Auto scan dalam 1 detik...", C.match)
