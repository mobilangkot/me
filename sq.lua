local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

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
local AUTO_RADIUS  = 4
local TOGGLE_KEY   = Enum.KeyCode.RightControl
local SPEED_ON     = false
local NOCLIP_ON    = false
local HIGHLIGHT_ON = true
local AUTO_ON      = false
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
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
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
    for _, h in ipairs(highlights) do
        pcall(function() h:Destroy() end)
    end
    highlights = {}
end

local function addHighlight(target, isNearest)
    local h = Instance.new("Highlight")
    h.Parent              = target
    h.FillColor           = isNearest
        and Color3.fromRGB(255, 220, 0)
        or  Color3.fromRGB(0, 180, 255)
    h.OutlineColor        = isNearest
        and Color3.fromRGB(255, 255, 255)
        or  Color3.fromRGB(0, 100, 200)
    h.FillTransparency    = 0.3
    h.OutlineTransparency = 0
    h.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    table.insert(highlights, h)
end

-- Auto collect
local function firePrompt(prompt)
    -- Coba fireproximityprompt via executor
    pcall(function()
        local fn = getfenv and getfenv(0) or {}
        if fn.firetouchinterest then return end
    end)
    -- Cara utama: FireProximityPrompt
    pcall(function()
        local VPS = game:GetService("VirtualInputManager")
        if VPS then end
    end)
    -- Method paling universal di executor
    pcall(function()
        fireproximityprompt(prompt)
    end)
end

local function getPromptFromModel(model)
    for _, desc in ipairs(model:GetDescendants()) do
        if desc:IsA("ProximityPrompt") then
            local at = string.lower(desc.ActionText)
            local ot = string.lower(desc.ObjectText)
            if at == "collect" or ot == "collect" then
                return desc
            end
        end
    end
    return nil
end

-- =============================================
-- GUI
-- =============================================
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name         = "SQToolGui"
gui.ResetOnSpawn = false

-- Float button
local floatBtn = Instance.new("TextButton", gui)
floatBtn.Size             = UDim2.new(0, 48, 0, 48)
floatBtn.Position         = UDim2.new(0, 14, 0, 14)
floatBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
floatBtn.TextColor3       = Color3.new(1, 1, 1)
floatBtn.Font             = Enum.Font.GothamBold
floatBtn.TextSize         = 22
floatBtn.Text             = "🦑"
floatBtn.Visible          = false
floatBtn.ZIndex           = 20
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(0, 12)

-- Main frame
local frame = Instance.new("Frame", gui)
frame.Size             = UDim2.new(0, 290, 0, 385)
frame.Position         = UDim2.new(0, 14, 0, 14)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
frame.BorderSizePixel  = 0
frame.Active           = true
frame.Draggable        = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local accent = Instance.new("Frame", frame)
accent.Size             = UDim2.new(1, 0, 0, 3)
accent.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
accent.BorderSizePixel  = 0
accent.ZIndex           = 5
Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 12)

local titleBar = Instance.new("Frame", frame)
titleBar.Size             = UDim2.new(1, 0, 0, 40)
titleBar.Position         = UDim2.new(0, 0, 0, 3)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
titleBar.BorderSizePixel  = 0
titleBar.ZIndex           = 4

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size            = UDim2.new(1, -80, 0, 21)
titleLbl.Position        = UDim2.new(0, 12, 0, 4)
titleLbl.BackgroundTransparency = 1
titleLbl.TextColor3      = Color3.fromRGB(255, 255, 255)
titleLbl.Font            = Enum.Font.GothamBold
titleLbl.TextSize        = 14
titleLbl.TextXAlignment  = Enum.TextXAlignment.Left
titleLbl.Text            = "🦑  Squid Game Tool"
titleLbl.ZIndex          = 5

local subLbl = Instance.new("TextLabel", titleBar)
subLbl.Size            = UDim2.new(1, -80, 0, 13)
subLbl.Position        = UDim2.new(0, 12, 0, 24)
subLbl.BackgroundTransparency = 1
subLbl.TextColor3      = Color3.fromRGB(200, 50, 50)
subLbl.Font            = Enum.Font.Gotham
subLbl.TextSize        = 11
subLbl.TextXAlignment  = Enum.TextXAlignment.Left
subLbl.Text            = "by menzcreate  •  discord: menzcreate"
subLbl.ZIndex          = 5

local minBtn = Instance.new("TextButton", titleBar)
minBtn.Size             = UDim2.new(0, 28, 0, 28)
minBtn.Position         = UDim2.new(1, -36, 0, 6)
minBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
minBtn.TextColor3       = Color3.new(1, 1, 1)
minBtn.Font             = Enum.Font.GothamBold
minBtn.TextSize         = 16
minBtn.Text             = "—"
minBtn.ZIndex           = 6
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 7)

-- Info bar
local infoBar = Instance.new("Frame", frame)
infoBar.Size             = UDim2.new(1, -16, 0, 28)
infoBar.Position         = UDim2.new(0, 8, 0, 50)
infoBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
infoBar.BorderSizePixel  = 0
infoBar.ZIndex           = 3
Instance.new("UICorner", infoBar).CornerRadius = UDim.new(0, 7)

local infoLbl = Instance.new("TextLabel", infoBar)
infoLbl.Size               = UDim2.new(1, -10, 1, 0)
infoLbl.Position           = UDim2.new(0, 8, 0, 0)
infoLbl.BackgroundTransparency = 1
infoLbl.TextColor3         = Color3.fromRGB(80, 220, 130)
infoLbl.Font               = Enum.Font.Gotham
infoLbl.TextSize           = 12
infoLbl.TextXAlignment     = Enum.TextXAlignment.Left
infoLbl.Text               = "📦  Scanning..."
infoLbl.ZIndex             = 4

-- Button factory
local function newBtn(posY, bgColor)
    local b = Instance.new("TextButton", frame)
    b.Size             = UDim2.new(1, -16, 0, 34)
    b.Position         = UDim2.new(0, 8, 0, posY)
    b.BackgroundColor3 = bgColor
    b.TextColor3       = Color3.new(1, 1, 1)
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 13
    b.Text             = ""
    b.AutoButtonColor  = false
    b.BorderSizePixel  = 0
    b.ZIndex           = 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local C_GREEN = Color3.fromRGB(20, 110, 40)
local C_GREY  = Color3.fromRGB(38, 38, 48)
local C_BLUE  = Color3.fromRGB(20, 70, 150)
local C_RED   = Color3.fromRGB(170, 28, 28)
local C_PURP  = Color3.fromRGB(100, 30, 160)

local hlBtn   = newBtn(86,  C_GREEN)
local tpBtn   = newBtn(128, C_BLUE)
local spBtn   = newBtn(170, C_GREY)
local ncBtn   = newBtn(212, C_GREY)
local autoBtn = newBtn(254, C_GREY)
local stopBtn = newBtn(300, C_RED)

hlBtn.Text   = "💡  Highlight  :  ON"
tpBtn.Text   = "📦  Teleport ke Terdekat"
spBtn.Text   = "⚡  Speed + Jump  :  OFF"
ncBtn.Text   = "👻  Noclip  :  OFF"
autoBtn.Text = "🤖  Auto Collect  :  OFF"
stopBtn.Text = "⏹  Stop All"

local hintLbl = Instance.new("TextLabel", frame)
hintLbl.Size               = UDim2.new(1, -16, 0, 14)
hintLbl.Position           = UDim2.new(0, 8, 1, -16)
hintLbl.BackgroundTransparency = 1
hintLbl.TextColor3         = Color3.fromRGB(55, 55, 70)
hintLbl.Font               = Enum.Font.Gotham
hintLbl.TextSize           = 11
hintLbl.TextXAlignment     = Enum.TextXAlignment.Left
hintLbl.Text               = "RightCtrl = hide/show"
hintLbl.ZIndex             = 3

-- =============================================
-- Minimize
-- =============================================
local function setMinimized(val)
    MINIMIZED        = val
    frame.Visible    = not val
    floatBtn.Visible = val
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

    applySpeed(LocalPlayer.Character)
    stopNoclip()
    clearHighlights()

    spBtn.Text             = "⚡  Speed + Jump  :  OFF"
    ncBtn.Text             = "👻  Noclip  :  OFF"
    hlBtn.Text             = "💡  Highlight  :  OFF"
    autoBtn.Text           = "🤖  Auto Collect  :  OFF"
    spBtn.BackgroundColor3 = C_GREY
    ncBtn.BackgroundColor3 = C_GREY
    hlBtn.BackgroundColor3 = C_GREY
    autoBtn.BackgroundColor3 = C_GREY

    stopBtn.Text             = "▶  Resume All"
    stopBtn.BackgroundColor3 = Color3.fromRGB(20, 100, 160)
    infoLbl.Text             = "⏹  Semua fitur dihentikan"
end

local function doResumeAll()
    STOPPED      = false
    HIGHLIGHT_ON = true

    hlBtn.Text             = "💡  Highlight  :  ON"
    hlBtn.BackgroundColor3 = C_GREEN
    stopBtn.Text             = "⏹  Stop All"
    stopBtn.BackgroundColor3 = C_RED
    infoLbl.Text             = "▶  Resumed — scanning..."
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
    if #foundModels == 0 then
        infoLbl.Text = "⚠  Tidak ada collect terdeteksi"
        return
    end

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
    tpBtn.BackgroundColor3 = Color3.fromRGB(140, 90, 10)

    local dir = (nearest.Position - hrp.Position).Unit
    hrp.CFrame = CFrame.new(hrp.Position + dir * 8 + Vector3.new(0, 3, 0))
    task.wait(0.7)
    hrp.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 4, 0))

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
        if not folder then
            infoLbl.Text = "⚠  Path tidak ditemukan"
            continue
        end

        clearHighlights()
        foundModels = {}
        local nearest, bestDist = nil, math.huge

        for _, model in ipairs(folder:GetChildren()) do
            local prompt = getPromptFromModel(model)
            if prompt then
                local bp = model.PrimaryPart
                    or model:FindFirstChildWhichIsA("BasePart", true)
                if bp then
                    local d = (bp.Position - hrp.Position).Magnitude
                    if d <= SCAN_RADIUS then
                        table.insert(foundModels, model)
                        if d < bestDist then
                            nearest, bestDist = model, d
                        end

                        -- Auto collect: kalau dalam radius 4 stud
                        if AUTO_ON and d <= AUTO_RADIUS then
                            firePrompt(prompt)
                        end
                    end
                end
            end
        end

        -- Highlight
        if HIGHLIGHT_ON then
            for _, model in ipairs(foundModels) do
                addHighlight(model, model == nearest)
            end
        end

        if nearest then
            local autoStatus = AUTO_ON and "  |  🤖 auto ON" or ""
            infoLbl.Text = string.format(
                "📦  %d collect  |  Terdekat: %.0f studs%s",
                #foundModels, bestDist, autoStatus
            )
        else
            infoLbl.Text = "📦  Tidak ada collect terdeteksi"
        end
    end
end)
