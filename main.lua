local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- ═══════════════════════════════════════════════════════════════
-- WINDOW CONFIGURATION
-- ═══════════════════════════════════════════════════════════════

local Window = Fluent:CreateWindow({
    Title = "Bloxy Hub Titanium",
    SubTitle = "POWERED BY BANANA HUB | CRACKED BY xZPUHigh",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.End
})

local Tabs = {
    home = Window:AddTab({ Title = "Home", Icon = "home" }),
    Main = Window:AddTab({ Title = "Farm", Icon = "zap" }),
    Sea = Window:AddTab({ Title = "Sea Event", Icon = "anchor" }),
    ITM = Window:AddTab({ Title = "Items", Icon = "sword" }),
    Stats = Window:AddTab({ Title = "Stats", Icon = "plus-circle" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Fruit = Window:AddTab({ Title = "Fruit", Icon = "apple" }),
    Raid = Window:AddTab({ Title = "Dungeon", Icon = "swords" }),
    Setting = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local Options = Fluent.Options

-- ═══════════════════════════════════════════════════════════════
-- DATA & DETECTION
-- ═══════════════════════════════════════════════════════════════

local id = game.PlaceId
local First_Sea, Second_Sea, Third_Sea = false, false, false

if id == 2753915549 then First_Sea = true
elseif id == 4442272183 then Second_Sea = true 
elseif id == 7449423635 then Third_Sea = true 
else game:Shutdown() end

-- Anti-AFK
game:GetService("Players").LocalPlayer.Idled:connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- Quest Data Loading
loadstring(game:HttpGet("https://raw.githubusercontent.com/NGUYENVUDUY1/Opfile/main/Ch%C6%B0a%20c%C3%B3%20ti%C3%AAu%20%C4%91%E1%BB%81.txt"))()

-- Mob Tables
if First_Sea then
    tableMon = {"Bandit","Monkey","Gorilla","Pirate","Brute","Desert Bandit","Desert Officer","Snow Bandit","Snowman","Chief Petty Officer","Sky Bandit","Dark Master","Prisoner","Dangerous Prisoner","Toga Warrior","Gladiator","Military Soldier","Military Spy","Fishman Warrior","Fishman Commando","God's Guard","Shanda","Royal Squad","Royal Soldier","Galley Pirate","Galley Captain"}
    AreaList = {'Jungle', 'Buggy', 'Desert', 'Snow', 'Marine', 'Sky', 'Prison', 'Colosseum', 'Magma', 'Fishman', 'Sky Island', 'Fountain'}
elseif Second_Sea then
    tableMon = {"Raider","Mercenary","Swan Pirate","Factory Staff","Marine Lieutenant","Marine Captain","Zombie","Vampire","Snow Trooper","Winter Warrior","Lab Subordinate","Horned Warrior","Magma Ninja","Lava Pirate","Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Arctic Warrior","Snow Lurker","Sea Soldier","Water Fighter"}
    AreaList = {'Area 1', 'Area 2', 'Zombie', 'Marine', 'Snow Mountain', 'Ice fire', 'Ship', 'Frost', 'Forgotten'}
elseif Third_Sea then
    tableMon = {"Pirate Millionaire","Dragon Crew Warrior","Dragon Crew Archer","Female Islander","Giant Islander","Marine Commodore","Marine Rear Admiral","Fishman Raider","Fishman Captain","Forest Pirate","Mythological Pirate","Jungle Pirate","Musketeer Pirate","Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy","Peanut Scout","Peanut President","Ice Cream Chef","Ice Cream Commander","Cookie Crafter","Cake Guard","Baking Staff","Head Baker","Cocoa Warrior","Chocolate Bar Battler","Sweet Thief","Candy Rebel","Candy Pirate","Snow Demon","Isle Outlaw","Island Boy","Isle Champion"}
    AreaList = {'Pirate Port', 'Amazon', 'Marine Tree', 'Deep Forest', 'Haunted Castle', 'Nut Island', 'Ice Cream Island', 'Cake Island', 'Choco Island', 'Candy Island','Tiki Outpost'}
end

-- External Assets
loadstring(game:HttpGet("https://raw.githubusercontent.com/NGUYENVUDUY1/Opfileew/main/file.txt"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/NGUYENVUDUY1/Filee/main/cast.txt"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/NGUYENVUDUY1/Tptv/main/Gpat.txt"))()

-- ═══════════════════════════════════════════════════════════════
-- CORE FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

local function isnil(thing) return (thing == nil) end
local function round(n) return math.floor(tonumber(n) + 0.5) end
local Number = math.random(1, 1000000)

-- ESP Functions
function UpdatePlayerChams()
    for i,v in pairs(game:GetService'Players':GetChildren()) do
        pcall(function()
            if not isnil(v.Character) and ESPPlayer then
                if not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild('NameEsp'..Number) then
                    local bill = Instance.new('BillboardGui',v.Character.Head)
                    bill.Name = 'NameEsp'..Number
                    bill.ExtentsOffset = Vector3.new(0, 1, 0); bill.Size = UDim2.new(1,200,1,30); bill.Adornee = v.Character.Head; bill.AlwaysOnTop = true
                    local name = Instance.new('TextLabel',bill)
                    name.Font = Enum.Font.GothamSemibold; name.FontSize = "Size10"; name.TextWrapped = true
                    name.Size = UDim2.new(1,0,1,0); name.TextYAlignment = 'Top'; name.BackgroundTransparency = 1; name.TextStrokeTransparency = 0.5
                    name.TextColor3 = (v.Team == game.Players.LocalPlayer.Team) and Color3.new(0,0,254) or Color3.new(255,0,0)
                else
                    v.Character.Head['NameEsp'..Number].TextLabel.Text = (v.Name ..' | '.. round((game:GetService('Players').LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' Distance\nHealth : ' .. round(v.Character.Humanoid.Health*100/v.Character.Humanoid.MaxHealth) .. '%')
                end
            elseif v.Character and v.Character:FindFirstChild("Head") and v.Character.Head:FindFirstChild('NameEsp'..Number) then
                v.Character.Head:FindFirstChild('NameEsp'..Number):Destroy()
            end
        end)
    end
end

-- Tween Speed Settings
local TweenSpeed = 340
function Tween(P1)
    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local Distance = (P1.Position - root.Position).Magnitude
    local info = TweenInfo.new(Distance/TweenSpeed, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(root, info, {CFrame = P1})
    tween:Play()
    if _G.StopTween then tween:Cancel() end
end

function toTarget(CF)
    Tween(CF)
end

-- Combat Logic
local plr = game.Players.LocalPlayer
local CbFw = debug.getupvalues(require(plr.PlayerScripts.CombatFramework))
local CbFw2 = CbFw[2]

function GetCurrentBlade() 
    local p13 = CbFw2.activeController
    local ret = p13.blades[1]
    if not ret then return end
    while ret.Parent~=game.Players.LocalPlayer.Character do ret=ret.Parent end
    return ret
end

function AttackNoCoolDown() 
    local AC = CbFw2.activeController
    pcall(function()
        local bladehit = require(game.ReplicatedStorage.CombatFramework.RigLib).getBladeHits(plr.Character,{plr.Character.HumanoidRootPart},60)
        local cac, hash = {}, {}
        for k, v in pairs(bladehit) do
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
            pcall(function() for k, v in pairs(AC.animator.anims.basic) do v:Play() end end)
            if plr.Character:FindFirstChildOfClass("Tool") and AC.blades and AC.blades[1] then 
                game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("weaponChange",tostring(GetCurrentBlade()))
                game.ReplicatedStorage.Remotes.Validator:FireServer(math.floor(u12 / 1099511627776 * 16777215), u10)
                game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", cac, 1, "") 
            end
        end
    end)
end

function EquipTool(ToolName)
    if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolName) then
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild(ToolName))
    end
end

-- ═══════════════════════════════════════════════════════════════
-- TABS IMPLEMENTATION
-- ═══════════════════════════════════════════════════════════════

-- Home Tab
Tabs.home:AddParagraph({ Title = "Welcome!", Content = "Bloxy Hub Titanium initialized.\nVersion: 2.0.2 Stable" })
Tabs.home:AddButton({ Title = "Copy Discord", Callback = function() setclipboard("https://discord.gg/bloxyhub") end })

-- Main Farm Tab
local DropdownWeapon = Tabs.Main:AddDropdown("Weapon", { Title = "Select Weapon", Values = {"Melee","Sword","Blox Fruit"}, Default = "Melee" })
DropdownWeapon:OnChanged(function(v) _G.SelectType = v end)

Tabs.Main:AddToggle("AutoFarmLevel", { Title = "Auto Farm Level", Default = false }):OnChanged(function(v) _G.AutoLevel = v end)

spawn(function()
    while task.wait() do
        if _G.AutoLevel then
            pcall(function()
                CheckLevel()
                local q = plr.PlayerGui.Main.Quest
                if not q.Visible or not string.find(q.Container.QuestTitle.Title.Text, NameMon) then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    toTarget(CFrameQ)
                    if (CFrameQ.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 5 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest",NameQuest,QuestLv)
                    end
                else
                    for _,v in pairs(game.Workspace.Enemies:GetChildren()) do
                        if v.Name == Ms and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            repeat task.wait()
                                toTarget(v.HumanoidRootPart.CFrame * CFrame.new(0,20,0))
                                v.HumanoidRootPart.CanCollide = false
                                AttackNoCoolDown()
                                EquipTool(SelectWeapon)
                            until not _G.AutoLevel or v.Humanoid.Health <= 0
                        end
                    end
                end
            end)
        end
    end
end)

-- Sea Events Tab
Tabs.Sea:AddToggle("AutoTerrorshark", { Title = "Auto Terrorshark", Default = false }):OnChanged(function(v) _G.AutoTerrorshark = v end)
-- (Loop for Sea Events here...)

-- Floating Button for Mobile
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local ImageButton = Instance.new("ImageButton", ScreenGui)
ImageButton.Size = UDim2.new(0,50,0,50); ImageButton.Position = UDim2.new(0.12,0,0.1,0); ImageButton.BackgroundColor3 = Color3.new(0,0,0); ImageButton.Draggable = true
ImageButton.Image = "http://www.roblox.com/asset/?id=16601446273"
ImageButton.MouseButton1Down:connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true,Enum.KeyCode.End,false,game)
end)

Window:SelectTab(1)
Fluent:Notify({ Title = "Bloxy Hub", Content = "Script cargado correctamente!", Duration = 5 })
