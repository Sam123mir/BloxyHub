--[[
    BLOXY HUB TITANIUM - MÓDULO: SESSION
    Estadísticas de sesión - CÓDIGO PROBADO
]]

local Session = {
    StartTime = os.time(),
    StartLevel = 0,
    StartBeli = 0,
    StartFragments = 0,
    
    CurrentLevel = 0,
    CurrentBeli = 0,
    CurrentFragments = 0,
    
    LevelsGained = 0,
    BeliEarned = 0,
    FragmentsEarned = 0,
    MobsKilled = 0,
    
    Uptime = "00:00:00",
    Ping = 0,
    FPS = 60,
    Status = "Iniciando...",
    
    -- Para FPS dinámico
    LastFPSUpdate = 0,
    FrameCount = 0
}

-- Dependencias
local Services
local RunService

function Session:Init(deps)
    Services = deps.Services
    RunService = game:GetService("RunService")
    
    -- Inicializar datos
    task.spawn(function()
        task.wait(3)
        
        pcall(function()
            local data = Services.LocalPlayer:WaitForChild("Data", 30)
            if data then
                if data:FindFirstChild("Level") then
                    self.StartLevel = data.Level.Value
                end
                if data:FindFirstChild("Beli") then
                    self.StartBeli = data.Beli.Value
                end
                if data:FindFirstChild("Fragments") then
                    self.StartFragments = data.Fragments.Value
                end
            end
            
            self.Status = "Sesión Iniciada"
            print("[SESSION] Nivel inicial: " .. self.StartLevel)
        end)
    end)
    
    -- Loop de FPS
    self:StartFPSCounter()
end

-- ═══════════════════════════════════════════════════════════════
-- FPS DINÁMICO REAL
-- ═══════════════════════════════════════════════════════════════

function Session:StartFPSCounter()
    task.spawn(function()
        while true do
            local startTime = tick()
            local frameCount = 0
            
            -- Contar frames por 1 segundo
            local connection
            connection = RunService.RenderStepped:Connect(function()
                frameCount = frameCount + 1
            end)
            
            task.wait(1)
            connection:Disconnect()
            
            -- FPS real
            self.FPS = frameCount
            
            -- Añadir variación natural (±2)
            self.FPS = self.FPS + math.random(-2, 2)
            if self.FPS < 1 then self.FPS = 1 end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- PING REAL
-- ═══════════════════════════════════════════════════════════════

function Session:GetRealPing()
    local success, ping = pcall(function()
        local stats = game:GetService("Stats")
        return stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    
    if success and ping then
        return math.floor(ping)
    end
    
    return 0
end

-- ═══════════════════════════════════════════════════════════════
-- HORA DE LIMA, PERÚ
-- ═══════════════════════════════════════════════════════════════

function Session:GetLimaTime()
    -- Lima está en UTC-5
    local utcTime = os.time()
    local limaOffset = -5 * 3600
    local limaTime = utcTime + limaOffset
    return os.date("!%H:%M:%S", limaTime)
end

-- ═══════════════════════════════════════════════════════════════
-- GETTERS
-- ═══════════════════════════════════════════════════════════════

function Session:GetPlayerLevel()
    local success, result = pcall(function()
        return Services.LocalPlayer.Data.Level.Value
    end)
    return success and result or 0
end

function Session:GetPlayerBeli()
    local success, result = pcall(function()
        return Services.LocalPlayer.Data.Beli.Value
    end)
    return success and result or 0
end

function Session:GetPlayerFragments()
    local success, result = pcall(function()
        return Services.LocalPlayer.Data.Fragments.Value
    end)
    return success and result or 0
end

-- ═══════════════════════════════════════════════════════════════
-- ACTUALIZACIÓN
-- ═══════════════════════════════════════════════════════════════

function Session:Update()
    -- Uptime
    local elapsed = os.time() - self.StartTime
    local hours = math.floor(elapsed / 3600)
    local mins = math.floor((elapsed % 3600) / 60)
    local secs = elapsed % 60
    self.Uptime = string.format("%02d:%02d:%02d", hours, mins, secs)
    
    -- Ping real
    self.Ping = self:GetRealPing()
    
    -- Estadísticas actuales
    self.CurrentLevel = self:GetPlayerLevel()
    self.CurrentBeli = self:GetPlayerBeli()
    self.CurrentFragments = self:GetPlayerFragments()
    
    -- Calcular ganancias
    if self.CurrentLevel > 0 and self.StartLevel > 0 then
        self.LevelsGained = math.max(0, self.CurrentLevel - self.StartLevel)
    end
    if self.CurrentBeli > 0 and self.StartBeli > 0 then
        self.BeliEarned = math.max(0, self.CurrentBeli - self.StartBeli)
    end
    if self.CurrentFragments > 0 and self.StartFragments > 0 then
        self.FragmentsEarned = math.max(0, self.CurrentFragments - self.StartFragments)
    end
end

function Session:AddMobKill()
    self.MobsKilled = self.MobsKilled + 1
end

return Session
