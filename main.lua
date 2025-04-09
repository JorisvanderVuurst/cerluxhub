local X;
X = hookmetamethod(game, "__namecall", function(self, ...)
    if checkcaller() and getnamecallmethod() == "Ban" then
       local eval1 = {false}
       local eval2 = {false}
       local args = {...}
       if debug.validlevel(3) and self.Parent == nil then
           local stack = debug.getstack(3)
           local counter = 0
           local expected;
           for i,v in pairs(stack) do
               if v == game.Players.LocalPlayer.Name or v == "Ban" or v == "Packet" or v == "Network" then
                   counter = counter + 1
               elseif type(v) == "number" then
                   if type(expected) == "number" then
                       expected = expected + v
                   else
                       expected = v
                   end
               end
           end
           if counter == expected then
               eval1 = {true, counter+5}
           end
       end
       if eval1[1] then
           if #args == eval1[2] then
               local counter = 0
               local outgoingkey;
               for i,v in pairs(args) do
                   if v == game.Players.LocalPlayer.Name or v == "Ban" or v == "Packet" or v == "Network" then
                       counter = counter + 1
                   elseif tostring(i) == "userdata: 0x000000001bdfb8ea" then
                       outgoingkey = v
                   end
                   if counter == eval1[2] then
                       eval2 = {true, outgoingkey}
                   end
               end
           end
           if eval2[1] then
               game:GetService("NetworkClient"):SetOutgoingKBPSLimit(0, outgoingkey)
               game.Players.LocalPlayer:Kick("Game attempted to ban you but was blocked")
               return wait(9e9)
           end
       end
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

local isPF = game.PlaceId == 292439477

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

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

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

local aimTarget = nil
local aimPart = "Head"
local aimbotActive = false
local silentAimActive = false
local fovValue = 100
local smoothValue = isPF and 0.5 or 0.2
local showFOV = false

local espActive = false
local boxEspActive = false
local nameEspActive = false

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.NumSides = 60

runService.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(mouse.X, mouse.Y + (isPF and 36 or 0))
    fovCircle.Radius = fovValue
    fovCircle.Visible = showFOV and (aimbotActive or silentAimActive)
end)

local function getClosestPlayerToMouse()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local isEnemy = isPF and plr.Team ~= player.Team or not isPF
            
            if isEnemy then
                local character = plr.Character
                local humanoid = character:FindFirstChild("Humanoid")
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                local targetPart = character:FindFirstChild(aimPart)

                if humanoid and rootPart and targetPart and humanoid.Health > 0 then
                    if isPF then
                        local ray = Ray.new(camera.CFrame.Position, (targetPart.Position - camera.CFrame.Position).Unit * 1000)
                        local ignoreList = {player.Character, camera}
                        local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
                        
                        if hit and hit:IsDescendantOf(character) then
                            local velocity = rootPart.Velocity
                            local bulletSpeed = 2800
                            local timeToHit = (targetPart.Position - camera.CFrame.Position).Magnitude / bulletSpeed
                            local predictedPosition = targetPart.Position + (velocity * timeToHit)
                            local screenPos, onScreen = camera:WorldToScreenPoint(predictedPosition)
                            
                            if onScreen then
                                local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude
                                
                                if magnitude < shortestDistance and magnitude <= fovValue then
                                    closestPlayer = targetPart
                                    shortestDistance = magnitude
                                end
                            end
                        end
                    else
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
        end
    end

    return closestPlayer
end

local function createESP(character)
    local plr = game.Players:GetPlayerFromCharacter(character)
    if not plr or plr == player then return end
    
    if isPF and plr.Team == player.Team then return end
    
    for _, esp in pairs(character:GetChildren()) do
        if esp.Name:find("ESP") then
            esp:Destroy()
        end
    end

    local espFolder = Instance.new("Folder")
    espFolder.Name = "ESP_Holder"
    espFolder.Parent = character

    local boxOutline = Drawing.new("Square")
    local box = Drawing.new("Square")
    local healthBar = Drawing.new("Square")
    local healthBarOutline = Drawing.new("Square")
    local nameTag = Drawing.new("Text")

    box.Thickness = 1
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Filled = false
    box.Transparency = 1
    boxOutline.Thickness = 3
    boxOutline.Color = Color3.fromRGB(0, 0, 0)
    boxOutline.Filled = false
    boxOutline.Transparency = 1

    healthBar.Thickness = 1
    healthBar.Filled = true
    healthBar.Color = Color3.fromRGB(0, 255, 0)
    healthBar.Transparency = 1
    healthBarOutline.Thickness = 1
    healthBarOutline.Filled = false
    healthBarOutline.Color = Color3.fromRGB(0, 0, 0)
    healthBarOutline.Transparency = 1

    nameTag.Size = 14
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.Color = Color3.fromRGB(255, 0, 0)
    nameTag.Font = 2

    local connection = runService.RenderStepped:Connect(function()
        if not character:IsDescendantOf(game) or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Humanoid") then
            box.Visible = false
            boxOutline.Visible = false
            healthBar.Visible = false
            healthBarOutline.Visible = false
            nameTag.Visible = false
            return
        end

        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")

        if isPF then
            local minX, minY, minZ = math.huge, math.huge, math.huge
            local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge
            
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    local size = part.Size
                    local cf = part.CFrame
                    
                    local corners = {
                        cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2),
                        cf * CFrame.new(-size.X/2, -size.Y/2, size.Z/2),
                        cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2),
                        cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2),
                        cf * CFrame.new(size.X/2, -size.Y/2, -size.Z/2),
                        cf * CFrame.new(size.X/2, -size.Y/2, size.Z/2),
                        cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2),
                        cf * CFrame.new(size.X/2, size.Y/2, size.Z/2)
                    }
                    
                    for _, corner in pairs(corners) do
                        local pos = corner.Position
                        minX = math.min(minX, pos.X)
                        minY = math.min(minY, pos.Y)
                        minZ = math.min(minZ, pos.Z)
                        maxX = math.max(maxX, pos.X)
                        maxY = math.max(maxY, pos.Y)
                        maxZ = math.max(maxZ, pos.Z)
                    end
                end
            end
            
            local topLeft = camera:WorldToViewportPoint(Vector3.new(minX, maxY, minZ))
            local bottomRight = camera:WorldToViewportPoint(Vector3.new(maxX, minY, maxZ))
            local pos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            
            if not onScreen or not espActive then
                box.Visible = false
                boxOutline.Visible = false
                healthBar.Visible = false
                healthBarOutline.Visible = false
                nameTag.Visible = false
                return
            end

            local boxSize = Vector2.new(
                math.abs(topLeft.X - bottomRight.X),
                math.abs(topLeft.Y - bottomRight.Y)
            )
            local boxPosition = Vector2.new(
                math.min(topLeft.X, bottomRight.X),
                math.min(topLeft.Y, bottomRight.Y)
            )

            box.Size = boxSize
            box.Position = boxPosition
            boxOutline.Size = boxSize
            boxOutline.Position = boxPosition
            box.Visible = true
            boxOutline.Visible = true

            local healthBarSize = Vector2.new(2, boxSize.Y * (humanoid.Health/humanoid.MaxHealth))
            local healthBarPosition = Vector2.new(boxPosition.X - 5, boxPosition.Y + (boxSize.Y - healthBarSize.Y))
            healthBar.Size = healthBarSize
            healthBar.Position = healthBarPosition
            healthBarOutline.Size = Vector2.new(2, boxSize.Y)
            healthBarOutline.Position = Vector2.new(boxPosition.X - 5, boxPosition.Y)
            healthBar.Visible = true
            healthBarOutline.Visible = true

            local distance = (rootPart.Position - camera.CFrame.Position).Magnitude
            nameTag.Position = Vector2.new((boxPosition.X + boxSize.X/2), boxPosition.Y - 20)
            nameTag.Text = string.format("%s [%dm]", plr.Name, math.floor(distance))
            nameTag.Visible = true

            local healthPercentage = humanoid.Health/humanoid.MaxHealth
            healthBar.Color = Color3.fromRGB(255 - 255 * healthPercentage, 255 * healthPercentage, 0)
        else
            local pos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            
            if not onScreen or not espActive then
                box.Visible = false
                boxOutline.Visible = false
                healthBar.Visible = false
                healthBarOutline.Visible = false
                nameTag.Visible = false
                return
            end

            local size = rootPart.Size * Vector3.new(2, 3, 0)
            local boxSize = Vector2.new(
                camera.ViewportSize.X / (pos.Z * 2) * size.X,
                camera.ViewportSize.Y / (pos.Z * 2) * size.Y
            )
            local boxPosition = Vector2.new(
                pos.X - boxSize.X/2,
                pos.Y - boxSize.Y/2
            )

            box.Size = boxSize
            box.Position = boxPosition
            boxOutline.Size = boxSize
            boxOutline.Position = boxPosition
            box.Visible = true
            boxOutline.Visible = true

            local healthBarSize = Vector2.new(2, boxSize.Y * (humanoid.Health/humanoid.MaxHealth))
            local healthBarPosition = Vector2.new(boxPosition.X - 5, boxPosition.Y + (boxSize.Y - healthBarSize.Y))
            healthBar.Size = healthBarSize
            healthBar.Position = healthBarPosition
            healthBarOutline.Size = Vector2.new(2, boxSize.Y)
            healthBarOutline.Position = Vector2.new(boxPosition.X - 5, boxPosition.Y)
            healthBar.Visible = true
            healthBarOutline.Visible = true

            local distance = (rootPart.Position - camera.CFrame.Position).Magnitude
            nameTag.Position = Vector2.new((boxPosition.X + boxSize.X/2), boxPosition.Y - 20)
            nameTag.Text = string.format("%s [%dm]", plr.Name, math.floor(distance))
            nameTag.Visible = true

            local healthPercentage = humanoid.Health/humanoid.MaxHealth
            healthBar.Color = Color3.fromRGB(255 - 255 * healthPercentage, 255 * healthPercentage, 0)
        end
    end)

    character.AncestryChanged:Connect(function()
        if not character:IsDescendantOf(game) then
            connection:Disconnect()
            box:Remove()
            boxOutline:Remove()
            healthBar:Remove()
            healthBarOutline:Remove()
            nameTag:Remove()
        end
    end)
end

game.Players.PlayerAdded:Connect(function(plr)
    if plr ~= player then
        plr.CharacterAdded:Connect(function(char)
            createESP(char)
        end)
    end
end)

for _, plr in pairs(game.Players:GetPlayers()) do
    if plr ~= player and plr.Character then
        createESP(plr.Character)
    end
    if plr ~= player then
        plr.CharacterAdded:Connect(function(char)
            createESP(char)
        end)
    end
end

runService.RenderStepped:Connect(function()
    if aimbotActive and userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayerToMouse()
        if target then
            if isPF then
                local velocity = target.Parent.HumanoidRootPart.Velocity
                local bulletSpeed = 2800
                local timeToHit = (target.Position - camera.CFrame.Position).Magnitude / bulletSpeed
                local predictedPosition = target.Position + (velocity * timeToHit)
                local targetPos = camera:WorldToScreenPoint(predictedPosition)
                local mousePos = Vector2.new(mouse.X, mouse.Y)
                local moveAmount = (Vector2.new(targetPos.X, targetPos.Y) - mousePos) * smoothValue
                mousemoverel(moveAmount.X, moveAmount.Y)
            else
                local targetPos = camera:WorldToScreenPoint(target.Position)
                local mousePos = Vector2.new(mouse.X, mouse.Y)
                local moveAmount = (Vector2.new(targetPos.X, targetPos.Y) - mousePos) * smoothValue
                mousemoverel(moveAmount.X, moveAmount.Y)
            end
        end
    end
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if silentAimActive and (method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" or method == "Raycast") then
        local target = getClosestPlayerToMouse()
        if target then
            if isPF then
                local velocity = target.Parent.HumanoidRootPart.Velocity
                local bulletSpeed = 2800
                local timeToHit = (target.Position - camera.CFrame.Position).Magnitude / bulletSpeed
                local predictedPosition = target.Position + (velocity * timeToHit)
                
                if method == "Raycast" then
                    args[1] = (predictedPosition - camera.CFrame.Position).Unit
                    args[2] = (predictedPosition - camera.CFrame.Position).Magnitude
                else
                    args[1] = Ray.new(camera.CFrame.Position, (predictedPosition - camera.CFrame.Position).Unit * 1000)
                end
            else
                if method == "Raycast" then
                    args[1] = (target.Position - camera.CFrame.Position).Unit
                    args[2] = (target.Position - camera.CFrame.Position).Magnitude
                else
                    args[1] = Ray.new(camera.CFrame.Position, (target.Position - camera.CFrame.Position).Unit * 1000)
                end
            end
            return oldNamecall(self, unpack(args))
        end
    end
    
    return oldNamecall(self, ...)
end)

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

-- Create aimbot toggles and sliders
createToggle("Aimbot", aimContent, function(enabled)
    aimbotActive = enabled
end)

createToggle("Silent Aim", aimContent, function(enabled)
    silentAimActive = enabled
end)

createToggle("Show FOV", aimContent, function(enabled)
    showFOV = enabled
end)

createDropdown("Aim Part", aimContent, {"Head", "Torso"}, function(selected)
    aimPart = selected
end)

createSlider("FOV", aimContent, 10, 800, fovValue, function(value)
    fovValue = value
end)

createSlider("Smoothness", aimContent, 0.01, 1, smoothValue, function(value)
    smoothValue = value
end)

-- Create ESP toggles
createToggle("ESP", espContent, function(enabled)
    espActive = enabled
end)

-- Create misc features
createToggle("Speed Hack", miscContent, function(enabled)
    if enabled then
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 50
        end
    else
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
    else
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 50
        end
        player.Character.Humanoid.JumpPower = 50
    end
end)
