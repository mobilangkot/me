-- ================================================================
--  Inspector: DetectivePick & DetectiveSystem
--  Cara: require ModuleScript → dump semua key/function yang di-return
--  Note: .Source tidak accessible di runtime (Roblox blokir)
-- ================================================================

local Players     = game:GetService("Players")
local LP          = Players.LocalPlayer

-- ================================================================
--  GUI
-- ================================================================
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "ScriptInspector"; gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,500,0,560)
frame.Position = UDim2.new(0.5,-250,0.5,-280)
frame.BackgroundColor3 = Color3.fromRGB(8,8,12)
frame.BorderSizePixel = 0; frame.Active = true; frame.Draggable = true
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke",frame).Color = Color3.fromRGB(35,35,50)

local titleBar = Instance.new("Frame",frame)
titleBar.Size = UDim2.new(1,0,0,36); titleBar.BackgroundColor3 = Color3.fromRGB(16,16,24)
titleBar.BorderSizePixel = 0
Instance.new("UICorner",titleBar).CornerRadius = UDim.new(0,10)
local tp = Instance.new("Frame",titleBar)
tp.Size=UDim2.new(1,0,0.5,0);tp.Position=UDim2.new(0,0,0.5,0)
tp.BackgroundColor3=Color3.fromRGB(16,16,24);tp.BorderSizePixel=0

local titleLbl = Instance.new("TextLabel",titleBar)
titleLbl.Size=UDim2.new(1,-40,1,0);titleLbl.Position=UDim2.new(0,10,0,0)
titleLbl.BackgroundTransparency=1;titleLbl.Text="🔬  Script Inspector — DetectivePick & DetectiveSystem"
titleLbl.TextColor3=Color3.fromRGB(200,200,200);titleLbl.Font=Enum.Font.GothamBold
titleLbl.TextSize=10;titleLbl.TextXAlignment=Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton",titleBar)
closeBtn.Size=UDim2.new(0,22,0,22);closeBtn.Position=UDim2.new(1,-28,0.5,-11)
closeBtn.BackgroundColor3=Color3.fromRGB(40,12,12);closeBtn.TextColor3=Color3.fromRGB(200,60,60)
closeBtn.Font=Enum.Font.GothamBold;closeBtn.TextSize=12;closeBtn.Text="✕"
closeBtn.BorderSizePixel=0;closeBtn.AutoButtonColor=false
Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,5)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Tombol
local function mkBtn(label, x, yPos, w, color, tc)
    local b = Instance.new("TextButton",frame)
    b.Size=UDim2.new(0,w,0,26);b.Position=UDim2.new(0,x,0,yPos)
    b.BackgroundColor3=color or Color3.fromRGB(18,18,28)
    b.TextColor3=tc or Color3.fromRGB(170,170,200)
    b.Font=Enum.Font.GothamBold;b.TextSize=10;b.Text=label
    b.BorderSizePixel=0;b.AutoButtonColor=false
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    Instance.new("UIStroke",b).Color=Color3.fromRGB(35,35,55)
    return b
end

local BW = 155
local btn_pick   = mkBtn("🔬 Dump DetectivePick",   8,  42, BW, Color3.fromRGB(15,25,45), Color3.fromRGB(100,160,255))
local btn_sys    = mkBtn("🔬 Dump DetectiveSystem",  8+BW+4, 42, BW, Color3.fromRGB(15,35,20), Color3.fromRGB(80,210,120))
local btn_find   = mkBtn("🗺  Find Semua Detective",  8+BW*2+8, 42, BW, Color3.fromRGB(30,20,45), Color3.fromRGB(180,130,255))
local btn_clear  = mkBtn("🗑  Clear",                8+BW*3+12, 42, 60, Color3.fromRGB(18,18,22), Color3.fromRGB(100,100,120))

-- Scroll log
local scroll = Instance.new("ScrollingFrame",frame)
scroll.Size=UDim2.new(1,-16,0,490);scroll.Position=UDim2.new(0,8,0,74)
scroll.BackgroundColor3=Color3.fromRGB(11,11,16);scroll.BorderSizePixel=0
scroll.ScrollBarThickness=4;scroll.ScrollBarImageColor3=Color3.fromRGB(50,50,70)
scroll.CanvasSize=UDim2.new(0,0,0,0)
Instance.new("UICorner",scroll).CornerRadius=UDim.new(0,6)

local layout = Instance.new("UIListLayout",scroll)
layout.Padding=UDim.new(0,1);layout.SortOrder=Enum.SortOrder.LayoutOrder
local uipad = Instance.new("UIPadding",scroll)
uipad.PaddingLeft=UDim.new(0,6);uipad.PaddingTop=UDim.new(0,4);uipad.PaddingRight=UDim.new(0,6)

-- ================================================================
--  LOG
-- ================================================================
local logIdx = 0
local function log(text, color)
    logIdx += 1
    local lbl = Instance.new("TextLabel",scroll)
    lbl.LayoutOrder=logIdx;lbl.Size=UDim2.new(1,-4,0,0)
    lbl.AutomaticSize=Enum.AutomaticSize.Y;lbl.BackgroundTransparency=1
    lbl.Text=os.date("[%H:%M:%S] ")..tostring(text)
    lbl.TextColor3=color or Color3.fromRGB(160,160,180)
    lbl.Font=Enum.Font.Code;lbl.TextSize=10
    lbl.TextXAlignment=Enum.TextXAlignment.Left;lbl.TextWrapped=true
    task.defer(function()
        local h=layout.AbsoluteContentSize.Y+10
        scroll.CanvasSize=UDim2.new(0,0,0,h)
        scroll.CanvasPosition=Vector2.new(0,h)
    end)
end

local C = {
    ok    = Color3.fromRGB(80,210,130),
    err   = Color3.fromRGB(220,80,80),
    info  = Color3.fromRGB(100,150,220),
    warn  = Color3.fromRGB(220,170,60),
    data  = Color3.fromRGB(180,140,255),
    sep   = Color3.fromRGB(30,30,45),
    fn    = Color3.fromRGB(255,180,80),    -- fungsi
    tbl   = Color3.fromRGB(80,200,200),    -- table
    str   = Color3.fromRGB(150,220,100),   -- string
    num   = Color3.fromRGB(200,160,255),   -- number
}

local function logOk(t)   log("✅ "..t, C.ok)   end
local function logErr(t)  log("❌ "..t, C.err)  end
local function logInfo(t) log("ℹ  "..t, C.info) end
local function logWarn(t) log("⚠  "..t, C.warn) end
local function logSep()   log(string.rep("─",60), C.sep) end

-- ================================================================
--  DUMP TABLE (hasil require)
--  Rekursif 1 level untuk tabel di dalam tabel
-- ================================================================
local function dumpTable(tbl, prefix, depth)
    depth = depth or 0
    prefix = prefix or ""
    if depth > 3 then log(prefix.."  ...(terlalu dalam)", C.sep); return end

    if type(tbl) ~= "table" then
        log(prefix.."(bukan table: "..type(tbl)..")", C.warn)
        return
    end

    local keys = {}
    for k in pairs(tbl) do table.insert(keys, k) end
    table.sort(keys, function(a,b)
        return tostring(a) < tostring(b)
    end)

    if #keys == 0 then
        log(prefix.."  (table kosong)", C.sep)
        return
    end

    for _, k in ipairs(keys) do
        local v = tbl[k]
        local t = type(v)
        local kStr = tostring(k)

        if t == "function" then
            log(prefix.."  🔧 "..kStr.." = function()", C.fn)

        elseif t == "table" then
            local subCount = 0
            for _ in pairs(v) do subCount += 1 end
            log(prefix.."  📦 "..kStr.." = table ("..subCount.." key)", C.tbl)
            -- Satu level lebih dalam untuk tabel
            if depth < 2 then
                dumpTable(v, prefix.."    ["..kStr.."]", depth+1)
            end

        elseif t == "string" then
            -- Potong kalau terlalu panjang
            local disp = #v > 80 and (v:sub(1,80).."...") or v
            log(prefix..'  📝 '..kStr..' = "'..disp..'"', C.str)

        elseif t == "number" then
            log(prefix.."  🔢 "..kStr.." = "..tostring(v), C.num)

        elseif t == "boolean" then
            log(prefix.."  ⚡ "..kStr.." = "..tostring(v), C.data)

        elseif t == "userdata" or t == "Instance" then
            local ok2, cn = pcall(function() return v.ClassName end)
            log(prefix.."  🎮 "..kStr.." = Instance "..(ok2 and cn or "?"), C.data)

        else
            log(prefix.."  ◦ "..kStr.." = ("..t..") "..tostring(v), C.data)
        end
    end
end

-- ================================================================
--  CARI SCRIPT DI SELURUH CLIENT
-- ================================================================
local function findScript(nameContains)
    local results = {}
    local searchRoots = {
        LP:WaitForChild("PlayerScripts", 5),
        LP:WaitForChild("PlayerGui", 5),
        LP:WaitForChild("Backpack", 5),
        game:GetService("ReplicatedStorage"),
        game:GetService("ReplicatedFirst"),
        workspace,
    }
    for _, root in ipairs(searchRoots) do
        if not root then continue end
        local ok, descs = pcall(function() return root:GetDescendants() end)
        if not ok then continue end
        for _, obj in ipairs(descs) do
            local nameOk, n = pcall(function() return obj.Name end)
            if nameOk and string.find(string.lower(n), string.lower(nameContains)) then
                table.insert(results, obj)
            end
        end
    end
    return results
end

-- ================================================================
--  DUMP SCRIPT OBJECT (properties yang accessible)
-- ================================================================
local function dumpScriptObject(obj)
    logInfo("Class      : "..obj.ClassName)
    logInfo("FullPath   : "..obj:GetFullName())

    -- Coba baca .Source (biasanya blocked, tapi coba saja)
    local srcOk, src = pcall(function() return obj.Source end)
    if srcOk and src and #src > 0 then
        logOk("Source ACCESSIBLE! ("..#src.." karakter)")
        -- Print per baris, max 100 baris
        local lines = src:split("\n")
        local maxLines = math.min(#lines, 100)
        for i = 1, maxLines do
            log("  "..string.format("%3d",i).." │ "..lines[i], C.str)
        end
        if #lines > maxLines then
            logWarn("  ... ("..#lines-maxLines.." baris lagi dipotong)")
        end
    else
        logWarn("Source tidak bisa dibaca (Roblox blokir akses .Source di runtime)")
    end

    -- Coba disabled property
    local disOk, dis = pcall(function() return obj.Disabled end)
    if disOk then logInfo("Disabled   : "..tostring(dis)) end

    -- Cek children
    local ch = obj:GetChildren()
    if #ch > 0 then
        logInfo("Children ("..#ch.."):")
        for _, c in ipairs(ch) do
            log("  ["..c.ClassName.."] "..c.Name, C.data)
        end
    end
end

-- ================================================================
--  REQUIRE MODULE — dump semua yang di-return
-- ================================================================
local function tryRequire(moduleScript)
    logInfo("Mencoba require()...")
    local ok, result = pcall(require, moduleScript)
    if not ok then
        logErr("require() gagal: "..tostring(result))
        logWarn("Kemungkinan: module error, dependency missing, atau diprotect")
        return
    end

    local t = type(result)
    logOk("require() BERHASIL! Return type: "..t)

    if t == "table" then
        local count = 0
        for _ in pairs(result) do count += 1 end
        logOk("Table berisi "..count.." key:")
        logSep()
        dumpTable(result, "")
    elseif t == "function" then
        logOk("Module return FUNCTION langsung")
        -- Coba panggil tanpa argumen
        logInfo("Mencoba panggil function()...")
        local ok2, r2 = pcall(result)
        if ok2 then
            log("  Hasil: "..tostring(r2), C.ok)
        else
            logErr("Panggil gagal: "..tostring(r2))
        end
    else
        logInfo("Module return: "..tostring(result))
    end
end

-- ================================================================
--  AKSI DUMP DetectivePick
-- ================================================================
btn_pick.MouseButton1Click:Connect(function()
    logSep()
    logInfo("=== DUMP: DetectivePick (ModuleScript) ===")

    local results = findScript("DetectivePick")
    if #results == 0 then
        logErr("DetectivePick tidak ditemukan di client")
        logSep(); return
    end

    for _, obj in ipairs(results) do
        logSep()
        logOk("Ditemukan: "..obj:GetFullName())
        dumpScriptObject(obj)

        if obj.ClassName == "ModuleScript" then
            logSep()
            tryRequire(obj)
        end
    end
    logSep()
end)

-- ================================================================
--  AKSI DUMP DetectiveSystem
-- ================================================================
btn_sys.MouseButton1Click:Connect(function()
    logSep()
    logInfo("=== DUMP: DetectiveSystem (LocalScript) ===")

    local results = findScript("DetectiveSystem")
    if #results == 0 then
        logErr("DetectiveSystem tidak ditemukan di client")
        logSep(); return
    end

    for _, obj in ipairs(results) do
        logSep()
        logOk("Ditemukan: "..obj:GetFullName())
        dumpScriptObject(obj)

        -- LocalScript tidak bisa require, tapi coba cek globals yang di-expose
        logInfo("LocalScript tidak bisa di-require langsung.")
        logInfo("Mencari globals yang mungkin di-set oleh script ini...")

        -- Cek apakah script ini expose sesuatu via _G atau shared
        local function checkGlobals(tbl, name)
            if type(tbl) ~= "table" then return end
            for k, v in pairs(tbl) do
                local ks = tostring(k):lower()
                if string.find(ks, "detective") or string.find(ks, "evidence") then
                    log("  ["..name.."] "..tostring(k).." = "..tostring(v), C.fn)
                end
            end
        end

        local ok1, _ = pcall(checkGlobals, _G, "_G")
        local ok2, _ = pcall(checkGlobals, shared, "shared")
    end
    logSep()
end)

-- ================================================================
--  AKSI FIND SEMUA yang mengandung "detective"
-- ================================================================
btn_find.MouseButton1Click:Connect(function()
    logSep()
    logInfo("=== FIND SEMUA — keyword: detective, evidence ===")

    local keywords = {"detective", "evidence", "Detective", "Evidence"}
    local found = {}
    local checked = {}

    local searchRoots = {
        LP:WaitForChild("PlayerScripts", 5),
        LP:WaitForChild("PlayerGui", 5),
        LP:WaitForChild("Backpack", 5),
        game:GetService("ReplicatedStorage"),
        game:GetService("ReplicatedFirst"),
        workspace,
    }

    for _, root in ipairs(searchRoots) do
        if not root then continue end
        local ok, descs = pcall(function() return root:GetDescendants() end)
        if not ok then continue end
        for _, obj in ipairs(descs) do
            if checked[obj] then continue end
            checked[obj] = true
            local nameOk, n = pcall(function() return obj.Name end)
            if not nameOk then continue end
            for _, kw in ipairs(keywords) do
                if string.find(n, kw) then
                    table.insert(found, obj)
                    break
                end
            end
        end
    end

    logInfo("Total ditemukan: "..#found.." object")
    logSep()
    for _, obj in ipairs(found) do
        local icon = "◦"
        if obj.ClassName == "ModuleScript"  then icon = "📦" end
        if obj.ClassName == "LocalScript"   then icon = "📜" end
        if obj.ClassName == "Script"        then icon = "📜" end
        if obj.ClassName == "RemoteEvent"   then icon = "📡" end
        if obj.ClassName == "RemoteFunction"then icon = "📞" end
        if obj.ClassName == "Folder"        then icon = "📁" end
        log("  "..icon.." ["..obj.ClassName.."] "..obj:GetFullName(), C.data)
    end
    logSep()
end)

-- Clear
btn_clear.MouseButton1Click:Connect(function()
    for _, c in ipairs(scroll:GetChildren()) do
        if c:IsA("TextLabel") then c:Destroy() end
    end
    logIdx=0; scroll.CanvasSize=UDim2.new(0,0,0,0)
    logInfo("Log dibersihkan")
end)

-- ================================================================
--  INIT
-- ================================================================
task.spawn(function()
    task.wait(0.3)
    logSep()
    logInfo("Script Inspector siap.")
    logInfo("Klik tombol untuk dump isi module/script.")
    logWarn("Catatan: .Source diblokir Roblox di runtime.")
    logWarn("Yang bisa dibaca: hasil require() → semua function & variable yang di-export.")
    logSep()
end)
