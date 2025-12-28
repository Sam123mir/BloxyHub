--[[
    BLOXY HUB TITANIUM - TAB: DASHBOARD
    Panel principal con estadísticas
]]

local Dashboard = {}

function Dashboard:Create(Window, deps)
    local Core = deps.Core
    local Session = deps.Session
    
    local Tab = Window:Tab({ Title = "Dashboard", Icon = "home" })
    
    -- Header
    Tab:Section({ Title = "🎮 BLOXY HUB TITANIUM" })
    Tab:Section({ Title = "Script profesional para Blox Fruits" })
    
    -- Estado
    local StateSection = Tab:Section({ Title = "📊 Estado", Box = true })
    
    StateSection:Button({
        Title = "📊 Actualizar Stats",
        Callback = function()
            deps.WindUI:Notify({
                Title = "Stats Actuales",
                Content = string.format(
                    "FPS: %d | Ping: %dms | Hora Lima: %s\nNivel: %d | Beli: %d | Fragmentos: %s\nMundo: %s | Uptime: %s",
                    Session.FPS, Session.Ping, Session:GetLimaTime(),
                    Session:GetCurrentLevel(), Session:GetCurrentBeli(), Session:GetFragments(),
                    Core.GetWorldName(), Session:GetUptime()
                ),
                Duration = 5
            })
        end
    })
    
    StateSection:Button({
        Title = "⏱️ Ver Ganancias de Sesión",
        Callback = function()
            deps.WindUI:Notify({
                Title = "Ganancias",
                Content = string.format(
                    "Niveles ganados: +%d\nMobs eliminados: %d\nTiempo activo: %s",
                    Session:GetLevelsGained(),
                    Session.MobsKilled,
                    Session:GetUptime()
                ),
                Duration = 4
            })
        end
    })
    
    -- Perfil
    local ProfileSection = Tab:Section({ Title = "👤 Tu Perfil", Box = true })
    ProfileSection:Section({ Title = Core.LocalPlayer.DisplayName })
    ProfileSection:Section({ Title = "@" .. Core.LocalPlayer.Name })
    
    return Tab
end

return Dashboard
