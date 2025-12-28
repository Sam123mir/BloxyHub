--[[
    BLOXY HUB TITANIUM - MÓDULO: SECURITY
    Sistema de seguridad y detección de admins
]]

local Security = {
    AdminHistory = {}
}

-- Dependencias
local Services, Config, Utils, LogSystem

function Security:Init(deps)
    Services = deps.Services
    Config = deps.Config
    Utils = deps.Utils
    LogSystem = deps.LogSystem
    
    -- Limpieza de caché cada 10 min
    task.spawn(function()
        while task.wait(600) do
            self.AdminHistory = {}
        end
    end)
end

function Security:DetectAdmin()
    if not Config.Security.AdminDetector then return false end
    
    for _, player in pairs(Services.Players:GetPlayers()) do
        if player ~= Services.LocalPlayer then
            -- Evitar chequeos redundantes
            if self.AdminHistory[player.UserId] then
                if self.AdminHistory[player.UserId].IsAdmin then return true end
                continue
            end
            
            local success, rank = pcall(function()
                return player:GetRankInGroup(Config.Security.StaffGroupId)
            end)
            
            if success then
                local isAdmin = rank and rank >= 1
                self.AdminHistory[player.UserId] = {
                    IsAdmin = isAdmin,
                    LastChecked = os.time()
                }
                
                if isAdmin then
                    local msg = string.format("Admin Detectado: %s (Rank: %d)", player.Name, rank)
                    Utils:Notify("⚠️ ALERTA", msg, 5)
                    if LogSystem then LogSystem:Add(msg, "SECURITY") end
                    
                    if Config.Security.AutoLeaveOnAdmin then
                        task.wait(2)
                        Services.LocalPlayer:Kick("🛡️ BLOXY HUB: Admin detectado. Servidor cerrado por seguridad.")
                    end
                    return true
                end
            end
        end
    end
    return false
end

function Security:RunAntiAFK()
    if not Config.Security.AntiAFK then return end
    
    pcall(function()
        Services.VirtualUser:CaptureController()
        Services.VirtualUser:ClickButton2(Vector2.new())
    end)
end

function Security:CheckNewPlayers()
    -- Verificar jugadores que entran al servidor
    Services.Players.PlayerAdded:Connect(function(player)
        if Config.Security.AdminDetector then
            task.delay(2, function()
                self:DetectAdmin()
            end)
        end
    end)
end

return Security
