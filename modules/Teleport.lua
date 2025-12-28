--[[
    BLOXY HUB TITANIUM - MÓDULO: TELEPORT
    Sistema de teleport
]]

local Teleport = {}

local Core = nil
local Combat = nil

function Teleport:Init(core, combat)
    Core = core
    Combat = combat
    
    -- Cargar sistema de teleport de Banana Hub
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NGUYENVUDUY1/Tptv/main/Gpat.txt"))()
    end)
end

function Teleport:ToIsland(islandName)
    pcall(function()
        for i, v in pairs(Core.Workspace["_WorldOrigin"].Locations:GetChildren()) do
            if v.Name == islandName then
                Combat:Tween(v.CFrame)
                break
            end
        end
    end)
end

function Teleport:ToPlayer(playerName)
    pcall(function()
        local target = Core.Players:FindFirstChild(playerName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            for i = 1, 5 do
                Core.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                wait()
            end
        end
    end)
end

function Teleport:ToCFrame(cframe)
    Combat:Tween(cframe)
end

function Teleport:ToKitsune()
    pcall(function()
        if Core.Workspace.Map:FindFirstChild("KitsuneIsland") then
            local shrine = Core.Workspace.Map.KitsuneIsland:FindFirstChild("ShrineActive")
            if shrine then
                for _, v in pairs(shrine:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name:find("NeonShrinePart") then
                        Combat:Tween(v.CFrame)
                        break
                    end
                end
            end
        end
    end)
end

function Teleport:GetPlayerList()
    local list = {}
    for _, p in pairs(Core.Players:GetPlayers()) do
        if p ~= Core.LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

return Teleport
