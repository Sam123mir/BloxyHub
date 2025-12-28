--[[
    BLOXY HUB TITANIUM - MÓDULO: THREAD MANAGER
    Gestión profesional del ciclo de vida de threads
]]

local ThreadManager = {
    Threads = {},
    Active = true
}

function ThreadManager:Register(name, func)
    if not self.Active then return end
    
    -- Limpieza de thread existente para evitar duplicados
    if self.Threads[name] then
        self:Stop(name)
        task.wait(0.1)
    end
    
    local thread = task.spawn(function()
        while self.Active and self.Threads[name] do
            local success, err = pcall(func)
            if not success then
                warn(string.format("[THREAD ERROR: %s] %s", name, tostring(err)))
            end
            task.wait(0.1)
        end
    end)
    
    self.Threads[name] = {
        thread = thread,
        startTime = os.time(),
        status = "running"
    }
    
    return name
end

function ThreadManager:Stop(name)
    if self.Threads[name] then
        self.Threads[name].status = "stopped"
        self.Threads[name] = nil
    end
end

function ThreadManager:StopAll()
    self.Active = false
    for name, data in pairs(self.Threads) do
        data.status = "stopped"
    end
    self.Threads = {}
end

function ThreadManager:GetStatus()
    local active = 0
    for _, data in pairs(self.Threads) do
        if data.status == "running" then
            active = active + 1
        end
    end
    return active
end

function ThreadManager:Reset()
    self:StopAll()
    task.wait(0.5)
    self.Active = true
    self.Threads = {}
end

return ThreadManager
