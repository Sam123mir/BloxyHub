--[[
    BLOXY HUB TITANIUM - LOADER
    Carga el archivo main.lua consolidado.
]]

local GITHUB_URL = "https://raw.githubusercontent.com/Sam123mir/Blox-Fruits-Panel-BloxyHub/main/main.lua"

local script_content = nil
local success, err = pcall(function()
    script_content = game:HttpGet(GITHUB_URL .. "?t=" .. tick())
end)

if success and script_content then
    local func, load_err = loadstring(script_content)
    if func then
        func()
    else
        warn("[BLOXY HUB] Error al parsear main.lua: " .. tostring(load_err))
    end
else
    warn("[BLOXY HUB] Falló la carga desde GitHub: " .. tostring(err))
    -- Fallback local para testing si estás en el editor
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Sam123mir/Blox-Fruits-Panel-BloxyHub/main/main.lua"))()
    end)
end
