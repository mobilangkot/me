-- ================================================================
--  DEBUG SCRIPT v2: PrompDetective & onDetectiveDied
--  Fix: InvokeServer pakai timeout agar tidak hang selamanya
-- ================================================================

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP                = Players.LocalPlayer

local Remotes         = ReplicatedStorage:WaitForChild("Remotes", 10)


--sdf
local PrompDetective  = Remotes and Remotes:FindFirstChild("PromptDetective")
local onDetectiveDied = Remotes and Remotes:FindFirstChild("onDetectiveDied")

-- ================================================================
--  GUI 
-- ================================================================
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "DebugRemote2"; gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 460, 0, 560)
frame.Position = UDim2.new(0.5,-230,0.5,-280)
frame.BackgroundColor3 = Color3.fromRGB(8,8,12)
frame.BorderSizePixel = 0; frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(35,35,50)

local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1,0,0,36)
titleBar.BackgroundColor3 = Color3.fromRGB(16,16,24)
titleBar.BorderSizePixel = 0
Instance.new("UICorner",titleBar).CornerRadius = UDim.new(0,10)
local tp = Instance.new("Frame",titleBar)
tp.Size=UDim2.new(1,0,0.5,0);tp.Position=UDim2.new(0,0,0.5,0)
tp.BackgroundColor3=Color3.fromRGB(16,16,24);tp.BorderSizePixel=0

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size=UDim2.new(1,-40,1,0);titleLbl.Position=UDim2.new(0,10,0,0)
titleLbl.BackgroundTransparency=1
titleLbl.Text="🛠  Remote Debugger v2 — timeout-safe invoke"
titleLbl.TextColor3=Color3.fromRGB(200,200,200)
titleLbl.Font=Enum.Font.GothamBold;titleLbl.TextSize=10
titleLbl.TextXAlignment=Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton",titleBar)
closeBtn.Size=UDim2.new(0,22,0,22);closeBtn.Position=UDim2.new(1,-28,0.5,-11)
closeBtn.BackgroundColor3=Color3.fromRGB(40,12,12)
closeBtn.TextColor3=Color3.fromRGB(200,60,60)
closeBtn.Font=Enum.Font.GothamBold;closeBtn.TextSize=12;closeBtn.Text="✕"
closeBtn.BorderSizePixel=0;closeBtn.AutoButtonColor=false
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,5)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Status
local statusLbl = Instance.new("TextLabel",frame)
statusLbl.Size=UDim2.new(1,-16,0,22);statusLbl.Position=UDim2.new(0,8,0,40)
statusLbl.BackgroundColor3=Color3.fromRGB(14,14,20);statusLbl.BorderSizePixel=0
statusLbl.Font=Enum.Font.Code;statusLbl.TextSize=10
statusLbl.TextColor3=Color3.fromRGB(140,140,160)
statusLbl.TextXAlignment=Enum.TextXAlignment.Left
statusLbl.Text="  Mengecek..."
Instance.new("UICorner",statusLbl).CornerRadius=UDim.new(0,5)

-- ================================================================
--  TOMBOL HELPER
-- ================================================================
local function mkBtn(label, x, y, w, color, tc)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0, w, 0, 28)
    b.Position = UDim2.new(0, x, 0, y)
    b.BackgroundColor3 = color or Color3.fromRGB(20,20,32)
    b.TextColor3 = tc or Color3.fromRGB(180,180,200)
    b.Font = Enum.Font.GothamBold; b.TextSize = 10; b.Text = label
    b.BorderSizePixel = 0; b.AutoButtonColor = false
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)
    Instance.new("UIStroke",b).Color=Color3.fromRGB(35,35,55)
    return b
end

local W = 214
-- Row 1: PrompDetective
local btn_inv0   = mkBtn("📞 Invoke (kosong)",      8,  68, W, Color3.fromRGB(15,25,50), Color3.fromRGB(100,160,255))
local btn_invArg = mkBtn("📞 Invoke (arg LP)",      8+W+8, 68, W, Color3.fromRGB(15,25,50), Color3.fromRGB(100,160,255))
-- Row 2
local btn_invStr = mkBtn('📞 Invoke ("collect")',   8,  100, W, Color3.fromRGB(15,25,50), Color3.fromRGB(100,160,255))
local btn_invNum = mkBtn("📞 Invoke (1, true)",     8+W+8,100, W, Color3.fromRGB(15,25,50), Color3.fromRGB(100,160,255))
-- Row 3: onDetectiveDied
local btn_listen = mkBtn("👂 Listen ON/OFF",        8,  132, W, Color3.fromRGB(15,35,20), Color3.fromRGB(80,210,120))
local btn_fire   = mkBtn("🔥 FireServer (test)",    8+W+8,132, W, Color3.fromRGB(40,15,15), Color3.fromRGB(220,100,80))
-- Row 4: util
local btn_insp   = mkBtn("🔍 Inspect",              8,  164, W, Color3.fromRGB(20,20,28), Color3.fromRGB(160,130,210))
local btn_clear  = mkBtn("🗑  Clear",               8+W+8,164, W, Color3.fromRGB(18,18,22), Color3.fromRGB(100,100,120))

-- Timeout slider label
local timeoutLbl = Instance.new("TextLabel", frame)
timeoutLbl.Size=UDim2.new(1,-16,0,16);timeoutLbl.Position=UDim2.new(0,8,0,197)
timeoutLbl.BackgroundTransparency=1
timeoutLbl.Text="⏱  Invoke timeout: 5 detik  (ubah CFG.invokeTimeout di script)"
timeoutLbl.TextColor3=Color3.fromRGB(70,70,90)
timeoutLbl.Font=Enum.Font.Code;timeoutLbl.TextSize=9
timeoutLbl.TextXAlignment=Enum.TextXAlignment.Left

-- Log scroll
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size=UDim2.new(1,-16,0,330);scroll.Position=UDim2.new(0,8,0,216)
scroll.BackgroundColor3=Color3.fromRGB(11,11,16);scroll.BorderSizePixel=0
scroll.ScrollBarThickness=4
scroll.ScrollBarImageColor3=Color3.fromRGB(50,50,70)
scroll.CanvasSize=UDim2.new(0,0,0,0)
Instance.new("UICorner",scroll).CornerRadius=UDim.new(0,6)

local layout = Instance.new("UIListLayout",scroll)
layout.Padding=UDim.new(0,1);layout.SortOrder=Enum.SortOrder.LayoutOrder
local uipad = Instance.new("UIPadding",scroll)
uipad.PaddingLeft=UDim.new(0,6);uipad.PaddingTop=UDim.new(0,4)
uipad.PaddingRight=UDim.new(0,6)

-- ================================================================
--  LOG
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
    lbl.Font = Enum.Font.Code; lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    task.defer(function()
        local h = layout.AbsoluteContentSize.Y + 10
        scroll.CanvasSize = UDim2.new(0,0,0,h)
        scroll.CanvasPosition = Vector2.new(0,h)
    end)
end

local function logOk(t)   log("✅ "..t, Color3.fromRGB(80,210,130))   end
local function logErr(t)  log("❌ "..t, Color3.fromRGB(220,80,80))    end
local function logInfo(t) log("ℹ  "..t, Color3.fromRGB(100,150,220))  end
local function logWarn(t) log("⚠  "..t, Color3.fromRGB(220,170,60))   end
local function logData(t) log("→  "..t, Color3.fromRGB(180,140,255))  end
local function logSep()   log(string.rep("─",55), Color3.fromRGB(30,30,45)) end

-- ================================================================
--  SERIALIZE — tampilkan return value sejelas mungkin
-- ================================================================
local function serialize(v, depth)
    depth = depth or 0
    if depth > 4 then return "..." end
    local t = typeof(v)
    if v == nil          then return "nil" end
    if t == "boolean"    then return tostring(v) end
    if t == "number"     then return tostring(v) end
    if t == "string"     then return '"'..v..'"' end
    if t == "Instance"   then
        local ok,n = pcall(function() return v:GetFullName() end)
        return "["..v.ClassName.."] "..(ok and n or v.Name)
    end
    if t == "table" then
        if next(v) == nil then return "{}" end
        local parts = {}
        for k, val in pairs(v) do
            local ks = (type(k)=="string") and k or "["..tostring(k).."]"
            table.insert(parts, ks.." = "..serialize(val, depth+1))
        end
        return "{ "..table.concat(parts, ", ").." }"
    end
    if t == "Vector3"    then return string.format("Vector3(%.2f, %.2f, %.2f)", v.X,v.Y,v.Z) end
    if t == "CFrame"     then return string.format("CFrame(%.1f,%.1f,%.1f)", v.X,v.Y,v.Z) end
    if t == "EnumItem"   then return tostring(v) end
    return "("..t..") "..tostring(v)
end

local function logResult(returnVals)
    if returnVals == nil then
        logData("Return: nil")
        return
    end
    if type(returnVals) == "table" then
        if #returnVals == 0 and next(returnVals) == nil then
            logData("Return: (table kosong / void)")
        else
            for i, v in ipairs(returnVals) do
                logData("Return["..i.."]: "..serialize(v))
            end
            -- kalau ada key non-numerik
            for k, v in pairs(returnVals) do
                if type(k) ~= "number" then
                    logData("Return."..tostring(k)..": "..serialize(v))
                end
            end
        end
    else
        logData("Return: "..serialize(returnVals))
    end
end

-- ================================================================
--  INVOKE DENGAN TIMEOUT
--  Pakai coroutine terpisah agar tidak hang UI/loop utama
--  Kalau timeout → anggap server tidak punya OnServerInvoke handler
-- ================================================================
local CFG = { invokeTimeout = 5 }  -- detik, ubah sesuai kebutuhan

local invoking = false

local function safeInvoke(label, ...)
    if not PrompDetective then logErr("PrompDetective tidak ada"); return end
    if invoking then logWarn("Invoke sebelumnya masih berjalan, tunggu..."); return end

    local args = {...}
    invoking = true
    logSep()
    logInfo("InvokeServer: "..label)
    if #args > 0 then
        local argStrs = {}
        for _, a in ipairs(args) do table.insert(argStrs, serialize(a)) end
        logData("Argumen: "..table.concat(argStrs, ", "))
    else
        logData("Argumen: (kosong)")
    end
    logInfo("Menunggu response server (timeout "..CFG.invokeTimeout.."s)...")

    -- Jalankan invoke di coroutine terpisah
    local done   = false
    local result = nil
    local errMsg = nil

    task.spawn(function()
        local ok, ret = pcall(function()
            -- Kalau args ada, unpack; kalau tidak, kosong
            if #args > 0 then
                return PrompDetective:InvokeServer(table.unpack(args))
            else
                return PrompDetective:InvokeServer()
            end
        end)
        if ok then
            result = ret
        else
            errMsg = ret
        end
        done = true
    end)

    -- Tunggu dengan timeout
    local elapsed = 0
    local step    = 0.1
    while not done and elapsed < CFG.invokeTimeout do
        task.wait(step)
        elapsed += step
    end

    if not done then
        -- Timeout — invoke masih nge-hang di server
        logErr("TIMEOUT setelah "..CFG.invokeTimeout.."s!")
        logWarn("Kemungkinan penyebab:")
        logWarn("  1. Server tidak punya OnServerInvoke callback")
        logWarn("  2. Server punya callback tapi butuh kondisi tertentu")
        logWarn("  3. Server menunggu argumen spesifik sebelum return")
        logInfo("Coroutine invoke masih hidup di background (akan hang sampai game tutup)")
        logInfo("Coba variasi argumen yang berbeda atau inspect server-side script")
    elseif errMsg then
        logErr("InvokeServer error: "..tostring(errMsg))
        logInfo("Kemungkinan: server reject argumen atau remote tidak punya handler")
    else
        logOk("InvokeServer BERHASIL! Server merespons.")
        -- Tampilkan hasil selengkap mungkin
        if result == nil then
            logData("Server return: nil (handler ada tapi return kosong)")
        elseif type(result) == "table" then
            logOk("Server return TABLE:")
            for k, v in pairs(result) do
                logData("  ["..tostring(k).."] = "..serialize(v))
            end
        else
            logData("Server return: "..serialize(result))
            logData("Type: "..typeof(result))
        end
    end

    logSep()
    invoking = false
end

-- ================================================================
--  LISTEN onDetectiveDied
-- ================================================================
local listening   = false
local listenConn  = nil

local function toggleListen()
    if not onDetectiveDied then logErr("onDetectiveDied tidak ada"); return end

    if listening then
        if listenConn then listenConn:Disconnect(); listenConn = nil end
        listening = false
        btn_listen.Text = "👂 Listen ON/OFF"
        btn_listen.TextColor3 = Color3.fromRGB(80,210,120)
        logWarn("Listener onDetectiveDied DIMATIKAN")
    else
        listening = true
        btn_listen.Text = "👂 Listening... (klik stop)"
        btn_listen.TextColor3 = Color3.fromRGB(60,240,100)

        listenConn = onDetectiveDied.OnClientEvent:Connect(function(...)
            local args = {...}
            logSep()
            logOk("onDetectiveDied FIRED dari server!")
            logInfo("Jumlah argumen: "..#args)
            if #args == 0 then
                logData("(tidak ada argumen)")
            else
                for i, v in ipairs(args) do
                    logData("Arg["..i.."] typeof="..typeof(v).."  val="..serialize(v))
                end
            end
            logSep()
        end)
        logOk("Listener onDetectiveDied AKTIF — menunggu server fire event ini...")
    end
end

-- ================================================================
--  FIRE SERVER (test arah sebaliknya)
-- ================================================================
local function testFireServer()
    if not onDetectiveDied then logErr("onDetectiveDied tidak ada"); return end
    logSep()
    logInfo("FireServer() pada onDetectiveDied...")
    logWarn("Event ini biasanya SERVER → CLIENT.")
    logWarn("FireServer jarang punya handler, tapi dicoba untuk debug.")
    local ok, err = pcall(function()
        onDetectiveDied:FireServer()
    end)
    if ok then
        logOk("FireServer terkirim tanpa error di sisi client")
        logInfo("Cek server output untuk konfirmasi apakah ada OnServerEvent handler")
    else
        logErr("FireServer error: "..tostring(err))
    end
    logSep()
end

-- ================================================================
--  INSPECT
-- ================================================================
local function inspect()
    logSep()
    logInfo("=== INSPECT ===")

    local function ins(obj, name)
        if not obj then logErr(name.." = nil / tidak ditemukan"); return end
        logOk(name.." ditemukan")
        logData("  ClassName : "..obj.ClassName)
        logData("  FullPath  : "..obj:GetFullName())
        local ch = obj:GetChildren()
        if #ch > 0 then
            logInfo("  Children:")
            for _, c in ipairs(ch) do
                logData("    ["..c.ClassName.."] "..c.Name)
            end
        else
            logInfo("  Children: (tidak ada)")
        end
    end

    ins(PrompDetective, "PrompDetective (RemoteFunction)")
    ins(onDetectiveDied, "onDetectiveDied (RemoteEvent)")

    -- Tampilkan semua isi Remotes folder untuk konteks
    if Remotes then
        logInfo("--- Semua isi Remotes ---")
        for _, obj in ipairs(Remotes:GetChildren()) do
            logData("  ["..obj.ClassName.."] "..obj.Name)
        end
    end
    logSep()
end

-- ================================================================
--  BIND TOMBOL
-- ================================================================
btn_inv0.MouseButton1Click:Connect(function()
    safeInvoke("kosong")
end)

btn_invArg.MouseButton1Click:Connect(function()
    safeInvoke("arg=LocalPlayer", LP)
end)

btn_invStr.MouseButton1Click:Connect(function()
    safeInvoke('"collect"', "collect")
end)

btn_invNum.MouseButton1Click:Connect(function()
    safeInvoke("1, true", 1, true)
end)

btn_listen.MouseButton1Click:Connect(toggleListen)
btn_fire.MouseButton1Click:Connect(testFireServer)
btn_insp.MouseButton1Click:Connect(inspect)
btn_clear.MouseButton1Click:Connect(function()
    for _, c in ipairs(scroll:GetChildren()) do
        if c:IsA("TextLabel") then c:Destroy() end
    end
    logIdx = 0; scroll.CanvasSize = UDim2.new(0,0,0,0)
    logInfo("Log dibersihkan")
end)

-- ================================================================
--  INIT
-- ================================================================
task.spawn(function()
    task.wait(0.3)
    logSep()
    logInfo("Remote Debugger v2 siap")

    local s1 = PrompDetective  and "📞 PrompDetective ["..PrompDetective.ClassName.."] ✓"  or "📞 PrompDetective ✗"
    local s2 = onDetectiveDied and "  📡 onDetectiveDied ["..onDetectiveDied.ClassName.."] ✓" or "  📡 onDetectiveDied ✗"

    if PrompDetective then logOk(s1) else logErr(s1) end
    if onDetectiveDied then logOk(s2) else logErr(s2) end

    statusLbl.Text = "  "..s1..s2
    statusLbl.TextColor3 = (PrompDetective and onDetectiveDied)
        and Color3.fromRGB(80,200,130)
        or  Color3.fromRGB(220,130,60)

    logSep()
    logInfo("Auto-listen onDetectiveDied aktif...")
    toggleListen()
    logSep()
    logInfo("Siap. Klik tombol Invoke untuk test PrompDetective.")
    logWarn("Jika invoke timeout → server butuh argumen/kondisi tertentu.")
end)
