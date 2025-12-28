--[[
    BLOXY HUB TITANIUM - MÓDULO: STATS MANAGER
    Sistema de distribución automática de estadísticas
]]

local StatsManager = {}

-- Dependencias
local Services, Config, Utils

function StatsManager:Init(deps)
    Services = deps.Services
    Config = deps.Config
    Utils = deps.Utils
end

function StatsManager:DistributePoints(manual)
    if not Config.Stats.Enabled and not manual then return end
    
    local success, err = pcall(function()
        local data = Services.LocalPlayer:FindFirstChild("Data")
        if not data then return end
        
        local pointsVal = data:FindFirstChild("StatsPoints") or data:FindFirstChild("Points")
        if not pointsVal or pointsVal.Value <= 0 then 
            if manual then Utils:Notify("Stats", "No tienes puntos disponibles", 2) end
            return 
        end
        
        local activeStats = {}
        for stat, enabled in pairs(Config.Stats.Distribution) do
            if enabled then table.insert(activeStats, stat) end
        end
        
        if #activeStats == 0 then 
            if manual then Utils:Notify("Stats", "Selecciona al menos una estadística", 2) end
            return 
        end
        
        local points = pointsVal.Value
        local pointsPerStat = math.floor(points / #activeStats)
        
        if pointsPerStat > 0 then
            local remotes = Services.ReplicatedStorage:FindFirstChild("Remotes")
            if remotes and remotes:FindFirstChild("CommF_") then
                for _, stat in ipairs(activeStats) do
                    remotes.CommF_:InvokeServer("AddPoint", stat, pointsPerStat)
                end
            end
            Utils:Notify("Stats", "Puntos distribuidos correctamente", 2)
        end
    end)
    
    if not success then
        warn("[STATS ERROR] " .. tostring(err))
    end
end

function StatsManager:GetCurrentPoints()
    local data = Services.LocalPlayer:FindFirstChild("Data")
    if not data then return 0 end
    
    local pointsVal = data:FindFirstChild("StatsPoints") or data:FindFirstChild("Points")
    return pointsVal and pointsVal.Value or 0
end

return StatsManager
