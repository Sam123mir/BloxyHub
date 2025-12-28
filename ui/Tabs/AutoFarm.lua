--[[
    BLOXY HUB TITANIUM - TAB: AUTO FARM
    Sistema de farming automático
]]

local AutoFarm = {}

function AutoFarm:Create(Window, deps)
    local Core = deps.Core
    local Farming = deps.Farming
    local Combat = deps.Combat
    
    local Tab = Window:Tab({ Title = "Auto Farm", Icon = "zap" })
    
    -- Configuración
    Tab:Section({ Title = "⚙️ Configuración" })
    
    local listfastattack = {"0.01", "0.05", "0.015", "0.001", "0.1", "0.005", "0", "0.02"}
    
    Tab:Dropdown({
        Title = "Fast Attack Speed",
        Values = listfastattack,
        Value = "0.05",
        Callback = function(value)
            _G.Fast_Delay = tonumber(value) or 0.05
        end
    })
    
    Tab:Dropdown({
        Title = "Weapon Type",
        Values = {"Melee", "Sword", "Blox Fruit"},
        Value = "Melee",
        Callback = function(value)
            Core.ChooseWeapon = value
        end
    })
    
    -- Auto Farm Level
    Tab:Section({ Title = "🎯 Auto Farm Level" })
    
    Tab:Toggle({
        Title = "Auto Farm Level",
        Default = false,
        Callback = function(value)
            _G.AutoLevel = value
            if not value then
                Combat:CancelTween()
            end
        end
    })
    
    -- Kill Near
    Tab:Section({ Title = "🔄 Kill Near Mobs" })
    
    Tab:Toggle({
        Title = "Auto Kill Near Mob Aura",
        Default = false,
        Callback = function(value)
            _G.AutoNear = value
            if not value then
                Combat:CancelTween()
            end
        end
    })
    
    -- Safe Mode
    Tab:Section({ Title = "💡 Safe Mode" })
    
    Tab:Toggle({
        Title = "Auto Safe (Run when low HP)",
        Default = true,
        Callback = function(value)
            _G.SafeMode = value
        end
    })
    
    return Tab
end

return AutoFarm
