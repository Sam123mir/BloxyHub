--[[
    BLOXY HUB TITANIUM - UI: TAB DASHBOARD
    Panel principal con estadísticas
]]

local DashboardTab = {}

function DashboardTab:Create(Window, deps)
    local Utils = deps.Utils
    local Session = deps.Session
    local ThreadManager = deps.ThreadManager
    local Colors = deps.Colors
    
    local Tab = Window:Tab({
        Title = Utils:Translate("Dashboard"),
        Icon = "solar:home-2-bold",
        IconColor = Colors.Blue,
        IconShape = "Square",
        Border = true
    })
    
    -- Sección de bienvenida
    local WelcomeSection = Tab:Section({
        Title = Utils:Translate("BIENVENIDO"),
        TextSize = 20,
        FontWeight = Enum.FontWeight.Bold
    })
    
    Tab:Section({
        Title = Utils:Translate("WelcomeContent"),
        TextSize = 14,
        TextTransparency = 0.3
    })
    
    Tab:Space({ Columns = 2 })
    
    -- Estado del Script
    local StatusSection = Tab:Section({
        Title = Utils:Translate("EstadoScript"),
        Box = true,
        BoxBorder = true,
        Opened = true
    })
    
    local StatusLabel = StatusSection:Section({
        Title = Session.Status,
        TextSize = 16
    })
    
    local InfoLabel = StatusSection:Section({
        Title = string.format("FPS: %d | Ping: %dms | Uptime: %s", 
            Session.FPS, Session.Ping, Session.Uptime),
        TextSize = 12,
        TextTransparency = 0.4
    })
    
    Tab:Space()
    
    -- Estadísticas de Sesión
    local StatsSection = Tab:Section({
        Title = Utils:Translate("SesionStats"),
        Box = true,
        BoxBorder = true,
        Opened = true
    })
    
    local StatsLabel = StatsSection:Section({
        Title = string.format(
            "Niveles: +%d | Beli: +%d | Fragments: +%d | Mobs: %d",
            Session.LevelsGained, Session.BeliEarned, 
            Session.FragmentsEarned, Session.MobsKilled
        ),
        TextSize = 14
    })
    
    Tab:Space()
    
    -- Mundo Actual
    local _, worldName = Utils:GetCurrentWorld()
    local WorldSection = Tab:Section({
        Title = Utils:Translate("MundoActual") .. ": " .. worldName,
        Box = true,
        BoxBorder = true
    })
    
    -- Guardar referencias para actualización
    DashboardTab.StatusLabel = StatusLabel
    DashboardTab.InfoLabel = InfoLabel
    DashboardTab.StatsLabel = StatsLabel
    DashboardTab.Session = Session
    DashboardTab.Utils = Utils
    DashboardTab.ThreadManager = ThreadManager
    
    return Tab
end

function DashboardTab:Update()
    if not self.Session then return end
    
    pcall(function()
        self.Session:Update()
        
        if self.StatusLabel then
            -- WindUI sections don't have SetContent, so we'd need to recreate
            -- For now, status updates go to Session.Status which is read by loops
        end
    end)
end

return DashboardTab
