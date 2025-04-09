local X;
X = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    local methods = {"Ban", "Kick", "kick", "ban", "Remove", "remove", "destroy", "Destroy", "Fire", "fire"}
    
    if checkcaller() and table.find(methods, method) then
        game.Players.LocalPlayer:Kick("Game attempted to ban/kick you but was blocked")
        return wait(9e9)
    end
    
    return X(self, ...)
end)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local guiService = game:GetService("GuiService")
local textService = game:GetService("TextService")

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "UniversixGUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame
mainFrame.Parent = gui

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0
local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 10)
corner2.Parent = titleBar
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "Universix"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.Parent = titleBar

-- Make GUI draggable
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

userInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

userInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Create content frames
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Create tabs
local function createTab(name, position)
    local tab = Instance.new("TextButton")
    tab.Name = name .. "Tab"
    tab.Size = UDim2.new(0.33, -4, 0, 35)
    tab.Position = UDim2.new(0.33 * position + 0.01, 0, 0, 5)
    tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    tab.Text = name
    tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    tab.TextSize = 16
    tab.Font = Enum.Font.GothamSemibold
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = tab
    tab.Parent = contentFrame
    return tab
end

local aimTab = createTab("Aimbot", 0)
local espTab = createTab("ESP", 1)
local miscTab = createTab("Misc", 2)

-- Protect GUI
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = game:GetService("CoreGui")
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = game:GetService("CoreGui")
    end
end)

-- Aimbot variables
local aimTarget = nil
local aimPart = "Head"
local aimbotActive = false
local silentAimActive = false
local fovValue = 100
local smoothValue = 0.2
local showFOV = false

-- ESP variables  
local espActive = false
local boxEspActive = false
local nameEspActive = false

-- Create FOV circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.NumSides = 60

-- Update FOV circle
runService.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(mouse.X, mouse.Y)
    fovCircle.Radius = fovValue
    fovCircle.Visible = showFOV and (aimbotActive or silentAimActive)
end)

-- Aimbot functions
local function getClosestPlayerToMouse()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local character = plr.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local targetPart = character:FindFirstChild(aimPart)

            if humanoid and rootPart and targetPart then
                local screenPos, onScreen = camera:WorldToScreenPoint(targetPart.Position)
                
                if onScreen then
                    local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude
                    
                    if magnitude < shortestDistance and magnitude <= fovValue then
                        closestPlayer = targetPart
                        shortestDistance = magnitude
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- ESP function
local function createESP(character)
    local plr = game.Players:GetPlayerFromCharacter(character)
    if not plr or plr == player then return end
    
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Green neon fill
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White outline
    highlight.FillTransparency = 0.5 -- Semi-transparent fill
    highlight.OutlineTransparency = 0
    highlight.Parent = character
    highlight.Enabled = espActive

    local connection = runService.RenderStepped:Connect(function()
        if not character:IsDescendantOf(game) or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Humanoid") then
            highlight:Destroy()
            connection:Disconnect()
            return
        end
        highlight.Enabled = espActive
    end)

    character.AncestryChanged:Connect(function(_, parent)
        if not parent then
            highlight:Destroy()
            connection:Disconnect()
        end
    end)
end

-- ESP setup
local function setupESPForPlayer(plr)
    if plr ~= player then
        if plr.Character then
            createESP(plr.Character)
        end
        plr.CharacterAdded:Connect(function(char)
            createESP(char)
        end)
    end
end

game.Players.PlayerAdded:Connect(setupESPForPlayer)

-- Setup ESP for existing players
for _, plr in pairs(game.Players:GetPlayers()) do
    setupESPForPlayer(plr)
end

-- Aimbot loop
runService.RenderStepped:Connect(function()
    if aimbotActive and userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayerToMouse()
        if target then
            local targetPos = camera:WorldToScreenPoint(target.Position)
            local mousePos = Vector2.new(mouse.X, mouse.Y)
            local moveAmount = (Vector2.new(targetPos.X, targetPos.Y) - mousePos) * smoothValue
            mousemoverel(moveAmount.X, moveAmount.Y)
        end
    end
end)

-- Silent aim
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if silentAimActive and (method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" or method == "Raycast") then
        local target = getClosestPlayerToMouse()
        if target then
            if method == "Raycast" then
                args[1] = (target.Position - camera.CFrame.Position).Unit
                args[2] = (target.Position - camera.CFrame.Position).Magnitude
            else
                args[1] = Ray.new(camera.CFrame.Position, (target.Position - camera.CFrame.Position).Unit * 1000)
            end
            return oldNamecall(self, unpack(args))
        end
    end
    
    return oldNamecall(self, ...)
end)

-- Create content frames
local aimContent = Instance.new("Frame")
aimContent.Name = "AimContent"
aimContent.Size = UDim2.new(1, 0, 1, -50)
aimContent.Position = UDim2.new(0, 0, 0, 50)
aimContent.BackgroundTransparency = 1
aimContent.Parent = contentFrame

local espContent = Instance.new("Frame")
espContent.Name = "ESPContent"
espContent.Size = UDim2.new(1, 0, 1, -50)
espContent.Position = UDim2.new(0, 0, 0, 50)
espContent.BackgroundTransparency = 1
espContent.Visible = false
espContent.Parent = contentFrame

local miscContent = Instance.new("Frame")
miscContent.Name = "MiscContent"
miscContent.Size = UDim2.new(1, 0, 1, -50)
miscContent.Position = UDim2.new(0, 0, 0, 50)
miscContent.BackgroundTransparency = 1
miscContent.Visible = false
miscContent.Parent = contentFrame

-- Tab switching
aimTab.MouseButton1Click:Connect(function()
    aimContent.Visible = true
    espContent.Visible = false
    miscContent.Visible = false
end)

espTab.MouseButton1Click:Connect(function()
    aimContent.Visible = false
    espContent.Visible = true
    miscContent.Visible = false
end)

miscTab.MouseButton1Click:Connect(function()
    aimContent.Visible = false
    espContent.Visible = false
    miscContent.Visible = true
end)

-- UI Components
local function createSlider(name, parent, min, max, default, callback)
    local sliderHolder = Instance.new("Frame")
    sliderHolder.Name = name .. "Holder"
    sliderHolder.Size = UDim2.new(0.9, 0, 0, 50)
    sliderHolder.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 60)
    sliderHolder.BackgroundTransparency = 1
    sliderHolder.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.GothamSemibold
    label.Parent = sliderHolder

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, 0, 0, 4)
    sliderBar.Position = UDim2.new(0, 0, 0.7, 0)
    sliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    sliderBar.Parent = sliderHolder

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    sliderFill.Parent = sliderBar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 2)
    corner.Parent = sliderBar

    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 2)
    corner2.Parent = sliderFill

    local dragging = false
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    userInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    userInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * relativeX
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            label.Text = name .. ": " .. math.floor(value)
            callback(value)
        end
    end)

    return sliderHolder
end

local function createToggle(name, parent, callback)
    local toggle = Instance.new("TextButton")
    toggle.Name = name .. "Toggle"
    toggle.Size = UDim2.new(0.9, 0, 0, 35)
    toggle.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 45)
    toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    toggle.Text = name
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 16
    toggle.Font = Enum.Font.GothamSemibold
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = toggle
    
    local enabled = false
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(45, 45, 45)
        callback(enabled)
    end)
    
    toggle.Parent = parent
    return toggle
end

local function createDropdown(name, parent, options, callback)
    local dropdownHolder = Instance.new("Frame")
    dropdownHolder.Name = name .. "Holder"
    dropdownHolder.Size = UDim2.new(0.9, 0, 0, 35)
    dropdownHolder.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 45)
    dropdownHolder.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = dropdownHolder
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(1, 0, 1, 0)
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.Text = name .. ": " .. options[1]
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.TextSize = 16
    dropdownButton.Font = Enum.Font.GothamSemibold
    dropdownButton.Parent = dropdownHolder
    
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Size = UDim2.new(1, 0, 0, #options * 35)
    optionsFrame.Position = UDim2.new(0, 0, 1, 5)
    optionsFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    optionsFrame.Visible = false
    optionsFrame.ZIndex = 10
    
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0, 8)
    corner2.Parent = optionsFrame
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 35)
        optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 35)
        optionButton.BackgroundTransparency = 1
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.TextSize = 16
        optionButton.Font = Enum.Font.GothamSemibold
        optionButton.ZIndex = 10
        optionButton.Parent = optionsFrame
        
        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = name .. ": " .. option
            optionsFrame.Visible = false
            callback(option)
        end)
    end
    
    optionsFrame.Parent = dropdownHolder
    
    dropdownButton.MouseButton1Click:Connect(function()
        optionsFrame.Visible = not optionsFrame.Visible
    end)
    
    dropdownHolder.Parent = parent
    return dropdownHolder
end

-- Create aimbot controls
createToggle("Aimbot", aimContent, function(enabled)
    aimbotActive = enabled
end)

createToggle("Silent Aim", aimContent, function(enabled)
    silentAimActive = enabled
end)

createToggle("Show FOV", aimContent, function(enabled)
    showFOV = enabled
end)

createDropdown("Aim Part", aimContent, {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}, function(selected)
    aimPart = selected
end)

createSlider("FOV", aimContent, 10, 800, fovValue, function(value)
    fovValue = value
end)

createSlider("Smoothness", aimContent, 0.01, 1, smoothValue, function(value)
    smoothValue = value
end)

-- Create ESP controls
createToggle("ESP Master Toggle", espContent, function(enabled)
    espActive = enabled
end)

-- Create misc controls
createToggle("Speed Hack", miscContent, function(enabled)
    local speedConnection
    if enabled then
        speedConnection = runService.Heartbeat:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 50
            end
        end)
    else
        if speedConnection then
            speedConnection:Disconnect()
        end
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

createToggle("Jump Power", miscContent, function(enabled)
    if enabled then
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 100
        end
        
        player.CharacterAdded:Connect(function(char)
            local humanoid = char:WaitForChild("Humanoid")
            humanoid.JumpPower = 100
        end)
    else
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 50
        end
        
        player.CharacterAdded:Connect(function(char)
            local humanoid = char:WaitForChild("Humanoid")
            humanoid.JumpPower = 50
        end)
    end
end)

createToggle("Infinite Jump", miscContent, function(enabled)
    local connection
    if enabled then
        connection = userInputService.JumpRequest:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end)

createToggle("No Clip", miscContent, function(enabled)
    local function updateNoclip()
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not enabled
                end
            end
        end
    end
    
    local connection
    if enabled then
        connection = runService.Stepped:Connect(updateNoclip)
    else
        if connection then
            connection:Disconnect()
        end
        updateNoclip()
    end
end)
