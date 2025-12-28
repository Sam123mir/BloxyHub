--[[
    BLOXY HUB TITANIUM - UI: FLOATING BUTTON
    Botón flotante para dispositivos móviles
]]

local FloatingButton = {}

function FloatingButton:Create(deps)
    local Services = deps.Services
    local Window = deps.Window
    
    -- Solo crear en dispositivos móviles
    if not Services.UserInputService.TouchEnabled then
        return nil
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    local Button = Instance.new("ImageButton")
    local Corner = Instance.new("UICorner")
    local Gradient = Instance.new("UIGradient")
    
    ScreenGui.Name = "TitaniumMobileToggle"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    Button.Name = "ToggleButton"
    Button.Parent = ScreenGui
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Button.BackgroundTransparency = 0.2
    Button.Position = UDim2.new(0, 20, 0.5, -25)
    Button.Size = UDim2.new(0, 50, 0, 50)
    Button.Image = "rbxassetid://4483362458"
    Button.ImageColor3 = Color3.fromRGB(255, 255, 255)
    
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = Button
    
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("#7775F2")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#305dff"))
    })
    Gradient.Rotation = 45
    Gradient.Parent = Button
    
    -- Click para minimizar/maximizar
    Button.MouseButton1Click:Connect(function()
        if Window then
            Window:Minimize()
        end
    end)
    
    -- Lógica de arrastre
    local dragging, dragInput, dragStart, startPos
    
    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Button.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Button.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    return ScreenGui
end

function FloatingButton:Destroy(gui)
    if gui then
        gui:Destroy()
    end
end

return FloatingButton
