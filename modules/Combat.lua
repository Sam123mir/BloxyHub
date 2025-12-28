--[[
    BLOXY HUB TITANIUM - MÓDULO: COMBAT
    Sistema de combate avanzado
]]

local Combat = {
    LastAttack = 0,
    AttackCooldown = 0.05
}

-- Dependencias
local Services, Config, Utils, Session

function Combat:Init(deps)
    Services = deps.Services
    Config = deps.Config
    Utils = deps.Utils
    Session = deps.Session
end

function Combat:FastAttack()
    if not Config.Combat.FastAttack then return end
    
    local currentTime = tick()
    if currentTime - self.LastAttack < self.AttackCooldown then return end
    self.LastAttack = currentTime
    
    pcall(function()
        local char = Utils:GetCharacter()
        local tool = char:FindFirstChildOfClass("Tool")
        
        -- Método 1: Activación de herramienta local
        if tool then
            tool:Activate()
        end
        
        -- Método 2: Disparo de remoto de ataque (Blox Fruits)
        local remotes = Services.ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local combatRemote = remotes:FindFirstChild("Validator")
            if combatRemote then
                combatRemote:FireServer("Combat", char)
            end
        end
        
        -- Método 3: Simulación de click
        if Config.Combat.ClickSimulation then
            Services.VirtualUser:CaptureController()
            Services.VirtualUser:Button1Down(Vector2.new(0, 0), Services.Workspace.CurrentCamera.CFrame)
        end
    end)
end

function Combat:AttackEnemy(enemy)
    if not enemy or not enemy:FindFirstChild("HumanoidRootPart") then return end
    if Utils:IsLagging() then 
        Session.Status = "Lag detectado - Pausando..."
        return 
    end
    
    pcall(function()
        local char = Utils:GetCharacter()
        local rootPart = Utils:GetRootPart()
        if not rootPart then return end
        
        local enemyHRP = enemy.HumanoidRootPart
        local dist = (rootPart.Position - enemyHRP.Position).Magnitude
        
        -- Solo teletransportar si estamos lejos
        if dist > 15 then
            Utils:TeleportTo(enemyHRP.CFrame * CFrame.new(0, 10, 0), Config.AutoFarm.SafeMode)
        end
        
        -- Ejecutar ataques rápidos
        self:FastAttack()
        
        -- Actualizar estadísticas al morir
        if enemy.Humanoid.Health <= 0 then
            Session:AddMobKill()
        end
    end)
end

function Combat:ExecuteMasteryFinisher(enemy)
    if not Config.Mastery.Enabled or not enemy then return end
    
    pcall(function()
        local healthPercent = (enemy.Humanoid.Health / enemy.Humanoid.MaxHealth) * 100
        
        if healthPercent <= Config.Mastery.FinishAtHealth then
            local weaponName = Config.Mastery.Weapon
            local char = Utils:GetCharacter()
            local humanoid = Utils:GetHumanoid()
            local weapon = Services.LocalPlayer.Backpack:FindFirstChild(weaponName) or char:FindFirstChild(weaponName)
            
            if weapon and humanoid then
                humanoid:EquipTool(weapon)
                task.wait(0.1)
                
                if Config.Mastery.UseSkills then
                    Services.VirtualUser:SetKeyDown("z")
                    task.wait(0.15)
                    Services.VirtualUser:SetKeyUp("z")
                end
            end
        end
    end)
end

function Combat:KillAura()
    if not Config.Combat.KillAura then return end
    
    local enemies = Utils:GetEnemiesInRange(Config.Combat.Range)
    for _, enemy in ipairs(enemies) do
        self:AttackEnemy(enemy)
    end
end

return Combat
