--[[
    BLOXY HUB TITANIUM - UI: TAB COMBAT
    Configuración de combate y PvP
]]

local CombatTab = {}

function CombatTab:Create(Window, deps)
    local Utils = deps.Utils
    local Config = deps.Config
    local Services = deps.Services
    local Colors = deps.Colors
    
    local Tab = Window:Tab({
        Title = Utils:Translate("Combate"),
        Icon = "solar:bolt-bold",
        IconColor = Colors.Red,
        IconShape = "Square",
        Border = true
    })
    
    -- Sección PvP Profesional
    local PvPSection = Tab:Section({
        Title = Utils:Translate("PvPPro"),
        Box = true,
        BoxBorder = true,
        Opened = true
    })
    
    PvPSection:Toggle({
        Title = Utils:Translate("ActivarPvP"),
        Default = Config.PvP.Enabled,
        Flag = "PvPEnabled",
        Callback = function(value)
            Config.PvP.Enabled = value
        end
    })
    
    PvPSection:Space()
    
    PvPSection:Toggle({
        Title = Utils:Translate("AutoPvPIA"),
        Desc = "IA orbita y ataca automáticamente",
        Default = Config.PvP.AutoPvP,
        Flag = "AutoPvP",
        Callback = function(value)
            Config.PvP.AutoPvP = value
        end
    })
    
    PvPSection:Space()
    
    PvPSection:Slider({
        Title = Utils:Translate("MaxObjects"),
        Step = 1,
        Value = {
            Min = 1,
            Max = 10,
            Default = Config.PvP.MaxKills
        },
        Flag = "MaxKills",
        Callback = function(value)
            Config.PvP.MaxKills = value
        end
    })
    
    Tab:Space({ Columns = 2 })
    
    -- Lista de jugadores para TP
    local playerList = {}
    local function updatePlayerList()
        playerList = {}
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= Services.LocalPlayer then
                table.insert(playerList, p.Name)
            end
        end
    end
    updatePlayerList()
    
    -- Sección Teleport
    local TPSection = Tab:Section({
        Title = Utils:Translate("TeleportPlayer"),
        Box = true,
        BoxBorder = true,
        Opened = true
    })
    
    local PlayerDropdown = TPSection:Dropdown({
        Title = Utils:Translate("SelectPlayer"),
        Values = playerList,
        Flag = "TargetPlayer",
        Callback = function(value)
            Config.PvP.TargetPlayer = value
        end
    })
    
    TPSection:Space()
    
    TPSection:Button({
        Title = Utils:Translate("TPToPlayer"),
        Color = Colors.Blue,
        Icon = "navigation",
        Callback = function()
            if Config.PvP.TargetPlayer then
                local target = Services.Players:FindFirstChild(Config.PvP.TargetPlayer)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    Utils:TeleportTo(target.Character.HumanoidRootPart.CFrame)
                    Utils:Notify("Teleport", "Teletransportado a " .. target.Name, 2)
                end
            end
        end
    })
    
    TPSection:Space()
    
    TPSection:Button({
        Title = Utils:Translate("RefreshPlayers"),
        Icon = "refresh-cw",
        Callback = function()
            updatePlayerList()
            PlayerDropdown:Refresh(playerList)
            Utils:Notify("Lista", "Lista de jugadores actualizada", 2)
        end
    })
    
    Tab:Space({ Columns = 2 })
    
    -- Combat Settings
    local CombatSection = Tab:Section({
        Title = "⚡ Configuración de Combate",
        Box = true,
        BoxBorder = true,
        Opened = true
    })
    
    CombatSection:Toggle({
        Title = "Fast Attack",
        Desc = "Ataques más rápidos",
        Default = Config.Combat.FastAttack,
        Flag = "FastAttack",
        Callback = function(value)
            Config.Combat.FastAttack = value
        end
    })
    
    CombatSection:Space()
    
    CombatSection:Toggle({
        Title = "Kill Aura",
        Desc = "Ataca a todos los enemigos en rango",
        Default = Config.Combat.KillAura,
        Flag = "KillAura",
        Callback = function(value)
            Config.Combat.KillAura = value
        end
    })
    
    CombatSection:Space()
    
    CombatSection:Slider({
        Title = "Rango de Ataque",
        Step = 5,
        Value = {
            Min = 10,
            Max = 100,
            Default = Config.Combat.Range
        },
        Flag = "CombatRange",
        Callback = function(value)
            Config.Combat.Range = value
        end
    })
    
    return Tab
end

return CombatTab
