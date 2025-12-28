--[[
    BLOXY HUB TITANIUM - MÓDULO: COMBAT
    Sistema de combate (código de Banana Hub)
]]

local Combat = {}

local Core = nil
local CbFw, CbFw2

function Combat:Init(core)
    Core = core
    
    -- Inicializar CombatFramework
    pcall(function()
        CbFw = debug.getupvalues(require(Core.LocalPlayer.PlayerScripts.CombatFramework))
        CbFw2 = CbFw[2]
    end)
end

function Combat:GetCurrentBlade()
    local success, result = pcall(function()
        local p13 = CbFw2.activeController
        local ret = p13.blades[1]
        if not ret then return end
        while ret.Parent ~= Core.LocalPlayer.Character do ret = ret.Parent end
        return ret
    end)
    return success and result or nil
end

function Combat:AttackNoCoolDown()
    local success = pcall(function()
        local AC = CbFw2.activeController
        for i = 1, 1 do
            local bladehit = require(Core.ReplicatedStorage.CombatFramework.RigLib).getBladeHits(
                Core.LocalPlayer.Character,
                {Core.LocalPlayer.Character.HumanoidRootPart},
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
                if Core.LocalPlayer.Character:FindFirstChildOfClass("Tool") and AC.blades and AC.blades[1] and blade then
                    Core.ReplicatedStorage.RigControllerEvent:FireServer("weaponChange", tostring(blade))
                    Core.ReplicatedStorage.Remotes.Validator:FireServer(math.floor(u12 / 1099511627776 * 16777215), u10)
                    Core.ReplicatedStorage.RigControllerEvent:FireServer("hit", bladehit, i, "")
                end
            end
        end
    end)
    
    -- Fallback
    if not success then
        pcall(function()
            Core.VirtualUser:CaptureController()
            Core.VirtualUser:Button1Down(Vector2.new(1280, 672))
        end)
    end
end

function Combat:NormalAttack()
    pcall(function()
        local Module = require(Core.LocalPlayer.PlayerScripts.CombatFramework)
        local CombatFramework = debug.getupvalues(Module)[2]
        local CamShake = require(Core.ReplicatedStorage.Util.CameraShaker)
        CamShake:Stop()
        CombatFramework.activeController.attacking = false
        CombatFramework.activeController.timeToNextAttack = 0
        CombatFramework.activeController.hitboxMagnitude = 180
        Core.VirtualUser:CaptureController()
        Core.VirtualUser:Button1Down(Vector2.new(1280, 672))
    end)
end

function Combat:AutoHaki()
    pcall(function()
        if not Core.LocalPlayer.Character:FindFirstChild("HasBuso") then
            Core.ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
        end
    end)
end

function Combat:EquipTool(toolName)
    pcall(function()
        if Core.LocalPlayer.Backpack:FindFirstChild(toolName) then
            local tool = Core.LocalPlayer.Backpack:FindFirstChild(toolName)
            Core.LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end)
end

function Combat:Tween(targetCFrame)
    pcall(function()
        local Distance = (targetCFrame.Position - Core.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        local Speed = Core.TweenSpeed
        Core.TweenService:Create(Core.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear), {
            CFrame = targetCFrame
        }):Play()
    end)
end

function Combat:CancelTween()
    self:Tween(Core.LocalPlayer.Character.HumanoidRootPart.CFrame)
end

return Combat
