local RS      = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LP      = Players.LocalPlayer
local char    = LP.Character or LP.CharacterAdded:Wait()

local remotes    = RS:FindFirstChild("Remotes")
local babyAction = remotes and remotes:FindFirstChild("BabyAction")
local dropBaby   = remotes and remotes:FindFirstChild("DropBaby")

-- =============================================
-- GUI
-- =============================================
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "BabyV2"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size             = UDim2.new(0, 420, 0, 500)
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
title.Text             = "  🍼  Baby Auto v2  —  menzcreate"
title.TextXAlignment   = Enum.TextXAlignment.Left
title.BorderSizePixel  = 0
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

-- Status bar
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
statusLbl.Text               = "Idle..."

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

local btnScan  = makeBtn("🔍 Scan Prompt",  8,   120, Color3.fromRGB(40, 80, 180))
local btnAuto  = makeBtn("🤖 Auto: OFF",    134, 110, Color3.fromRGB(50, 50, 65))
local btnClear = makeBtn("🗑 Clear",         250, 80,  Color3.fromRGB(120, 30, 30))
local btnTest  = makeBtn("⚡ Test Fire",     336, 80,  Color3.fromRGB(30, 110, 60))

-- Scroll
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

-- =============================================
-- Log
-- =============================================
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

local function setStatus(text, color)
    statusLbl.Text      = text
    statusLbl.TextColor3 = color or C.white
end

btnClear.MouseButton1Click:Connect(function()
    for _, l in ipairs(logLines) do pcall(function() l:Destroy() end) end
    logLines = {}
    order    = 0
    log("🗑 cleared", C.grey)
end)

-- =============================================
-- Prompt scanner
-- =============================================
local foundPrompts = {}

local function isBabyPrompt(obj)
    if not obj:IsA("ProximityPrompt") then return false end
    -- "Baby" kapital sesuai hasil analisis
    return obj.ActionText == "Baby" or obj.ObjectText == "Baby"
end

local function getPrompts()
    foundPrompts = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if isBabyPrompt(obj) then
            pcall(function()
                obj.MaxActivationDistance = 9999
                obj.RequiresLineOfSight   = false
            end)
            table.insert(foundPrompts, obj)
        end
    end
    return foundPrompts
end

-- Fire semua prompt baby
local function fireAllPrompts(source)
    if #foundPrompts == 0 then
        log("⚠ Tidak ada prompt — scan dulu", C.red)
        return
    end
    local fired = 0
    for _, p in ipairs(foundPrompts) do
        if p and p.Parent then
            local ok, err = pcall(function() fireproximityprompt(p) end)
            if ok then
                fired += 1
                log("✅ ["..source.."] fired: "..p.Parent.Name, C.green)
            else
                log("❌ ["..source.."] fail: "..tostring(err), C.red)
            end
        end
    end
    setStatus("Last fire: "..fired.." prompt ("..source..")", C.green)
end

-- =============================================
-- Scan button
-- =============================================
btnScan.MouseButton1Click:Connect(function()
    div()
    log("🔍 Scanning 'Baby' prompt...", C.orange)
    getPrompts()
    log("Total ditemukan: "..#foundPrompts, #foundPrompts > 0 and C.green or C.red)
    for _, p in ipairs(foundPrompts) do
        log("  📌 "..p:GetFullName(), C.orange)
        log("     Action:\""..p.ActionText.."\"  Object:\""..p.ObjectText.."\"", C.grey)
        log("     MaxDist:"..tostring(p.MaxActivationDistance).."  Enabled:"..tostring(p.Enabled), C.grey)
    end
    setStatus("Prompt ditemukan: "..#foundPrompts, C.orange)
end)

-- =============================================
-- Test fire manual
-- =============================================
btnTest.MouseButton1Click:Connect(function()
    div()
    log("⚡ Manual test fire...", C.blue)
    if #foundPrompts == 0 then
        getPrompts()
        log("Auto scan: "..#foundPrompts.." found", C.grey)
    end
    fireAllPrompts("manual")
end)

-- =============================================
-- Auto toggle
-- =============================================
local AUTO_ON = false
btnAuto.MouseButton1Click:Connect(function()
    AUTO_ON = not AUTO_ON
    btnAuto.Text             = AUTO_ON and "🤖 Auto: ON" or "🤖 Auto: OFF"
    btnAuto.BackgroundColor3 = AUTO_ON
        and Color3.fromRGB(160, 90, 10)
        or  Color3.fromRGB(50, 50, 65)
    log("🤖 Auto " .. (AUTO_ON and "ON" or "OFF"), C.orange)
end)

-- Auto loop
task.spawn(function()
    while true do
        task.wait(1)
        if not AUTO_ON then continue end
        if #foundPrompts == 0 then
            getPrompts()
            if #foundPrompts > 0 then
                log("🔍 Auto scan: "..#foundPrompts.." prompt found", C.orange)
            end
        end
        if #foundPrompts > 0 then
            fireAllPrompts("auto")
        end
    end
end)

-- =============================================
-- Listen BabyAction — inti utama
-- Ketika event masuk arg "dropBaby" → langsung fire prompt
-- =============================================
local function listenBabyAction()
    if not babyAction then
        log("⚠ BabyAction tidak ditemukan!", C.red)
        return
    end
    log("✅ Listening BabyAction", C.green)
    pcall(function()
        babyAction.OnClientEvent:Connect(function(...)
            local args = {...}
            div()
            log("📥 BabyAction RECEIVED", C.yellow)
            for i, v in ipairs(args) do
                log("   arg["..i.."] "..typeof(v).." = "..tostring(v), C.yellow)
            end

            -- Kalau arg[1] == "dropBaby" → fire prompt
            if args[1] == "dropBaby" then
                log("🎯 Trigger 'dropBaby' detected → fire prompt!", C.green, true)
                setStatus("🎯 dropBaby detected! Firing...", C.green)

                -- Scan ulang dulu biar prompt fresh
                getPrompts()

                if #foundPrompts > 0 then
                    fireAllPrompts("BabyAction trigger")
                else
                    log("⚠ Tidak ada prompt Baby ditemukan saat trigger", C.red)
                end
            end
        end)
    end)
end

-- Listen DropBaby — log aja
local function listenDropBaby()
    if not dropBaby then
        log("⚠ DropBaby tidak ditemukan!", C.red)
        return
    end
    log("✅ Listening DropBaby", C.green)
    pcall(function()
        dropBaby.OnClientEvent:Connect(function(...)
            local args = {...}
            div()
            log("📥 DropBaby RECEIVED", C.blue)
            for i, v in ipairs(args) do
                log("   arg["..i.."] "..typeof(v).." = "..tostring(v), C.blue)
            end
        end)
    end)
end

-- =============================================
-- Init
-- =============================================
log("🟢 Baby Auto v2 ready", C.green)
div()
listenBabyAction()
listenDropBaby()
div()
log("ℹ Cara pakai:", C.grey)
log("  • Scan prompt dulu biar ready", C.grey)
log("  • Listener aktif otomatis — saat BabyAction 'dropBaby' masuk, prompt langsung di-fire", C.grey)
log("  • Nyalakan Auto jika mau loop terus", C.grey)
div()
