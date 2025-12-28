--[[
    BLOXY HUB TITANIUM - MÓDULO: PLAYER ENHANCEMENTS
    Mejoras del jugador - CÓDIGO PROBADO
]]

local PlayerEnhancements = {
    SpeedConnection = nil,
    SkyjumpConnected = false
}

-- Dependencias
local Services, Config, Utils

function PlayerEnhancements:Init(deps)
    Services = deps.Services
    Config = deps.Config
    Utils = deps.Utils
end

-- ═══════════════════════════════════════════════════════════════
-- AUTO HAKI (BUSO)
-- ═══════════════════════════════════════════════════════════════

function PlayerEnhancements:AutoAura()
    if not Config.Player.AutoAura then return end
    
    pcall(function()
        if not Services.LocalPlayer.Character:FindFirstChild("HasBuso") then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- INFINITE SKYJUMP
-- ═══════════════════════════════════════════════════════════════

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

-- ═══════════════════════════════════════════════════════════════
-- SPEED/JUMP LOOP
-- ═══════════════════════════════════════════════════════════════

function PlayerEnhancements:SetupSpeedLoop()
    if self.SpeedConnection then return end
    
    self.SpeedConnection = game:GetService("RunService").Heartbeat:Connect(function()
        pcall(function()
            local humanoid = Utils:GetHumanoid()
            if humanoid then
                -- Aplicar velocidad
                if Config.Player.WalkSpeed and Config.Player.WalkSpeed > 16 then
                    humanoid.WalkSpeed = Config.Player.WalkSpeed
                end
                
                -- Aplicar salto
                if Config.Player.JumpPower and Config.Player.JumpPower > 50 then
                    humanoid.JumpPower = Config.Player.JumpPower
                end
            end
        end)
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- NOCLIP (PARA FARMING)
-- ═══════════════════════════════════════════════════════════════

function PlayerEnhancements:SetupNoclip()
    game:GetService("RunService").Stepped:Connect(function()
        if Config.AutoFarm.Enabled or Config.Mastery.Enabled then
            pcall(function()
                for _, part in pairs(Services.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- BODY VELOCITY (PARA FARMING)
-- ═══════════════════════════════════════════════════════════════

function PlayerEnhancements:SetupBodyClip()
    task.spawn(function()
        while task.wait() do
            pcall(function()
                if Config.AutoFarm.Enabled or Config.Mastery.Enabled then
                    local rootPart = Utils:GetRootPart()
                    if rootPart and not rootPart:FindFirstChild("BodyClip") then
                        local noclip = Instance.new("BodyVelocity")
                        noclip.Name = "BodyClip"
                        noclip.Parent = rootPart
                        noclip.MaxForce = Vector3.new(100000, 100000, 100000)
                        noclip.Velocity = Vector3.new(0, 0, 0)
                    end
                else
                    local rootPart = Utils:GetRootPart()
                    if rootPart and rootPart:FindFirstChild("BodyClip") then
                        rootPart.BodyClip:Destroy()
                    end
                end
            end)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- UPDATE
-- ═══════════════════════════════════════════════════════════════

function PlayerEnhancements:Update()
    if Config.Player.AutoAura then
        self:AutoAura()
    end
end

-- ═══════════════════════════════════════════════════════════════
-- CLEANUP
-- ═══════════════════════════════════════════════════════════════

function PlayerEnhancements:Cleanup()
    if self.SpeedConnection then
        self.SpeedConnection:Disconnect()
        self.SpeedConnection = nil
    end
end

return PlayerEnhancements
