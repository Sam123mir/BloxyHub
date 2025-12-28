--[[
    BLOXY HUB TITANIUM - MÓDULO: PLAYER ENHANCEMENTS
    Mejoras del jugador (Aura, Skyjump, Speed, etc.)
]]

local PlayerEnhancements = {
    SkyjumpConnected = false
}

-- Dependencias
local Services, Config, Utils

function PlayerEnhancements:Init(deps)
    Services = deps.Services
    Config = deps.Config
    Utils = deps.Utils
end

function PlayerEnhancements:AutoAura()
    if not Config.Player.AutoAura then return end
    
    pcall(function()
        local char = Utils:GetCharacter()
        
        -- Verificar si ya tiene el efecto de Aura
        if not char:FindFirstChild("IronBody") then
            local remotes = Services.ReplicatedStorage:FindFirstChild("Remotes")
            if remotes and remotes:FindFirstChild("CommF_") then
                remotes.CommF_:InvokeServer("Buso")
            end
        end
    end)
end

function PlayerEnhancements:SetupInfiniteSkyjump()
    if self.SkyjumpConnected then return end
    
    Services.UserInputService.JumpRequest:Connect(function()
        if Config.Player.InfiniteSkyjump then
            local humanoid = Utils:GetHumanoid()
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
    
    self.SkyjumpConnected = true
end

function PlayerEnhancements:ApplySpeed()
    local humanoid = Utils:GetHumanoid()
    if humanoid then
        if humanoid.WalkSpeed ~= Config.Player.WalkSpeed then 
            humanoid.WalkSpeed = Config.Player.WalkSpeed 
        end
        if humanoid.JumpPower ~= Config.Player.JumpPower then 
            humanoid.JumpPower = Config.Player.JumpPower 
        end
    end
end

function PlayerEnhancements:Update()
    self:AutoAura()
    self:ApplySpeed()
end

return PlayerEnhancements
