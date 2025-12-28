--[[
    BLOXY HUB TITANIUM - MÓDULO: CORE
    Funciones base y variables globales (de Banana Hub)
]]

local Core = {}

-- Servicios
Core.Players = game:GetService("Players")
Core.ReplicatedStorage = game:GetService("ReplicatedStorage")
Core.Workspace = game:GetService("Workspace")
Core.TweenService = game:GetService("TweenService")
Core.VirtualUser = game:GetService("VirtualUser")
Core.VirtualInputManager = game:GetService("VirtualInputManager")
Core.RunService = game:GetService("RunService")
Core.UserInputService = game:GetService("UserInputService")

Core.LocalPlayer = Core.Players.LocalPlayer

-- Detectar Sea
Core.First_Sea = false
Core.Second_Sea = false
Core.Third_Sea = false

local id = game.PlaceId
if id == 2753915549 then 
    Core.First_Sea = true 
elseif id == 4442272183 then 
    Core.Second_Sea = true 
elseif id == 7449423635 then 
    Core.Third_Sea = true 
end

-- Variables globales
_G.Fast_Delay = 0.05
_G.AutoLevel = false
_G.AutoNear = false
_G.AutoBoss = false
_G.AutoMaterial = false
_G.AutoBone = false
_G.CakePrince = false
_G.Ectoplasm = false
_G.AutoElite = false
_G.AutoSeaBeast = false
_G.AutoTerrorshark = false
_G.AutoShark = false
_G.AutoFishCrew = false
_G.SafeMode = true
_G.InfiniteJump = false
_G.AutoBuso = false

-- Variables de farming
Core.SelectWeapon = "Combat"
Core.ChooseWeapon = "Melee"
Core.TweenSpeed = 340
Core.posX, Core.posY, Core.posZ = 0, 10, 0
Core.bringmob = false
Core.FarmPos = nil
Core.MonFarm = ""

-- Variables de quest
Core.NameQuest = ""
Core.NameMon = ""
Core.QuestLv = 1
Core.CFrameQ = CFrame.new()
Core.Ms = ""

-- Listas de mobs
Core.tableMon = {}
Core.tableBoss = {}

if Core.First_Sea then
    Core.tableMon = {"Bandit","Monkey","Gorilla","Pirate","Brute","Desert Bandit","Desert Officer","Snow Bandit","Snowman","Chief Petty Officer","Sky Bandit","Dark Master","Prisoner","Dangerous Prisoner","Toga Warrior","Gladiator","Military Soldier","Military Spy","Fishman Warrior","Fishman Commando","God's Guard","Shanda","Royal Squad","Royal Soldier","Galley Pirate","Galley Captain"}
    Core.tableBoss = {"The Gorilla King","Bobby","Yeti","Mob Leader","Vice Admiral","Warden","Chief Warden","Swan","Magma Admiral","Fishman Lord","Wysper","Thunder God","Cyborg","Saber Expert"}
elseif Core.Second_Sea then
    Core.tableMon = {"Raider","Mercenary","Swan Pirate","Factory Staff","Marine Lieutenant","Marine Captain","Zombie","Vampire","Snow Trooper","Winter Warrior","Lab Subordinate","Horned Warrior","Magma Ninja","Lava Pirate","Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Arctic Warrior","Snow Lurker","Sea Soldier","Water Fighter"}
    Core.tableBoss = {"Diamond","Jeremy","Fajita","Don Swan","Smoke Admiral","Cursed Captain","Darkbeard","Order","Awakened Ice Admiral","Tide Keeper"}
elseif Core.Third_Sea then
    Core.tableMon = {"Pirate Millionaire","Dragon Crew Warrior","Dragon Crew Archer","Female Islander","Giant Islander","Marine Commodore","Marine Rear Admiral","Fishman Raider","Fishman Captain","Forest Pirate","Mythological Pirate","Jungle Pirate","Musketeer Pirate","Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy","Peanut Scout","Peanut President","Ice Cream Chef","Ice Cream Commander","Cookie Crafter","Cake Guard","Baking Staff","Head Baker","Cocoa Warrior","Chocolate Bar Battler","Sweet Thief","Candy Rebel","Candy Pirate","Snow Demon","Isle Outlaw","Island Boy","Isle Champion"}
    Core.tableBoss = {"Stone","Island Empress","Kilo Admiral","Captain Elephant","Beautiful Pirate","rip_indra True Form","Longma","Soul Reaper","Cake Queen"}
end

-- Listas de islas
Core.IslandList = {}

if Core.First_Sea then
    Core.IslandList = {"Jungle", "Buggy", "Desert", "Snow", "Marine", "Sky", "Prison", "Colosseum", "Magma", "Fishman", "Sky Island", "Fountain"}
elseif Core.Second_Sea then
    Core.IslandList = {"Area 1", "Area 2", "Zombie", "Marine", "Snow Mountain", "Ice fire", "Ship", "Frost", "Forgotten"}
elseif Core.Third_Sea then
    Core.IslandList = {"Pirate Port", "Amazon", "Marine Tree", "Deep Forest", "Haunted Castle", "Nut Island", "Ice Cream Island", "Cake Island", "Choco Island", "Candy Island", "Tiki Outpost"}
end

-- Función helper
function Core.round(n)
    return math.floor(tonumber(n) + 0.5)
end

function Core.GetWorldName()
    if Core.First_Sea then return "First Sea"
    elseif Core.Second_Sea then return "Second Sea"
    elseif Core.Third_Sea then return "Third Sea"
    else return "Unknown" end
end

return Core
