--[[
    BLOXY HUB TITANIUM - MÓDULO: FARMING
    Sistema de auto-farm y gestión de misiones
]]

local Farming = {}

-- Dependencias
local Services, Config, Utils, Session, Combat, QuestData

function Farming:Init(deps)
    Services = deps.Services
    Config = deps.Config
    Utils = deps.Utils
    Session = deps.Session
    Combat = deps.Combat
    QuestData = deps.QuestData
end

-- Cache de Quest
local QuestCache = {
    LastUpdate = 0,
    UpdateInterval = 5,
    ActiveQuest = nil
}

function Farming:GetBestQuest()
    local data = Services.LocalPlayer:FindFirstChild("Data")
    if not data or not data:FindFirstChild("Level") then return nil end
    
    local myLvl = data.Level.Value
    local world, _ = Utils:GetCurrentWorld()
    local worldQuests = QuestData[world] or {}
    
    local best = worldQuests[1]
    for _, q in ipairs(worldQuests) do
        if myLvl >= q.Level then
            best = q
        end
    end
    return best
end

function Farming:CheckQuest()
    local playerGui = Services.LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return false end
    
    local main = playerGui:FindFirstChild("Main")
    if not main then return false end
    
    local questFrame = main:FindFirstChild("Quest")
    return questFrame and questFrame.Visible
end

function Farming:TakeQuest()
    local currentTime = tick()
    
    -- Si ya hay quest activa, no hacer nada
    if self:CheckQuest() then return true end
    
    -- Evitar spam de peticiones al servidor
    if currentTime - QuestCache.LastUpdate < QuestCache.UpdateInterval then
        return false
    end
    
    local best = self:GetBestQuest()
    if not best then 
        return false 
    end
    
    QuestCache.LastUpdate = currentTime
    Session.Status = "Obteniendo Quest: " .. best.Quest
    
    local success = pcall(function()
        Utils:TeleportTo(best.CFrame)
        task.wait(0.3)
        
        local remotes = Services.ReplicatedStorage:FindFirstChild("Remotes")
        if remotes and remotes:FindFirstChild("CommF_") then
            remotes.CommF_:InvokeServer("StartQuest", best.Quest, 1)
        end
    end)
    
    return success
end

function Farming:AutoLevel()
    if not Config.AutoFarm.Enabled or Config.AutoFarm.Mode ~= "Level" then return end
    
    if not self:CheckQuest() then
        self:TakeQuest()
        return
    end
    
    local best = self:GetBestQuest()
    if not best then return end
    
    local enemy = Utils:GetEnemyByName(best.Enemy) or Utils:GetClosestEnemy(1500)
    
    if enemy then
        Session.Status = "Atacando: " .. enemy.Name
        Utils:Equip("Melee")
        Combat:AttackEnemy(enemy)
        
        if Config.Mastery.Enabled then
            Combat:ExecuteMasteryFinisher(enemy)
        end
    else
        Session.Status = "Esperando respawn de " .. (best.Enemy or "Objetivo")
    end
end

function Farming:AutoMastery()
    if not Config.Mastery.Enabled then return end
    
    local enemy = Utils:GetClosestEnemy(500)
    
    if enemy then
        Session.Status = "Mastery: " .. enemy.Name
        Combat:AttackEnemy(enemy)
        Combat:ExecuteMasteryFinisher(enemy)
    end
end

return Farming
