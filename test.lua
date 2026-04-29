local RS      = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LP      = Players.LocalPlayer

local remotes    = RS:FindFirstChild("Remotes")
local babyAction = remotes and remotes:FindFirstChild("BabyAction")
local dropBaby   = remotes and remotes:FindFirstChild("DropBaby")

-- =============================================
-- GUI minimal
-- =============================================
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "BabyDebug"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size             = UDim2.new(0, 460, 0, 560)
frame.Position         = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
frame.Active           = true
frame.Draggable        = true
frame.BorderSizePixel  = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size            = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
title.TextColor3      = Color3.fromRGB(255,255,255)
title.Font            = Enum.Font.GothamBold
title.TextSize        = 13
title.Text            = "  🍼 Baby Debug"
title.TextXAlignment  = Enum.TextXAlignment.Left
title.BorderSizePixel = 0
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

-- Status remote
local statusLbl = Instance.new("TextLabel", frame)
statusLbl.Position        = UDim2.new(0, 8, 0, 34)
statusLbl.Size            = UDim2.new(1, -16, 0, 18)
statusLbl.BackgroundTransparency = 1
statusLbl.TextColor3      = babyAction
    and Color3.fromRGB(80, 220, 130)
    or  Color3.fromRGB(255, 80, 80)
statusLbl.Font            = Enum.Font.Gotham
statusLbl.TextSize        = 11
statusLbl.TextXAlignment  = Enum.TextXAlignment.Left
statusLbl.Text            = babyAction
    and "✅ BabyAction & DropBaby found"
    or  "⚠ Remote tidak ditemukan"

-- Buttons row
local function makeBtn(text, x, w, col)
    local b = Instance.new("TextButton", frame)
    b.Position         = UDim2.new(0, x, 0, 56)
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

local btn_fireAction = makeBtn("▶ BabyAction",  8,   105, Color3.fromRGB(30,80,200))
local btn_fireDrop   = makeBtn("▶ DropBaby",    118, 95,  Color3.fromRGB(30,80,200))
local btn_scan       = makeBtn("🔍 Scan Prompt", 218, 110, Color3.fromRGB(60,60,80))
local btn_autoFire   = makeBtn("🤖 Auto: OFF",   333, 90,  Color3.fromRGB(60,60,80))
local btn_clear      = makeBtn("🗑",              428, 30,  Color3.fromRGB(120,30,30))

-- Scroll log
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Position            = UDim2.new(0, 8, 0, 90)
scroll.Size                = UDim2.new(1, -16, 1, -98)
scroll.BackgroundColor3    = Color3.fromRGB(10, 10, 14)
scroll.BorderSizePixel     = 0
scroll.ScrollBarThickness  = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(80,120,255)
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

-- =============================================
-- Log
-- =============================================
local lines = {}
local order = 0

local C = {
    white   = Color3.fromRGB(220, 220, 220),
    green   = Color3.fromRGB(80,  220, 130),
    yellow  = Color3.fromRGB(255, 220, 60),
    blue    = Color3.fromRGB(80,  180, 255),
    red     = Color3.fromRGB(255, 80,  80),
    orange  = Color3.fromRGB(255, 160, 30),
    grey    = Color3.fromRGB(100, 100, 120),
    div     = Color3.fromRGB(30,  30,  45),
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
    table.insert(lines, l)
    if #lines > 400 then table.remove(lines,1):Destroy() end
end

local function div() log("─────────────────────────────────────────", C.div) end

local function clearLog()
    for _, l in ipairs(lines) do pcall(function() l:Destroy() end) end
    lines = {}
    order = 0
end

-- =============================================
-- Logic
-- =============================================

-- Listen remote
local function listenAll()
    if babyAction then
        pcall(function()
            babyAction.OnClientEvent:Connect(function(...)
                div()
                log("📥 [BabyAction] RECEIVED", C.yellow)
                local args = {...}
                if #args == 0 then log("   (no args)", C.grey) end
                for i, v in ipairs(args) do
                    log("   arg["..i.."] "..typeof(v).." = "..tostring(v), C.yellow)
                    if typeof(v) == "Instance" then
                        log("   path: "..v:GetFullName(), C.grey)
                        pcall(function()
                            for k, av in pairs(v:GetAttributes()) do
                                log("     attr "..k.." = "..tostring(av), C.orange)
                            end
                        end)
                        pcall(function()
                            for _, c in ipairs(v:GetChildren()) do
                                if c:IsA("StringValue") or c:IsA("IntValue") or c:IsA("NumberValue") then
                                    log("     child "..c.Name.." = "..tostring(c.Value), C.orange)
                                end
                            end
                        end)
                    end
                end
            end)
        end)
        log("✅ Listening: BabyAction", C.green)
    else
        log("⚠ BabyAction tidak ditemukan", C.red)
    end

    if dropBaby then
        pcall(function()
            dropBaby.OnClientEvent:Connect(function(...)
                div()
                log("📥 [DropBaby] RECEIVED", C.blue)
                local args = {...}
                if #args == 0 then log("   (no args)", C.grey) end
                for i, v in ipairs(args) do
                    log("   arg["..i.."] "..typeof(v).." = "..tostring(v), C.blue)
                end
            end)
        end)
        log("✅ Listening: DropBaby", C.green)
    else
        log("⚠ DropBaby tidak ditemukan", C.red)
    end
end

-- Fire remote
btn_fireAction.MouseButton1Click:Connect(function()
    if not babyAction then log("⚠ BabyAction not found", C.red) return end
    div()
    log("🔵 Fire BabyAction...", C.blue)
    local ok, err = pcall(function() babyAction:FireServer() end)
    log(ok and "   ✅ sent" or "   ❌ "..tostring(err), ok and C.green or C.red)
end)

btn_fireDrop.MouseButton1Click:Connect(function()
    if not dropBaby then log("⚠ DropBaby not found", C.red) return end
    div()
    log("🔵 Fire DropBaby...", C.blue)
    local ok, err = pcall(function() dropBaby:FireServer() end)
    log(ok and "   ✅ sent" or "   ❌ "..tostring(err), ok and C.green or C.red)
end)

-- Scan prompt
local foundPrompts = {}

btn_scan.MouseButton1Click:Connect(function()
    foundPrompts = {}
    div()
    log("🔍 Scanning prompt 'baby'...", C.orange)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local at = string.lower(obj.ActionText or "")
            local ot = string.lower(obj.ObjectText or "")
                if string.find(at,"Baby") or string.find(ot,"Baby") then
                table.insert(foundPrompts, obj)
                pcall(function() obj.MaxActivationDistance = 9999 end)
                log("📌 "..obj:GetFullName(), C.orange)
                log("   Action: \""..obj.ActionText.."\"  Object: \""..obj.ObjectText.."\"", C.grey)
                log("   Enabled:"..tostring(obj.Enabled).."  MaxDist:"..tostring(obj.MaxActivationDistance), C.grey)

                -- fire langsung
                local ok, err = pcall(function() fireproximityprompt(obj) end)
                log("   fireproximityprompt: "..(ok and "✅ OK" or "❌ "..tostring(err)),
                    ok and C.green or C.red)
            end
        end
    end
    log("Total: "..#foundPrompts, #foundPrompts > 0 and C.green or C.red)
end)

-- Auto fire
local AUTO_ON = false
btn_autoFire.MouseButton1Click:Connect(function()
    AUTO_ON = not AUTO_ON
    btn_autoFire.Text             = AUTO_ON and "🤖 Auto: ON" or "🤖 Auto: OFF"
    btn_autoFire.BackgroundColor3 = AUTO_ON
        and Color3.fromRGB(160, 80, 10)
        or  Color3.fromRGB(60, 60, 80)
    log("🤖 Auto ".. (AUTO_ON and "ON" or "OFF"), C.orange)
end)

task.spawn(function()
    while true do
        task.wait(0.8)
        if not AUTO_ON or #foundPrompts == 0 then continue end
        for _, p in ipairs(foundPrompts) do
            if p and p.Parent then
                local ok, err = pcall(function() fireproximityprompt(p) end)
                if not ok then
                    log("❌ auto fire: "..tostring(err), C.red)
                end
            end
        end
    end
end)

btn_clear.MouseButton1Click:Connect(function()
    clearLog()
    log("🗑 cleared", C.grey)
end)

-- =============================================
-- Init
-- =============================================
log("🟢 Baby Debug ready", C.green)
div()
listenAll()
div()
log("1. Fire dulu tanpa arg → lihat log", C.grey)
log("2. Scan prompt → auto langsung dicoba", C.grey)
log("3. Nyalakan Auto jika mau loop", C.grey)
