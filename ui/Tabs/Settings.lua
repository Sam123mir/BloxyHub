--[[
    BLOXY HUB TITANIUM - UI: TAB SETTINGS
    Configuración general
]]

local SettingsTab = {}

function SettingsTab:Create(Window, deps)
    local Utils = deps.Utils
    local Config = deps.Config
    local Colors = deps.Colors
    local WindUI = deps.WindUI
    local BloxyHub = deps.BloxyHub
    
    local Tab = Window:Tab({
        Title = Utils:Translate("Ajustes"),
        Icon = "solar:settings-bold",
        IconColor = Colors.Grey,
        IconShape = "Square",
        Border = true
    })
    
    -- Sección Configuración
    local ConfigSection = Tab:Section({
        Title = Utils:Translate("Configuracion"),
        Box = true,
        BoxBorder = true,
        Opened = true
    })
    
    ConfigSection:Dropdown({
        Title = Utils:Translate("Idioma"),
        Values = {"Spanish", "English", "Portuguese"},
        Value = Config.UI.Language,
        Flag = "Language",
        Callback = function(value)
            Config.UI.Language = value
            Utils:Notify(Utils:Translate("RestartRequired"), Utils:Translate("IdiomaCambiado"), 5)
        end
    })
    
    ConfigSection:Space()
    
    ConfigSection:Toggle({
        Title = Utils:Translate("Notificaciones"),
        Default = Config.UI.Notifications,
        Flag = "Notifications",
        Callback = function(value)
            Config.UI.Notifications = value
        end
    })
    
    Tab:Space({ Columns = 2 })
    
    -- Info del Script
    local InfoSection = Tab:Section({
        Title = "📋 Información",
        Box = true,
        BoxBorder = true,
        Opened = true
    })
    
    InfoSection:Section({
        Title = "Blox Fruits Panel",
        TextSize = 16,
        FontWeight = Enum.FontWeight.Bold
    })
    
    InfoSection:Section({
        Title = "Brand: BLOXY HUB\nCategory: Premium Titanium\nVersion: " .. Config.Version .. "\nDeveloped by Sammir",
        TextSize = 12,
        TextTransparency = 0.3
    })
    
    Tab:Space({ Columns = 2 })
    
    -- Controles del Script
    local ControlSection = Tab:Section({
        Title = "🔧 Control del Script",
        Box = true,
        BoxBorder = true,
        Opened = true
    })
    
    ControlSection:Button({
        Title = Utils:Translate("ReiniciarPanel"),
        Icon = "refresh-cw",
        Color = Colors.Yellow,
        Callback = function()
            Utils:Notify("System", Utils:Translate("Restating3s"), 3)
            task.wait(3)
            if BloxyHub and BloxyHub.Restart then
                BloxyHub.Restart()
            end
        end
    })
    
    ControlSection:Space()
    
    ControlSection:Button({
        Title = Utils:Translate("CerrarScript"),
        Icon = "x",
        Color = Colors.Red,
        Callback = function()
            if BloxyHub and BloxyHub.Shutdown then
                BloxyHub.Shutdown()
            end
        end
    })
    
    return Tab
end

return SettingsTab
