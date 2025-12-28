--[[
    BLOXY HUB TITANIUM - MÓDULO: PLAYER
    Mejoras del jugador
]]

local Player = {}

local Core = nil

Player.WalkSpeedValue = 16
Player.JumpPowerValue = 50

function Player:Init(core)
    Core = core
    
    -- Setup loops
    self:SetupMovementLoop()
    self:SetupInfiniteJump()
    self:SetupAutoBuso()
    self:SetupAntiAFK()
end

function Player:SetupMovementLoop()
    Core.RunService.Heartbeat:Connect(function()
        pcall(function()
            if Core.LocalPlayer.Character and Core.LocalPlayer.Character:FindFirstChild("Humanoid") then
                if Player.WalkSpeedValue > 16 then
                    Core.LocalPlayer.Character.Humanoid.WalkSpeed = Player.WalkSpeedValue
                end
                if Player.JumpPowerValue > 50 then
                    Core.LocalPlayer.Character.Humanoid.JumpPower = Player.JumpPowerValue
                end
            end
        end)
    end)
end

function Player:SetupInfiniteJump()
    Core.UserInputService.JumpRequest:Connect(function()
        if _G.InfiniteJump then
            pcall(function()
                Core.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end)
        end
    end)
end

function Player:SetupAutoBuso()
    spawn(function()
        while wait(1) do
            if _G.AutoBuso then
                pcall(function()
                    if not Core.LocalPlayer.Character:FindFirstChild("HasBuso") then
                        Core.ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                    end
                end)
            end
        end
    end)
end

function Player:SetupAntiAFK()
    Core.LocalPlayer.Idled:connect(function()
        Core.VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        Core.VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

function Player:SetWalkSpeed(value)
    Player.WalkSpeedValue = value
end

function Player:SetJumpPower(value)
    Player.JumpPowerValue = value
end

return Player
