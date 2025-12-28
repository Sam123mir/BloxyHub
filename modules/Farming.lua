--[[
    BLOXY HUB TITANIUM - MÓDULO: FARMING
    Sistema de auto-farm - CÓDIGO PROBADO
]]

local Farming = {}

-- Dependencias
local Services, Config, Utils, Session, Combat, QuestData

-- Variables de quest
local NameQuest = ""
local NameMon = ""
local QuestLv = 1
local CFrameQ = CFrame.new()
local Ms = ""

function Farming:Init(deps)
    Services = deps.Services
    Config = deps.Config
    Utils = deps.Utils
    Session = deps.Session
    Combat = deps.Combat
    QuestData = deps.QuestData
end

-- ═══════════════════════════════════════════════════════════════
-- SISTEMA DE QUESTS (BASADO EN BANANA HUB)
-- ═══════════════════════════════════════════════════════════════

function Farming:CheckLevel()
    local MyLevel = Services.LocalPlayer.Data.Level.Value
    local world, _ = Utils:GetCurrentWorld()
    
    -- Obtener quest del QuestData
    local quests = QuestData[world] or {}
    
    if #quests == 0 then
        Session.Status = "Sin quests disponibles"
        return
    end
    
    -- Buscar la mejor quest para el nivel
    local bestQuest = quests[1]
    for _, q in ipairs(quests) do
        if MyLevel >= q.Level then
            bestQuest = q
        end
    end
    
    if bestQuest then
        NameQuest = bestQuest.Quest
        NameMon = bestQuest.Enemy
        Ms = bestQuest.Enemy
        QuestLv = bestQuest.QuestLv or 1
        CFrameQ = bestQuest.CFrame
        
        Session.Status = "Quest: " .. NameMon
    end
end

function Farming:HasQuest()
    local success, result = pcall(function()
        local questGui = Services.LocalPlayer.PlayerGui.Main.Quest
        return questGui.Visible
    end)
    return success and result or false
end

function Farming:QuestMatchesMob()
    local success, result = pcall(function()
        local questTitle = Services.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
        return string.find(questTitle, NameMon)
    end)
    return success and result or false
end

-- ═══════════════════════════════════════════════════════════════
-- AUTO FARM LEVEL (MÉTODO PROBADO)
-- ═══════════════════════════════════════════════════════════════

function Farming:AutoLevel()
    if not Config.AutoFarm.Enabled then return end
    
    -- Verificar nivel y quest
    self:CheckLevel()
    
    -- Si no tiene quest o la quest no coincide con el mob
    if not self:QuestMatchesMob() or not self:HasQuest() then
        -- Abandonar quest anterior
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
        end)
        
        -- Ir al NPC de quest
        Utils:Tween(CFrameQ)
        
        local rootPart = Utils:GetRootPart()
        if rootPart then
            local dist = (CFrameQ.Position - rootPart.Position).Magnitude
            if dist <= 5 then
                -- Tomar la quest
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                end)
            end
        end
        
        return
    end
    
    -- Tiene quest, buscar enemigos
    for _, enemy in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
            if enemy.Humanoid.Health > 0 and enemy.Name == Ms then
                -- Equipar arma
                Utils:Equip("Melee")
                
                -- Atacar
                Combat:AttackEnemy(enemy)
                
                return
            end
        end
    end
    
    -- No hay enemigos, ir a zona de spawn
    for _, spawn in pairs(game:GetService("Workspace")["_WorldOrigin"].EnemySpawns:GetChildren()) do
        if string.find(spawn.Name, NameMon) then
            local rootPart = Utils:GetRootPart()
            if rootPart then
                local dist = (spawn.Position - rootPart.Position).Magnitude
                if dist >= 10 then
                    Utils:Tween(spawn.CFrame * CFrame.new(0, 10, 0))
                end
            end
            break
        end
    end
end

-- ═══════════════════════════════════════════════════════════════
-- AUTO KILL NEAR (MÉTODO PROBADO)
-- ═══════════════════════════════════════════════════════════════

function Farming:AutoKillNear()
    if not Config.AutoFarm.Enabled then return end
    
    for _, enemy in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
            if enemy.Humanoid.Health > 0 then
                local rootPart = Utils:GetRootPart()
                if rootPart then
                    local dist = (rootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                    if dist <= 5000 then
                        Utils:Equip("Melee")
                        Combat:AttackEnemy(enemy)
                        return
                    end
                end
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════
-- AUTO MASTERY
-- ═══════════════════════════════════════════════════════════════

function Farming:AutoMastery()
    if not Config.Mastery.Enabled then return end
    
    local weapon = Config.AIMastery.SelectedWeapon or "Melee"
    Utils:Equip(weapon)
    
    local enemy = Utils:GetClosestEnemy(500)
    if enemy then
        Combat:AttackEnemy(enemy)
    end
end

return Farming
