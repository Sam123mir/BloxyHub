--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║  BLOXY HUB ELITE V6.0 - TITANIUM EDITION                    ║
    ║  Arquitectura Modular Industrial | Sincronización Real      ║
    ║  Desarrollado para Sammir | Reconstrucción Maestro          ║
    ╚══════════════════════════════════════════════════════════════╝
--]]

-- // SEGURIDAD Y PRE-CARGA
getgenv().BloxyElite = getgenv().BloxyElite or {}
if getgenv().BloxyElite.Active then
    pcall(function() getgenv().BloxyElite.Shutdown() end)
    task.wait(1)
end

-- // MÓDULO: THREAD MANAGER (PRO)
local ThreadManager = {Threads = {}, Active = true}
function ThreadManager:Spawn(name, func)
    if self.Threads[name] then pcall(function() task.cancel(self.Threads[name]) end) end
    self.Threads[name] = task.spawn(function()
        while self.Active do
            local s, e = pcall(func)
            if not s then warn("[TITANIUM ERROR: "..name.."] "..tostring(e)) end
            task.wait(0.1)
        end
    end)
end

-- // MÓDULO: SERVICIOS
local S = {
    P = game:GetService("Players"),
    W = game:GetService("Workspace"),
    RS = game:GetService("ReplicatedStorage"),
    TS = game:GetService("TweenService"),
    RSV = game:GetService("RunService"),
    VU = game:GetService("VirtualUser"),
    ST = game:GetService("Stats")
}
local LP = S.P.LocalPlayer

-- // CONFIGURACIÓN TITANIUM
local Config = {
    Farm = {Enabled = false, Mode = "Level", Tool = "Melee", Distance = 10, Fast = true},
    Mastery = {Enabled = false, TargetHP = 20, Tool = "Sword"},
    Stats = {Enabled = false, Points = {Melee = false, Defense = false, Sword = false}},
    Security = {AdminLeave = true, AntiAFK = true},
    Visuals = {CPUMode = false, WhiteScreen = false}
}

-- // DATABASE: QUESTS (SEA 1 - COMPACTO MASTER)
local QuestData = {
    ["Sea 1"] = {
        {Lvl = 0, Name = "Bandit", QName = "BanditQuest1", NPC = Vector3.new(1060, 16, 1547), Mobs = "Bandit"},
        {Lvl = 10, Name = "Monkey", QName = "MonkeyQuest1", NPC = Vector3.new(-1601, 37, 153), Mobs = "Monkey"},
        {Lvl = 15, Name = "Gorilla", QName = "GorillaQuest1", NPC = Vector3.new(-1137, 4, -495), Mobs = "Gorilla"},
        {Lvl = 30, Name = "Pirate", QName = "PirateQuest1", NPC = Vector3.new(-1140, 4, 3828), Mobs = "Pirate"},
        {Lvl = 60, Name = "Brute", QName = "Island1Quest1", NPC = Vector3.new(-1240, 11, 4766), Mobs = "Brute"},
        {Lvl = 90, Name = "Desert Bandit", QName = "DesertQuest", NPC = Vector3.new(894, 6, 4390), Mobs = "Desert Bandit"},
        {Lvl = 120, Name = "Snow Bandit", QName = "SnowQuest", NPC = Vector3.new(1385, 87, -1298), Mobs = "Snow Bandit"},
        {Lvl = 150, Name = "Chief Petty Officer", QName = "MarineQuest1", NPC = Vector3.new(-4809, 21, 4360), Mobs = "Chief Petty Officer"},
        {Lvl = 190, Name = "Sky Bandit", QName = "SkyQuest", NPC = Vector3.new(-4842, 717, -2620), Mobs = "Sky Bandit"},
        {Lvl = 250, Name = "Toga Warrior", QName = "ColosseumQuest", NPC = Vector3.new(-1575, 7, -2982), Mobs = "Toga Warrior"},
        {Lvl = 300, Name = "Magma Village", QName = "MagmaQuest", NPC = Vector3.new(-5313, 12, 8515), Mobs = "Military Detective"},
        {Lvl = 375, Name = "Fishman Warrior", QName = "FishmanQuest", NPC = Vector3.new(61122, 18, 1568), Mobs = "Fishman Warrior"},
        {Lvl = 450, Name = "God's Guard", QName = "UpperSkyQuest1", NPC = Vector3.new(-7859, 5545, -382), Mobs = "God's Guard"},
        {Lvl = 525, Name = "Galley Pirate", QName = "FountainQuest", NPC = Vector3.new(5124, 59, 4102), Mobs = "Galley Pirate"},
        {Lvl = 625, Name = "Shanda", QName = "Island2Quest1", NPC = Vector3.new(-7859, 5545, -382), Mobs = "Shanda"}
    },
    ["Sea 2"] = {
        {Lvl = 700, Name = "Raider", QName = "Area1Quest", NPC = Vector3.new(-425, 73, 1836), Mobs = "Raider"},
        {Lvl = 775, Name = "Mercenary", QName = "Area2Quest", NPC = Vector3.new(635, 73, 917), Mobs = "Mercenary"},
        {Lvl = 875, Name = "Swan Pirate", QName = "Area2Quest", NPC = Vector3.new(635, 73, 917), Mobs = "Swan Pirate"},
        {Lvl = 1000, Name = "Snowman", QName = "SnowMountainQuest", NPC = Vector3.new(607, 401, -5371), Mobs = "Snowman"}
    },
    ["Sea 3"] = {
        {Lvl = 1500, Name = "Pirate Millionaire", QName = "TurtleQuest1", NPC = Vector3.new(-13233, 532, -7576), Mobs = "Pirate Millionaire"}
    }
}

-- // MÓDULO: AUTO STATS
ThreadManager:Spawn("StatsDistributor", function()
    if not Config.Stats.Enabled then return end
    local p = LP.Data.StatsPoints.Value
    if p > 0 then
        local active = {}
        if Config.Stats.Points.Melee then table.insert(active, "Melee") end
        if Config.Stats.Points.Defense then table.insert(active, "Defense") end
        if Config.Stats.Points.Sword then table.insert(active, "Sword") end
        
        if #active > 0 then
            local per = math.floor(p / #active)
            for _, s in pairs(active) do
                S.RS.Remotes.CommF_:InvokeServer("AddPoint", s, per)
            end
        end
    end
    task.wait(1)
end)

-- // UTILIDADES PRO
local Utils = {}
function Utils:Teleport(cf)
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    LP.Character.HumanoidRootPart.CFrame = cf
end

function Utils:Equip(toolName)
    if toolName == "Melee" then
        for _, t in pairs(LP.Backpack:GetChildren()) do
            if t:IsA("Tool") and (t.ToolTip == "Melee" or t.Name == "Combat" or t.Name == "Water Kung Fu" or t.Name == "Dark Step") then
                LP.Character.Humanoid:EquipTool(t)
                return
            end
        end
    end
    local tool = LP.Backpack:FindFirstChild(toolName) or LP.Character:FindFirstChild(toolName)
    if tool then LP.Character.Humanoid:EquipTool(tool) end
end

function Utils:GetWorld()
    local id = game.PlaceId
    if id == 2753915549 then return "Sea 1"
    elseif id == 4442272183 then return "Sea 2"
    elseif id == 7449423635 then return "Sea 3"
    else return "Unknown" end
end

-- // MÓDULO: AUTO MASTERY (BRAIN)
ThreadManager:Spawn("MasteryBrain", function()
    if not Config.Mastery.Enabled then return end
    
    local q = GetBestQuest()
    if not q then return end
    
    for _, m in pairs(S.W.Enemies:GetChildren()) do
        if m.Name == q.Mobs and m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0 then
            repeat
                task.wait()
                Utils:Teleport(m.HumanoidRootPart.CFrame * CFrame.new(0, Config.Farm.Distance, 0))
                
                local hp = m.Humanoid.Health / m.Humanoid.MaxHealth * 100
                if hp > Config.Mastery.TargetHP then
                    Utils:Equip("Melee") -- Bajar vida con Melee
                    Combat:Attack(m)
                else
                    Utils:Equip(Config.Mastery.Tool) -- Rematar con Arma elegida
                    S.VU:SetKeyDown("z")
                    task.wait(0.1)
                    S.VU:SetKeyUp("z")
                end
            until not Config.Mastery.Enabled or not m.Parent or m.Humanoid.Health <= 0
        end
    end
end)

-- // MÓDULO: SEGURIDAD (ADMIN DETECTOR)
ThreadManager:Spawn("SecurityAdmin", function()
    if not Config.Security.AdminLeave then return end
    for _, p in pairs(S.P:GetPlayers()) do
        if p:GetRankInGroup(2440505) >= 1 then
            LP:Kick("¡ALERTA TITANIUM! Admin detectado: "..p.Name)
        end
    end
    task.wait(5)
end)

-- // MÓDULO: PERFORMANCE (CPU MODE)
local function ApplyCPUMode()
    for _, v in pairs(S.W:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic 
        elseif v:IsA("Decal") then v:Destroy() end
    end
end

-- // COMBAT SYSTEM (SISTEMA DE DAÑO TITANIUM)
local Combat = {}
function Combat:Attack(target)
    pcall(function()
        local v = S.RS.Remotes:FindFirstChild("Validator")
        if v then
            v:FireServer("Combat", LP.Character)
            if target then v:FireServer(target) end
        end
        S.VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

-- // THE BRAIN: AUTO FARM LOGIC
local function GetBestQuest()
    local myLvl = LP.Data.Level.Value
    local world = Utils:GetWorld()
    local best = nil
    
    if QuestData[world] then
        for _, q in pairs(QuestData[world]) do
            if myLvl >= q.Lvl then best = q end
        end
    end
    return best
end

ThreadManager:Spawn("FarmingBrain", function()
    if not Config.Farm.Enabled then return end
    
    local q = GetBestQuest()
    if not q then return end
    
    -- Lógica de Quest
    if not LP.PlayerGui.Main:FindFirstChild("Quest") then
        Utils:Teleport(CFrame.new(q.NPC))
        task.wait(0.5)
        S.RS.Remotes.CommF_:InvokeServer("StartQuest", q.QName, 1)
    else
        -- Lógica de Kill
        for _, m in pairs(S.W.Enemies:GetChildren()) do
            if m.Name == q.Mobs and m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0 then
                repeat
                    task.wait()
                    Utils:Teleport(m.HumanoidRootPart.CFrame * CFrame.new(0, Config.Farm.Distance, 0))
                    Combat:Attack(m)
                until not Config.Farm.Enabled or not m.Parent or m.Humanoid.Health <= 0
            end
        end
    end
end)

-- // UI SETUP (RAYFIELD ELITE)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Bloxy Hub TITANIUM 💎 | v6.0",
    LoadingTitle = "Iniciando Edición Maestra...",
    LoadingSubtitle = "por Antigravity & Sammir",
    ImageId = 4483362458
})

local Tabs = {
    Home = Window:CreateTab("Dashboard", 4483362458),
    Farm = Window:CreateTab("Farming", 4483362458),
    Stats = Window:CreateTab("Stats", 4483362458),
    Misc = Window:CreateTab("Misc", 4483362458)
}

-- DASHBOARD SINC
local DashPara = Tabs.Home:CreateParagraph({Title = "Sincronizando...", Content = "Cargando datos reales..."})
ThreadManager:Spawn("DashboardUpdate", function()
    local ping = math.floor(S.ST.Network.ServerStatsItem["Data Ping"]:GetValue())
    local world = Utils:GetWorld()
    DashPara:Set({
        Title = "TITANIUM v6.0 | Ping: "..ping.."ms",
        Content = string.format("Nivel: %d | Beli: %s\nMundo: %s | Estado: %s", 
            LP.Data.Level.Value, 
            tostring(LP.Data.Beli.Value),
            world,
            Config.Farm.Enabled and "Farmeando" or "En espera")
    })
    task.wait(1)
end)

-- STATS TAB
Tabs.Stats:CreateSection("Distribución Selectiva")
Tabs.Stats:CreateToggle({Name = "🥊 Auto Melee", Callback = function(v) Config.Stats.Points.Melee = v end})
Tabs.Stats:CreateToggle({Name = "🛡️ Auto Defense", Callback = function(v) Config.Stats.Points.Defense = v end})
Tabs.Stats:CreateToggle({Name = "⚔️ Auto Sword", Callback = function(v) Config.Stats.Points.Sword = v end})
Tabs.Stats:CreateToggle({Name = "✅ ACTIVAR AUTO STATS", Callback = function(v) Config.Stats.Enabled = v end})

-- FARM CONTROLS
Tabs.Farm:CreateSection("Auto Farming")
Tabs.Farm:CreateToggle({Name = "Iniciar Auto Level", Callback = function(v) Config.Farm.Enabled = v end})
Tabs.Farm:CreateSlider({Name = "Distancia", Range = {5, 20}, Increment = 1, CurrentValue = 10, Callback = function(v) Config.Farm.Distance = v end})

-- MASTERY TAB
local MasteryTab = Window:CreateTab("Auto-Maestría", 4483362458)
MasteryTab:CreateSection("Configuración de Maestría")
MasteryTab:CreateDropdown({
    Name = "Arma Requerida",
    Options = {"Sword", "Fruit", "Gun"},
    Callback = function(v) Config.Mastery.Tool = v end
})
MasteryTab:CreateSlider({
    Name = "HP para Cambiar (%)",
    Range = {10, 40},
    Increment = 5,
    CurrentValue = 20,
    Callback = function(v) Config.Mastery.TargetHP = v end
})
MasteryTab:CreateToggle({Name = "🔥 ACTIVAR AUTO MASTERY", Callback = function(v) Config.Mastery.Enabled = v end})

-- MISC TAB
Tabs.Misc:CreateSection("Utilidades de Servidor")
Tabs.Misc:CreateButton({
    Name = "Server Hop (Saltar a otro)",
    Callback = function() 
        local ps = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, s in pairs(ps.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, LP)
            end
        end
    end
})

Tabs.Misc:CreateSection("Optimización Visual")
Tabs.Misc:CreateToggle({
    Name = "Modo CPU (Remover Texturas)",
    Callback = function(v) if v then ApplyCPUMode() end end
})
Tabs.Misc:CreateToggle({
    Name = "Modo Pantalla Blanca (FPS)",
    Callback = function(v) S.RSV:Set3dRenderingEnabled(not v) end
})

-- SHUTDOWN LOGIC
local function Shutdown()
    ThreadManager.Active = false
    Rayfield:Destroy()
    getgenv().BloxyElite.Active = false
    S.RSV:Set3dRenderingEnabled(true)
    print("Bloxy Hub: Shutdown Complete.")
end

Tabs.Misc:CreateSection("Control del Script")
Tabs.Misc:CreateButton({
    Name = "🔄 Reiniciar Script",
    Callback = function() 
        Shutdown() 
        task.wait(1)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/BloxyHub/refs/heads/main/Main.lua?t="..math.random(1,9999)))()
    end
})

Tabs.Misc:CreateButton({
    Name = "❌ Cerrar Script Totalmente",
    Callback = function() Shutdown() end
})

getgenv().BloxyElite.Shutdown = Shutdown
getgenv().BloxyElite.Active = true

Rayfield:LoadConfiguration()
