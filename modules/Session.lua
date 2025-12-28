--[[
    BLOXY HUB TITANIUM - MÓDULO: SESSION
    Estadísticas de sesión del jugador
]]

local Session = {
    StartTime = os.time(),
    StartLevel = 0,
    StartBeli = 0,
    StartFragments = 0,
    
    LevelsGained = 0,
    BeliEarned = 0,
    FragmentsEarned = 0,
    MobsKilled = 0,
    BossesKilled = 0,
    
    Uptime = "00:00:00",
    Ping = 0,
    FPS = 60,
    Status = "Esperando Datos..."
}

-- Dependencias
local Services

function Session:Init(deps)
    Services = deps.Services
    
    -- Inicialización segura de estadísticas
    task.spawn(function()
        local data = Services.LocalPlayer:WaitForChild("Data", 20)
        if data then
            self.StartLevel = data:WaitForChild("Level", 10).Value
            self.StartBeli = data:WaitForChild("Beli", 10).Value
            self.StartFragments = data:WaitForChild("Fragments", 10).Value
            self.Status = "Sesión Iniciada"
        end
    end)
end

function Session:Update()
    pcall(function()
        local elapsed = os.time() - self.StartTime
        local hours = math.floor(elapsed / 3600)
        local mins = math.floor((elapsed % 3600) / 60)
        local secs = elapsed % 60
        
        self.Uptime = string.format("%02d:%02d:%02d", hours, mins, secs)
        
        local data = Services.LocalPlayer:FindFirstChild("Data")
        if data then
            if data:FindFirstChild("Level") then 
                self.LevelsGained = data.Level.Value - self.StartLevel 
            end
            if data:FindFirstChild("Beli") then 
                self.BeliEarned = data.Beli.Value - self.StartBeli 
            end
            if data:FindFirstChild("Fragments") then 
                self.FragmentsEarned = data.Fragments.Value - self.StartFragments 
            end
        end
        
        -- Ping
        local successPing, pingVal = pcall(function() 
            return Services.Stats.Network.ServerStatsItem:FindFirstChild("Data Ping"):GetValue() 
        end)
        if successPing then self.Ping = math.floor(pingVal) end
        
        -- FPS
        local successFPS, fpsVal = pcall(function() 
            return Services.Stats.FrameRateManager:FindFirstChild("RenderAverage"):GetValue() 
        end)
        if successFPS then self.FPS = math.floor(fpsVal) end
    end)
end

function Session:AddMobKill()
    self.MobsKilled = self.MobsKilled + 1
end

function Session:AddBossKill()
    self.BossesKilled = self.BossesKilled + 1
end

return Session
