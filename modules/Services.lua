--[[
    BLOXY HUB TITANIUM - MÓDULO: SERVICES
    Referencias a todos los servicios de Roblox
]]

local Services = {
    Players = game:GetService("Players"),
    Workspace = game:GetService("Workspace"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    TeleportService = game:GetService("TeleportService"),
    RunService = game:GetService("RunService"),
    Stats = game:GetService("Stats"),
    VirtualUser = game:GetService("VirtualUser"),
    UserInputService = game:GetService("UserInputService"),
    Lighting = game:GetService("Lighting"),
    CoreGui = game:GetService("CoreGui"),
    LogService = game:GetService("LogService")
}

-- Obtener jugador local
Services.LocalPlayer = Services.Players.LocalPlayer

return Services
