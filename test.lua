-- Ganti fungsi walkTo dengan ini

local function walkTo(targetPos, label)
    local char = LocalPlayer.Character
    local hum  = resolveHum(char)
    local hrp2 = resolveHRP(char)
    if not hum or not hrp2 then return false end

    setStatus("🚶 " .. (label or "berjalan..."), Color3.fromRGB(80,180,255))

    local path = PathfindingService:CreatePath({
        AgentRadius         = 2,
        AgentHeight         = 5,
        AgentCanJump        = true,
        AgentCanClimb       = true,
        WaypointSpacing     = 3,
        -- Ini kuncinya: cost untuk terrain & part
        Costs = {
            Water   = 100,  -- hindari air
            Plastic = 1,    -- part biasa ok
        }
    })

    local MAX_RETRY = 3
    local attempt   = 0

    ::retry::
    attempt += 1
    if attempt > MAX_RETRY then
        -- Fallback terakhir: teleport pelan bertahap
        setStatus("⚠ Path gagal — gerak bertahap", Color3.fromRGB(255,200,60))
        local steps = 5
        for i = 1, steps do
            if not AI_ON then return false end
            local t = i / steps
            local midPos = hrp2.Position:Lerp(targetPos, t)
            hum:MoveTo(midPos)
            hum.MoveToFinished:Wait(3)
        end
        return true
    end

    local ok = pcall(function()
        path:ComputeAsync(hrp2.Position, targetPos)
    end)

    if not ok or path.Status ~= Enum.PathStatus.Success then
        -- Coba dari posisi sedikit diangkat (kadang masalah terrain)
        local liftedStart = hrp2.Position + Vector3.new(0, 3, 0)
        pcall(function() path:ComputeAsync(liftedStart, targetPos) end)

        if path.Status ~= Enum.PathStatus.Success then
            task.wait(0.5)
            goto retry
        end
    end

    local waypoints  = path:GetWaypoints()
    local stuckTimer = 0
    local lastPos    = hrp2.Position

    for i, wp in ipairs(waypoints) do
        if not AI_ON then return false end

        if wp.Action == Enum.PathWaypointAction.Jump then
            hum.Jump = true
            task.wait(0.1)
        end

        hum:MoveTo(wp.Position)

        -- Tunggu dengan deteksi stuck
        local timeout  = 3
        local interval = 0.2
        local elapsed  = 0
        local reached  = false

        while elapsed < timeout do
            task.wait(interval)
            elapsed += interval

            local curPos = resolveHRP(LocalPlayer.Character)
            if not curPos then break end
            curPos = curPos.Position

            local distToWP = (curPos - wp.Position).Magnitude
            if distToWP < 2.5 then
                reached = true
                break
            end

            -- Cek stuck: tidak bergerak lebih dari 1 stud dalam 1 detik
            local moved = (curPos - lastPos).Magnitude
            if moved < 0.5 then
                stuckTimer += interval
            else
                stuckTimer = 0
            end
            lastPos = curPos

            if stuckTimer >= 1.2 then
                -- Stuck! Coba jump dan recompute
                setStatus("⚠ Stuck! Mencoba lagi...", Color3.fromRGB(255,200,60))
                hum.Jump = true
                task.wait(0.4)
                stuckTimer = 0

                -- Recompute dari posisi sekarang
                local newHRP = resolveHRP(LocalPlayer.Character)
                if newHRP then
                    goto retry
                end
            end
        end

        if not reached and i < #waypoints then
            -- Waypoint tidak tercapai tapi lanjut ke berikutnya
            -- (mungkin masih bisa sampai tujuan)
        end
    end

    -- Cek apakah benar-benar sampai tujuan
    local finalHRP = resolveHRP(LocalPlayer.Character)
    if finalHRP then
        local finalDist = (finalHRP.Position - targetPos).Magnitude
        if finalDist > 10 then
            -- Masih jauh, coba lagi
            task.wait(0.3)
            goto retry
        end
    end

    return true
end
