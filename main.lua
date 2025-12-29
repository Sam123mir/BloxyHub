--[[
    BLOXY HUB TITANIUM - PROFESSIONAL CONSOLIDATED SCRIPT
    Interface: WindUI Premium
    Engine: Banana Hub Enhanced Logic
    Version: 2.1.0 Stable
]]

-- ═══════════════════════════════════════════════════════════════
-- INITIALIZATION & SERVICES
-- ═══════════════════════════════════════════════════════════════

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- ═══════════════════════════════════════════════════════════════
-- GLOBAL STATE (CORE DATA)
-- ═══════════════════════════════════════════════════════════════

_G.BloxyHub = {
    Flags = {
        AutoFarmer = false,
        AutoMastery = false,
        KillAura = false,
        SafeMode = true,
        FastAttack = true,
        Noclip = false,
        AutoHaki = true,
        InfiniteJump = false,
        ESP_Player = false,
        ESP_Chest = false,
        ESP_Fruit = false,
    },
    Data = {
        SelectWeapon = "Melee",
        CurrentTask = "Idle",
        StartLevel = LocalPlayer.Data.Level.Value,
        StartBeli = LocalPlayer.Data.Beli.Value,
        StartTime = tick(),
    }
}

local Flags = _G.BloxyHub.Flags
local Data = _G.BloxyHub.Data

-- ═══════════════════════════════════════════════════════════════
-- UTILITIES & BYPASSES
-- ═══════════════════════════════════════════════════════════════

local Utils = {}

function Utils:Tween(TargetCFrame, Speed)
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local distance = (TargetCFrame.Position - root.Position).Magnitude
    local info = TweenInfo.new(distance / (Speed or 320), Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, info, {CFrame = TargetCFrame})
    tween:Play()
    return tween
end

function Utils:EquipByToolTip(ToolTip)
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == ToolTip then
            LocalPlayer.Character.Humanoid:EquipTool(tool)
            return tool
        end
    end
    -- Fallback search in character
    for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == ToolTip then
            return tool
        end
    end
end

-- Banana Hub Combat Bypass
local Combat = {}
local CbFw = debug.getupvalues(require(LocalPlayer.PlayerScripts.CombatFramework))
local CbFw2 = CbFw[2]

function Combat:AttackNoCoolDown()
    local AC = CbFw2.activeController
    if not AC or not AC.attack then return end
    
    pcall(function()
        local bladehit = require(ReplicatedStorage.CombatFramework.RigLib).getBladeHits(
            LocalPlayer.Character,
            {LocalPlayer.Character.HumanoidRootPart},
            60
        )
        
        local cac, hash = {}, {}
        for _, v in pairs(bladehit) do
            if v.Parent:FindFirstChild("HumanoidRootPart") and not hash[v.Parent] then
                table.insert(cac, v.Parent.HumanoidRootPart)
                hash[v.Parent] = true
            end
        end
        
        if #cac > 0 then
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
                for _, v in pairs(AC.animator.anims.basic) do v:Play() end
            end)
            
            local tool = Utils:EquipByToolTip(Data.SelectWeapon)
            if tool and AC.blades and AC.blades[1] then
                ReplicatedStorage.RigControllerEvent:FireServer("weaponChange", tostring(tool))
                ReplicatedStorage.Remotes.Validator:FireServer(math.floor(u12 / 1099511627776 * 16777215), u10)
                ReplicatedStorage.RigControllerEvent:FireServer("hit", cac, 1, "")
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- FARMING LOGIC (BANANA HUB ENGINE)
-- ═══════════════════════════════════════════════════════════════

-- Load Quest Data from Banana Hub
loadstring(game:HttpGet("https://raw.githubusercontent.com/NGUYENVUDUY1/Opfile/main/Ch%C6%B0a%20c%C3%B3%20ti%C3%AAu%20%C4%91%E1%BB%81.txt"))()

local Farming = {}

function Farming:CheckLevel()
    -- Global variables CheckLevel, NameMon, CFrameQ, etc are defined in the Banana Hub text file above
    _G.CheckLevel() 
end

task.spawn(function()
    while task.wait() do
        if Flags.AutoFarmer then
            pcall(function()
                Farming:CheckLevel()
                local questGui = LocalPlayer.PlayerGui.Main.Quest
                if not questGui.Visible or not string.find(questGui.Container.QuestTitle.Title.Text, _G.NameMon) then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                    Utils:Tween(_G.CFrameQ)
                    if (LocalPlayer.Character.HumanoidRootPart.Position - _G.CFrameQ.Position).Magnitude < 10 then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", _G.NameQuest, _G.QuestLv)
                    end
                else
                    -- Search for target mob
                    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                        if enemy.Name == _G.Ms and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            repeat task.wait()
                                if not Flags.AutoFarmer then break end
                                Utils:Tween(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                                enemy.HumanoidRootPart.CanCollide = false
                                if Flags.AutoHaki and not LocalPlayer.Character:FindFirstChild("HasBuso") then
                                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                                end
                                if Flags.FastAttack then
                                    Combat:AttackNoCoolDown()
                                end
                            until enemy.Humanoid.Health <= 0 or not enemy.Parent or not Flags.AutoFarmer
                        end
                    end
                end
            end)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- WINDUI PREMIUM INTERFACE
-- ═══════════════════════════════════════════════════════════════

local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/ui/WindUI"))()

local Window = WindUI:CreateWindow({
    Title = "Bloxy Hub Titanium",
    Icon = "rbxassetid://16601446273",
    Author = "@BloxyHub",
    Folder = "BH_Titanium",
    Size = UDim2.fromOffset(560, 480),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    HasOutline = true
})

-- 1. Dashboard
local HomeTab = Window:Tab({ Title = "Dashboard", Icon = "home" })
local StatsSection = HomeTab:Section({ Title = "📊 Session Statistics", Box = true })

local FPSLabel = StatsSection:Label({ Title = "FPS: 60" })
local PingLabel = StatsSection:Label({ Title = "Ping: 0ms" })
local UptimeLabel = StatsSection:Label({ Title = "Uptime: 0s" })
local GainLabel = StatsSection:Label({ Title = "Level Gained: 0" })

local ProfileSection = HomeTab:Section({ Title = "👤 User Profile", Box = true })
ProfileSection:Label({ Title = "User: " .. LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")" })
ProfileSection:Label({ Title = "World: " .. (Workspace:FindFirstChild("Map") and "Sea " .. (Workspace.Map:FindFirstChild("Sea1") and "1" or Workspace.Map:FindFirstChild("Sea2") and "2" or "3") or "Unknown") })

-- 2. Farming
local FarmTab = Window:Tab({ Title = "Farming", Icon = "zap" })
local MainFarm = FarmTab:Section({ Title = "🎯 Auto Level", Box = true })

MainFarm:Toggle({
    Title = "Iniciar Auto Level",
    Default = false,
    Callback = function(v)
        Flags.AutoFarmer = v
        Data.CurrentTask = v and "Farming Level" or "Idle"
    end
})

local ConfigFarm = FarmTab:Section({ Title = "⚙️ Configuration", Box = true })
ConfigFarm:Dropdown({
    Title = "Select Weapon",
    Values = {"Melee", "Sword", "Blox Fruit"},
    Value = "Melee",
    Callback = function(v) Data.SelectWeapon = v end
})

ConfigFarm:Toggle({
    Title = "Fast Attack (bypass)",
    Default = true,
    Callback = function(v) Flags.FastAttack = v end
})

-- 3. Combat
local CombatTab = Window:Tab({ Title = "Combat", Icon = "sword" })
local AuraSec = CombatTab:Section({ Title = "⚔️ Kill Aura", Box = true })

AuraSec:Toggle({
    Title = "Enable Kill Aura",
    Default = false,
    Callback = function(v) Flags.KillAura = v end
})

local CombatSettings = CombatTab:Section({ Title = "⚙️ Combat Settings", Box = true })
CombatSettings:Toggle({
    Title = "Auto Haki",
    Default = true,
    Callback = function(v) Flags.AutoHaki = v end
})

-- 4. Sea Events
local SeaTab = Window:Tab({ Title = "Sea Events", Icon = "anchor" })
local SeaSec = SeaTab:Section({ Title = "🌊 Third Sea Events", Box = true })

SeaSec:Toggle({
    Title = "Auto Terrorshark",
    Default = false,
    Callback = function(v) Flags.AutoTerrorshark = v end
})

SeaSec:Toggle({
    Title = "Auto Shark",
    Default = false,
    Callback = function(v) Flags.AutoShark = v end
})

SeaSec:Toggle({
    Title = "Auto Sea Beast",
    Default = false,
    Callback = function(v) Flags.AutoSeaBeast = v end
})

-- 5. Items
local ItemTab = Window:Tab({ Title = "Items", Icon = "star" })
local SwordSec = ItemTab:Section({ Title = "⚔️ Swords", Box = true })

SwordSec:Button({
    Title = "Saber (Auto)",
    Callback = function() -- Logic for Saber
    end
})

-- 6. Stats
local StatsTab = Window:Tab({ Title = "Stats", Icon = "plus" })
local StatsAssign = StatsTab:Section({ Title = "📈 Auto Assign", Box = true })

local statsList = {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"}
for _, stat in pairs(statsList) do
    StatsAssign:Toggle({
        Title = "Auto " .. stat,
        Default = false,
        Callback = function(v)
            _G.AutoStats = _G.AutoStats or {}
            _G.AutoStats[stat] = v
        end
    })
end

-- 7. Player
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local EnhanceSec = PlayerTab:Section({ Title = "⚡ Enhancements", Box = true })

EnhanceSec:Slider({
    Title = "Walk Speed",
    Value = { Min = 16, Max = 300, Default = 16 },
    Callback = function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v end
})

EnhanceSec:Slider({
    Title = "Jump Power",
    Value = { Min = 50, Max = 500, Default = 50 },
    Callback = function(v) LocalPlayer.Character.Humanoid.JumpPower = v end
})

EnhanceSec:Toggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(v) Flags.InfiniteJump = v end
})

-- 5. Settings
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })
SettingsTab:Button({
    Title = "FPS Boost",
    Callback = function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.Plastic end
        end
    end
})

-- ═══════════════════════════════════════════════════════════════
-- BACKGROUND LOOPS (STATS & FEATS)
-- ═══════════════════════════════════════════════════════════════

task.spawn(function()
    while task.wait(1) do
        -- Update UI Stats
        local uptime = math.floor(tick() - Data.StartTime)
        local levelGained = LocalPlayer.Data.Level.Value - Data.StartLevel
        
        FPSLabel:SetTitle("FPS: " .. math.floor(1 / task.wait()))
        PingLabel:SetTitle("Ping: " .. math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) .. "ms")
        UptimeLabel:SetTitle("Uptime: " .. uptime .. "s")
        GainLabel:SetTitle("Level Gained: " .. levelGained)
        
        -- Infinite Jump
        if Flags.InfiniteJump then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

Window:SelectTab(1)
WindUI:Notify({
    Title = "Bloxy Hub Titanium",
    Content = "Professional Script Loaded Successfully!",
    Icon = "rbxassetid://16601446273"
})
