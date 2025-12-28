--[[
    BLOXY HUB TITANIUM - TAB: SETTINGS
    Configuraciones
]]

local Settings = {}

function Settings:Create(Window, deps)
    local Core = deps.Core
    
    local Tab = Window:Tab({ Title = "Settings", Icon = "settings" })
    
    -- General
    Tab:Section({ Title = "⚙️ General Settings" })
    
    Tab:Toggle({
        Title = "FPS Boost",
        Default = false,
        Callback = function(value)
            if value then
                pcall(function()
                    local l = game.Lighting
                    local t = Core.Workspace.Terrain
                    sethiddenproperty(l, "Technology", 2)
                    sethiddenproperty(t, "Decoration", false)
                    t.WaterWaveSize = 0
                    t.WaterWaveSpeed = 0
                    t.WaterReflectance = 0
                    t.WaterTransparency = 0
                    l.GlobalShadows = false
                    l.FogEnd = 9e9
                    l.Brightness = 0
                    settings().Rendering.QualityLevel = "Level01"
                    
                    for i, v in pairs(game:GetDescendants()) do
                        if v:IsA("Part") or v:IsA("Union") or v:IsA("MeshPart") then
                            v.Material = "Plastic"
                            v.Reflectance = 0
                        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                            v.Lifetime = NumberRange.new(0)
                        elseif v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                            v.Enabled = false
                        end
                    end
                    
                    deps.WindUI:Notify({ Title = "FPS Boost", Content = "Activado!", Duration = 2 })
                end)
            end
        end
    })
    
    -- Server Actions
    Tab:Section({ Title = "🔄 Server Actions" })
    
    Tab:Button({
        Title = "Rejoin Server",
        Callback = function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, Core.LocalPlayer)
        end
    })
    
    Tab:Button({
        Title = "Server Hop",
        Callback = function()
            pcall(function()
                local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
                for _, v in pairs(servers.data) do
                    if v.playing < v.maxPlayers and v.id ~= game.JobId then
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, Core.LocalPlayer)
                        break
                    end
                end
            end)
        end
    })
    
    Tab:Button({
        Title = "Leave Game",
        Callback = function()
            Core.LocalPlayer:Kick("Goodbye!")
        end
    })
    
    -- Script Info
    Tab:Section({ Title = "📋 Script Info" })
    Tab:Section({ Title = "Version: 2.0 (Modular)" })
    Tab:Section({ Title = "UI: WindUI Premium" })
    Tab:Section({ Title = "Core: Banana Hub" })
    
    return Tab
end

return Settings
