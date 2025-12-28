--[[
    BLOXY HUB TITANIUM - MÓDULO: AI
    Sistema de Inteligencia Artificial para combate
]]

local AI = {
    IsUsingSkill = false,
    CurrentSkillIndex = 1,
    SkillKeys = {"z", "x", "c", "v"}
}

-- Dependencias
local Services, Config, Utils, Session, Combat

function AI:Init(deps)
    Services = deps.Services
    Config = deps.Config
    Utils = deps.Utils
    Session = deps.Session
    Combat = deps.Combat
end

function AI:UseSkills(targetType)
    if not Config.AIMastery.Enabled and not Config.PvP.AutoPvP then return end
    if self.IsUsingSkill then return end
    
    task.spawn(function()
        self.IsUsingSkill = true
        
        -- Rotación profesional de habilidades
        for _, key in ipairs(self.SkillKeys) do
            local upperKey = key:upper()
            if Config.AIMastery.Skills[upperKey] then
                Session.Status = "IA: Usando habilidad " .. upperKey
                
                Services.VirtualUser:SetKeyDown(key)
                task.wait(0.15)
                Services.VirtualUser:SetKeyUp(key)
                task.wait(0.1)
            end
        end
        
        Session.Status = "IA: Recargando habilidades..."
        task.wait(0.5) -- Cool-down global
        self.IsUsingSkill = false
    end)
end

function AI:HandlePvP()
    if not Config.PvP.AutoPvP then return end
    
    local targetName = Config.PvP.TargetPlayer
    local target = targetName and Services.Players:FindFirstChild(targetName)
    
    if target and target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
        local targetHRP = target.Character.HumanoidRootPart
        
        -- Movimiento profesional (IA STRAFE)
        local time = tick()
        local orbitDistance = 8
        local orbitSpeed = 4
        local offset = Vector3.new(
            math.cos(time * orbitSpeed) * orbitDistance, 
            5, 
            math.sin(time * orbitSpeed) * orbitDistance
        )
        
        Utils:TeleportTo(CFrame.new(targetHRP.Position + offset, targetHRP.Position))
        
        -- Ataque y Habilidades
        Session.Status = "PvP IA: Atacando a " .. target.Name
        Combat:FastAttack()
        self:UseSkills("PvP")
        
        -- Verificar si murió para el contador
        if target.Character.Humanoid.Health <= 0 then
            Config.PvP.KillCount = Config.PvP.KillCount + 1
            Utils:Notify("PvP", "Objetivo eliminado (" .. Config.PvP.KillCount .. "/" .. Config.PvP.MaxKills .. ")", 3)
            
            if Config.PvP.KillCount >= Config.PvP.MaxKills then
                Config.PvP.AutoPvP = false
                Config.PvP.Enabled = false
                Config.PvP.KillCount = 0
                Utils:Notify("PvP", "Límite de bajas alcanzado. Modo PvP desactivado.", 5)
            end
        end
    else
        Session.Status = "Buscando objetivo PvP..."
    end
end

return AI
