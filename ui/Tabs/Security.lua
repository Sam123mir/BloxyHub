--[[
    BLOXY HUB TITANIUM - UI: TAB SECURITY
    Seguridad y anti-ban
]]

local SecurityTab = {}

function SecurityTab:Create(Window, deps)
    local Utils = deps.Utils
    local Config = deps.Config
    local Colors = deps.Colors
    
    local Tab = Window:Tab({
        Title = Utils:Translate("Seguridad"),
        Icon = "solar:shield-bold",
        IconColor = Colors.Green,
        IconShape = "Square",
        Border = true
    })
    
    -- Sección Protección
    local ProtSection = Tab:Section({
        Title = Utils:Translate("ProtectionAntiBan"),
        Box = true,
        BoxBorder = true,
        Opened = true
    })
    
    ProtSection:Toggle({
        Title = Utils:Translate("AntiAFK"),
        Desc = "Evita ser expulsado por inactividad",
        Default = Config.Security.AntiAFK,
        Flag = "AntiAFK",
        Callback = function(value)
            Config.Security.AntiAFK = value
        end
    })
    
    ProtSection:Space()
    
    ProtSection:Toggle({
        Title = Utils:Translate("AdminDetector"),
        Desc = "Detecta staff del juego en el servidor",
        Default = Config.Security.AdminDetector,
        Flag = "AdminDetector",
        Callback = function(value)
            Config.Security.AdminDetector = value
        end
    })
    
    ProtSection:Space()
    
    ProtSection:Toggle({
        Title = Utils:Translate("AutoLeaveAdmin"),
        Desc = "Sale automáticamente si detecta un admin",
        Default = Config.Security.AutoLeaveOnAdmin,
        Flag = "AutoLeaveAdmin",
        Callback = function(value)
            Config.Security.AutoLeaveOnAdmin = value
        end
    })
    
    Tab:Space({ Columns = 2 })
    
    -- Advertencia
    Tab:Section({
        Title = "⚠️ Advertencia",
        TextSize = 14
    })
    
    Tab:Section({
        Title = "El uso de scripts puede resultar en ban. Usa las funciones de seguridad para minimizar riesgos. Nunca uses en tu cuenta principal.",
        TextSize = 12,
        TextTransparency = 0.4
    })
    
    return Tab
end

return SecurityTab
