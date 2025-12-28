--[[
    BLOXY HUB TITANIUM - TAB: BOSS FARM
    Farming de bosses
]]

local BossFarm = {}

local SelectedBoss = ""

function BossFarm:Create(Window, deps)
    local Core = deps.Core
    local Farming = deps.Farming
    local Combat = deps.Combat
    
    local Tab = Window:Tab({ Title = "Boss Farm", Icon = "skull" })
    
    Tab:Section({ Title = "👹 Boss Farm" })
    
    SelectedBoss = Core.tableBoss[1] or ""
    
    Tab:Dropdown({
        Title = "Select Boss",
        Values = Core.tableBoss,
        Callback = function(value)
            SelectedBoss = value
        end
    })
    
    Tab:Toggle({
        Title = "Auto Kill Boss",
        Default = false,
        Callback = function(value)
            _G.AutoBoss = value
            if value then
                Farming:StartAutoBoss(SelectedBoss)
            end
        end
    })
    
    -- Lista de bosses disponibles
    Tab:Section({ Title = "📋 Bosses en " .. Core.GetWorldName() })
    
    for i, boss in ipairs(Core.tableBoss) do
        if i <= 10 then -- Máximo 10 para no saturar
            Tab:Button({
                Title = "🎯 " .. boss,
                Callback = function()
                    SelectedBoss = boss
                    deps.WindUI:Notify({
                        Title = "Boss",
                        Content = "Boss seleccionado: " .. boss,
                        Duration = 2
                    })
                end
            })
        end
    end
    
    return Tab
end

return BossFarm
