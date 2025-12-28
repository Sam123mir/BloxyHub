--[[
    BLOXY HUB TITANIUM - UI: TAB PERFORMANCE
    Optimización de rendimiento
]]

local PerformanceTab = {}

function PerformanceTab:Create(Window, deps)
    local Utils = deps.Utils
    local Config = deps.Config
    local Performance = deps.Performance
    local Colors = deps.Colors
    
    local Tab = Window:Tab({
        Title = Utils:Translate("Rendimiento"),
        Icon = "solar:cpu-bold",
        IconColor = Colors.Yellow,
        IconShape = "Square",
        Border = true
    })
    
    -- Sección Optimización
    local OptSection = Tab:Section({
        Title = Utils:Translate("PerformanceOptimization"),
        Box = true,
        BoxBorder = true,
        Opened = true
    })
    
    OptSection:Toggle({
        Title = Utils:Translate("CPUMode"),
        Desc = "Remueve texturas y efectos para mejor rendimiento",
        Default = Config.Performance.CPUMode,
        Flag = "CPUMode",
        Callback = function(value)
            Config.Performance.CPUMode = value
            if value then
                Performance:ApplyCPUMode()
            end
        end
    })
    
    OptSection:Space()
    
    OptSection:Toggle({
        Title = Utils:Translate("WhiteScreen"),
        Desc = "Desactiva renderizado 3D para FPS máximo",
        Default = Config.Performance.WhiteScreen,
        Flag = "WhiteScreen",
        Callback = function(value)
            Performance:ToggleWhiteScreen(value)
        end
    })
    
    OptSection:Space()
    
    OptSection:Toggle({
        Title = Utils:Translate("FPSBoost"),
        Desc = "Reduce calidad gráfica",
        Default = Config.Performance.FPSBoost,
        Flag = "FPSBoost",
        Callback = function(value)
            Config.Performance.FPSBoost = value
            if value then
                Performance:ApplyFPSBoost()
            end
        end
    })
    
    Tab:Space({ Columns = 2 })
    
    -- Info
    Tab:Section({
        Title = "💡 Consejo",
        TextSize = 14
    })
    
    Tab:Section({
        Title = "Si el juego está muy lento, activa 'Modo CPU' o 'FPS Boost'. La 'Pantalla Blanca' es el modo más extremo pero no podrás ver el juego.",
        TextSize = 12,
        TextTransparency = 0.4
    })
    
    return Tab
end

return PerformanceTab
