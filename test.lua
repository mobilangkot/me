local RS      = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LP      = Players.LocalPlayer

local remotes    = RS:FindFirstChild("Remotes")
local babyAction = remotes and remotes:FindFirstChild("BabyAction")
local dropBaby   = remotes and remotes:FindFirstChild("DropBaby")

-- GUI
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "BabyV3"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size             = UDim2.new(0, 420, 0, 480)
frame.Position         = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
frame.Active           = true
frame.Draggable        = true
frame.BorderSizePixel  = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size             = UDim2.new(1, 0, 0, 32)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
title.TextColor3       = Color3.fromRGB(255, 255, 255)
title.Font             = Enum.Font.GothamBold
title.TextSize         = 13
title.Text             = "  🍼  Baby Auto v3  —  menzcreate"
title.TextXAlignment   = Enum.TextXAlignment.Left
title.BorderSizePixel  = 0
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

-- Status
local statusBar = Instance.new("Frame", frame)
statusBar.Position         = UDim2.new(0, 8, 0, 38)
statusBar.Size             = UDim2.new(1, -16, 0, 22)
statusBar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
statusBar.BorderSizePixel  = 0
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0, 6)

local statusLbl = Instance.new("TextLabel", statusBar)
statusLbl.Size               = UDim2.new(1, -10, 1, 0)
statusLbl.Position           = UDim2.new(0, 8, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.TextColor3         = Color3.fromRGB(160, 160, 180)
statusLbl.Font               = Enum.Font.Gotham
statusLbl.TextSize           = 11
statusLbl.TextXAlignment     = Enum.TextXAlignment.Left
statusLbl.Text               = "Menunggu event BabyAction..."

local function setStatus(text, color)
    statusLbl.Text       = text
    statusLbl.TextColor3 = color
end

-- Buttons
local function makeBtn(text, x, w, col)
    local b = Instance.new("TextButton", frame)
    b.Position         = UDim2.new(0, x, 0, 66)
    b.Size             = UDim2.new(0, w, 0, 28)
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

local btnClear = makeBtn("🗑 Clear",      8,   90, Color3.fromRGB(120,30,30))
local btnTest  = makeBtn("⚡ Test Fire", 104,  90, Color3.fromRGB(30,110,60))

-- Scroll log
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Position            = UDim2.new(0, 8, 0, 102)
scroll.Size                = UDim2.new(1, -16, 1, -110)
scroll.BackgroundColor3    = Color3.fromRGB(10, 10, 14)
scroll.BorderSizePixel     = 0
scroll.ScrollBarThickness  = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 160, 30)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize          = UDim2.new(0,0,0,0)
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 7)

local layout = Instance.new("UIListLayout", scroll)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding   = UDim.new(0, 1)

local padInner = Instance.new("UIPadding", scroll)
padInner.PaddingLeft  = UDim.new(0, 5)
padInner.PaddingTop   = UDim.new(0, 4)
padInner.PaddingRight = UDim.new(0, 5)

-- Log
local logLines = {}
local order    = 0

local C = {
    white  = Color3.fromRGB(220, 220, 220),
    green  = Color3.fromRGB(80,  220, 130),
    yellow = Color3.fromRGB(255, 220, 60),
    blue   = Color3.fromRGB(80,  180, 255),
    red    = Color3.fromRGB(255, 80,  80),
    orange = Color3.fromRGB(255, 160, 30),
    grey   = Color3.fromRGB(100, 100, 120),
    div    = Color3.fromRGB(28,  28,  42),
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
    if #logLines > 400 then table.remove(logLines, 1):Destroy() end
end

local function div()
    log("─────────────────────────────────────────", C.div)
end

btnClear.MouseButton1Click:Connect(function()
    for _, l in ipairs(logLines) do pcall(function() l:Destroy() end) end
    logLines = {}
    order    = 0
    log("🗑 cleared", C.grey)
end)

-- =============================================
-- Core: scan & fire semua prompt Baby
-- =============================================
local function fireAllBabyPrompts(source)
    local fired = 0
    local found = 0

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            if obj.ActionText == "Baby" or obj.ObjectText == "Baby" then
                found += 1
                -- Bypass distance
                pcall(function()
                    obj.MaxActivationDistance = 9999
                    obj.RequiresLineOfSight   = false
                end)
                local ok, err = pcall(function()
                    fireproximityprompt(obj)
                end)
                if ok then
                    fired += 1
                    log("✅ ["..source.."] "..obj.Parent.Name, C.green)
                else
                    log("❌ ["..source.."] "..tostring(err), C.red)
                end
            end
        end
    end

    log("   found:"..found.."  fired:"..fired, C.grey)
    setStatus("Last: "..fired.."/"..found.." fired  ("..source..")", fired > 0 and C.green or C.red)
    return fired, found
end

-- Test manual
btnTest.MouseButton1Click:Connect(function()
    div()
    log("⚡ Manual test fire...", C.blue)
    fireAllBabyPrompts("manual")
end)

-- =============================================
-- Listen BabyAction
-- =============================================
if babyAction then
    log("✅ BabyAction found — listening", C.green)
    pcall(function()
        babyAction.OnClientEvent:Connect(function(...)
            local args = {...}
            div()
            log("📥 BabyAction received", C.yellow)
            log("   arg1: "..typeof(args[1]).." = "..tostring(args[1]), C.yellow)
            if args[2] ~= nil then
                log("   arg2: "..typeof(args[2]).." = "..tostring(args[2]), C.yellow)
            end

            if args[1] == "dropBaby" then
                log("🎯 dropBaby detected → firing prompt...", C.green)
                setStatus("🎯 dropBaby! Firing...", C.orange)

                -- task.wait kecil biar prompt sempat spawn dulu
                task.wait(0.15)
                fireAllBabyPrompts("BabyAction")
            end
        end)
    end)
else
    log("⚠ BabyAction tidak ditemukan di Remotes", C.red)
end

-- =============================================
-- Listen DropBaby — log aja
-- =============================================
if dropBaby then
    log("✅ DropBaby found — listening", C.green)
    pcall(function()
        dropBaby.OnClientEvent:Connect(function(...)
            local args = {...}
            div()
            log("📥 DropBaby received", C.blue)
            for i, v in ipairs(args) do
                log("   arg["..i.."] "..typeof(v).." = "..tostring(v), C.blue)
            end
        end)
    end)
else
    log("⚠ DropBaby tidak ditemukan di Remotes", C.red)
end

div()
log("🟢 Ready — menunggu event dropBaby", C.green)
log("ℹ task.wait(0.15) sebelum fire — biar prompt sempat spawn", C.grey)
