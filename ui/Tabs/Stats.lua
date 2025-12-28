--[[
    BLOXY HUB TITANIUM - TAB: STATS
    Distribución de estadísticas
]]

local Stats = {}

function Stats:Create(Window, deps)
    local Core = deps.Core
    
    local Tab = Window:Tab({ Title = "Stats", Icon = "plus-circle" })
    
    local StatToggles = {
        Melee = false,
        Defense = false,
        Sword = false,
        Gun = false,
        ["Blox Fruit"] = false
    }
    
    Tab:Section({ Title = "📈 Auto Stats Distribution" })
    
    Tab:Toggle({
        Title = "Melee",
        Default = false,
        Callback = function(v) StatToggles.Melee = v end
    })
    
    Tab:Toggle({
        Title = "Defense",
        Default = false,
        Callback = function(v) StatToggles.Defense = v end
    })
    
    Tab:Toggle({
        Title = "Sword",
        Default = false,
        Callback = function(v) StatToggles.Sword = v end
    })
    
    Tab:Toggle({
        Title = "Gun",
        Default = false,
        Callback = function(v) StatToggles.Gun = v end
    })
    
    Tab:Toggle({
        Title = "Blox Fruit",
        Default = false,
        Callback = function(v) StatToggles["Blox Fruit"] = v end
    })
    
    Tab:Button({
        Title = "Apply Stats Now",
        Callback = function()
            pcall(function()
                for stat, enabled in pairs(StatToggles) do
                    if enabled then
                        local points = Core.LocalPlayer.Data.Points.Value
                        if points > 0 then
                            Core.ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", stat, points)
                        end
                    end
                end
                deps.WindUI:Notify({ Title = "Stats", Content = "Puntos distribuidos!", Duration = 3 })
            end)
        end
    })
    
    -- Auto Stats Loop
    local AutoStatsEnabled = false
    
    Tab:Toggle({
        Title = "Auto Distribute Stats",
        Default = false,
        Callback = function(value)
            AutoStatsEnabled = value
            if value then
                spawn(function()
                    while AutoStatsEnabled do
                        wait(1)
                        pcall(function()
                            for stat, enabled in pairs(StatToggles) do
                                if enabled then
                                    local points = Core.LocalPlayer.Data.Points.Value
                                    if points > 0 then
                                        Core.ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", stat, 1)
                                    end
                                end
                            end
                        end)
                    end
                end)
            end
        end
    })
    
    Tab:Section({ Title = "🔄 Stats Reset" })
    
    Tab:Button({
        Title = "Buy Stats Reset (2500 Fragments)",
        Callback = function()
            pcall(function()
                Core.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "1")
                deps.WindUI:Notify({ Title = "Stats", Content = "Reset de stats comprado!", Duration = 3 })
            end)
        end
    })
    
    return Tab
end

return Stats
