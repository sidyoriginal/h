local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- Настройки
local settings = {
    teleportEnabled = true,
    teleportDistance = 5,
    maxSearchDistance = 16,
    survivorSpeed = 16,
    killerSpeed = 8,
    aimEnabled = false,
    aimKey = Enum.KeyCode.U
}

-- Создаем GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local background = Instance.new("Frame")
background.Name = "Background"
background.Size = UDim2.new(0, 300, 0, 400)
background.Position = UDim2.new(0.5, -150, 0.5, -175)
background.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
background.BorderSizePixel = 0
background.Active = true
background.Draggable = true
background.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = background

-- Добавляем тень
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Parent = background
shadow.ZIndex = -1

-- Заголовок с градиентом
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
titleBar.Parent = background

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 12)
titleBarCorner.Parent = titleBar

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 120))
}
titleGradient.Rotation = 90
titleGradient.Parent = titleBar

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0.15, 0, 0, 0)
title.Text = "holixel script"
title.TextColor3 = Color3.fromRGB(220, 220, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = titleBar

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -32, 0, 2)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

-- Кнопка сворачивания
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 28, 0, 28)
minimizeButton.Position = UDim2.new(1, -64, 0, 2)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 20
minimizeButton.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(1, 0)
minimizeCorner.Parent = minimizeButton

-- Список всех элементов контента
local contentElements = {}

-- Функция создания ползунка
local function createSlider(parent, yPos, labelText, minValue, maxValue, currentValue, color)
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = labelText.."Container"
    sliderContainer.Size = UDim2.new(0.9, 0, 0, 70)
    sliderContainer.Position = UDim2.new(0.05, 0, yPos, 0)
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.Parent = parent
    
    table.insert(contentElements, sliderContainer)

    local label = Instance.new("TextLabel")
    label.Name = labelText.."Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = labelText..": "..currentValue
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderContainer

    local slider = Instance.new("Frame")
    slider.Name = labelText.."Slider"
    slider.Size = UDim2.new(1, 0, 0, 40)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.BackgroundTransparency = 1
    slider.Parent = sliderContainer

    local bar = Instance.new("Frame")
    bar.Name = "Bar"
    bar.Size = UDim2.new(1, 0, 0, 6)
    bar.Position = UDim2.new(0, 0, 0.5, -3)
    bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    bar.BorderSizePixel = 0
    bar.Parent = slider

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 3)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new((currentValue - minValue)/(maxValue - minValue), 0, 1, 0)
    fill.BackgroundColor3 = color
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill

    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(0, 24, 0, 24)
    button.Position = UDim2.new((currentValue - minValue)/(maxValue - minValue), -12, 0.5, -12)
    button.Text = ""
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.BorderSizePixel = 0
    button.ZIndex = 2
    button.Parent = slider

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = button

    -- Добавляем свечение кнопке
    local buttonGlow = Instance.new("ImageLabel")
    buttonGlow.Name = "Glow"
    buttonGlow.Image = "rbxassetid://5028857084"
    buttonGlow.ImageColor3 = color
    buttonGlow.ImageTransparency = 0.8
    buttonGlow.Size = UDim2.new(1.5, 0, 1.5, 0)
    buttonGlow.Position = UDim2.new(-0.25, 0, -0.25, 0)
    buttonGlow.BackgroundTransparency = 1
    buttonGlow.ZIndex = 1
    buttonGlow.Parent = button

    return sliderContainer, label, bar, fill, button
end

-- Создаем переключатель телепорта
local teleportToggle = Instance.new("TextButton")
teleportToggle.Name = "TeleportToggle"
teleportToggle.Size = UDim2.new(0.8, 0, 0, 36)
teleportToggle.Position = UDim2.new(0.1, 0, 0.1, 0)
teleportToggle.Text = "TELEPORT: ON"
teleportToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
teleportToggle.Font = Enum.Font.GothamBold
teleportToggle.TextSize = 16
teleportToggle.BorderSizePixel = 0
teleportToggle.Parent = background

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = teleportToggle

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(80, 80, 100)
toggleStroke.Thickness = 2
toggleStroke.Parent = teleportToggle

table.insert(contentElements, teleportToggle)

-- Создаем кнопку активации скрипта (премиум дизайн)
local activateButton = Instance.new("TextButton")
activateButton.Name = "ActivateButton"
activateButton.Size = UDim2.new(0.8, 0, 0, 42)
activateButton.Position = UDim2.new(0.1, 0, 0.8, 0)
activateButton.Text = "ACTIVATE SCRIPT"
activateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
activateButton.TextSize = 16
activateButton.Font = Enum.Font.GothamBold
activateButton.AutoButtonColor = false
activateButton.BackgroundTransparency = 0
activateButton.Parent = background

-- Градиент для кнопки
local buttonGradient = Instance.new("UIGradient")
buttonGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 70, 180)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 40, 150))
})
buttonGradient.Rotation = 90
buttonGradient.Parent = activateButton

-- Скругление углов
local activateCorner = Instance.new("UICorner")
activateCorner.CornerRadius = UDim.new(0, 8)
activateCorner.Parent = activateButton

-- Обводка кнопки
local activateStroke = Instance.new("UIStroke")
activateStroke.Color = Color3.fromRGB(140, 100, 200)
activateStroke.Thickness = 2
activateStroke.Parent = activateButton

-- Тень кнопки
local buttonShadow = Instance.new("ImageLabel")
buttonShadow.Name = "ButtonShadow"
buttonShadow.Image = "rbxassetid://1316045217"
buttonShadow.ImageColor3 = Color3.new(0, 0, 0)
buttonShadow.ImageTransparency = 0.85
buttonShadow.ScaleType = Enum.ScaleType.Slice
buttonShadow.SliceCenter = Rect.new(10, 10, 118, 118)
buttonShadow.Size = UDim2.new(1, 10, 1, 10)
buttonShadow.Position = UDim2.new(0, -5, 0, -5)
buttonShadow.BackgroundTransparency = 1
buttonShadow.ZIndex = -1
buttonShadow.Parent = activateButton

-- Иконка для кнопки (правильные иконки включения/выключения)
local buttonIcon = Instance.new("ImageLabel")
buttonIcon.Name = "Icon"
buttonIcon.Image = "rbxassetid://3926307971"  -- Roblox icon atlas
buttonIcon.ImageRectSize = Vector2.new(36, 36)
buttonIcon.Size = UDim2.new(0, 20, 0, 20)
buttonIcon.Position = UDim2.new(0, 15, 0.5, -10)
buttonIcon.BackgroundTransparency = 1
buttonIcon.Parent = activateButton

-- Устанавливаем начальную иконку (скрипт выключен)
buttonIcon.ImageRectOffset = Vector2.new(324, 364)  -- Иконка "выключено"

-- Анимация при наведении
activateButton.MouseEnter:Connect(function()
    TweenService:Create(
        buttonGradient,
        TweenInfo.new(0.2),
        {Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 90, 200)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 60, 170))
        })}
    ):Play()
    TweenService:Create(
        activateStroke,
        TweenInfo.new(0.2),
        {Color = Color3.fromRGB(160, 120, 220)}
    ):Play()
end)

activateButton.MouseLeave:Connect(function()
    TweenService:Create(
        buttonGradient,
        TweenInfo.new(0.2),
        {Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 70, 180)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 40, 150))
        })}
    ):Play()
    TweenService:Create(
        activateStroke,
        TweenInfo.new(0.2),
        {Color = Color3.fromRGB(140, 100, 200)}
    ):Play()
end)

-- Анимация при нажатии
activateButton.MouseButton1Down:Connect(function()
    TweenService:Create(
        activateButton,
        TweenInfo.new(0.1),
        {Size = UDim2.new(0.78, 0, 0, 40)}
    ):Play()
end)

activateButton.MouseButton1Up:Connect(function()
    TweenService:Create(
        activateButton,
        TweenInfo.new(0.1),
        {Size = UDim2.new(0.8, 0, 0, 42)}
    ):Play()
end)

-- Обработчик клика
activateButton.MouseButton1Click:Connect(function()
    settings.aimEnabled = not settings.aimEnabled
    activateButton.Text = settings.aimEnabled and "SCRIPT: ON (Press U)" or "ACTIVATE SCRIPT"
    
    -- Анимация изменения цвета при активации
    local targetColor = settings.aimEnabled and ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 180, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 150, 90))
    }) or ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 70, 180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 40, 150))
    })
    
    local targetStroke = settings.aimEnabled and Color3.fromRGB(100, 200, 140) or Color3.fromRGB(140, 100, 200)
    
    TweenService:Create(
        buttonGradient,
        TweenInfo.new(0.3),
        {Color = targetColor}
    ):Play()
    TweenService:Create(
        activateStroke,
        TweenInfo.new(0.3),
        {Color = targetStroke}
    ):Play()
    
    -- Меняем иконку в зависимости от состояния
    buttonIcon.ImageRectOffset = settings.aimEnabled and Vector2.new(360, 364)  -- Иконка "включено" 
                                               or Vector2.new(324, 364)  -- Иконка "выключено"
end)

table.insert(contentElements, activateButton)

-- Создаем ползунки
local teleportDistanceSlider, teleportDistanceLabel = createSlider(background, 0.2, "Teleport Distance", 1, 50, settings.teleportDistance, Color3.fromRGB(0, 170, 255))
local searchDistanceSlider, searchDistanceLabel = createSlider(background, 0.35, "Search Distance", 5, 100, settings.maxSearchDistance, Color3.fromRGB(0, 200, 200))
local survivorSpeedSlider, survivorSpeedLabel = createSlider(background, 0.5, "Survivor Speed", 10, 50, settings.survivorSpeed, Color3.fromRGB(100, 255, 100))
local killerSpeedSlider, killerSpeedLabel = createSlider(background, 0.65, "Killer Speed", 5, 50, settings.killerSpeed, Color3.fromRGB(255, 100, 100))

-- Добавляем разделители между элементами
local function addSeparator(parent, yPos)
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(0.8, 0, 0, 1)
    separator.Position = UDim2.new(0.1, 0, yPos, 0)
    separator.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    separator.BorderSizePixel = 0
    separator.Parent = parent
    
    table.insert(contentElements, separator)
end

addSeparator(background, 0.18)
addSeparator(background, 0.33)
addSeparator(background, 0.48)
addSeparator(background, 0.63)
addSeparator(background, 0.78)

-- Функция для получения любого первичного объекта персонажа
local function getCharacterPrimaryPart(character)
    if not character then return nil end
    
    -- Сначала проверяем стандартные части
    if character:FindFirstChild("HumanoidRootPart") then
        return character:FindFirstChild("HumanoidRootPart")
    elseif character:FindFirstChild("Torso") then
        return character:FindFirstChild("Torso")
    elseif character:FindFirstChild("UpperTorso") then
        return character:FindFirstChild("UpperTorso")
    end
    
    -- Ищем любой другой BasePart
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "Head" then
            return part
        end
    end
    
    return nil
end

-- Функции изменения скорости
local function setSurvivorSpeed()
    local playersFolder = Workspace:FindFirstChild("Players")
    if not playersFolder then return end
    
    local survivorsFolder = playersFolder:FindFirstChild("Survivors")
    if not survivorsFolder then return end
    
    for _, survivor in pairs(survivorsFolder:GetChildren()) do
        local humanoid = survivor:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetAttribute("BaseSpeed", settings.survivorSpeed)
        end
    end
end

local function setKillerSpeed()
    local playersFolder = Workspace:FindFirstChild("Players")
    if not playersFolder then return end
    
    local killersFolder = playersFolder:FindFirstChild("Killers")
    if not killersFolder then return end
    
    for _, killer in pairs(killersFolder:GetChildren()) do
        local humanoid = killer:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetAttribute("BaseSpeed", settings.killerSpeed)
        end
    end
end

local function getNearestPlayer()
    if not LocalPlayer.Character then return nil end
    
    local closestPlayer = nil
    local minDistance = settings.maxSearchDistance
    local localPart = getCharacterPrimaryPart(LocalPlayer.Character)
    if not localPart then return nil end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetPart = getCharacterPrimaryPart(player.Character)
            if targetPart then
                local distance = (targetPart.Position - localPart.Position).Magnitude
                if distance < minDistance then
                    minDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer
end

local function teleportToPlayer()
    if not settings.teleportEnabled then return end
    if not LocalPlayer.Character then return end
    
    local nearestPlayer = getNearestPlayer()
    if nearestPlayer and nearestPlayer.Character then
        local targetPart = getCharacterPrimaryPart(nearestPlayer.Character)
        local localPart = getCharacterPrimaryPart(LocalPlayer.Character)
        if targetPart and localPart then
            local direction = (targetPart.Position - localPart.Position).Unit
            local newPosition = targetPart.Position - (direction * settings.teleportDistance)
            localPart.CFrame = CFrame.new(newPosition, targetPart.Position)
        end
    end
end

-- Функция для аима
local function aimAtNearestPlayer()
    if not settings.aimEnabled then return end
    if not LocalPlayer.Character then return end
    
    local nearestPlayer = getNearestPlayer()
    if nearestPlayer and nearestPlayer.Character then
        local targetPart = getCharacterPrimaryPart(nearestPlayer.Character)
        local localPart = getCharacterPrimaryPart(LocalPlayer.Character)
        
        if targetPart and localPart then
            local camera = Workspace.CurrentCamera
            if camera then
                -- Направляем камеру на цель
                camera.CFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
                
                -- Направляем персонажа на цель
                localPart.CFrame = CFrame.new(localPart.Position, Vector3.new(targetPart.Position.X, localPart.Position.Y, targetPart.Position.Z))
            end
        end
    end
end

-- Обработчики ползунков
local function setupSlider(sliderContainer, minValue, maxValue, propertyName, callback, label)
    local slider = sliderContainer:FindFirstChild(label.Text:match("([^:]+)").."Slider")
    local button = slider:FindFirstChild("Button")
    local bar = slider:FindFirstChild("Bar")
    local fill = bar:FindFirstChild("Fill")
    
    local dragging = false
    
    local function updateValue(x)
        local relativeX = math.clamp(x - bar.AbsolutePosition.X, 0, bar.AbsoluteSize.X)
        local ratio = relativeX / bar.AbsoluteSize.X
        local value = math.floor(minValue + (maxValue - minValue) * ratio + 0.5)
        
        button.Position = UDim2.new(ratio, -12, 0.5, -12)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        settings[propertyName] = value
        label.Text = label.Text:match("([^:]+)")..": "..value
        
        if callback then callback(value) end
        return value
    end
    
    button.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if dragging then
            local mouse = UserInputService:GetMouseLocation()
            updateValue(mouse.X)
        end
    end)
end

-- Настройка ползунков
setupSlider(teleportDistanceSlider, 1, 50, "teleportDistance", nil, teleportDistanceLabel)
setupSlider(searchDistanceSlider, 5, 100, "maxSearchDistance", nil, searchDistanceLabel)
setupSlider(survivorSpeedSlider, 10, 50, "survivorSpeed", setSurvivorSpeed, survivorSpeedLabel)
setupSlider(killerSpeedSlider, 5, 50, "killerSpeed", setKillerSpeed, killerSpeedLabel)

-- Переключатель телепорта
teleportToggle.MouseButton1Click:Connect(function()
    settings.teleportEnabled = not settings.teleportEnabled
    teleportToggle.Text = "TELEPORT: "..(settings.teleportEnabled and "ON" or "OFF")
    teleportToggle.BackgroundColor3 = settings.teleportEnabled and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(150, 40, 40)
end)

-- Drag логика для окна
local draggingWindow = false
local dragStartPos
local guiStartPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingWindow = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        guiStartPos = background.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingWindow = false
    end
end)

RunService.Heartbeat:Connect(function()
    if draggingWindow then
        local mouse = UserInputService:GetMouseLocation()
        local delta = Vector2.new(mouse.X, mouse.Y) - dragStartPos
        background.Position = UDim2.new(
            guiStartPos.X.Scale,
            guiStartPos.X.Offset + delta.X,
            guiStartPos.Y.Scale,
            guiStartPos.Y.Offset + delta.Y
        )
    end
end)

-- Кнопка закрытия
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Кнопка сворачивания
local minimized = false
local originalSize = background.Size
local originalPosition = background.Position

minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    if minimized then
        background.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 32)
        for _, element in ipairs(contentElements) do
            element.Visible = false
        end
    else
        background.Size = originalSize
        for _, element in ipairs(contentElements) do
            element.Visible = true
        end
    end
end)

-- Обработчик телепорта
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        teleportToPlayer()
    end
end)

-- Обработчик аима при нажатии U
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == settings.aimKey and settings.aimEnabled then
        aimAtNearestPlayer()
    end
end)

-- Первоначальная настройка
setSurvivorSpeed()
setKillerSpeed()

-- Обработчик респавна
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    setSurvivorSpeed()
    setKillerSpeed()
end)