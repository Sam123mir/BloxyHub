--[[
    BLOXY HUB TITANIUM - UI: TAB PLAYER
    Mejoras del jugador
]]

local PlayerTab = {}

function PlayerTab:Create(Window, deps)
    local Utils = deps.Utils
    local Config = deps.Config
    local Colors = deps.Colors
    
    local Tab = Window:Tab({
        Title = Utils:Translate("Personaje"),
        Icon = "solar:user-bold",
        IconColor = Colors.Purple,
        IconShape = "Square",
        Border = true
    })
    
    -- Sección Mejoras de Movilidad
    local MobilitySection = Tab:Section({
        Title = Utils:Translate("MobilityEnhancements"),
        Box = true,
        BoxBorder = true,
        Opened = true
    })
    
    MobilitySection:Toggle({
        Title = Utils:Translate("AutoAura"),
        Desc = "Activa Buso Haki automáticamente",
        Default = Config.Player.AutoAura,
        Flag = "AutoAura",
        Callback = function(value)
            Config.Player.AutoAura = value
        end
    })
    
    MobilitySection:Space()
    
    MobilitySection:Toggle({
        Title = Utils:Translate("InfiniteSkyjump"),
        Desc = "Salta infinitamente en el aire",
        Default = Config.Player.InfiniteSkyjump,
        Flag = "InfiniteSkyjump",
        Callback = function(value)
            Config.Player.InfiniteSkyjump = value
        end
    })
    
    Tab:Space({ Columns = 2 })
    
    -- Velocidad y Salto
    local SpeedSection = Tab:Section({
        Title = Utils:Translate("SpeedJump"),
        Box = true,
        BoxBorder = true,
        Opened = true
    })
    
    SpeedSection:Slider({
        Title = Utils:Translate("WalkSpeed"),
        Step = 1,
        Value = {
            Min = 16,
            Max = 200,
            Default = Config.Player.WalkSpeed
        },
        Flag = "WalkSpeed",
        Callback = function(value)
            Config.Player.WalkSpeed = value
        end
    })
    
    SpeedSection:Space()
    
    SpeedSection:Slider({
        Title = Utils:Translate("JumpPower"),
        Step = 1,
        Value = {
            Min = 50,
            Max = 300,
            Default = Config.Player.JumpPower
        },
        Flag = "JumpPower",
        Callback = function(value)
            Config.Player.JumpPower = value
        end
    })
    
    return Tab
end

return PlayerTab
