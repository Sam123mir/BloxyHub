--[[
    BLOXY HUB TITANIUM - MÓDULO: FARMING
    Sistema de auto-farm (código de Banana Hub)
]]

local Farming = {}

local Core = nil
local Combat = nil

function Farming:Init(core, combat)
    Core = core
    Combat = combat
    
    -- Cargar sistema de quests de Banana Hub
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NGUYENVUDUY1/Opfile/main/Ch%C6%B0a%20c%C3%B3%20ti%C3%AAu%20%C4%91%E1%BB%81.txt"))()
    end)
    
    -- Setup noclip y body velocity
    self:SetupNoclip()
    self:SetupBodyClip()
    self:SetupWeaponSelector()
end

function Farming:SetupNoclip()
    spawn(function()
        Core.RunService.Stepped:Connect(function()
            if _G.AutoLevel or _G.AutoNear or _G.AutoBoss or _G.AutoMaterial or _G.AutoBone or _G.CakePrince or _G.Ectoplasm or _G.AutoElite then
                pcall(function()
                    for i, v in pairs(Core.LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end)
            end
        end)
    end)
end

function Farming:SetupBodyClip()
    spawn(function()
        while task.wait() do
            pcall(function()
                if _G.AutoLevel or _G.AutoNear or _G.AutoBoss or _G.AutoMaterial or _G.AutoBone or _G.CakePrince or _G.Ectoplasm or _G.AutoElite then
                    if not Core.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                        local Noclip = Instance.new("BodyVelocity")
                        Noclip.Name = "BodyClip"
                        Noclip.Parent = Core.LocalPlayer.Character.HumanoidRootPart
                        Noclip.MaxForce = Vector3.new(100000, 100000, 100000)
                        Noclip.Velocity = Vector3.new(0, 0, 0)
                    end
                else
                    if Core.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                        Core.LocalPlayer.Character.HumanoidRootPart.BodyClip:Destroy()
                    end
                end
            end)
        end
    end)
end

function Farming:SetupWeaponSelector()
    task.spawn(function()
        while wait() do
            pcall(function()
                if Core.ChooseWeapon == "Melee" then
                    for i, v in pairs(Core.LocalPlayer.Backpack:GetChildren()) do
                        if v.ToolTip == "Melee" then
                            Core.SelectWeapon = v.Name
                        end
                    end
                elseif Core.ChooseWeapon == "Sword" then
                    for i, v in pairs(Core.LocalPlayer.Backpack:GetChildren()) do
                        if v.ToolTip == "Sword" then
                            Core.SelectWeapon = v.Name
                        end
                    end
                elseif Core.ChooseWeapon == "Blox Fruit" then
                    for i, v in pairs(Core.LocalPlayer.Backpack:GetChildren()) do
                        if v.ToolTip == "Blox Fruit" then
                            Core.SelectWeapon = v.Name
                        end
                    end
                end
            end)
        end
    end)
end

function Farming:StartAutoLevel()
    spawn(function()
        while task.wait() do
            if _G.AutoLevel then
                pcall(function()
                    CheckLevel()
                    if not string.find(Core.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or Core.LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                        Core.ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                        Combat:Tween(CFrameQ)
                        if (CFrameQ.Position - Core.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
                            Core.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                        end
                    elseif string.find(Core.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or Core.LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                        for i, v in pairs(Core.Workspace.Enemies:GetChildren()) do
                            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                if v.Name == Ms then
                                    repeat wait(_G.Fast_Delay)
                                        Combat:AttackNoCoolDown()
                                        Core.bringmob = true
                                        Combat:AutoHaki()
                                        Combat:EquipTool(Core.SelectWeapon)
                                        Combat:Tween(v.HumanoidRootPart.CFrame * CFrame.new(Core.posX, Core.posY, Core.posZ))
                                        v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                        v.HumanoidRootPart.Transparency = 1
                                        v.Humanoid.JumpPower = 0
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.CanCollide = false
                                        Core.FarmPos = v.HumanoidRootPart.CFrame
                                        Core.MonFarm = v.Name
                                    until not _G.AutoLevel or not v.Parent or v.Humanoid.Health <= 0 or not Core.Workspace.Enemies:FindFirstChild(v.Name) or Core.LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    Core.bringmob = false
                                end
                            end
                        end
                        for i, v in pairs(Core.Workspace["_WorldOrigin"].EnemySpawns:GetChildren()) do
                            if string.find(v.Name, NameMon) then
                                if (Core.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude >= 10 then
                                    Combat:Tween(v.CFrame * CFrame.new(Core.posX, Core.posY, Core.posZ))
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
end

function Farming:StartAutoNear()
    spawn(function()
        while wait(0.1) do
            if _G.AutoNear then
                pcall(function()
                    for i, v in pairs(Core.Workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            if (Core.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude <= 5000 then
                                repeat wait(_G.Fast_Delay)
                                    Combat:AttackNoCoolDown()
                                    Core.bringmob = true
                                    Combat:AutoHaki()
                                    Combat:EquipTool(Core.SelectWeapon)
                                    Combat:Tween(v.HumanoidRootPart.CFrame * CFrame.new(Core.posX, Core.posY, Core.posZ))
                                    v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    v.HumanoidRootPart.Transparency = 1
                                    v.Humanoid.JumpPower = 0
                                    v.Humanoid.WalkSpeed = 0
                                    v.HumanoidRootPart.CanCollide = false
                                    Core.FarmPos = v.HumanoidRootPart.CFrame
                                    Core.MonFarm = v.Name
                                until not _G.AutoNear or not v.Parent or v.Humanoid.Health <= 0 or not Core.Workspace.Enemies:FindFirstChild(v.Name)
                                Core.bringmob = false
                            end
                        end
                    end
                end)
            end
        end
    end)
end

function Farming:StartAutoBoss(bossName)
    spawn(function()
        while wait() do
            if _G.AutoBoss then
                pcall(function()
                    if Core.Workspace.Enemies:FindFirstChild(bossName) then
                        for i, v in pairs(Core.Workspace.Enemies:GetChildren()) do
                            if v.Name == bossName then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat wait(_G.Fast_Delay)
                                        Combat:AttackNoCoolDown()
                                        Combat:AutoHaki()
                                        Combat:EquipTool(Core.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(80, 80, 80)
                                        Combat:Tween(v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                                        pcall(function()
                                            sethiddenproperty(Core.LocalPlayer, "SimulationRadius", math.huge)
                                        end)
                                    until not _G.AutoBoss or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        if Core.ReplicatedStorage:FindFirstChild(bossName) then
                            Combat:Tween(Core.ReplicatedStorage:FindFirstChild(bossName).HumanoidRootPart.CFrame * CFrame.new(5, 10, 7))
                        end
                    end
                end)
            end
        end
    end)
end

function Farming:StartSafeMode()
    spawn(function()
        while true do
            task.wait()
            if _G.SafeMode then
                pcall(function()
                    if Core.LocalPlayer.Character and Core.LocalPlayer.Character:FindFirstChild("Humanoid") then
                        local h = Core.LocalPlayer.Character.Humanoid.Health / Core.LocalPlayer.Character.Humanoid.MaxHealth * 100
                        if h < 25 then
                            Core.LocalPlayer.Character.HumanoidRootPart.CFrame = Core.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 150, 0)
                        end
                    end
                end)
            end
        end
    end)
end

return Farming
