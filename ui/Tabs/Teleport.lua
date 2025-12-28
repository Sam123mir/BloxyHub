--[[
    BLOXY HUB TITANIUM - TAB: TELEPORT
    Sistema de teleportación
]]

local TeleportTab = {}

function TeleportTab:Create(Window, deps)
    local Core = deps.Core
    local Teleport = deps.Teleport
    local Combat = deps.Combat
    
    local Tab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
    
    local SelectedIsland = Core.IslandList[1] or ""
    local SelectedPlayer = ""
    
    -- Islands
    Tab:Section({ Title = "🗺️ Teleport to Islands" })
    
    Tab:Dropdown({
        Title = "Select Island",
        Values = Core.IslandList,
        Callback = function(value)
            SelectedIsland = value
        end
    })
    
    Tab:Button({
        Title = "Teleport to Island",
        Callback = function()
            Teleport:ToIsland(SelectedIsland)
            deps.WindUI:Notify({
                Title = "Teleport",
                Content = "Teleportando a " .. SelectedIsland .. "...",
                Duration = 2
            })
        end
    })
    
    -- Players
    Tab:Section({ Title = "👤 Teleport to Player" })
    
    local PlayerList = Teleport:GetPlayerList()
    if #PlayerList > 0 then
        SelectedPlayer = PlayerList[1]
    end
    
    Tab:Dropdown({
        Title = "Select Player",
        Values = PlayerList,
        Callback = function(value)
            SelectedPlayer = value
        end
    })
    
    Tab:Button({
        Title = "Teleport to Player",
        Callback = function()
            Teleport:ToPlayer(SelectedPlayer)
            deps.WindUI:Notify({
                Title = "Teleport",
                Content = "Teleportando a " .. SelectedPlayer,
                Duration = 2
            })
        end
    })
    
    Tab:Button({
        Title = "Refresh Player List",
        Callback = function()
            PlayerList = Teleport:GetPlayerList()
            deps.WindUI:Notify({ Title = "Teleport", Content = "Lista actualizada!", Duration = 2 })
        end
    })
    
    -- Special Locations
    if Core.Third_Sea then
        Tab:Section({ Title = "🌟 Special Locations" })
        
        Tab:Button({
            Title = "🦊 Kitsune Island",
            Callback = function()
                Teleport:ToKitsune()
            end
        })
        
        Tab:Button({
            Title = "🏴‍☠️ Tiki Outpost",
            Callback = function()
                Teleport:ToIsland("Tiki Outpost")
            end
        })
    end
    
    return Tab
end

return TeleportTab
