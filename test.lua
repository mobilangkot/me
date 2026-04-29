local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local character   = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local function resolveHRP(char)
    return char:FindFirstChild("HumanoidRootPart") 
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
end
local hrp = resolveHRP(character)

LocalPlayer.CharacterAdded:Connect(function(char)
    character = char
    hrp = resolveHRP(char)
end)

-- Remote targets
local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
local reBabyAction  = remotesFolder and remotesFolder:FindFirstChild("BabyAction")
local reDropBaby    = remotesFolder and remotesFolder:FindFirstChild("DropBaby")

local SCAN_RADIUS   = 20000
local AUTO_ON       = false
local logLines      = {}
local lineOrder     = 0

-- =============================================
-- GUI
-- =============================================
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name         = "BabyDebug"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size             = UDim2.new(0, 460, 0, 580)
frame.Position         = UDim2.new(0, 14, 0, 14)
frame.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local accent = Instance.new("Frame", frame)
accent.Size             = UDim2.new(1, 0, 0, 3)
accent.BackgroundColor3 = Color3.fromRGB(255, 160, 30)
accent.BorderSizePixel  = 0
accent.ZIndex           = 5
Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 12)

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
titleLbl.Text            = "🍼  Baby Debug & Auto"
titleLbl.ZIndex          = 5

local subLbl = Instance.new("TextLabel", titleBar)
subLbl.Size            = UDim2.new(1, -12, 0, 13)
subLbl.Position        = UDim2.new(0, 12, 0, 24)
subLbl.BackgroundTransparency = 1
subLbl.TextColor3      = Color3.fromRGB(255, 160, 30)
subLbl.Font            = Enum.Font.Gotham
subLbl.TextSize        = 11
subLbl.TextXAlignment  = Enum.TextXAlignment.Left
subLbl.Text            = "by menzcreate  •  discord: menzcreate"
subLbl.ZIndex          = 5

-- Status remote bar
local remoteBar = Instance.new("Frame", frame)
remoteBar.Size             = UDim2.new(1, -16, 0, 26)
remoteBar.Position         = UDim2.new(0, 8, 0, 50)
remoteBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
remoteBar.BorderSizePixel  = 0
remoteBar.ZIndex           = 3
Instance.new("UICorner", remoteBar).CornerRadius = UDim.new(0, 7)

local remoteLbl = Instance.new("TextLabel", remoteBar)
remoteLbl.Size               = UDim2.new(1, -10, 1, 0)
remoteLbl.Position           = UDim2.new(0, 8, 0, 0)
remoteLbl.BackgroundTransparency = 1
remoteLbl.TextColor3         = reBabyAction
    and Color3.fromRGB(80, 220, 130)
    or  Color3.fromRGB(255, 80, 80)
remoteLbl.Font               = Enum.Font.Gotham
remoteLbl.TextSize           = 12
remoteLbl.TextXAlignment     = Enum.TextXAlignment.Left
remoteLbl.Text               = reBabyAction
    and "✅  BabyAction & DropBaby ditemukan"
    or  "⚠  Remote tidak ditemukan — cek path"
remoteLbl.ZIndex             = 4

-- Buttons
local function newBtn(text, posY, col)
    local b = Instance.new("TextButton", frame)
    b.Size             = UDim2.new(1, -16, 0, 32)
    b.Position         = UDim2.new(0, 8, 0, posY)
    b.BackgroundColor3 = col
    b.TextColor3       = Color3.new(1,1,1)
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 13
    b.Text             = text
    b.AutoButtonColor  = false
    b.BorderSizePixel  = 0
    b.ZIndex           = 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local C_BLUE   = Color3.fromRGB(30, 80, 200)
local C_GREEN  = Color3.fromRGB(20, 110, 40)
local C_GREY   = Color3.fromRGB(38, 38, 50)
local C_ORANGE = Color3.fromRGB(180, 100, 10)
local C_RED    = Color3.fromRGB(160, 30, 30)

local fireActionBtn = newBtn("🔵  Fire BabyAction (no args)",  84,  C_BLUE)
local fireDropBtn   = newBtn("🔵  Fire DropBaby (no args)",    124, C_BLUE)
local scanPromptBtn = newBtn("🔍  Scan Prompt 'Baby'",         164, C_GREY)
local autoBtn       = newBtn("🤖  Auto Click Prompt  :  OFF",  204, C_GREY)
local clearBtn      = newBtn("🗑  Clear Log",                   244, C_RED)

-- Prompt info
local promptBar = Instance.new("Frame", frame)
promptBar.Size             = UDim2.new(1, -16, 0, 24)
promptBar.Position         = UDim2.new(0, 8, 0, 284)
promptBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
promptBar.BorderSizePixel  = 0
promptBar.ZIndex           = 3
Instance.new("UICorner", promptBar).CornerRadius = UDim.new(0, 7)

local promptLbl = Instance.new("TextLabel", promptBar)
promptLbl.Size               = UDim2.new(1, -10, 1, 0)
promptLbl.Position           = UDim2.new(0, 8, 0, 0)
promptLbl.BackgroundTransparency = 1
promptLbl.TextColor3         = Color3.fromRGB(160, 160, 180)
promptLbl.Font               = Enum.Font.Gotham
promptLbl.TextSize           = 12
promptLbl.TextXAlignment     = Enum.TextXAlignment.Left
promptLbl.Text               = "🍼  Prompt baby: belum discan"
promptLbl.ZIndex             = 4

-- Scroll log
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size                = UDim2.new(1, -16, 1, -324)
scroll.Position            = UDim2.new(0, 8, 0, 316)
scroll.BackgroundColor3    = Color3.fromRGB(14, 14, 20)
scroll.BorderSizePixel     = 0
scroll.ScrollBarThickness  = 5
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 160, 30)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize          = UDim2.new(0,0,0,0)
scroll.ZIndex              = 3
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 7)

local layout = Instance.new("UIListLayout", scroll)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding   = UDim.new(0, 1)

local padInner = Instance.new("UIPadding", scroll)
padInner.PaddingLeft   = UDim.new(0, 6)
padInner.PaddingRight  = UDim.new(0, 6)
padInner.PaddingTop    = UDim.new(0, 4)

local hintLbl = Instance.new("TextLabel", frame)
hintLbl.Size               = UDim2.new(1,-16,0,14)
hintLbl.Position           = UDim2.new(0,8,1,-16)
hintLbl.BackgroundTransparency = 1
hintLbl.TextColor3         = Color3.fromRGB(50,50,65)
hintLbl.Font               = Enum.Font.Gotham
hintLbl.TextSize           = 11
hintLbl.TextXAlignment     = Enum.TextXAlignment.Left
hintLbl.Text               = "RightCtrl = hide/show"
hintLbl.ZIndex             = 3

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightControl then
        gui.Enabled = not gui.Enabled
    end
end)

-- =============================================
-- Log
-- =============================================
local C = {
    info    = Color3.fromRGB(160, 160, 180),
    fire    = Color3.fromRGB(80,  200, 255),
    receive = Color3.fromRGB(255, 200, 60),
    prompt  = Color3.fromRGB(150, 255, 150),
    error   = Color3.fromRGB(255, 80,  80),
    auto    = Color3.fromRGB(255, 160, 30),
    div     = Color3.fromRGB(30,  30,  42),
}

local function addLog(text, color, bold)
    lineOrder += 1
    local lbl = Instance.new("TextLabel", scroll)
    lbl.Size               = UDim2.new(1, -4, 0, 0)
    lbl.AutomaticSize      = Enum.AutomaticSize.Y
    lbl.BackgroundTransparency = 1
    lbl.TextColor3         = color or C.info
    lbl.Font               = bold and Enum.Font.GothamBold or Enum.Font.Code
    lbl.TextSize           = 12
    lbl.TextWrapped        = true
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.Text               = text
    lbl.LayoutOrder        = lineOrder
    lbl.ZIndex             = 4
    task.defer(function() scroll.CanvasPosition = Vector2.new(0, math.huge) end)
    table.insert(logLines, lbl)
    if #logLines > 300 then
        table.remove(logLines, 1):Destroy()
    end
end

local function addDiv()
    addLog("────────────────────────────────────────────────", C.div)
end

local function ts()
    return "[" .. os.date("%H:%M:%S") .. "]  "
end

clearBtn.MouseButton1Click:Connect(function()
    for _, l in ipairs(logLines) do pcall(function() l:Destroy() end) end
    logLines  = {}
    lineOrder = 0
    addLog("🗑  Log dibersihkan.", C.info)
end)

-- =============================================
-- Listen RemoteEvent (OnClientEvent)
-- =============================================
local function listenRemote(re, name)
    if not re then
        addLog("⚠  " .. name .. " tidak ditemukan", C.error, true)
        return
    end
    addLog("✅  Listening: " .. name, C.prompt, true)
    re.OnClientEvent:Connect(function(...)
        local args = {...}
        addDiv()
        addLog(ts() .. "📥  RECEIVED  →  " .. name, C.receive, true)
        if #args == 0 then
            addLog("   (tidak ada argument)", C.info)
        else
            for i, v in ipairs(args) do
                local vtype = typeof(v)
                local vstr
                if vtype == "Instance" then
                    vstr = v:GetFullName() .. "  [" .. v.ClassName .. "]"
                    -- Print semua attribute instance yang diterima
                    local ok, attrs = pcall(function() return v:GetAttributes() end)
                    if ok then
                        for k, av in pairs(attrs) do
                            addLog("     attr  " .. k .. "  =  " .. tostring(av), C.auto)
                        end
                    end
                    -- Print children value
                    for _, child in ipairs(v:GetChildren()) do
                        if child:IsA("StringValue") or child:IsA("IntValue")
                        or child:IsA("NumberValue") or child:IsA("BoolValue") then
                            addLog("     child  [" .. child.ClassName .. "]  " .. child.Name .. "  =  " .. tostring(child.Value), C.prompt)
                        end
                    end
                else
                    vstr = tostring(v)
                end
                addLog("   arg[" .. i .. "]  <" .. vtype .. ">  =  " .. vstr, C.receive)
            end
        end
    end)
end

-- =============================================
-- Fire remote manual
-- =============================================
local function tryFire(re, name, ...)
    if not re then
        addLog("⚠  " .. name .. " tidak ditemukan", C.error)
        return
    end
    addDiv()
    addLog(ts() .. "🔵  FIRE  →  " .. name, C.fire, true)
    local args = {...}
    if #args == 0 then
        addLog("   (no args)", C.info)
    end
    local ok, err = pcall(function()
        re:FireServer(...)
    end)
    if ok then
        addLog("   ✅ berhasil dikirim", C.prompt)
    else
        addLog("   ❌ error: " .. tostring(err), C.error)
    end
end

fireActionBtn.MouseButton1Click:Connect(function()
    tryFire(reBabyAction, "BabyAction")
end)

fireDropBtn.MouseButton1Click:Connect(function()
    tryFire(reDropBaby, "DropBaby")
end)

-- =============================================
-- Scan & Auto ProximityPrompt "baby"
-- =============================================
local foundPrompts = {}

local function isBabyPrompt(obj)
    if not obj:IsA("ProximityPrompt") then return false end
    local at = string.lower(obj.ActionText)
    local ot = string.lower(obj.ObjectText)
    return string.find(at, "baby") ~= nil
        or string.find(ot, "baby") ~= nil
end

local function scanBabyPrompts()
    foundPrompts = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if isBabyPrompt(obj) then
            -- Perpanjang MaxActivationDistance
            pcall(function()
                obj.MaxActivationDistance = SCAN_RADIUS
            end)
            table.insert(foundPrompts, obj)
        end
    end

    addDiv()
    addLog(ts() .. "🔍  Scan prompt 'baby' selesai", C.prompt, true)
    addLog("   Total ditemukan: " .. #foundPrompts, C.prompt)

    for _, p in ipairs(foundPrompts) do
        addLog("   📌  " .. p:GetFullName(), C.info)
        addLog("      ActionText: " .. p.ActionText, C.auto)
        addLog("      ObjectText: " .. p.ObjectText, C.auto)
        addLog("      MaxActivationDistance: " .. tostring(p.MaxActivationDistance), C.auto)
        addLog("      Enabled: " .. tostring(p.Enabled), C.auto)
    end

    promptLbl.Text = "🍼  Prompt baby: " .. #foundPrompts .. " ditemukan"
end

scanPromptBtn.MouseButton1Click:Connect(scanBabyPrompts)

-- Auto click
autoBtn.MouseButton1Click:Connect(function()
    AUTO_ON = not AUTO_ON
    autoBtn.Text             = AUTO_ON and "🤖  Auto Click Prompt  :  ON" or "🤖  Auto Click Prompt  :  OFF"
    autoBtn.BackgroundColor3 = AUTO_ON and C_ORANGE or C_GREY
    addLog(ts() .. "🤖  Auto Collect " .. (AUTO_ON and "ON" or "OFF"), C.auto, true)
end)

-- =============================================
-- Auto loop
-- =============================================
task.spawn(function()
    while true do
        task.wait(0.5)
        if not AUTO_ON then continue end
        if not hrp or not hrp.Parent then continue end

        for _, prompt in ipairs(foundPrompts) do
            if not prompt or not prompt.Parent then continue end
            local part = prompt:FindFirstAncestorWhichIsA("BasePart")
                or prompt:FindFirstAncestorWhichIsA("Model")
            if part then
                local pos = part:IsA("BasePart") and part.Position
                    or (part.PrimaryPart and part.PrimaryPart.Position)
                if pos then
                    local d = (pos - hrp.Position).Magnitude
                    if d <= SCAN_RADIUS then
                        local ok, err = pcall(function()
                            fireproximityprompt(prompt)
                        end)
                        if ok then
                            addLog(ts() .. "🤖  Auto fire prompt: " .. prompt:GetFullName(), C.auto)
                        else
                            addLog(ts() .. "❌  gagal fire: " .. tostring(err), C.error)
                        end
                    end
                end
            end
        end
    end
end)

-- =============================================
-- Start
-- =============================================
addLog("🟢  Baby Debug aktif", C.prompt, true)
addDiv()
addLog("📡  Listening RemoteEvent...", C.info, true)
listenRemote(reBabyAction, "BabyAction")
listenRemote(reDropBaby,   "DropBaby")
addDiv()
addLog("💡  Tips:", C.info, true)
addLog("  1. Klik 'Scan Prompt Baby' dulu", C.info)
addLog("  2. Klik 'Fire BabyAction' / 'Fire DropBaby' tanpa arg", C.info)
addLog("  3. Lihat log — argument apa yang diterima dari server", C.info)
addLog("  4. Enable Auto jika prompt sudah ketemu", C.info)
