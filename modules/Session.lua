--[[
    BLOXY HUB TITANIUM - MÓDULO: SESSION
    Estadísticas de sesión
]]

local Session = {}

local Core = nil

Session.StartTime = os.time()
Session.StartLevel = 0
Session.MobsKilled = 0
Session.FPS = 60
Session.Ping = 0

function Session:Init(core)
    Core = core
    
    -- Obtener nivel inicial
    task.spawn(function()
        task.wait(3)
        pcall(function()
            Session.StartLevel = Core.LocalPlayer.Data.Level.Value
        end)
    end)
    
    -- FPS Counter
    self:StartFPSCounter()
    
    -- Ping Counter
    self:StartPingCounter()
end

function Session:StartFPSCounter()
    task.spawn(function()
        while true do
            local frames = 0
            local conn = Core.RunService.RenderStepped:Connect(function()
                frames = frames + 1
            end)
            task.wait(1)
            conn:Disconnect()
            Session.FPS = frames + math.random(-2, 2)
        end
    end)
end

function Session:StartPingCounter()
    task.spawn(function()
        while true do
            pcall(function()
                Session.Ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            task.wait(1)
        end
    end)
end

function Session:GetLimaTime()
    local utc = os.time()
    local lima = utc + (-5 * 3600)
    return os.date("!%H:%M:%S", lima)
end

function Session:GetUptime()
    local elapsed = os.time() - Session.StartTime
    local hours = math.floor(elapsed / 3600)
    local mins = math.floor((elapsed % 3600) / 60)
    local secs = elapsed % 60
    return string.format("%02d:%02d:%02d", hours, mins, secs)
end

function Session:GetCurrentLevel()
    local s, r = pcall(function() return Core.LocalPlayer.Data.Level.Value end)
    return s and r or 0
end

function Session:GetCurrentBeli()
    local s, r = pcall(function() return Core.LocalPlayer.Data.Beli.Value end)
    return s and r or 0
end

function Session:GetFragments()
    if Core.First_Sea then return "Sea 2+ requerido" end
    local s, r = pcall(function() return Core.LocalPlayer.Data.Fragments.Value end)
    return s and tostring(r) or "0"
end

function Session:GetLevelsGained()
    local current = self:GetCurrentLevel()
    if current > 0 and Session.StartLevel > 0 then
        return math.max(0, current - Session.StartLevel)
    end
    return 0
end

return Session
