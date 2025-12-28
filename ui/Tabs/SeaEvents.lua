--[[
    BLOXY HUB TITANIUM - TAB: SEA EVENTS
    Eventos del mar (Third Sea)
]]

local SeaEvents = {}

function SeaEvents:Create(Window, deps)
    local Core = deps.Core
    local Combat = deps.Combat
    
    local Tab = Window:Tab({ Title = "Sea Events", Icon = "anchor" })
    
    if Core.Third_Sea then
        -- Rough Sea
        Tab:Section({ Title = "🌊 Rough Sea" })
        
        Tab:Toggle({
            Title = "Auto Kill Terrorshark",
            Default = false,
            Callback = function(value)
                _G.AutoTerrorshark = value
                if value then
                    self:StartTerrorsharkLoop(Core, Combat)
                end
            end
        })
        
        Tab:Toggle({
            Title = "Auto Kill Shark",
            Default = false,
            Callback = function(value)
                _G.AutoShark = value
                if value then
                    self:StartSharkLoop(Core, Combat)
                end
            end
        })
        
        Tab:Toggle({
            Title = "Auto Kill Fish Crew",
            Default = false,
            Callback = function(value)
                _G.AutoFishCrew = value
                if value then
                    self:StartFishCrewLoop(Core, Combat)
                end
            end
        })
        
        -- Kitsune
        Tab:Section({ Title = "🦊 Kitsune Island" })
        
        Tab:Button({
            Title = "Tween to Kitsune Island",
            Callback = function()
                deps.Teleport:ToKitsune()
            end
        })
        
        -- Sea Beast
        Tab:Section({ Title = "🐙 Sea Beast" })
        
        Tab:Toggle({
            Title = "Auto Kill Sea Beast",
            Default = false,
            Callback = function(value)
                _G.AutoSeaBeast = value
            end
        })
    else
        Tab:Section({ Title = "⚠️ Sea Events solo disponible en Third Sea" })
        Tab:Section({ Title = "Nivel requerido: 2450+" })
    end
    
    return Tab
end

function SeaEvents:StartTerrorsharkLoop(Core, Combat)
    spawn(function()
        while _G.AutoTerrorshark do
            wait()
            pcall(function()
                for i, v in pairs(Core.Workspace.Enemies:GetChildren()) do
                    if v.Name == "Terrorshark" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat wait(_G.Fast_Delay)
                            Combat:AttackNoCoolDown()
                            Combat:AutoHaki()
                            Combat:EquipTool(Core.SelectWeapon)
                            v.HumanoidRootPart.CanCollide = false
                            v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                            Combat:Tween(v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                        until not _G.AutoTerrorshark or not v.Parent or v.Humanoid.Health <= 0
                    end
                end
            end)
        end
    end)
end

function SeaEvents:StartSharkLoop(Core, Combat)
    spawn(function()
        while _G.AutoShark do
            wait()
            pcall(function()
                for i, v in pairs(Core.Workspace.Enemies:GetChildren()) do
                    if v.Name == "Shark" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat wait(_G.Fast_Delay)
                            Combat:AttackNoCoolDown()
                            Combat:AutoHaki()
                            Combat:EquipTool(Core.SelectWeapon)
                            v.HumanoidRootPart.CanCollide = false
                            v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                            Combat:Tween(v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                        until not _G.AutoShark or not v.Parent or v.Humanoid.Health <= 0
                    end
                end
            end)
        end
    end)
end

function SeaEvents:StartFishCrewLoop(Core, Combat)
    spawn(function()
        while _G.AutoFishCrew do
            wait()
            pcall(function()
                for i, v in pairs(Core.Workspace.Enemies:GetChildren()) do
                    if v.Name == "Fish Crew Member" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat wait(_G.Fast_Delay)
                            Combat:AttackNoCoolDown()
                            Combat:AutoHaki()
                            Combat:EquipTool(Core.SelectWeapon)
                            v.HumanoidRootPart.CanCollide = false
                            v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                            Combat:Tween(v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                        until not _G.AutoFishCrew or not v.Parent or v.Humanoid.Health <= 0
                    end
                end
            end)
        end
    end)
end

return SeaEvents
