--[[
    BLOXY HUB TITANIUM - TAB: PLAYER
    Mejoras del jugador
]]

local PlayerTab = {}

function PlayerTab:Create(Window, deps)
    local Core = deps.Core
    local Player = deps.Player
    
    local Tab = Window:Tab({ Title = "Player", Icon = "user" })
    
    -- Movement
    Tab:Section({ Title = "🏃 Movement" })
    
    Tab:Slider({
        Title = "Walk Speed",
        Value = { Min = 16, Max = 500, Default = 16 },
        Callback = function(value)
            Player:SetWalkSpeed(value)
        end
    })
    
    Tab:Slider({
        Title = "Jump Power",
        Value = { Min = 50, Max = 500, Default = 50 },
        Callback = function(value)
            Player:SetJumpPower(value)
        end
    })
    
    -- Enhancements
    Tab:Section({ Title = "✨ Enhancements" })
    
    Tab:Toggle({
        Title = "Infinite Sky Jump",
        Default = false,
        Callback = function(value)
            _G.InfiniteJump = value
        end
    })
    
    Tab:Toggle({
        Title = "Auto Buso (Haki)",
        Default = false,
        Callback = function(value)
            _G.AutoBuso = value
        end
    })
    
    -- Quick Actions
    Tab:Section({ Title = "⚡ Quick Actions" })
    
    Tab:Button({
        Title = "Full Heal (Eat Fruit)",
        Callback = function()
            pcall(function()
                for _, fruit in pairs(Core.Workspace:GetDescendants()) do
                    if fruit:IsA("Tool") and fruit.ToolTip == "Blox Fruit" then
                        firetouchinterest(Core.LocalPlayer.Character.HumanoidRootPart, fruit.Handle, 0)
                        wait()
                        firetouchinterest(Core.LocalPlayer.Character.HumanoidRootPart, fruit.Handle, 1)
                    end
                end
            end)
        end
    })
    
    Tab:Button({
        Title = "Respawn",
        Callback = function()
            pcall(function()
                Core.LocalPlayer.Character.Humanoid.Health = 0
            end)
        end
    })
    
    return Tab
end

return PlayerTab
