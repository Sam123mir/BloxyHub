--[[
    BLOXY HUB TITANIUM - MÓDULO: UTILS
    Funciones de utilidad general
]]

local Utils = {}

-- Dependencias (se inyectan desde el loader)
local Services, Config, I18n

function Utils:Init(deps)
    Services = deps.Services
    Config = deps.Config
    I18n = deps.I18n
end

-- ═══════════════════════════════════════════════════════════════
-- CACHÉ ESPACIAL (Optimización de CPU)
-- ═══════════════════════════════════════════════════════════════

local EnemyCache = {
    LastUpdate = 0,
    CacheTime = 0.5,
    Enemies = {}
}

function Utils:GetCharacter()
    return Services.LocalPlayer.Character or Services.LocalPlayer.CharacterAdded:Wait()
end

function Utils:GetHumanoid()
    local char = self:GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

function Utils:GetRootPart()
    local char = self:GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

function Utils:GetClosestEnemy(maxDistance)
    maxDistance = maxDistance or 500
    local rootPart = self:GetRootPart()
    if not rootPart then return nil, math.huge end
    
    local currentTime = tick()
    
    -- Usar caché si es reciente
    if currentTime - EnemyCache.LastUpdate < EnemyCache.CacheTime then
        local closest = nil
        local closestDist = maxDistance
        
        for _, enemy in pairs(EnemyCache.Enemies) do
            if enemy and enemy.Parent and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                local dist = (rootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                if dist < closestDist and enemy.Humanoid.Health > 0 then
                    closest = enemy
                    closestDist = dist
                end
            end
        end
        return closest, closestDist
    end
    
    -- Actualizar caché si expiró
    EnemyCache.Enemies = {}
    local closest = nil
    local closestDist = maxDistance
    
    local folder = Services.Workspace:FindFirstChild("Enemies")
    if not folder then return nil, math.huge end
    
    for _, enemy in pairs(folder:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
            table.insert(EnemyCache.Enemies, enemy)
            local dist = (rootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
            if dist < closestDist then
                closest = enemy
                closestDist = dist
            end
        end
    end
    
    EnemyCache.LastUpdate = currentTime
    return closest, closestDist
end

function Utils:GetEnemiesInRange(range)
    local rootPart = self:GetRootPart()
    if not rootPart then return {} end
    
    local inRange = {}
    self:GetClosestEnemy(range) -- Actualiza caché
    
    for _, enemy in pairs(EnemyCache.Enemies) do
        if enemy and enemy.Parent and enemy:FindFirstChild("HumanoidRootPart") then
            local dist = (rootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
            if dist <= range and enemy.Humanoid.Health > 0 then
                table.insert(inRange, enemy)
            end
        end
    end
    return inRange
end

function Utils:GetEnemyByName(name)
    local enemies = Services.Workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    
    for _, enemy in ipairs(enemies:GetChildren()) do
        if enemy.Name == name and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            return enemy
        end
    end
    return nil
end

function Utils:TeleportTo(cframe, safeMode)
    local rootPart = self:GetRootPart()
    if not rootPart then return false end
    
    local success = pcall(function()
        if safeMode then
            local targetCFrame = cframe * CFrame.new(0, Config.AutoFarm.Distance, 0)
            rootPart.CFrame = targetCFrame
        else
            rootPart.CFrame = cframe
        end
    end)
    
    return success
end

function Utils:Equip(toolName)
    pcall(function()
        local char = self:GetCharacter()
        local humanoid = self:GetHumanoid()
        if not humanoid then return end
        
        if toolName == "Melee" then
            for _, t in pairs(Services.LocalPlayer.Backpack:GetChildren()) do
                if t:IsA("Tool") and (t.ToolTip == "Melee" or t.Name == "Combat" or t:FindFirstChild("Combat")) then
                    humanoid:EquipTool(t)
                    return
                end
            end
        else
            local tool = Services.LocalPlayer.Backpack:FindFirstChild(toolName) or char:FindFirstChild(toolName)
            if tool then
                humanoid:EquipTool(tool)
            else
                -- Búsqueda por tipo si no encuentra el nombre exacto
                for _, t in pairs(Services.LocalPlayer.Backpack:GetChildren()) do
                    if t:IsA("Tool") and string.find(t.Name, toolName) then
                        humanoid:EquipTool(t)
                        return
                    end
                end
            end
        end
    end)
end

function Utils:GetCurrentWorld()
    local placeId = game.PlaceId
    if placeId == 2753915549 then return 1, "First Sea"
    elseif placeId == 4442272183 then return 2, "Second Sea"
    elseif placeId == 7449423635 then return 3, "Third Sea"
    else return 0, "Unknown" end
end

function Utils:IsLagging()
    local success, ping = pcall(function()
        return Services.Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    return success and ping > 500
end

function Utils:Translate(key)
    local lang = (Config and Config.UI and Config.UI.Language) or "Spanish"
    local dict = I18n.Dictionary[lang] or I18n.Dictionary["Spanish"]
    return dict[key] or key
end

-- WindUI es inyectado externamente
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
    else
        print(string.format("[BLOXY HUB] %s: %s", title, message))
    end
end

return Utils
