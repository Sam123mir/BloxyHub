--[[
    BLOXY HUB TITANIUM - MÓDULO: LOG SYSTEM
    Sistema de depuración y registro de actividad
]]

local LogSystem = {
    Entries = {},
    MaxEntries = 50,
    UIElement = nil
}

local Services

function LogSystem:Init(deps)
    Services = deps.Services
    
    -- Captura automática de errores del script
    Services.LogService.MessageOut:Connect(function(msg, messageType)
        if messageType == Enum.MessageType.MessageError then
            if string.find(msg, "Bloxy") or string.find(msg, "Titanium") then
                self:Add(msg, "ERROR")
            end
        end
    end)
end

function LogSystem:Add(msg, logType)
    logType = logType or "INFO"
    local timestamp = os.date("%H:%M:%S")
    local entry = string.format("[%s] [%s] %s", timestamp, logType, msg)
    
    table.insert(self.Entries, 1, entry)
    if #self.Entries > self.MaxEntries then
        table.remove(self.Entries)
    end
    
    if self.UIElement then
        self:RefreshUI()
    end
    
    -- También imprimir a consola
    if logType == "ERROR" then
        warn(entry)
    else
        print(entry)
    end
end

function LogSystem:RefreshUI()
    if self.UIElement and self.UIElement.SetContent then
        local content = table.concat(self.Entries, "\n")
        self.UIElement:SetContent(content == "" and "No hay logs registrados." or content)
    end
end

function LogSystem:Clear()
    self.Entries = {}
    self:RefreshUI()
end

function LogSystem:GetLogs()
    return table.concat(self.Entries, "\n")
end

function LogSystem:CopyToClipboard()
    local allLogs = self:GetLogs()
    
    local methods = {
        setclipboard, 
        toclipboard, 
        set_clipboard, 
        (Clipboard and Clipboard.set)
    }
    
    for _, method in ipairs(methods) do
        if method then
            local success = pcall(function() method(allLogs) end)
            if success then return true end
        end
    end
    
    return false
end

return LogSystem
