local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")

local LP = Players.LocalPlayer

local keywords = {"detective", "evidence", "deposit", "lobby", "facility", "collect", "badge", "reward", "case"}

local function matchKeyword(str)
    if not str then return false end
    local s = string.lower(str)
    for _, kw in ipairs(keywords) do
        if string.find(s, kw) then return true end
    end
    return false
end

-- =============================================
-- GUI
-- =============================================
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "DebugScanner"; gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size             = UDim2.new(0, 500, 0, 580)
frame.Position         = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local titleBar = Instance.new("Frame", frame)
titleBar.Size             = UDim2.new(1, 0, 0, 36)
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
titleLbl.Text            = "🔍  Detective / Evidence Debug Scanner"

-- Counter
local countBar = Instance.new("Frame", frame)
countBar.Size             = UDim2.new(1, -16, 0, 24)
countBar.Position         = UDim2.new(0, 8, 0, 42)
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

-- Buttons row
local function makeBtn(text, x, w, col)
    local b = Instance.new("TextButton", frame)
    b.Position         = UDim2.new(0, x, 0, 72)
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

local btnScanAll   = makeBtn("🔍 Scan Semua",     8,   110, Color3.fromRGB(20,80,180))
local btnScanWS    = makeBtn("🌐 Workspace",       124, 95,  Color3.fromRGB(30,100,50))
local btnScanRS    = makeBtn("📦 Replicated",      225, 100, Color3.fromRGB(100,50,150))
local btnScanRemote= makeBtn("📡 Remote Only",     331, 100, Color3.fromRGB(160,80,10))
local btnClear     = makeBtn("🗑 Clear",            437, 60,  Color3.fromRGB(140,25,25))

-- Scroll log
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Position            = UDim2.new(0, 8, 0, 105)
scroll.Size                = UDim2.new(1, -16, 1, -113)
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

-- =============================================
-- Log
-- =============================================
local logLines = {}
local order    = 0

local C = {
    white    = Color3.fromRGB(220, 220, 220),
    grey     = Color3.fromRGB(100, 100, 120),
    div      = Color3.fromRGB(28,  28,  42),
    -- type colors
    remote   = Color3.fromRGB(80,  200, 255),  -- RemoteEvent/Function
    bindable = Color3.fromRGB(180, 100, 255),  -- BindableEvent/Function
    folder   = Color3.fromRGB(255, 180, 50),   -- Folder / Model
    prompt   = Color3.fromRGB(80,  255, 140),  -- ProximityPrompt
    value    = Color3.fromRGB(255, 220, 80),   -- StringValue dll
    attr     = Color3.fromRGB(255, 120, 120),  -- Attribute
    script   = Color3.fromRGB(150, 150, 170),  -- Script
    match    = Color3.fromRGB(255, 80,  255),  -- keyword match (highlight)
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
    task.defer(function() scroll.CanvasPosition = Vector2.new(0, math.huge) end)
    table.insert(logLines, l)
    if #logLines > 600 then table.remove(logLines, 1):Destroy() end
end

local function div(text)
    log("── " .. (text or "") .. " " .. string.rep("─", math.max(0, 44 - #(text or ""))), C.div)
end

local function clearLog()
    for _, l in ipairs(logLines) do pcall(function() l:Destroy() end) end
    logLines = {}
    order    = 0
end

-- =============================================
-- Determine color by class
-- =============================================
local function classColor(className)
    local cn = string.lower(className)
    if string.find(cn, "remoteevent") or string.find(cn, "remotefunction") then return C.remote end
    if string.find(cn, "bindable") then return C.bindable end
    if string.find(cn, "folder") or string.find(cn, "model") then return C.folder end
    if string.find(cn, "proximityprompt") then return C.prompt end
    if string.find(cn, "value") then return C.value end
    if string.find(cn, "script") then return C.script end
    return C.white
end

-- =============================================
-- Deep scan sebuah object
-- =============================================
local totalFound = 0

local function scanObject(obj, depth, source)
    if depth > 12 then return end
    local indent = string.rep("  ", depth)
    local cn     = obj.ClassName
    local name   = obj.Name
    local nameMatch = matchKeyword(name)

    -- Tentukan apakah perlu di-log
    local shouldLog = nameMatch

    -- Selalu log: Remote, Bindable, ProximityPrompt, Script
    local important = cn:find("Remote") or cn:find("Bindable")
                   or cn == "ProximityPrompt"
                   or cn:find("Script")
    if important and matchKeyword(name) then
        shouldLog = true
    end

    -- Log object yang match
    if shouldLog then
        totalFound += 1
        local col = nameMatch and C.match or classColor(cn)
        local tag = nameMatch and "⭐" or "  "
        log(string.format("%s%s [%s]  %s", indent, tag, cn, name), col)

        -- Attributes
        local ok, attrs = pcall(function() return obj:GetAttributes() end)
        if ok then
            for k, v in pairs(attrs) do
                log(string.format("%s      attr  %s = %s", indent, k, tostring(v)), C.attr)
            end
        end

        -- ProximityPrompt detail
        if cn == "ProximityPrompt" then
            local props = {"ActionText","ObjectText","MaxActivationDistance","Enabled","HoldDuration"}
            for _, p in ipairs(props) do
                local ok2, val = pcall(function() return obj[p] end)
                if ok2 then
                    log(string.format("%s      %s = %s", indent, p, tostring(val)), C.prompt)
                end
            end
        end

        -- Value objects
        if cn:find("Value") and cn ~= "LocalizationTable" then
            local ok3, val = pcall(function() return obj.Value end)
            if ok3 then
                log(string.format("%s      .Value = %s", indent, tostring(val)), C.value)
            end
        end

        -- Remote detail
        if cn:find("Remote") or cn:find("Bindable") then
            log(string.format("%s      path: %s", indent, obj:GetFullName()), C.grey)
        end
    end

    -- Rekursif ke children
    local ok4, children = pcall(function() return obj:GetChildren() end)
    if ok4 then
        for _, child in ipairs(children) do
            scanObject(child, depth + 1, source)
        end
    end
end

-- =============================================
-- Scan khusus remote saja
-- =============================================
local function scanRemotesOnly(root, sourceName)
    div("Remote scan: " .. sourceName)
    local count = 0
    local function walk(obj, depth)
        if depth > 15 then return end
        local cn = obj.ClassName
        if cn:find("Remote") or cn:find("Bindable") then
            count += 1
            local col = classColor(cn)
            log(string.format("[%s]  %s", cn, obj:GetFullName()), col)
            -- Attributes
            local ok, attrs = pcall(function() return obj:GetAttributes() end)
            if ok then
                for k, v in pairs(attrs) do
                    log(string.format("  attr  %s = %s", k, tostring(v)), C.attr)
                end
            end
        end
        local ok2, children = pcall(function() return obj:GetChildren() end)
        if ok2 then
            for _, c in ipairs(children) do walk(c, depth + 1) end
        end
    end
    walk(root, 0)
    log("Total remote/bindable di " .. sourceName .. ": " .. count, C.remote)
    return count
end

-- =============================================
-- Main scan functions
-- =============================================
local function doScanWorkspace()
    totalFound = 0
    div("WORKSPACE — keyword scan")
    scanObject(workspace, 0, "Workspace")
    log("✅ WS done — " .. totalFound .. " match", C.match)
end

local function doScanRS()
    totalFound = 0
    div("REPLICATED STORAGE — keyword scan")
    scanObject(ReplicatedStorage, 0, "ReplicatedStorage")
    log("✅ RS done — " .. totalFound .. " match", C.match)
end

local function doScanRemoteOnly()
    div("ALL REMOTES — full scan")
    local total = 0
    total += scanRemotesOnly(workspace,          "Workspace")
    total += scanRemotesOnly(ReplicatedStorage,  "ReplicatedStorage")
    -- Coba lokasi lain
    pcall(function() total += scanRemotesOnly(game:GetService("Players"), "Players") end)
    pcall(function() total += scanRemotesOnly(game:GetService("StarterGui"), "StarterGui") end)
    log("✅ Remote scan done — total: " .. total, C.remote)
end

local function doScanAll()
    clearLog()
    totalFound = 0
    log("🔍 Full scan dimulai...", C.match)

    -- Workspace
    div("WORKSPACE")
    local wsCount = 0
    local function walkWS(obj, depth)
        if depth > 10 then return end
        local nameMatch = matchKeyword(obj.Name)
        local cn = obj.ClassName
        local importantClass = cn:find("Remote") or cn:find("Bindable")
                            or cn == "ProximityPrompt"

        if nameMatch or importantClass then
            local col = nameMatch and C.match or classColor(cn)
            local tag = nameMatch and "⭐ " or ""
            log(tag .. "[" .. cn .. "]  " .. obj:GetFullName(), col)
            wsCount += 1; totalFound += 1

            -- Detail ProximityPrompt
            if cn == "ProximityPrompt" then
                local props = {"ActionText","ObjectText","MaxActivationDistance","Enabled"}
                for _, p in ipairs(props) do
                    local ok, v = pcall(function() return obj[p] end)
                    if ok then log("    " .. p .. " = " .. tostring(v), C.prompt) end
                end
            end

            -- Attributes
            local ok, attrs = pcall(function() return obj:GetAttributes() end)
            if ok then
                for k, v in pairs(attrs) do
                    log("    attr  " .. k .. " = " .. tostring(v), C.attr)
                end
            end

            -- Remote path
            if cn:find("Remote") or cn:find("Bindable") then
                log("    path: " .. obj:GetFullName(), C.grey)
            end
        end

        local ok2, ch = pcall(function() return obj:GetChildren() end)
        if ok2 then
            for _, c in ipairs(ch) do walkWS(c, depth + 1) end
        end
    end
    walkWS(workspace, 0)
    log("WS match: " .. wsCount, C.grey)

    -- ReplicatedStorage
    div("REPLICATED STORAGE")
    local rsCount = 0
    local function walkRS(obj, depth)
        if depth > 10 then return end
        local nameMatch = matchKeyword(obj.Name)
        local cn = obj.ClassName
        local importantClass = cn:find("Remote") or cn:find("Bindable")

        if nameMatch or importantClass then
            local col = nameMatch and C.match or classColor(cn)
            local tag = nameMatch and "⭐ " or ""
            log(tag .. "[" .. cn .. "]  " .. obj:GetFullName(), col)
            rsCount += 1; totalFound += 1

            local ok, attrs = pcall(function() return obj:GetAttributes() end)
            if ok then
                for k, v in pairs(attrs) do
                    log("    attr  " .. k .. " = " .. tostring(v), C.attr)
                end
            end
        end

        local ok2, ch = pcall(function() return obj:GetChildren() end)
        if ok2 then
            for _, c in ipairs(ch) do walkRS(c, depth + 1) end
        end
    end
    walkRS(ReplicatedStorage, 0)
    log("RS match: " .. rsCount, C.grey)

    -- Services lain
    local otherServices = {
        "Players", "StarterGui", "StarterPack",
        "StarterPlayer", "Teams", "SoundService",
        "Chat", "TextChatService"
    }
    div("OTHER SERVICES")
    for _, svcName in ipairs(otherServices) do
        local ok, svc = pcall(function() return game:GetService(svcName) end)
        if ok and svc then
            local function walkSvc(obj, depth)
                if depth > 6 then return end
                if matchKeyword(obj.Name) then
                    log("⭐ [" .. obj.ClassName .. "]  " .. obj:GetFullName(), C.match)
                    totalFound += 1
                end
                local ok2, ch = pcall(function() return obj:GetChildren() end)
                if ok2 then
                    for _, c in ipairs(ch) do walkSvc(c, depth + 1) end
                end
            end
            walkSvc(svc, 0)
        end
    end

    div()
    countLbl.Text = "✅ Scan selesai — total match: " .. totalFound
    log("✅ Scan selesai. Total: " .. totalFound, C.match)
end

-- =============================================
-- Button events
-- =============================================
btnScanAll.MouseButton1Click:Connect(function()
    countLbl.Text = "⏳ Scanning..."
    task.spawn(doScanAll)
end)

btnScanWS.MouseButton1Click:Connect(function()
    clearLog()
    countLbl.Text = "⏳ Scanning Workspace..."
    task.spawn(function()
        doScanWorkspace()
        countLbl.Text = "✅ WS done — " .. totalFound .. " match"
    end)
end)

btnScanRS.MouseButton1Click:Connect(function()
    clearLog()
    countLbl.Text = "⏳ Scanning ReplicatedStorage..."
    task.spawn(function()
        doScanRS()
        countLbl.Text = "✅ RS done — " .. totalFound .. " match"
    end)
end)

btnScanRemote.MouseButton1Click:Connect(function()
    clearLog()
    countLbl.Text = "⏳ Scanning remotes..."
    task.spawn(doScanRemoteOnly)
end)

btnClear.MouseButton1Click:Connect(function()
    clearLog()
    countLbl.Text = "Log dibersihkan"
    log("🗑 cleared", C.grey)
end)

-- Init
log("🟢 Scanner siap — tekan salah satu tombol scan", C.match)
log("⭐ = nama mengandung keyword  |  warna = tipe object", C.grey)
div()
