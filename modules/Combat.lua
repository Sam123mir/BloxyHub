--[[
    BLOXY HUB TITANIUM - MÓDULO: COMBAT
    Sistema de combate - CÓDIGO PROBADO (basado en scripts funcionales)
]]

local Combat = {}

-- Dependencias
local Services, Config, Utils, Session

-- Variables del CombatFramework
local CbFw, CbFw2

function Combat:Init(deps)
    Services = deps.Services
    Config = deps.Config
    Utils = deps.Utils
    Session = deps.Session
    
    -- Inicializar CombatFramework
    pcall(function()
        local plr = Services.LocalPlayer
        CbFw = debug.getupvalues(require(plr.PlayerScripts.CombatFramework))
        CbFw2 = CbFw[2]
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- ATAQUE SIN COOLDOWN (MÉTODO PROBADO)
-- ═══════════════════════════════════════════════════════════════

function Combat:GetCurrentBlade()
    local success, result = pcall(function()
        local p13 = CbFw2.activeController
        local ret = p13.blades[1]
        if not ret then return nil end
        while ret.Parent ~= Services.LocalPlayer.Character do 
            ret = ret.Parent 
        end
        return ret
    end)
    return success and result or nil
end

function Combat:AttackNoCoolDown()
    local success = pcall(function()
        local plr = Services.LocalPlayer
        local AC = CbFw2.activeController
        
        for i = 1, 1 do
            local bladehit = require(game.ReplicatedStorage.CombatFramework.RigLib).getBladeHits(
                plr.Character,
                {plr.Character.HumanoidRootPart},
                60
            )
            
            local cac = {}
            local hash = {}
            for k, v in pairs(bladehit) do
                if v.Parent:FindFirstChild("HumanoidRootPart") and not hash[v.Parent] then
                    table.insert(cac, v.Parent.HumanoidRootPart)
                    hash[v.Parent] = true
                end
            end
            bladehit = cac
            
            if #bladehit > 0 then
                local u8 = debug.getupvalue(AC.attack, 5)
                local u9 = debug.getupvalue(AC.attack, 6)
                local u7 = debug.getupvalue(AC.attack, 4)
                local u10 = debug.getupvalue(AC.attack, 7)
                local u12 = (u8 * 798405 + u7 * 727595) % u9
                local u13 = u7 * 798405
                
                u12 = (u12 * u9 + u13) % 1099511627776
                u8 = math.floor(u12 / u9)
                u7 = u12 - u8 * u9
                u10 = u10 + 1
                
                debug.setupvalue(AC.attack, 5, u8)
                debug.setupvalue(AC.attack, 6, u9)
                debug.setupvalue(AC.attack, 4, u7)
                debug.setupvalue(AC.attack, 7, u10)
                
                pcall(function()
                    for k, v in pairs(AC.animator.anims.basic) do
                        v:Play()
                    end
                end)
                
                local blade = self:GetCurrentBlade()
                if plr.Character:FindFirstChildOfClass("Tool") and AC.blades and AC.blades[1] and blade then
                    game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("weaponChange", tostring(blade))
                    game.ReplicatedStorage.Remotes.Validator:FireServer(math.floor(u12 / 1099511627776 * 16777215), u10)
                    game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", bladehit, i, "")
                end
            end
        end
    end)
    return success
end

-- ═══════════════════════════════════════════════════════════════
-- ATAQUE NORMAL (MÉTODO ALTERNATIVO)
-- ═══════════════════════════════════════════════════════════════

function Combat:NormalAttack()
    pcall(function()
        local Module = require(Services.LocalPlayer.PlayerScripts.CombatFramework)
        local CombatFramework = debug.getupvalues(Module)[2]
        local CamShake = require(game.ReplicatedStorage.Util.CameraShaker)
        CamShake:Stop()
        CombatFramework.activeController.attacking = false
        CombatFramework.activeController.timeToNextAttack = 0
        CombatFramework.activeController.hitboxMagnitude = 180
        game:GetService('VirtualUser'):CaptureController()
        game:GetService('VirtualUser'):Button1Down(Vector2.new(1280, 672))
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- AUTO HAKI
-- ═══════════════════════════════════════════════════════════════

function Combat:AutoHaki()
    pcall(function()
        if not Services.LocalPlayer.Character:FindFirstChild("HasBuso") then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- ATACAR ENEMIGO
-- ═══════════════════════════════════════════════════════════════

function Combat:AttackEnemy(enemy)
    if not enemy then return false end
    
    local enemyHRP = enemy:FindFirstChild("HumanoidRootPart")
    local enemyHum = enemy:FindFirstChild("Humanoid")
    
    if not enemyHRP or not enemyHum then return false end
    if enemyHum.Health <= 0 then
        Session:AddMobKill()
        return false
    end
    
    -- Auto Haki
    self:AutoHaki()
    
    -- Teletransportar al enemigo
    Utils:Tween(enemyHRP.CFrame * CFrame.new(0, 10, 0))
    
    -- Hacer el enemigo más grande para hitbox
    pcall(function()
        enemyHRP.Size = Vector3.new(60, 60, 60)
        enemyHRP.Transparency = 1
        enemyHum.JumpPower = 0
        enemyHum.WalkSpeed = 0
        enemyHRP.CanCollide = false
    end)
    
    -- Atacar
    self:AttackNoCoolDown()
    
    -- Actualizar status
    Session.Status = "Atacando: " .. enemy.Name
    
    return true
end

-- ═══════════════════════════════════════════════════════════════
-- KILL AURA
-- ═══════════════════════════════════════════════════════════════

function Combat:KillAura()
    if not Config.Combat.KillAura then return end
    
    for _, enemy in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
            if enemy.Humanoid.Health > 0 then
                local dist = (Services.LocalPlayer.Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                if dist <= (Config.Combat.Range or 50) then
                    self:AttackEnemy(enemy)
                end
            end
        end
    end
end

return Combat
