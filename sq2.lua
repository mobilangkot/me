local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local character   = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local function resolveHRP(char)
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
end
local function resolveHumanoid(char)
    return char:FindFirstChildOfClass("Humanoid")
end

local hrp      = resolveHRP(character)
local humanoid = resolveHumanoid(character)

local SCAN_RADIUS  = 15000
local TOGGLE_KEY   = Enum.KeyCode.RightControl
local SPEED_ON     = false
local NOCLIP_ON    = false
local HIGHLIGHT_ON = true
local AUTO_ON      = false
local BABY_ON      = false
local STOPPED      = false
local MINIMIZED    = false

local foundModels = {}
local highlights  = {}

local function getInstancesFolder()
    local ok, res = pcall(function()
        return workspace
            :WaitForChild("Data", 5)
            :WaitForChild("Detective", 5)
            :WaitForChild("Evidence", 5)
            :WaitForChild("Instances", 5)
    end)
    return ok and res or nil
end

-- Speed
local speedConn
local function startSpeedLoop()
    if speedConn then speedConn:Disconnect() end
    speedConn = RunService.Heartbeat:Connect(function()
        if not SPEED_ON or STOPPED then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = resolveHumanoid(char)
        if hum then
            hum.UseJumpPower = true
            hum.WalkSpeed    = 100
            hum.JumpPower    = 80
        end
    end)
end

local function applySpeed(char)
    local hum = resolveHumanoid(char)
    if hum then
        hum.UseJumpPower = true
        if SPEED_ON and not STOPPED then
            hum.WalkSpeed = 100
            hum.JumpPower = 80
        else
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end
end
startSpeedLoop()

-- Noclip
local noclipConn
local function startNoclip()
    if noclipConn then noclipConn:Disconnect() end
    noclipConn = RunService.Stepped:Connect(function()
        if not NOCLIP_ON or STOPPED then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)
end

local function stopNoclip()
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end
startNoclip()

-- Highlight
local function clearHighlights()
    for _, h in ipairs(highlights) do pcall(function() h:Destroy() end) end
    highlights = {}
end

local function addHighlight(target, isNearest)
    local h = Instance.new("Highlight")
    h.Parent              = target
    h.FillColor           = isNearest and Color3.fromRGB(255,220,0) or Color3.fromRGB(0,180,255)
    h.OutlineColor        = isNearest and Color3.fromRGB(255,255,255) or Color3.fromRGB(0,100,200)
    h.FillTransparency    = 0.3
    h.OutlineTransparency = 0
    h.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    table.insert(highlights, h)
end

-- Collect
local function getPromptFromModel(model)
    for _, desc in ipairs(model:GetDescendants()) do
        if desc:IsA("ProximityPrompt") then
            local at = string.lower(desc.ActionText)
            local ot = string.lower(desc.ObjectText)
            if at == "collect" or ot == "collect" then return desc end
        end
    end
    return nil
end

local function firePrompt(prompt)
    pcall(function() fireproximityprompt(prompt) end)
end

-- Respawn (HP = 0)
local function doRespawn()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = resolveHumanoid(char)
    if hum then
        hum.Health = 0
    end
end

-- Auto Baby
local function fireAllBabyPrompts()
    if STOPPED then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            if obj.ActionText == "Baby" or obj.ObjectText == "Baby" then
                pcall(function()
                    obj.MaxActivationDistance = 9999
                    obj.RequiresLineOfSight   = false
                end)
                pcall(function() fireproximityprompt(obj) end)
            end
        end
    end
end

local remotes    = ReplicatedStorage:FindFirstChild("Remotes")
local babyAction = remotes and remotes:FindFirstChild("BabyAction")

if babyAction then
    pcall(function()
        babyAction.OnClientEvent:Connect(function(...)
            local args = {...}
            if args[1] == "dropBaby" and BABY_ON and not STOPPED then
                task.wait(0.15)
                fireAllBabyPrompts()
            end
        end)
    end)
end

-- =============================================
-- GUI
-- =============================================
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name         = "SQToolGui"
gui.ResetOnSpawn = false

-- =============================================
-- Float button (minimize mode)
-- =============================================
local floatFrame = Instance.new("Frame", gui)
floatFrame.Size             = UDim2.new(0, 48, 0, 110)
floatFrame.Position         = UDim2.new(0, 14, 0, 14)
floatFrame.BackgroundTransparency = 1
floatFrame.Visible          = false
floatFrame.ZIndex           = 20

local floatBtn = Instance.new("TextButton", floatFrame)
floatBtn.Size             = UDim2.new(0, 48, 0, 48)
floatBtn.Position         = UDim2.new(0, 0, 0, 0)
floatBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
floatBtn.TextColor3       = Color3.new(1,1,1)
floatBtn.Font             = Enum.Font.GothamBold
floatBtn.TextSize         = 22
floatBtn.Text             = "🦑"
floatBtn.ZIndex           = 21
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(0, 12)

-- Respawn button di float mode
local floatRespawnBtn = Instance.new("TextButton", floatFrame)
floatRespawnBtn.Size             = UDim2.new(0, 48, 0, 36)
floatRespawnBtn.Position         = UDim2.new(0, 0, 0, 54)
floatRespawnBtn.BackgroundColor3 = Color3.fromRGB(160, 20, 20)
floatRespawnBtn.TextColor3       = Color3.new(1,1,1)
floatRespawnBtn.Font             = Enum.Font.GothamBold
floatRespawnBtn.TextSize         = 18
floatRespawnBtn.Text             = "💀"
floatRespawnBtn.ZIndex           = 21
Instance.new("UICorner", floatRespawnBtn).CornerRadius = UDim.new(0, 10)

floatRespawnBtn.MouseButton1Click:Connect(doRespawn)

-- =============================================
-- Main frame
-- =============================================
local frame = Instance.new("Frame", gui)
frame.Size             = UDim2.new(0, 280, 0, 420)
frame.Position         = UDim2.new(0, 14, 0, 14)
frame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

-- Shadow
local shadow = Instance.new("Frame", frame)
shadow.Size             = UDim2.new(1, 10, 1, 10)
shadow.Position         = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
shadow.BackgroundTransparency = 0.75
shadow.BorderSizePixel  = 0
shadow.ZIndex           = 0
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 16)

-- Accent
local accent = Instance.new("Frame", frame)
accent.Size             = UDim2.new(1, 0, 0, 3)
accent.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
accent.BorderSizePixel  = 0
accent.ZIndex           = 5
Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 14)

-- Title bar
local titleBar = Instance.new("Frame", frame)
titleBar.Size             = UDim2.new(1, 0, 0, 42)
titleBar.Position         = UDim2.new(0, 0, 0, 3)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
titleBar.BorderSizePixel  = 0
titleBar.ZIndex           = 4

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size            = UDim2.new(1, -76, 0, 22)
titleLbl.Position        = UDim2.new(0, 12, 0, 4)
titleLbl.BackgroundTransparency = 1
titleLbl.TextColor3      = Color3.fromRGB(255,255,255)
titleLbl.Font            = Enum.Font.GothamBold
titleLbl.TextSize        = 14
titleLbl.TextXAlignment  = Enum.TextXAlignment.Left
titleLbl.Text            = "🦑  Squid Game Tool"
titleLbl.ZIndex          = 5

local subLbl = Instance.new("TextLabel", titleBar)
subLbl.Size            = UDim2.new(1, -76, 0, 13)
subLbl.Position        = UDim2.new(0, 12, 0, 25)
subLbl.BackgroundTransparency = 1
subLbl.TextColor3      = Color3.fromRGB(180, 40, 40)
subLbl.Font            = Enum.Font.Gotham
subLbl.TextSize        = 10
subLbl.TextXAlignment  = Enum.TextXAlignment.Left
subLbl.Text            = "by menzcreate  •  discord: menzcreate"
subLbl.ZIndex          = 5

-- Minimize button
local minBtn = Instance.new("TextButton", titleBar)
minBtn.Size             = UDim2.new(0, 26, 0, 26)
minBtn.Position         = UDim2.new(1, -34, 0, 8)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
minBtn.TextColor3       = Color3.new(1,1,1)
minBtn.Font             = Enum.Font.GothamBold
minBtn.TextSize         = 14
minBtn.Text             = "—"
minBtn.ZIndex           = 6
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- Info bar
local infoBar = Instance.new("Frame", frame)
infoBar.Size             = UDim2.new(1, -16, 0, 26)
infoBar.Position         = UDim2.new(0, 8, 0, 52)
infoBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
infoBar.BorderSizePixel  = 0
infoBar.ZIndex           = 3
Instance.new("UICorner", infoBar).CornerRadius = UDim.new(0, 7)

local infoLbl = Instance.new("TextLabel", infoBar)
infoLbl.Size               = UDim2.new(1, -10, 1, 0)
infoLbl.Position           = UDim2.new(0, 8, 0, 0)
infoLbl.BackgroundTransparency = 1
infoLbl.TextColor3         = Color3.fromRGB(80,220,130)
infoLbl.Font               = Enum.Font.Gotham
infoLbl.TextSize           = 11
infoLbl.TextXAlignment     = Enum.TextXAlignment.Left
infoLbl.Text               = "📦  Scanning..."
infoLbl.ZIndex             = 4

-- =============================================
-- Button factory compact
-- =============================================
local BTN_H   = 32
local BTN_GAP = 4
local BTN_Y   = 86

local function newBtn(posY)
    local b = Instance.new("TextButton", frame)
    b.Size             = UDim2.new(1, -16, 0, BTN_H)
    b.Position         = UDim2.new(0, 8, 0, posY)
    b.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    b.TextColor3       = Color3.new(1,1,1)
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 12
    b.Text             = ""
    b.AutoButtonColor  = false
    b.BorderSizePixel  = 0
    b.ZIndex           = 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local function btnY(i) return BTN_Y + (i-1) * (BTN_H + BTN_GAP) end

local C_GREEN = Color3.fromRGB(18, 100, 36)
local C_GREY  = Color3.fromRGB(28, 28, 36)
local C_BLUE  = Color3.fromRGB(18, 62, 140)
local C_RED   = Color3.fromRGB(160, 25, 25)
local C_PURP  = Color3.fromRGB(90, 25, 150)
local C_PINK  = Color3.fromRGB(160, 25, 110)
local C_DARK  = Color3.fromRGB(80, 10, 10)

local hlBtn      = newBtn(btnY(1))
local tpBtn      = newBtn(btnY(2))
local spBtn      = newBtn(btnY(3))
local ncBtn      = newBtn(btnY(4))
local autoBtn    = newBtn(btnY(5))
local babyBtn    = newBtn(btnY(6))
local respawnBtn = newBtn(btnY(7))
local stopBtn    = newBtn(btnY(8))

hlBtn.Text      = "💡  Highlight  :  ON"
tpBtn.Text      = "📦  Teleport ke Terdekat"
spBtn.Text      = "⚡  Speed + Jump  :  OFF"
ncBtn.Text      = "👻  Noclip  :  OFF"
autoBtn.Text    = "🤖  Auto Collect  :  OFF"
babyBtn.Text    = "🍼  Auto Baby  :  OFF"
respawnBtn.Text = "💀  Respawn (HP = 0)"
stopBtn.Text    = "⏹  Stop All"

hlBtn.BackgroundColor3      = C_GREEN
tpBtn.BackgroundColor3      = C_BLUE
respawnBtn.BackgroundColor3 = C_DARK
stopBtn.BackgroundColor3    = C_RED

-- Resize frame sesuai jumlah tombol
frame.Size = UDim2.new(0, 280, 0, btnY(8) + BTN_H + 26)

local hintLbl = Instance.new("TextLabel", frame)
hintLbl.Size               = UDim2.new(1,-16,0,14)
hintLbl.Position           = UDim2.new(0,8,1,-16)
hintLbl.BackgroundTransparency = 1
hintLbl.TextColor3         = Color3.fromRGB(50,50,65)
hintLbl.Font               = Enum.Font.Gotham
hintLbl.TextSize            = 10
hintLbl.TextXAlignment     = Enum.TextXAlignment.Left
hintLbl.Text               = "RightCtrl = hide/show"
hintLbl.ZIndex             = 3

-- =============================================
-- Minimize
-- =============================================
local function setMinimized(val)
    MINIMIZED            = val
    frame.Visible        = not val
    floatFrame.Visible   = val
end

minBtn.MouseButton1Click:Connect(function() setMinimized(true) end)
floatBtn.MouseButton1Click:Connect(function() setMinimized(false) end)
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == TOGGLE_KEY then
        setMinimized(not MINIMIZED)
    end
end)

-- =============================================
-- Stop All / Resume
-- =============================================
local function doStopAll()
    STOPPED      = true
    SPEED_ON     = false
    NOCLIP_ON    = false
    HIGHLIGHT_ON = false
    AUTO_ON      = false
    BABY_ON      = false

    applySpeed(LocalPlayer.Character)
    stopNoclip()
    clearHighlights()

    hlBtn.Text             = "💡  Highlight  :  OFF"
    spBtn.Text             = "⚡  Speed + Jump  :  OFF"
    ncBtn.Text             = "👻  Noclip  :  OFF"
    autoBtn.Text           = "🤖  Auto Collect  :  OFF"
    babyBtn.Text           = "🍼  Auto Baby  :  OFF"
    hlBtn.BackgroundColor3   = C_GREY
    spBtn.BackgroundColor3   = C_GREY
    ncBtn.BackgroundColor3   = C_GREY
    autoBtn.BackgroundColor3 = C_GREY
    babyBtn.BackgroundColor3 = C_GREY

    stopBtn.Text             = "▶  Resume All"
    stopBtn.BackgroundColor3 = Color3.fromRGB(18, 90, 150)
    infoLbl.Text             = "⏹  Semua fitur dihentikan"
end

local function doResumeAll()
    STOPPED      = false
    HIGHLIGHT_ON = true
    hlBtn.Text             = "💡  Highlight  :  ON"
    hlBtn.BackgroundColor3 = C_GREEN
    stopBtn.Text             = "⏹  Stop All"
    stopBtn.BackgroundColor3 = C_RED
    infoLbl.Text             = "▶  Resumed..."
end

stopBtn.MouseButton1Click:Connect(function()
    if STOPPED then doResumeAll() else doStopAll() end
end)

-- =============================================
-- Tombol logic
-- =============================================
hlBtn.MouseButton1Click:Connect(function()
    if STOPPED then return end
    HIGHLIGHT_ON = not HIGHLIGHT_ON
    hlBtn.Text             = HIGHLIGHT_ON and "💡  Highlight  :  ON" or "💡  Highlight  :  OFF"
    hlBtn.BackgroundColor3 = HIGHLIGHT_ON and C_GREEN or C_GREY
    if not HIGHLIGHT_ON then clearHighlights() end
end)

local isTeleporting = false
tpBtn.MouseButton1Click:Connect(function()
    if isTeleporting or not hrp or STOPPED then return end
    if #foundModels == 0 then infoLbl.Text = "⚠  Tidak ada collect" return end
    local nearest, bestDist = nil, math.huge
    for _, model in ipairs(foundModels) do
        local bp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
        if bp then
            local d = (bp.Position - hrp.Position).Magnitude
            if d < bestDist then nearest, bestDist = bp, d end
        end
    end
    if not nearest then return end
    isTeleporting = true
    tpBtn.BackgroundColor3 = Color3.fromRGB(120, 80, 10)
    local dir = (nearest.Position - hrp.Position).Unit
    hrp.CFrame = CFrame.new(hrp.Position + dir * 8 + Vector3.new(0,3,0))
    task.wait(0.7)
    hrp.CFrame = CFrame.new(nearest.Position + Vector3.new(0,4,0))
    tpBtn.BackgroundColor3 = C_BLUE
    isTeleporting = false
end)

spBtn.MouseButton1Click:Connect(function()
    if STOPPED then return end
    SPEED_ON = not SPEED_ON
    spBtn.Text             = SPEED_ON and "⚡  Speed + Jump  :  ON" or "⚡  Speed + Jump  :  OFF"
    spBtn.BackgroundColor3 = SPEED_ON and C_GREEN or C_GREY
    if not SPEED_ON then applySpeed(LocalPlayer.Character) end
end)

ncBtn.MouseButton1Click:Connect(function()
    if STOPPED then return end
    NOCLIP_ON = not NOCLIP_ON
    ncBtn.Text             = NOCLIP_ON and "👻  Noclip  :  ON" or "👻  Noclip  :  OFF"
    ncBtn.BackgroundColor3 = NOCLIP_ON and C_GREEN or C_GREY
    if not NOCLIP_ON then stopNoclip() end
end)

autoBtn.MouseButton1Click:Connect(function()
    if STOPPED then return end
    AUTO_ON = not AUTO_ON
    autoBtn.Text             = AUTO_ON and "🤖  Auto Collect  :  ON" or "🤖  Auto Collect  :  OFF"
    autoBtn.BackgroundColor3 = AUTO_ON and C_PURP or C_GREY
end)

babyBtn.MouseButton1Click:Connect(function()
    if STOPPED then return end
    BABY_ON = not BABY_ON
    babyBtn.Text             = BABY_ON and "🍼  Auto Baby  :  ON" or "🍼  Auto Baby  :  OFF"
    babyBtn.BackgroundColor3 = BABY_ON and C_PINK or C_GREY
end)

respawnBtn.MouseButton1Click:Connect(function()
    doRespawn()
end)

-- =============================================
-- Respawn
-- =============================================
LocalPlayer.CharacterAdded:Connect(function(char)
    character = char
    hrp       = resolveHRP(char)
    humanoid  = resolveHumanoid(char)
    task.wait(1)
    applySpeed(char)
end)

-- =============================================
-- Scan Loop
-- =============================================
task.spawn(function()
    while true do
        task.wait(0.7)
        if STOPPED then continue end
        if not hrp or not hrp.Parent then
            character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            hrp       = resolveHRP(character)
            humanoid  = resolveHumanoid(character)
        end
        if not hrp or not hrp.Parent then continue end

        local folder = getInstancesFolder()
        if not folder then infoLbl.Text = "⚠  Path tidak ditemukan" continue end

        clearHighlights()
        foundModels = {}
        local nearest, bestDist = nil, math.huge

        for _, model in ipairs(folder:GetChildren()) do
            local prompt = getPromptFromModel(model)
            if prompt then
                local bp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
                if bp then
                    local d = (bp.Position - hrp.Position).Magnitude
                    if d <= SCAN_RADIUS then
                        table.insert(foundModels, model)
                        if d < bestDist then nearest, bestDist = model, d end
                        if AUTO_ON then firePrompt(prompt) end
                    end
                end
            end
        end

        if HIGHLIGHT_ON then
            for _, model in ipairs(foundModels) do
                addHighlight(model, model == nearest)
            end
        end

        if nearest then
            local tags = (AUTO_ON and " 🤖" or "") .. (BABY_ON and " 🍼" or "")
            infoLbl.Text = string.format("📦 %d collect | %.0f studs%s", #foundModels, bestDist, tags)
        else
            infoLbl.Text = "📦  Tidak ada collect"
        end
    end
end)
