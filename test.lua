-- ================================================================
--  DEBUG SCRIPT: PrompDetective & onDetectiveDied
--  Tujuan: inspect, listen, dan test invoke/fire remote
-- ================================================================

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP                = Players.LocalPlayer

-- ================================================================
--  AMBIL REMOTE 
-- ================================================================
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)

local PrompDetective  = Remotes and Remotes:FindFirstChild("PromptDetective")   -- RemoteFunction
local onDetectiveDied = Remotes and Remotes:FindFirstChild("onDetectiveDied")  -- RemoteEvent

-- ================================================================
--  GUI
-- ================================================================
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "DebugRemote"; gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 460, 0, 540)
frame.Position = UDim2.new(0.5, -230, 0.5, -270)
frame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
frame.BorderSizePixel = 0
frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(35, 35, 50)

-- Title
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)
local tpatch = Instance.new("Frame", titleBar)
tpatch.Size = UDim2.new(1,0,0.5,0); tpatch.Position = UDim2.new(0,0,0.5,0)
tpatch.BackgroundColor3 = Color3.fromRGB(16,16,24); tpatch.BorderSizePixel = 0

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size = UDim2.new(1,-40,1,0); titleLbl.Position = UDim2.new(0,10,0,0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "🛠  Remote Debugger — PrompDetective & onDetectiveDied"
titleLbl.TextColor3 = Color3.fromRGB(200,200,200)
titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextSize = 10
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0,22,0,22); closeBtn.Position = UDim2.new(1,-28,0.5,-11)
closeBtn.BackgroundColor3 = Color3.fromRGB(40,12,12)
closeBtn.TextColor3 = Color3.fromRGB(200,60,60)
closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 12; closeBtn.Text = "✕"
closeBtn.BorderSizePixel = 0; closeBtn.AutoButtonColor = false
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,5)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Status row (apakah remote ditemukan)
local statusLbl = Instance.new("TextLabel", frame)
statusLbl.Size = UDim2.new(1,-16,0,28); statusLbl.Position = UDim2.new(0,8,0,40)
statusLbl.BackgroundColor3 = Color3.fromRGB(14,14,20)
statusLbl.BorderSizePixel = 0
statusLbl.Font = Enum.Font.Code; statusLbl.TextSize = 10
statusLbl.TextColor3 = Color3.fromRGB(150,150,170)
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Text = "  Mengecek remote..."
Instance.new("UICorner", statusLbl).CornerRadius = UDim.new(0,6)

-- Tombol-tombol aksi
local function mkBtn(label, yPos, color, textColor)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.5,-12,0,30); b.Position = UDim2.new(0,8,0,yPos)
    b.BackgroundColor3 = color or Color3.fromRGB(20,20,32)
    b.TextColor3 = textColor or Color3.fromRGB(180,180,200)
    b.Font = Enum.Font.GothamBold; b.TextSize = 10; b.Text = label
    b.BorderSizePixel = 0; b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,7)
    Instance.new("UIStroke", b).Color = Color3.fromRGB(35,35,55)
    return b
end

local function mkBtn2(label, yPos, color, textColor)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0.5,-12,0,30); b.Position = UDim2.new(0.5,4,0,yPos)
    b.BackgroundColor3 = color or Color3.fromRGB(20,20,32)
    b.TextColor3 = textColor or Color3.fromRGB(180,180,200)
    b.Font = Enum.Font.GothamBold; b.TextSize = 10; b.Text = label
    b.BorderSizePixel = 0; b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,7)
    Instance.new("UIStroke", b).Color = Color3.fromRGB(35,35,55)
    return b
end

-- Row 1: PrompDetective (RemoteFunction)
local invokeBtn     = mkBtn( "📞 InvokeServer (kosong)",   74, Color3.fromRGB(20,30,50), Color3.fromRGB(100,160,255))
local invokeArgBtn  = mkBtn2("📞 InvokeServer (arg test)", 74, Color3.fromRGB(20,30,50), Color3.fromRGB(100,160,255))

-- Row 2: onDetectiveDied (RemoteEvent)
local listenBtn     = mkBtn( "👂 Listen onDetectiveDied",  110, Color3.fromRGB(20,40,25), Color3.fromRGB(80,200,120))
local fireBtn       = mkBtn2("🔥 FireServer (test)",       110, Color3.fromRGB(40,20,20), Color3.fromRGB(220,100,80))

-- Row 3: util
local clearBtn      = mkBtn( "🗑  Clear Log",              146, Color3.fromRGB(18,18,24), Color3.fromRGB(100,100,120))
local inspectBtn    = mkBtn2("🔍 Inspect Properties",      146, Color3.fromRGB(18,18,24), Color3.fromRGB(150,130,200))

-- Log area
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1,-16,0,340); scroll.Position = UDim2.new(0,8,0,184)
scroll.BackgroundColor3 = Color3.fromRGB(11,11,16)
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(50,50,70)
scroll.CanvasSize = UDim2.new(0,0,0,0)
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0,6)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,1)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local uipad = Instance.new("UIPadding", scroll)
uipad.PaddingLeft = UDim.new(0,6); uipad.PaddingTop = UDim.new(0,4)
uipad.PaddingRight = UDim.new(0,6)

-- ================================================================
--  LOG SYSTEM
-- ================================================================
local logIdx = 0

local function log(text, color)
    logIdx += 1
    local lbl = Instance.new("TextLabel", scroll)
    lbl.LayoutOrder = logIdx
    lbl.Size = UDim2.new(1,-4,0,0)
    lbl.AutomaticSize = Enum.AutomaticSize.Y
    lbl.BackgroundTransparency = 1
    lbl.Text = os.date("[%H:%M:%S] ") .. tostring(text)
    lbl.TextColor3 = color or Color3.fromRGB(160,160,180)
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true

    task.defer(function()
        local h = layout.AbsoluteContentSize.Y + 10
        scroll.CanvasSize = UDim2.new(0,0,0,h)
        scroll.CanvasPosition = Vector2.new(0,h)
    end)
end

local function logSep()
    log(string.rep("─", 55), Color3.fromRGB(35,35,50))
end

local function logOk(t)   log("✅ " .. t, Color3.fromRGB(80,210,130))  end
local function logErr(t)  log("❌ " .. t, Color3.fromRGB(220,80,80))   end
local function logInfo(t) log("ℹ  " .. t, Color3.fromRGB(100,150,220)) end
local function logWarn(t) log("⚠  " .. t, Color3.fromRGB(220,170,60)) end
local function logData(t) log("→  " .. t, Color3.fromRGB(180,140,255)) end

-- ================================================================
--  CEK REMOTE SAAT INIT
-- ================================================================
local function serializeValue(v)
    local t = typeof(v)
    if t == "nil"     then return "nil" end
    if t == "boolean" then return tostring(v) end
    if t == "number"  then return tostring(v) end
    if t == "string"  then return '"' .. v .. '"' end
    if t == "table"   then
        local parts = {}
        for k, val in pairs(v) do
            table.insert(parts, tostring(k) .. "=" .. serializeValue(val))
        end
        return "{" .. table.concat(parts, ", ") .. "}"
    end
    if t == "Instance" then return "[" .. v.ClassName .. "] " .. v.Name end
    return "(" .. t .. ") " .. tostring(v)
end

local function checkRemotes()
    logSep()
    logInfo("Cek remote di ReplicatedStorage.Remotes...")

    if not Remotes then
        logErr("ReplicatedStorage.Remotes TIDAK DITEMUKAN")
        statusLbl.Text = "  ❌ Remotes folder tidak ada"
        statusLbl.TextColor3 = Color3.fromRGB(220,80,80)
        return
    end
    logOk("Remotes folder ditemukan")

    -- PrompDetective
    if PrompDetective then
        logOk("PrompDetective → " .. PrompDetective.ClassName)
        logData("Path: " .. PrompDetective:GetFullName())
    else
        logErr("PrompDetective TIDAK DITEMUKAN di Remotes")
    end

    -- onDetectiveDied
    if onDetectiveDied then
        logOk("onDetectiveDied → " .. onDetectiveDied.ClassName)
        logData("Path: " .. onDetectiveDied:GetFullName())
    else
        logErr("onDetectiveDied TIDAK DITEMUKAN di Remotes")
    end

    -- Update status bar
    local s1 = PrompDetective  and "📞 PrompDetective ✓" or "📞 PrompDetective ✗"
    local s2 = onDetectiveDied and "  |  📡 onDetectiveDied ✓" or "  |  📡 onDetectiveDied ✗"
    statusLbl.Text = "  " .. s1 .. s2
    statusLbl.TextColor3 = Color3.fromRGB(140,200,160)
    logSep()
end

-- ================================================================
--  LISTEN onDetectiveDied (auto dari awal)
-- ================================================================
local listening = false
local listenerConn = nil

local function startListen()
    if not onDetectiveDied then
        logErr("onDetectiveDied tidak ada, tidak bisa listen")
        return
    end
    if listening then
        logWarn("Sudah listening — koneksi sebelumnya tetap aktif")
        return
    end

    listening = true
    listenBtn.Text = "👂 Listening... (ON)"
    listenBtn.TextColor3 = Color3.fromRGB(60,220,100)

    listenerConn = onDetectiveDied.OnClientEvent:Connect(function(...)
        local args = {...}
        logSep()
        logOk("onDetectiveDied FIRED dari server!")
        if #args == 0 then
            logInfo("Tidak ada argumen")
        else
            for i, v in ipairs(args) do
                logData("Arg[" .. i .. "] = " .. serializeValue(v))
            end
        end
        logSep()
    end)
    logOk("Listener onDetectiveDied aktif — menunggu event dari server...")
end

-- ================================================================
--  TOMBOL ACTIONS
-- ================================================================

-- InvokeServer tanpa argumen
invokeBtn.MouseButton1Click:Connect(function()
    if not PrompDetective then logErr("PrompDetective tidak ada"); return end
    logSep()
    logInfo("InvokeServer() — tanpa argumen...")
    local ok, result = pcall(function()
        return PrompDetective:InvokeServer()
    end)
    if ok then
        logOk("InvokeServer berhasil!")
        logData("Return: " .. serializeValue(result))
    else
        logErr("InvokeServer gagal: " .. tostring(result))
    end
    logSep()
end)

-- InvokeServer dengan beberapa argumen test
invokeArgBtn.MouseButton1Click:Connect(function()
    if not PrompDetective then logErr("PrompDetective tidak ada"); return end
    logSep()
    logInfo("InvokeServer(LP, 'test', 1, true) — dengan argumen test...")
    local ok, result = pcall(function()
        return PrompDetective:InvokeServer(LP, "test", 1, true)
    end)
    if ok then
        logOk("InvokeServer berhasil!")
        logData("Return: " .. serializeValue(result))
    else
        logErr("InvokeServer gagal: " .. tostring(result))
    end
    logSep()
end)

-- Toggle listen
listenBtn.MouseButton1Click:Connect(function()
    if listening then
        if listenerConn then listenerConn:Disconnect(); listenerConn = nil end
        listening = false
        listenBtn.Text = "👂 Listen onDetectiveDied"
        listenBtn.TextColor3 = Color3.fromRGB(80,200,120)
        logWarn("Listener dimatikan")
    else
        startListen()
    end
end)

-- FireServer onDetectiveDied (test — biasanya server yang fire ini ke client,
-- tapi kita coba FireServer kalau ada handler di server)
fireBtn.MouseButton1Click:Connect(function()
    if not onDetectiveDied then logErr("onDetectiveDied tidak ada"); return end
    logSep()
    logInfo("Mencoba FireServer pada onDetectiveDied...")
    logWarn("Catatan: RemoteEvent ini biasanya di-fire oleh SERVER ke client,")
    logWarn("bukan sebaliknya. FireServer mungkin tidak ada handler-nya.")
    local ok, err = pcall(function()
        onDetectiveDied:FireServer()
    end)
    if ok then
        logOk("FireServer terkirim (tidak ada error client-side)")
        logInfo("Cek output server untuk konfirmasi apakah ada handler")
    else
        logErr("FireServer error: " .. tostring(err))
    end
    logSep()
end)

-- Inspect properties
inspectBtn.MouseButton1Click:Connect(function()
    logSep()
    logInfo("=== INSPECT PROPERTIES ===")

    local function inspectRemote(obj, name)
        if not obj then logErr(name .. " → nil"); return end
        logOk(name .. " [" .. obj.ClassName .. "]")
        logData("  Name:     " .. obj.Name)
        logData("  FullPath: " .. obj:GetFullName())

        -- Cek apakah ada children
        local children = obj:GetChildren()
        if #children > 0 then
            logInfo("  Children (" .. #children .. "):")
            for _, c in ipairs(children) do
                logData("    - [" .. c.ClassName .. "] " .. c.Name)
            end
        else
            logInfo("  Children: (kosong)")
        end
    end

    inspectRemote(PrompDetective, "PrompDetective")
    inspectRemote(onDetectiveDied, "onDetectiveDied")

    -- Scan semua isi Remotes folder untuk konteks
    if Remotes then
        logInfo("--- Semua isi Remotes ---")
        for _, obj in ipairs(Remotes:GetChildren()) do
            logData("  [" .. obj.ClassName .. "] " .. obj.Name)
        end
    end
    logSep()
end)

-- Clear log
clearBtn.MouseButton1Click:Connect(function()
    for _, c in ipairs(scroll:GetChildren()) do
        if c:IsA("TextLabel") then c:Destroy() end
    end
    logIdx = 0
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    logInfo("Log dibersihkan")
end)

-- ================================================================
--  INIT
-- ================================================================
task.spawn(function()
    task.wait(0.3)
    checkRemotes()
    task.wait(0.2)
    -- Auto mulai listen dari awal
    startListen()
    logInfo("Auto-listen aktif. Tekan tombol untuk test invoke/fire.")
end)
