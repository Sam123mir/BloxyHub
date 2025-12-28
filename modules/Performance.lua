--[[
    BLOXY HUB TITANIUM - MÓDULO: PERFORMANCE
    Sistema de optimización de rendimiento
]]

local Performance = {}

-- Dependencias
local Services, Config, Utils

function Performance:Init(deps)
    Services = deps.Services
    Config = deps.Config
    Utils = deps.Utils
end

function Performance:ApplyCPUMode()
    if not Config.Performance.CPUMode then return end
    
    for _, obj in pairs(Services.Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            end
        end)
    end
    
    Utils:Notify("Performance", "Modo CPU activado - Texturas optimizadas", 3)
end

function Performance:ToggleWhiteScreen(enabled)
    Config.Performance.WhiteScreen = enabled
    
    pcall(function()
        Services.RunService:Set3dRenderingEnabled(not enabled)
    end)
    
    if enabled then
        Utils:Notify("Performance", "Pantalla blanca activada - FPS máximo", 3)
    end
end

function Performance:ApplyFPSBoost()
    if not Config.Performance.FPSBoost then return end
    
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
    
    -- Desactivar efectos de post-procesamiento
    for _, effect in pairs(Services.Lighting:GetChildren()) do
        pcall(function()
            if effect:IsA("PostEffect") then
                effect.Enabled = false
            end
        end)
    end
    
    -- Desactivar sombras
    pcall(function()
        Services.Lighting.GlobalShadows = false
    end)
    
    Utils:Notify("Performance", "FPS Boost activado", 3)
end

function Performance:RestoreDefaults()
    pcall(function()
        Services.RunService:Set3dRenderingEnabled(true)
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        Services.Lighting.GlobalShadows = true
    end)
end

return Performance
