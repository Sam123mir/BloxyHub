--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║              BLOXY HUB TITANIUM - LOADER                     ║
    ║         Estructura Modular con Código de Banana Hub          ║
    ║                    UI: WindUI Premium                        ║
    ╚══════════════════════════════════════════════════════════════╝
]]

local GITHUB_RAW = "https://raw.githubusercontent.com/Sam123mir/Blox-Fruits-Panel-BloxyHub/main/"

-- ═══════════════════════════════════════════════════════════════
-- VALIDACIÓN DE JUEGO
-- ═══════════════════════════════════════════════════════════════

local id = game.PlaceId
if id ~= 2753915549 and id ~= 4442272183 and id ~= 7449423635 then
    game:Shutdown()
    return
end

-- ═══════════════════════════════════════════════════════════════
-- FUNCIÓN PARA CARGAR MÓDULOS
-- ═══════════════════════════════════════════════════════════════

local function LoadModule(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(GITHUB_RAW .. path .. ".lua"))()
    end)
    if success then
        return result
    else
        warn("[BLOXY HUB] Error cargando " .. path .. ": " .. tostring(result))
        return nil
    end
end

print("[BLOXY HUB] Cargando módulos...")

-- ═══════════════════════════════════════════════════════════════
-- CARGAR MÓDULOS
-- ═══════════════════════════════════════════════════════════════

local Core = LoadModule("modules/Core")
local Combat = LoadModule("modules/Combat")
local Farming = LoadModule("modules/Farming")
local Session = LoadModule("modules/Session")
local Player = LoadModule("modules/Player")
local Teleport = LoadModule("modules/Teleport")

if not Core then
    warn("[BLOXY HUB] Error fatal: No se pudo cargar Core")
    return
end

-- ═══════════════════════════════════════════════════════════════
-- INICIALIZAR MÓDULOS
-- ═══════════════════════════════════════════════════════════════

print("[BLOXY HUB] Inicializando módulos...")

if Combat then Combat:Init(Core) end
if Session then Session:Init(Core) end
if Player then Player:Init(Core) end
if Teleport then Teleport:Init(Core, Combat) end
if Farming then Farming:Init(Core, Combat) end

-- Iniciar loops de farming
if Farming then
    Farming:StartAutoLevel()
    Farming:StartAutoNear()
    Farming:StartSafeMode()
end

-- ═══════════════════════════════════════════════════════════════
-- CARGAR WINDUI
-- ═══════════════════════════════════════════════════════════════

print("[BLOXY HUB] Cargando WindUI...")

local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/ui/WindUI"))()

local Window = WindUI:CreateWindow({
    Title = "Bloxy Hub Titanium",
    Icon = "star",
    Author = "@BloxyHub",
    Folder = "BloxyHubTitanium",
    Size = UDim2.fromOffset(560, 480),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    HasOutline = true
})

-- ═══════════════════════════════════════════════════════════════
-- DEPENDENCIAS PARA TABS
-- ═══════════════════════════════════════════════════════════════

local deps = {
    Core = Core,
    Combat = Combat,
    Farming = Farming,
    Session = Session,
    Player = Player,
    Teleport = Teleport,
    WindUI = WindUI,
    Window = Window
}

-- ═══════════════════════════════════════════════════════════════
-- CARGAR Y CREAR TABS
-- ═══════════════════════════════════════════════════════════════

print("[BLOXY HUB] Cargando tabs...")

local DashboardTab = LoadModule("ui/Tabs/Dashboard")
local AutoFarmTab = LoadModule("ui/Tabs/AutoFarm")
local BossFarmTab = LoadModule("ui/Tabs/BossFarm")
local SeaEventsTab = LoadModule("ui/Tabs/SeaEvents")
local StatsTab = LoadModule("ui/Tabs/Stats")
local PlayerTab = LoadModule("ui/Tabs/Player")
local TeleportTab = LoadModule("ui/Tabs/Teleport")
local SettingsTab = LoadModule("ui/Tabs/Settings")

-- Crear tabs
if DashboardTab then DashboardTab:Create(Window, deps) end
if AutoFarmTab then AutoFarmTab:Create(Window, deps) end
if BossFarmTab then BossFarmTab:Create(Window, deps) end
if SeaEventsTab then SeaEventsTab:Create(Window, deps) end
if StatsTab then StatsTab:Create(Window, deps) end
if PlayerTab then PlayerTab:Create(Window, deps) end
if TeleportTab then TeleportTab:Create(Window, deps) end
if SettingsTab then SettingsTab:Create(Window, deps) end

-- ═══════════════════════════════════════════════════════════════
-- LIMPIEZA Y EXTRAS
-- ═══════════════════════════════════════════════════════════════

-- Remover efectos de muerte
pcall(function()
    if Core.ReplicatedStorage.Effect.Container:FindFirstChild("Death") then
        Core.ReplicatedStorage.Effect.Container.Death:Destroy()
    end
    if Core.ReplicatedStorage.Effect.Container:FindFirstChild("Respawn") then
        Core.ReplicatedStorage.Effect.Container.Respawn:Destroy()
    end
end)

-- Botón flotante para móvil
local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.12, 0, 0.1, 0)
ImageButton.Size = UDim2.new(0, 50, 0, 50)
ImageButton.Draggable = true
ImageButton.Image = "http://www.roblox.com/asset/?id=16601446273"
ImageButton.MouseButton1Down:connect(function()
    Core.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.End, false, game)
end)

-- ═══════════════════════════════════════════════════════════════
-- FINALIZACIÓN
-- ═══════════════════════════════════════════════════════════════

Window:SelectTab(1)

print("[BLOXY HUB] ✅ Script cargado exitosamente!")
print("[BLOXY HUB] Mundo: " .. Core.GetWorldName())

WindUI:Notify({
    Title = "Bloxy Hub Titanium",
    Content = "Script cargado exitosamente! Mundo: " .. Core.GetWorldName(),
    Duration = 5
})
