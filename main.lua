local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CerluxHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FovSlider = Instance.new("TextButton")
local FovToggle = Instance.new("TextButton")
local EspToggle = Instance.new("TextButton")
local AimPartDropdown = Instance.new("TextButton")
local DropdownFrame = Instance.new("Frame")
local Suggestions = Instance.new("TextLabel")
local AimbotToggle = Instance.new("TextButton")
local PredictionToggle = Instance.new("TextButton")
local SilentAimToggle = Instance.new("TextButton")
local EspColorButton = Instance.new("TextButton")

-- Updated UI to match the screenshot style
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Darker background
Frame.BorderSizePixel = 1
Frame.BorderColor3 = Color3.fromRGB(0, 255, 0) -- Green border
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

Title.Text = "Cerlux Hub"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Darker title background
Title.BorderSizePixel = 1
Title.BorderColor3 = Color3.fromRGB(0, 255, 0) -- Green border
Title.TextColor3 = Color3.fromRGB(0, 255, 0) -- Green text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.Parent = Frame

FovSlider.Text = "FOV: 100"
FovSlider.Position = UDim2.new(0, 10, 0, 50)
FovSlider.Size = UDim2.new(0.9, 0, 0, 30)
FovSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FovSlider.BorderSizePixel = 1
FovSlider.BorderColor3 = Color3.fromRGB(0, 255, 0)
FovSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
FovSlider.Font = Enum.Font.Gotham
FovSlider.TextSize = 18
FovSlider.Parent = Frame

FovToggle.Text = "Toggle FOV Circle: On"
FovToggle.Position = UDim2.new(0, 10, 0, 90)
FovToggle.Size = UDim2.new(0.9, 0, 0, 30)
FovToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FovToggle.BorderSizePixel = 1
FovToggle.BorderColor3 = Color3.fromRGB(0, 255, 0)
FovToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FovToggle.Font = Enum.Font.Gotham
FovToggle.TextSize = 18
FovToggle.Parent = Frame

EspToggle.Text = "Toggle ESP: On"
EspToggle.Position = UDim2.new(0, 10, 0, 130)
EspToggle.Size = UDim2.new(0.9, 0, 0, 30)
EspToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
EspToggle.BorderSizePixel = 1
EspToggle.BorderColor3 = Color3.fromRGB(0, 255, 0)
EspToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
EspToggle.Font = Enum.Font.Gotham
EspToggle.TextSize = 18
EspToggle.Parent = Frame

AimPartDropdown.Text = "Aim Part: Head"
AimPartDropdown.Position = UDim2.new(0, 10, 0, 170)
AimPartDropdown.Size = UDim2.new(0.9, 0, 0, 30)
AimPartDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AimPartDropdown.BorderSizePixel = 1
AimPartDropdown.BorderColor3 = Color3.fromRGB(0, 255, 0)
AimPartDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
AimPartDropdown.Font = Enum.Font.Gotham
AimPartDropdown.TextSize = 18
AimPartDropdown.Parent = Frame

AimbotToggle.Text = "Aimbot: Off"
AimbotToggle.Position = UDim2.new(0, 10, 0, 210)
AimbotToggle.Size = UDim2.new(0.9, 0, 0, 30)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AimbotToggle.BorderSizePixel = 1
AimbotToggle.BorderColor3 = Color3.fromRGB(0, 255, 0)
AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotToggle.Font = Enum.Font.Gotham
AimbotToggle.TextSize = 18
AimbotToggle.Parent = Frame

PredictionToggle = Instance.new("TextButton")
PredictionToggle.Text = "Prediction: On"
PredictionToggle.Position = UDim2.new(0, 10, 0, 250)
PredictionToggle.Size = UDim2.new(0.9, 0, 0, 30)
PredictionToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PredictionToggle.BorderSizePixel = 1
PredictionToggle.BorderColor3 = Color3.fromRGB(0, 255, 0)
PredictionToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
PredictionToggle.Font = Enum.Font.Gotham
PredictionToggle.TextSize = 18
PredictionToggle.Parent = Frame

SilentAimToggle.Text = "Silent Aim: Off"
SilentAimToggle.Position = UDim2.new(0, 10, 0, 290)
SilentAimToggle.Size = UDim2.new(0.9, 0, 0, 30)
SilentAimToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SilentAimToggle.BorderSizePixel = 1
SilentAimToggle.BorderColor3 = Color3.fromRGB(0, 255, 0)
SilentAimToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SilentAimToggle.Font = Enum.Font.Gotham
SilentAimToggle.TextSize = 18
SilentAimToggle.Parent = Frame

EspColorButton.Text = "ESP Color: Green"
EspColorButton.Position = UDim2.new(0, 10, 0, 330)
EspColorButton.Size = UDim2.new(0.9, 0, 0, 30)
EspColorButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
EspColorButton.BorderSizePixel = 1
EspColorButton.BorderColor3 = Color3.fromRGB(0, 255, 0)
EspColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EspColorButton.Font = Enum.Font.Gotham
EspColorButton.TextSize = 18
EspColorButton.Parent = Frame

Suggestions.Text = "Suggestions: DM cerluxxx on Discord"
Suggestions.Position = UDim2.new(0, 10, 0, 370)
Suggestions.Size = UDim2.new(0.9, 0, 0, 20)
Suggestions.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Suggestions.BorderSizePixel = 1
Suggestions.BorderColor3 = Color3.fromRGB(0, 255, 0)
Suggestions.TextColor3 = Color3.fromRGB(0, 255, 0)
Suggestions.TextWrapped = true
Suggestions.Font = Enum.Font.Gotham
Suggestions.TextSize = 14
Suggestions.Parent = Frame

-- Variables
local FOV = 100
local AimPart = "Head"
local IsAiming = false
local SelectedTarget = nil
local FOVCircleVisible = true
local ESPEnabled = true
local FOVCircleEnabled = true
local AimbotEnabled = false
local StickyAim = false
local PredictionEnabled = true
local SilentAimEnabled = false
local ESPColor = Color3.fromRGB(0, 255, 0)
local ESPColorOptions = {
    ["Green"] = Color3.fromRGB(0, 255, 0),
    ["Red"] = Color3.fromRGB(255, 0, 0),
    ["Blue"] = Color3.fromRGB(0, 0, 255),
    ["Yellow"] = Color3.fromRGB(255, 255, 0),
    ["Purple"] = Color3.fromRGB(128, 0, 128),
    ["White"] = Color3.fromRGB(255, 255, 255)
}
local CurrentESPColorName = "Green"

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 100
FOVCircle.Radius = FOV
FOVCircle.Filled = false
FOVCircle.Visible = FOVCircleVisible
FOVCircle.ZIndex = 999
FOVCircle.Transparency = 1
FOVCircle.Color = Color3.fromRGB(0, 255, 0) -- Changed to green to match UI

-- Universal prediction settings
local PredictionConfig = {
    velocity = 2000,
    gravity = 196.2
}

-- Function to calculate prediction
local function CalculatePrediction(targetPosition, targetVelocity)
    if not PredictionEnabled then return targetPosition end
    
    local bulletVelocity = PredictionConfig.velocity
    local gravity = PredictionConfig.gravity
    
    local distance = (targetPosition - Camera.CFrame.Position).Magnitude
    local timeToHit = distance / bulletVelocity
    
    -- Calculate prediction based on target velocity
    local predictionOffset = targetVelocity * timeToHit
    
    -- Add gravity compensation for longer shots
    local gravityOffset = Vector3.new(0, 0.5 * gravity * timeToHit^2, 0)
    
    return targetPosition + predictionOffset + gravityOffset
end

-- Detect game
local gameId = game.PlaceId
local isArsenal = gameId == 286090429
local isPhantomForces = gameId == 292439477 or gameId == 299659045

-- Universal ESP Function with game-specific handling
local function CreateESP(player)
    -- Remove existing ESP if any
    if player.Character then
        local existingESP = player.Character:FindFirstChildOfClass("Highlight")
        if existingESP then
            existingESP:Destroy()
        end
    end
    
    -- Create ESP based on game
    if isArsenal then
        -- Arsenal-specific ESP
        local espFolder = Instance.new("Folder")
        espFolder.Name = "ESPFolder"
        
        local function applyESPToCharacter(character)
            if not character then return end
            
            local boxOutline = Drawing.new("Square")
            boxOutline.Visible = true
            boxOutline.Color = Color3.fromRGB(0, 0, 0)
            boxOutline.Thickness = 3
            boxOutline.Transparency = 1
            boxOutline.Filled = false
            
            local box = Drawing.new("Square")
            box.Visible = true
            box.Color = ESPColor
            box.Thickness = 1
            box.Transparency = 1
            box.Filled = false
            
            local nameText = Drawing.new("Text")
            nameText.Visible = true
            nameText.Color = ESPColor
            nameText.Size = 18
            nameText.Center = true
            nameText.Outline = true
            nameText.Text = player.Name
            
            RunService:BindToRenderStep("ESP_" .. player.Name, 1, function()
                if not ESPEnabled or not player or not player.Character or not character:FindFirstChild("HumanoidRootPart") then
                    boxOutline.Visible = false
                    box.Visible = false
                    nameText.Visible = false
                    return
                end
                
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                local head = character:FindFirstChild("Head")
                
                if not humanoidRootPart or not head then
                    boxOutline.Visible = false
                    box.Visible = false
                    nameText.Visible = false
                    return
                end
                
                local vector, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
                
                if onScreen then
                    local rootPos = Camera:WorldToViewportPoint(humanoidRootPart.Position)
                    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local legPos = Camera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, 3, 0))
                    
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height * 0.6
                    
                    boxOutline.Size = Vector2.new(width, height)
                    boxOutline.Position = Vector2.new(rootPos.X - width / 2, rootPos.Y - height / 2)
                    boxOutline.Visible = true
                    
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(rootPos.X - width / 2, rootPos.Y - height / 2)
                    box.Visible = true
                    box.Color = ESPColor
                    
                    nameText.Position = Vector2.new(rootPos.X, rootPos.Y - height / 2 - 15)
                    nameText.Visible = true
                    nameText.Color = ESPColor
                else
                    boxOutline.Visible = false
                    box.Visible = false
                    nameText.Visible = false
                end
            end)
            
            player.CharacterRemoving:Connect(function()
                RunService:UnbindFromRenderStep("ESP_" .. player.Name)
                boxOutline.Visible = false
                box.Visible = false
                nameText.Visible = false
                boxOutline:Remove()
                box:Remove()
                nameText:Remove()
            end)
        end
        
        if player.Character then
            applyESPToCharacter(player.Character)
        end
        
        player.CharacterAdded:Connect(applyESPToCharacter)
        
    elseif isPhantomForces then
        -- Phantom Forces-specific ESP
        local function applyPFESP()
            spawn(function()
                while ESPEnabled and player and player.Parent do
                    wait(0.1)
                    
                    -- Get character from PF's character system
                    local character = nil
                    
                    -- Try to find character in Phantom Forces' structure
                    if workspace.Players then
                        if workspace.Players:FindFirstChild("Phantoms") and workspace.Players.Phantoms:FindFirstChild(player.Name) then
                            character = workspace.Players.Phantoms[player.Name]
                        elseif workspace.Players:FindFirstChild("Ghosts") and workspace.Players.Ghosts:FindFirstChild(player.Name) then
                            character = workspace.Players.Ghosts[player.Name]
                        end
                    end
                    
                    if character then
                        -- Create or update ESP
                        local torso = character:FindFirstChild("Torso")
                        if torso and not torso:FindFirstChild("ESPHighlight") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "ESPHighlight"
                            highlight.FillColor = ESPColor
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 0
                            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            highlight.Parent = torso
                        elseif torso and torso:FindFirstChild("ESPHighlight") then
                            torso.ESPHighlight.FillColor = ESPColor
                        end
                    end
                end
            end)
        end
        
        applyPFESP()
        
    else
        -- Default ESP for other games
        local highlight = Instance.new("Highlight")
        highlight.FillColor = ESPColor -- Use current ESP color
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White outline
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        
        if player.Character then
            highlight.Parent = player.Character
        end
        
        player.CharacterAdded:Connect(function(char)
            highlight.Parent = char
        end)
        
        -- Update ESP color when it changes
        spawn(function()
            while wait(0.5) do
                if highlight and highlight.Parent then
                    highlight.FillColor = ESPColor
                else
                    break
                end
            end
        end)
        
        return highlight
    end
end

-- Apply ESP to all players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end)

-- FOV Slider functionality
local isDragging = false
FovSlider.MouseButton1Down:Connect(function()
    isDragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouseX = UserInputService:GetMouseLocation().X
        local sliderStart = FovSlider.AbsolutePosition.X
        local sliderWidth = FovSlider.AbsoluteSize.X
        local newFOV = math.clamp(math.floor((mouseX - sliderStart) / sliderWidth * 200), 10, 200)
        FOV = newFOV
        FOVCircle.Radius = FOV
        FovSlider.Text = "FOV: " .. tostring(FOV)
    end
end)

-- Aim Part Selection
local aimParts = {"Head", "UpperTorso", "HumanoidRootPart"}
local dropdownVisible = false

AimPartDropdown.MouseButton1Click:Connect(function()
    if dropdownVisible then
        if DropdownFrame then
            DropdownFrame:Destroy()
        end
    else
        DropdownFrame = Instance.new("Frame")
        DropdownFrame.Size = UDim2.new(0.9, 0, 0, #aimParts * 25)
        DropdownFrame.Position = UDim2.new(0, 10, 0, 205)
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black background
        DropdownFrame.Parent = Frame
        
        for i, part in ipairs(aimParts) do
            local option = Instance.new("TextButton")
            option.Text = part
            option.Size = UDim2.new(1, 0, 0, 25)
            option.Position = UDim2.new(0, 0, 0, (i-1) * 25)
            option.BackgroundColor3 = Color3.fromRGB(70, 0, 150) -- Updated color
            option.TextColor3 = Color3.fromRGB(255, 255, 255)
            option.Font = Enum.Font.Gotham
            option.TextSize = 18
            option.Parent = DropdownFrame
            
            option.MouseButton1Click:Connect(function()
                AimPart = part
                AimPartDropdown.Text = "Aim Part: " .. part
                DropdownFrame:Destroy()
                dropdownVisible = false
            end)
        end
    end
    dropdownVisible = not dropdownVisible
end)

-- ESP Color Selection
EspColorButton.MouseButton1Click:Connect(function()
    local colorDropdownFrame = Instance.new("Frame")
    colorDropdownFrame.Size = UDim2.new(0.9, 0, 0, 180) -- 6 colors * 30 height
    colorDropdownFrame.Position = UDim2.new(0, 10, 0, 330)
    colorDropdownFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    colorDropdownFrame.ZIndex = 10
    colorDropdownFrame.Parent = Frame
    
    local i = 0
    for colorName, colorValue in pairs(ESPColorOptions) do
        local colorOption = Instance.new("TextButton")
        colorOption.Text = colorName
        colorOption.Size = UDim2.new(1, 0, 0, 30)
        colorOption.Position = UDim2.new(0, 0, 0, i * 30)
        colorOption.BackgroundColor3 = colorValue
        colorOption.TextColor3 = Color3.fromRGB(255, 255, 255)
        colorOption.Font = Enum.Font.Gotham
        colorOption.TextSize = 18
        colorOption.ZIndex = 11
        colorOption.Parent = colorDropdownFrame
        
        colorOption.MouseButton1Click:Connect(function()
            ESPColor = colorValue
            CurrentESPColorName = colorName
            EspColorButton.Text = "ESP Color: " .. colorName
            
            -- Update all existing ESP
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local highlight = player.Character:FindFirstChildOfClass("Highlight")
                    if highlight then
                        highlight.FillColor = ESPColor
                    end
                end
            end
            
            colorDropdownFrame:Destroy()
        end)
        
        i = i + 1
    end
end)

-- Enhanced Aimbot Logic with Improved Prediction
local function GetClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = FOV
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = nil
            
            -- Handle different game character structures
            if isPhantomForces then
                if workspace.Players then
                    if workspace.Players:FindFirstChild("Phantoms") and workspace.Players.Phantoms:FindFirstChild(player.Name) then
                        character = workspace.Players.Phantoms[player.Name]
                    elseif workspace.Players:FindFirstChild("Ghosts") and workspace.Players.Ghosts:FindFirstChild(player.Name) then
                        character = workspace.Players.Ghosts[player.Name]
                    end
                end
            else
                character = player.Character
            end
            
            if character then
                local targetPart = nil
                
                -- Find the appropriate target part based on game and selected aim part
                if isPhantomForces then
                    if AimPart == "Head" and character:FindFirstChild("Head") then
                        targetPart = character.Head
                    elseif character:FindFirstChild("Torso") then
                        targetPart = character.Torso
                    end
                else
                    if character:FindFirstChild(AimPart) then
                        targetPart = character[AimPart]
                    end
                end
                
                if targetPart then
                    local targetPos = targetPart.Position
                    local screenPos, onScreen = Camera:WorldToScreenPoint(targetPos)
                    
                    if onScreen then
                        local mousePos = UserInputService:GetMouseLocation()
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        
                        if distance <= shortestDistance then
                            closestPlayer = player
                            shortestDistance = distance
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Silent Aim Implementation
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if SilentAimEnabled and (method == "FireServer" or method == "InvokeServer") then
        local target = GetClosestPlayerInFOV()
        if target then
            local character = nil
            
            -- Handle different game character structures
            if isPhantomForces then
                if workspace.Players then
                    if workspace.Players:FindFirstChild("Phantoms") and workspace.Players.Phantoms:FindFirstChild(target.Name) then
                        character = workspace.Players.Phantoms[target.Name]
                    elseif workspace.Players:FindFirstChild("Ghosts") and workspace.Players.Ghosts:FindFirstChild(target.Name) then
                        character = workspace.Players.Ghosts[target.Name]
                    end
                end
            else
                character = target.Character
            end
            
            if character then
                local targetPart = nil
                
                -- Find the appropriate target part based on game and selected aim part
                if isPhantomForces then
                    if AimPart == "Head" and character:FindFirstChild("Head") then
                        targetPart = character.Head
                    elseif character:FindFirstChild("Torso") then
                        targetPart = character.Torso
                    end
                else
                    if character:FindFirstChild(AimPart) then
                        targetPart = character[AimPart]
                    end
                end
                
                if targetPart then
                    local targetVelocity = targetPart.Velocity or Vector3.new(0, 0, 0)
                    local predictedPos = CalculatePrediction(targetPart.Position, targetVelocity)
                    
                    -- Modify arguments for silent aim
                    if self.Name == "RemoteEvent" or self.Name == "RemoteFunction" then
                        -- Check if any argument is a Vector3 (position)
                        for i, arg in ipairs(args) do
                            if typeof(arg) == "Vector3" then
                                args[i] = predictedPos
                            elseif typeof(arg) == "CFrame" then
                                args[i] = CFrame.new(arg.Position, predictedPos)
                            end
                        end
                    end
                end
            end
        end
    end
    
    return oldNamecall(self, unpack(args))
end)

-- Update FOV Circle and Aimbot
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UserInputService:GetMouseLocation()
    
    if IsAiming and AimbotEnabled then
        SelectedTarget = GetClosestPlayerInFOV()
        if SelectedTarget then
            local character = nil
            local targetPart = nil
            
            -- Handle different game character structures
            if isPhantomForces then
                if workspace.Players then
                    if workspace.Players:FindFirstChild("Phantoms") and workspace.Players.Phantoms:FindFirstChild(SelectedTarget.Name) then
                        character = workspace.Players.Phantoms[SelectedTarget.Name]
                    elseif workspace.Players:FindFirstChild("Ghosts") and workspace.Players.Ghosts:FindFirstChild(SelectedTarget.Name) then
                        character = workspace.Players.Ghosts[SelectedTarget.Name]
                    end
                end
                
                if character then
                    if AimPart == "Head" and character:FindFirstChild("Head") then
                        targetPart = character.Head
                    elseif character:FindFirstChild("Torso") then
                        targetPart = character.Torso
                    end
                end
            else
                character = SelectedTarget.Character
                if character and character:FindFirstChild(AimPart) then
                    targetPart = character[AimPart]
                end
            end
            
            if targetPart then
                local targetVelocity = targetPart.Velocity or Vector3.new(0, 0, 0)
                
                -- Get predicted position based on target velocity
                local predictedPos = CalculatePrediction(targetPart.Position, targetVelocity)
                
                -- Stronger aimbot with less smoothness for more precise aiming
                local smoothness = 0.05 -- Reduced smoothness for stronger aimbot
                local aimOffset = Vector3.new(0, 0, 0) -- No offset for more accurate aiming
                
                -- Direct camera to predicted position for stronger aimbot
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, predictedPos + aimOffset), 1 - smoothness)
            end
        end
    end

    -- Toggle FOV Circle visibility
    FOVCircle.Visible = FOVCircleVisible
end)

-- Right Click Detection
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        IsAiming = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        IsAiming = false
        SelectedTarget = nil
    end
end)

-- Left Click Detection for Sticky Aim
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        StickyAim = true
        SelectedTarget = GetClosestPlayerInFOV() -- Set the target when left click is held
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        StickyAim = false
        SelectedTarget = nil
    end
end)

-- Toggle UI with Right Shift
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.RightShift then
        Frame.Visible = not Frame.Visible
    end
end)

FovToggle.MouseButton1Click:Connect(function()
    FOVCircleVisible = not FOVCircleVisible
    FovToggle.Text = "Toggle FOV Circle: " .. (FOVCircleVisible and "On" or "Off")
end)

EspToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    
    -- Handle ESP toggling based on game
    if isArsenal or isPhantomForces then
        -- For Arsenal and PF, we'll reapply ESP to all players
        if ESPEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    CreateESP(player)
                end
            end
        else
            -- Clean up ESP
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    if isArsenal then
                        RunService:UnbindFromRenderStep("ESP_" .. player.Name)
                    elseif isPhantomForces then
                        -- Find and remove PF ESP
                        if workspace.Players then
                            for _, team in pairs(workspace.Players:GetChildren()) do
                                if team:FindFirstChild(player.Name) then
                                    local character = team[player.Name]
                                    if character and character:FindFirstChild("Torso") then
                                        local highlight = character.Torso:FindFirstChild("ESPHighlight")
                                        if highlight then
                                            highlight:Destroy()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        -- Default ESP handling for other games
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if ESPEnabled then
                    CreateESP(player)
                else
                    if player.Character then
                        local highlight = player.Character:FindFirstChildOfClass("Highlight")
                        if highlight then
                            highlight:Destroy()
                        end
                    end
                end
            end
        end
    end
    
    EspToggle.Text = "Toggle ESP: " .. (ESPEnabled and "On" or "Off")
end)

AimbotToggle.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    AimbotToggle.Text = "Aimbot: " .. (AimbotEnabled and "On" or "Off")
end)

PredictionToggle.MouseButton1Click:Connect(function()
    PredictionEnabled = not PredictionEnabled
    PredictionToggle.Text = "Prediction: " .. (PredictionEnabled and "On" or "Off")
end)
