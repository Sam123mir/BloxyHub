--[[
    BLOXY HUB TITANIUM - UI: TAB FARMING
    Configuración de auto-farm
]]

local FarmingTab = {}

function FarmingTab:Create(Window, deps)
    local Utils = deps.Utils
    local Config = deps.Config
    local Colors = deps.Colors
    
    local Tab = Window:Tab({
        Title = Utils:Translate("Farming"),
        Icon = "solar:sword-bold",
        IconColor = Colors.Orange,
        IconShape = "Square",
        Border = true
    })
    
    -- Sección Auto Farm
    local AutoFarmSection = Tab:Section({
        Title = Utils:Translate("AutoFarm"),
        Box = true,
        BoxBorder = true,
        Opened = true
    })
    
    AutoFarmSection:Toggle({
        Title = Utils:Translate("AutoFarmLvl"),
        Desc = "Farmea automáticamente mobs según tu nivel",
        Default = Config.AutoFarm.Enabled,
        Flag = "AutoFarmToggle",
        Callback = function(value)
            Config.AutoFarm.Enabled = value
            Config.AutoFarm.Mode = "Level"
        end
    })
    
    AutoFarmSection:Space()
    
    AutoFarmSection:Toggle({
        Title = "🎯 Modo Seguro",
        Desc = "Teletransporte con altura para evitar detección",
        Default = Config.AutoFarm.SafeMode,
        Flag = "SafeModeToggle",
        Callback = function(value)
            Config.AutoFarm.SafeMode = value
        end
    })
    
    Tab:Space({ Columns = 2 })
    
    -- Sección Mastery
    local MasterySection = Tab:Section({
        Title = "⚔️ Mastery",
        Box = true,
        BoxBorder = true,
        Opened = true
    })
    
    MasterySection:Toggle({
        Title = "Auto Mastery",
        Desc = "Entrena maestría de armas automáticamente",
        Default = Config.Mastery.Enabled,
        Flag = "MasteryToggle",
        Callback = function(value)
            Config.Mastery.Enabled = value
        end
    })
    
    MasterySection:Space()
    
    MasterySection:Dropdown({
        Title = Utils:Translate("SeleccionarArma"),
        Values = {"Melee", "Sword", "Blox Fruit", "Gun"},
        Value = Config.AIMastery.SelectedWeapon,
        Flag = "WeaponSelect",
        Callback = function(value)
            Config.AIMastery.SelectedWeapon = value
        end
    })
    
    MasterySection:Space()
    
    MasterySection:Toggle({
        Title = Utils:Translate("ModoIA"),
        Desc = "Rotación inteligente de habilidades",
        Default = Config.AIMastery.Enabled,
        Flag = "AIMasteryToggle",
        Callback = function(value)
            Config.AIMastery.Enabled = value
        end
    })
    
    Tab:Space({ Columns = 2 })
    
    -- Sección de Habilidades
    local SkillsSection = Tab:Section({
        Title = Utils:Translate("Habilidades"),
        Box = true,
        BoxBorder = true,
        Opened = true
    })
    
    local skillsGroup = SkillsSection:Group({})
    
    for _, key in ipairs({"Z", "X", "C", "V"}) do
        skillsGroup:Toggle({
            Title = key,
            Default = Config.AIMastery.Skills[key],
            Flag = "Skill" .. key,
            Callback = function(value)
                Config.AIMastery.Skills[key] = value
            end
        })
        skillsGroup:Space()
    end
    
    return Tab
end

return FarmingTab
