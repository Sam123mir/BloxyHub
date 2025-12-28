--[[
    BLOXY HUB TITANIUM - MÓDULO: UTILS
    Utilidades generales - CÓDIGO PROBADO
]]

local Utils = {}

-- Dependencias
local Services, Config, I18n

-- Variables globales
local tween = nil
local TweenSpeed = 340

function Utils:Init(deps)
    Services = deps.Services
    Config = deps.Config
    I18n = deps.I18n
end

-- ═══════════════════════════════════════════════════════════════
-- FUNCIONES DE PERSONAJE
-- ═══════════════════════════════════════════════════════════════

function Utils:GetCharacter()
    return Services.LocalPlayer.Character
end

function Utils:GetHumanoid()
    local char = self:GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

function Utils:GetRootPart()
    local char = self:GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- ═══════════════════════════════════════════════════════════════
-- TWEEN (MÉTODO PROBADO - DE BANANA HUB)
-- ═══════════════════════════════════════════════════════════════

function Utils:Tween(targetCFrame)
    local rootPart = self:GetRootPart()
    if not rootPart then return end
    
    local Distance = (targetCFrame.Position - rootPart.Position).Magnitude
    local Speed = TweenSpeed
    
    if Distance >= 1 then
        Speed = TweenSpeed
    end
    
    local tweenService = game:GetService("TweenService")
    local info = TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
    
    tween = tweenService:Create(rootPart, info, {CFrame = targetCFrame})
    tween:Play()
end

function Utils:CancelTween()
    if tween then
        tween:Cancel()
    end
end

-- Teleport con espera (para quests)
function Utils:TweenAndWait(targetCFrame)
    self:Tween(targetCFrame)
    
    local rootPart = self:GetRootPart()
    if not rootPart then return end
    
    local Distance = (targetCFrame.Position - rootPart.Position).Magnitude
    local waitTime = Distance / TweenSpeed
    
    task.wait(waitTime + 0.1)
end

-- Teleport directo (para distancias cortas)
function Utils:TeleportTo(cframe)
    local rootPart = self:GetRootPart()
    if not rootPart then return false end
    
    pcall(function()
        rootPart.CFrame = cframe
        task.wait()
        rootPart.CFrame = cframe
    end)
    
    return true
end

-- ═══════════════════════════════════════════════════════════════
-- EQUIPAR HERRAMIENTA (MÉTODO PROBADO)
-- ═══════════════════════════════════════════════════════════════

function Utils:Equip(toolType)
    local humanoid = self:GetHumanoid()
    if not humanoid then return end
    
    pcall(function()
        for _, tool in pairs(Services.LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                if toolType == "Melee" and tool.ToolTip == "Melee" then
                    humanoid:EquipTool(tool)
                    return
                elseif toolType == "Sword" and tool.ToolTip == "Sword" then
                    humanoid:EquipTool(tool)
                    return
                elseif toolType == "Blox Fruit" and tool.ToolTip == "Blox Fruit" then
                    humanoid:EquipTool(tool)
                    return
                elseif tool.Name == toolType then
                    humanoid:EquipTool(tool)
                    return
                end
            end
        end
        
        -- Fallback: equipar primera herramienta melee
        for _, tool in pairs(Services.LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.ToolTip == "Melee" then
                humanoid:EquipTool(tool)
                return
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- BÚSQUEDA DE ENEMIGOS
-- ═══════════════════════════════════════════════════════════════

function Utils:GetClosestEnemy(maxDistance)
    maxDistance = maxDistance or 500
    local rootPart = self:GetRootPart()
    if not rootPart then return nil end
    
    local closest = nil
    local closestDist = maxDistance
    
    local enemies = game:GetService("Workspace"):FindFirstChild("Enemies")
    if not enemies then return nil end
    
    for _, enemy in pairs(enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
            if enemy.Humanoid.Health > 0 then
                local dist = (rootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                if dist < closestDist then
                    closest = enemy
                    closestDist = dist
                end
            end
        end
    end
    
    return closest, closestDist
end

function Utils:GetEnemyByName(name)
    local enemies = game:GetService("Workspace"):FindFirstChild("Enemies")
    if not enemies then return nil end
    
    for _, enemy in pairs(enemies:GetChildren()) do
        if enemy.Name == name then
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                return enemy
            end
        end
    end
    
    return nil
end

function Utils:GetEnemiesInRange(range)
    local rootPart = self:GetRootPart()
    if not rootPart then return {} end
    
    local inRange = {}
    local enemies = game:GetService("Workspace"):FindFirstChild("Enemies")
    if not enemies then return {} end
    
    for _, enemy in pairs(enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
            if enemy.Humanoid.Health > 0 then
                local dist = (rootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                if dist <= range then
                    table.insert(inRange, enemy)
                end
            end
        end
    end
    
    return inRange
end

-- ═══════════════════════════════════════════════════════════════
-- UTILIDADES GENERALES
-- ═══════════════════════════════════════════════════════════════

function Utils:GetCurrentWorld()
    local placeId = game.PlaceId
    if placeId == 2753915549 then return 1, "First Sea"
    elseif placeId == 4442272183 then return 2, "Second Sea"
    elseif placeId == 7449423635 then return 3, "Third Sea"
    else return 0, "Unknown" end
end

function Utils:Translate(key)
    local lang = (Config and Config.UI and Config.UI.Language) or "Spanish"
    local dict = I18n.Dictionary[lang] or I18n.Dictionary["Spanish"]
    return dict[key] or key
end

-- WindUI
local WindUI = nil

function Utils:SetWindUI(ui)
    WindUI = ui
end

function Utils:Notify(title, message, duration)
    if not Config.UI.Notifications then return end
    
    if WindUI then
        WindUI:Notify({
            Title = title,
            Content = message,
            Duration = duration or 3,
            Icon = "bell"
        })
    end
    print(string.format("[BLOXY HUB] %s: %s", title, message))
end

function Utils:GetPlayerInfo()
    local player = Services.LocalPlayer
    return {
        Name = player.DisplayName,
        Username = player.Name,
        UserId = player.UserId,
        ThumbnailId = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
    }
end

return Utils
