--[[
    BLOXY HUB TITANIUM - UI: TAB LOGS
    Sistema de logs y depuración
]]

local LogsTab = {}

function LogsTab:Create(Window, deps)
    local Utils = deps.Utils
    local LogSystem = deps.LogSystem
    local Colors = deps.Colors
    local WindUI = deps.WindUI
    
    local Tab = Window:Tab({
        Title = Utils:Translate("Historial"),
        Icon = "solar:file-text-bold",
        IconColor = Colors.Grey,
        IconShape = "Square",
        Border = true
    })
    
    -- Sección Debug
    local DebugSection = Tab:Section({
        Title = Utils:Translate("SystemDebug"),
        Box = true,
        BoxBorder = true,
        Opened = true
    })
    
    -- Registro de actividad
    local LogContent = DebugSection:Section({
        Title = Utils:Translate("ActivityLog"),
        TextSize = 12
    })
    
    local LogDisplay = DebugSection:Section({
        Title = #LogSystem.Entries > 0 and table.concat(LogSystem.Entries, "\n") or "No hay logs registrados.",
        TextSize = 10,
        TextTransparency = 0.3
    })
    
    -- Guardar referencia para actualización
    LogSystem.UIElement = LogDisplay
    
    Tab:Space({ Columns = 2 })
    
    -- Botones de control
    local ControlGroup = Tab:Group({})
    
    ControlGroup:Button({
        Title = Utils:Translate("ClearHistory"),
        Icon = "trash",
        Color = Colors.Red,
        Callback = function()
            LogSystem:Clear()
            Utils:Notify("Logs", "Historial limpiado", 2)
        end
    })
    
    ControlGroup:Space()
    
    ControlGroup:Button({
        Title = Utils:Translate("CopyClipboard"),
        Icon = "clipboard",
        Callback = function()
            if LogSystem:CopyToClipboard() then
                Utils:Notify("Logs", "Historial copiado al portapapeles", 2)
            else
                Utils:Notify("Error", "No se pudo copiar. Intenta manualmente.", 3)
            end
        end
    })
    
    return Tab
end

return LogsTab
