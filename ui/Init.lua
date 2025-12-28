--[[
    BLOXY HUB TITANIUM - UI: INIT
    Inicialización de WindUI y ventana principal
]]

local UI = {}

-- Dependencias
local Config, Utils

function UI:Init(deps)
    Config = deps.Config
    Utils = deps.Utils
end

function UI:LoadWindUI()
    print("[BLOXY HUB] Cargando WindUI...")
    
    local WindUI = nil
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    end)
    
    if success and result then
        WindUI = result
        print("[BLOXY HUB] WindUI cargado correctamente - v" .. (WindUI.Version or "Unknown"))
    else
        warn("[BLOXY HUB] Error al cargar WindUI: " .. tostring(result))
        return nil, nil
    end
    
    return WindUI
end

function UI:CreateWindow(WindUI)
    if not WindUI then return nil end
    
    local Window = WindUI:CreateWindow({
        Title = "Blox Fruits Panel 🏴‍☠️ | Bloxy Hub",
        Folder = "BloxyHubTitanium",
        Icon = "solar:folder-2-bold-duotone",
        
        OpenButton = {
            Title = "Abrir Bloxy Hub",
            CornerRadius = UDim.new(1, 0),
            StrokeThickness = 2,
            Enabled = true,
            Draggable = true,
            OnlyMobile = false,
            Color = ColorSequence.new(
                Color3.fromHex("#7775F2"), 
                Color3.fromHex("#305dff")
            )
        },
        
        Topbar = {
            Height = 44,
            ButtonsType = "Mac"
        }
    })
    
    -- Tag de versión
    Window:Tag({
        Title = "v" .. (Config.Version or "8.0"),
        Icon = "github",
        Color = Color3.fromHex("#1c1c1c"),
        Border = true
    })
    
    return Window
end

-- Colores para iconos
UI.Colors = {
    Purple = Color3.fromHex("#7775F2"),
    Yellow = Color3.fromHex("#ECA201"),
    Green = Color3.fromHex("#10C550"),
    Grey = Color3.fromHex("#83889E"),
    Blue = Color3.fromHex("#257AF7"),
    Red = Color3.fromHex("#EF4F1D"),
    Orange = Color3.fromHex("#FF6B35")
}

return UI
