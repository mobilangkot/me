local LP  = game:GetService("Players").LocalPlayer
local RS  = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local function isMatch(s)
    if not s then return false end
    s = string.lower(tostring(s))
    return s:find("detective") or s:find("evidence")
end

-- GUI
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "DebugScan"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size             = UDim2.new(0, 500, 0, 560)
frame.Position         = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local topBar = Instance.new("Frame", frame)
topBar.Size             = UDim2.new(1, 0, 0, 32)
topBar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
topBar.BorderSizePixel  = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)

local topLbl = Instance.new("TextLabel", topBar)
topLbl.Size               = UDim2.new(1, -10, 1, 0)
topLbl.Position           = UDim2.new(0, 10, 0, 0)
topLbl.BackgroundTransparency = 1
topLbl.TextColor3         = Color3.fromRGB(255, 255, 255)
topLbl.Font               = Enum.Font.GothamBold
topLbl.TextSize            = 12
topLbl.TextXAlignment     = Enum.TextXAlignment.Left
topLbl.Text               = "Detective / Evidence Debug Scanner"

local statusLbl = Instance.new("TextLabel", frame)
statusLbl.Size               = UDim2.new(1, -16, 0, 20)
statusLbl.Position           = UDim2.new(0, 8, 0, 36)
statusLbl.BackgroundTransparency = 1
statusLbl.TextColor3         = Color3.fromRGB(100, 200, 255)
statusLbl.Font               = Enum.Font.Gotham
statusLbl.TextSize            = 11
statusLbl.TextXAlignment     = Enum.TextXAlignment.Left
statusLbl.Text               = "Tekan Scan"

local function mkBtn(txt, px, pw, col)
    local b = Instance.new("TextButton", frame)
    b.Position         = UDim2.new(0, px, 0, 60)
    b.Size             = UDim2.new(0, pw, 0, 24)
    b.BackgroundColor3 = col
    b.TextColor3       = Color3.new(1,1,1)
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 11
    b.Text             = txt
    b.AutoButtonColor  = false
    b.BorderSizePixel  = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end

local btnScan  = mkBtn("SCAN",  8,   80, Color3.fromRGB(20, 80, 180))
local btnClear = mkBtn("CLEAR", 94,  70, Color3.fromRGB(140, 25, 25))

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Position            = UDim2.new(0, 8, 0, 90)
scroll.Size                = UDim2.new(1, -16, 1, -98)
scroll.BackgroundColor3    = Color3.fromRGB(8, 8, 12)
scroll.BorderSizePixel     = 0
scroll.ScrollBarThickness  = 4
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize          = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)

local list = Instance.new("UIListLayout", scroll)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Padding   = UDim.new(0, 1)

local lpad = Instance.new("UIPadding", scroll)
lpad.PaddingLeft  = UDim.new(0, 4)
lpad.PaddingTop   = UDim.new(0, 3)
lpad.PaddingRight = UDim.new(0, 4)

UIS.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)

-- Log
local lines = {}
local n     = 0

local function addLine(txt, col)
    n += 1
    local l = Instance.new("TextLabel", scroll)
    l.Size               = UDim2.new(1, 0, 0, 0)
    l.AutomaticSize      = Enum.AutomaticSize.Y
    l.BackgroundTransparency = 1
    l.TextColor3         = col or Color3.fromRGB(200, 200, 200)
    l.Font               = Enum.Font.Code
    l.TextSize           = 11
    l.TextWrapped        = true
    l.TextXAlignment     = Enum.TextXAlignment.Left
    l.Text               = txt
    l.LayoutOrder        = n
    task.defer(function() scroll.CanvasPosition = Vector2.new(0, 9e9) end)
    table.insert(lines, l)
    if #lines > 600 then table.remove(lines, 1):Destroy() end
end

local function hr(lbl)
    addLine("--- " .. (lbl or "") .. " " .. string.rep("-", math.max(0, 44 - #(lbl or ""))),
        Color3.fromRGB(30, 30, 45))
end

local function wipe()
    for _, l in ipairs(lines) do pcall(function() l:Destroy() end) end
    lines = {}
    n     = 0
end

-- Warna
local cMatch  = Color3.fromRGB(255, 80,  255)
local cAttr   = Color3.fromRGB(255, 130, 100)
local cVal    = Color3.fromRGB(255, 220, 80)
local cPath   = Color3.fromRGB(90,  90,  110)
local cProp   = Color3.fromRGB(180, 180, 200)
local cRemote = Color3.fromRGB(80,  200, 255)
local cPrompt = Color3.fromRGB(80,  255, 140)
local cGrey   = Color3.fromRGB(100, 100, 120)
local cHead   = Color3.fromRGB(255, 200, 60)

local VALUE_CLS = {
    StringValue=1, IntValue=1, NumberValue=1, BoolValue=1,
    Color3Value=1, Vector3Value=1, ObjectValue=1, CFrameValue=1
}

-- Print detail object
local function detail(obj, ind)
    ind = ind or "  "

    addLine(ind .. "path  : " .. obj:GetFullName(), cPath)
    addLine(ind .. "class : " .. obj.ClassName, cGrey)

    -- Attributes
    local ok1, attrs = pcall(function() return obj:GetAttributes() end)
    if ok1 then
        for k, v in pairs(attrs) do
            local c = isMatch(k) and cMatch or cAttr
            addLine(ind .. "[attr] " .. k .. " = " .. tostring(v), c)
        end
    end

    -- .Value
    if VALUE_CLS[obj.ClassName] then
        local ok2, v = pcall(function() return obj.Value end)
        if ok2 then
            local c = isMatch(tostring(v)) and cMatch or cVal
            addLine(ind .. "[.Value] = " .. tostring(v), c)
        end
    end

    -- ProximityPrompt
    if obj.ClassName == "ProximityPrompt" then
        local pp = {"ActionText","ObjectText","MaxActivationDistance","Enabled","HoldDuration","RequiresLineOfSight"}
        for _, p in ipairs(pp) do
            local ok3, v = pcall(function() return obj[p] end)
            if ok3 then
                local c = isMatch(tostring(v)) and cMatch or cPrompt
                addLine(ind .. "[pp] " .. p .. " = " .. tostring(v), c)
            end
        end
    end

    -- Remote/Bindable
    if obj.ClassName:find("Remote") or obj.ClassName:find("Bindable") then
        addLine(ind .. "[remote] " .. obj.ClassName, cRemote)
    end

    -- .Text
    local ok4, tv = pcall(function() return obj.Text end)
    if ok4 and type(tv) == "string" and #tv > 0 then
        local c = isMatch(tv) and cMatch or cProp
        addLine(ind .. "[.Text] = \"" .. tv:sub(1, 100) .. "\"", c)
    end

    -- .PlaceholderText
    local ok5, pv = pcall(function() return obj.PlaceholderText end)
    if ok5 and type(pv) == "string" and #pv > 0 then
        local c = isMatch(pv) and cMatch or cProp
        addLine(ind .. "[.Placeholder] = \"" .. pv:sub(1, 100) .. "\"", c)
    end

    -- Children data
    local ok6, ch = pcall(function() return obj:GetChildren() end)
    if ok6 then
        for _, child in ipairs(ch) do
            local cn    = child.ClassName
            local isData = VALUE_CLS[cn]
                or (cn:find("Remote") ~= nil)
                or (cn:find("Bindable") ~= nil)
                or cn == "ProximityPrompt"
                or cn == "Folder"

            if isData or isMatch(child.Name) then
                addLine(ind .. "  child [" .. cn .. "] " .. child.Name, cGrey)

                local ok7, ca = pcall(function() return child:GetAttributes() end)
                if ok7 then
                    for k, v in pairs(ca) do
                        local c = isMatch(k) and cMatch or cAttr
                        addLine(ind .. "    [attr] " .. k .. " = " .. tostring(v), c)
                    end
                end

                if VALUE_CLS[cn] then
                    local ok8, vv = pcall(function() return child.Value end)
                    if ok8 then
                        local c = isMatch(tostring(vv)) and cMatch or cVal
                        addLine(ind .. "    [.Value] = " .. tostring(vv), c)
                    end
                end

                local ok9, ct = pcall(function() return child.Text end)
                if ok9 and type(ct) == "string" and #ct > 0 then
                    local c = isMatch(ct) and cMatch or cProp
                    addLine(ind .. "    [.Text] = \"" .. ct:sub(1, 80) .. "\"", c)
                end
            end
        end
    end
end

-- Walk rekursif
local total = 0

local function walk(obj, depth, maxDepth)
    if depth > maxDepth then return end
    if not obj then return end

    local nameHit = isMatch(obj.Name)

    local textHit = false
    local ok1, tv = pcall(function() return obj.Text end)
    if ok1 and type(tv) == "string" then textHit = isMatch(tv) end

    local valHit = false
    local ok2, vv = pcall(function() return obj.Value end)
    if ok2 and type(vv) == "string" then valHit = isMatch(vv) end

    if nameHit or textHit or valHit then
        total += 1
        local tag = "[name]"
        if textHit then tag = "[text]" end
        if valHit  then tag = "[val]"  end
        if nameHit then tag = "[NAME]" end
        hr(tag .. " " .. obj.ClassName .. " : " .. obj.Name)
        detail(obj, "  ")
    end

    local ok3, ch = pcall(function() return obj:GetChildren() end)
    if ok3 then
        for _, c in ipairs(ch) do
            walk(c, depth + 1, maxDepth)
        end
    end
end

local function scanSource(label, root, depth)
    addLine("", cGrey)
    addLine("=== " .. label .. " ===", cHead)
    local before = total
    if root then walk(root, 0, depth) end
    local found = total - before
    if found == 0 then
        addLine("  (tidak ada match)", cGrey)
    else
        addLine("  >> " .. found .. " match", cMatch)
    end
    task.wait(0.05)
end

local function doScan()
    wipe()
    total = 0
    statusLbl.Text = "Scanning..."

    addLine("keyword: detective | evidence", cMatch)
    addLine("[NAME]=nama  [text]=teks  [val]=value", cGrey)
    hr()

    scanSource("WORKSPACE",          workspace,                          12)
    scanSource("REPLICATED STORAGE", RS,                                 12)
    scanSource("PLAYER GUI",         LP:FindFirstChild("PlayerGui"),     12)
    scanSource("BACKPACK",           LP:FindFirstChild("Backpack"),      8)
    scanSource("CHARACTER",          LP.Character,                       8)
    scanSource("PLAYER OBJECT",      LP,                                 6)

    pcall(function()
        scanSource("TEAMS", game:GetService("Teams"), 6)
    end)

    hr()
    local msg = "Selesai — " .. total .. " match"
    addLine(msg, cMatch)
    statusLbl.Text = msg
end

btnScan.MouseButton1Click:Connect(function()
    task.spawn(doScan)
end)

btnClear.MouseButton1Click:Connect(function()
    wipe()
    total = 0
    statusLbl.Text = "Cleared"
    addLine("cleared", cGrey)
end)

task.delay(1, function()
    task.spawn(doScan)
end)

addLine("Auto scan dalam 1 detik...", cMatch)
