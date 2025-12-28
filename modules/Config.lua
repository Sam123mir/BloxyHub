--[[
    BLOXY HUB TITANIUM - MÓDULO: CONFIG
    Configuración global del script
]]

local Config = {
    -- Información del Script
    Version = "8.0.0 Professional",
    
    -- IDs válidos de Blox Fruits
    ValidPlaceIds = {2753915549, 4442272183, 7449423635},
    
    -- Auto Farming
    AutoFarm = {
        Enabled = false,
        Mode = "Level", -- Level, Mastery, Boss
        Distance = 15,
        SafeMode = true,
        FastMode = false
    },
    
    -- Auto Mastery
    Mastery = {
        Enabled = false,
        Weapon = "Combat", -- Combat, Sword, Fruit, Gun
        FinishAtHealth = 20, -- Porcentaje
        UseSkills = true
    },
    
    -- Auto Stats
    Stats = {
        Enabled = false,
        Distribution = {
            Melee = false,
            Defense = false,
            Sword = false,
            Gun = false,
            ["Blox Fruit"] = false
        },
        SmartMode = true
    },
    
    -- Combat Settings
    Combat = {
        FastAttack = false,
        AttackSpeed = 0.05,
        KillAura = false,
        Range = 50,
        AutoEquipWeapon = true,
        ClickSimulation = true
    },
    
    -- Performance & Security
    Performance = {
        CPUMode = false,
        WhiteScreen = false,
        FPSBoost = false,
        UIRefreshRate = 1.0
    },

    -- Quest Tracking
    Quest = {
        CurrentQuest = nil,
        CurrentNPC = nil,
        QuestName = nil,
        QuestEnemy = nil,
        TargetLvl = 1
    },

    -- Security
    Security = {
        AntiAFK = true,
        AdminDetector = false,
        AutoLeaveOnAdmin = true,
        StaffGroupId = 2440505
    },
    
    -- PvP & AI Settings
    PvP = {
        Enabled = false,
        AutoPvP = false,
        MaxKills = 1,
        TargetPlayer = nil,
        KillCount = 0
    },
    
    -- AI Mastery Settings
    AIMastery = {
        Enabled = false,
        Mode = "IA", -- IA, Manual
        SelectedWeapon = "Combat",
        Skills = {Z = true, X = true, C = true, V = true}
    },
    
    -- Player Settings
    Player = {
        AutoAura = false,
        InfiniteSkyjump = false,
        WalkSpeed = 16,
        JumpPower = 50
    },
    
    -- UI Settings
    UI = {
        Theme = "Dark",
        Language = "Spanish",
        Notifications = true,
        StatusBar = true
    }
}

return Config
