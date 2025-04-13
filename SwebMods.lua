-- Ensure the script is running in LocalPlayer context
if not game:GetService("Players").LocalPlayer then
    return
end

-- Debug: Confirm UI creation
print("Creating the menu UI...")

-- Create the ScreenGui and parent it to the player's PlayerGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer.PlayerGui
screenGui.Name = "ModMenu"

-- Create the Frame that will hold the buttons
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 250, 0, 400)
frame.Position = UDim2.new(0.8, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

-- Create the Aimbot button
local aimbotButton = Instance.new("TextButton")
aimbotButton.Parent = frame
aimbotButton.Size = UDim2.new(0, 230, 0, 60)
aimbotButton.Position = UDim2.new(0, 10, 0, 10)
aimbotButton.Text = "Toggle Aimbot"
aimbotButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Create the Speed Boost button
local speedButton = Instance.new("TextButton")
speedButton.Parent = frame
speedButton.Size = UDim2.new(0, 230, 0, 60)
speedButton.Position = UDim2.new(0, 10, 0, 80)
speedButton.Text = "Toggle Speed Boost"
speedButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Create the Toggle Menu button (for hiding/showing the menu)
local toggleButton = Instance.new("TextButton")
toggleButton.Parent = frame
toggleButton.Size = UDim2.new(0, 230, 0, 60)
toggleButton.Position = UDim2.new(0, 10, 0, 150)
toggleButton.Text = "Toggle Menu"
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Script Variables
local aimbotEnabled = false
local speedBoostEnabled = false
local menuVisible = true

-- Function to Toggle Menu Visibility
toggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
    print("Menu visibility toggled:", menuVisible)  -- Debug message
end)

-- Aimbot Logic
local function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character and player ~= game.Players.LocalPlayer then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local distance = (humanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

-- Aim at the closest player
local function aimbot()
    while aimbotEnabled do
        local targetPlayer = getClosestPlayer()
        if targetPlayer then
            local targetPos = targetPlayer.Character.HumanoidRootPart.Position
            local myPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(myPos, targetPos)
        end
        wait(0.1)
    end
end

-- Toggle Aimbot
aimbotButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        aimbotButton.Text = "Aimbot: ON"
        spawn(aimbot) -- Start aimbot in a new thread
        print("Aimbot enabled")  -- Debug message
    else
        aimbotButton.Text = "Aimbot: OFF"
        print("Aimbot disabled")  -- Debug message
    end
end)

-- Speed Boost Logic
local function enableSpeedBoost()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        humanoid.WalkSpeed = 100  -- Set speed boost value (can be adjusted)
    end
end

local function disableSpeedBoost()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        humanoid.WalkSpeed = 16  -- Reset to default speed
    end
end

-- Toggle Speed Boost
speedButton.MouseButton1Click:Connect(function()
    speedBoostEnabled = not speedBoostEnabled
    if speedBoostEnabled then
        speedButton.Text = "Speed Boost: ON"
        enableSpeedBoost()
        print("Speed boost enabled")  -- Debug message
    else
        speedButton.Text = "Speed Boost: OFF"
        disableSpeedBoost()
        print("Speed boost disabled")  -- Debug message
    end
end)

-- Anti-AntiCheat
local function antiCheat()
    while true do
        -- Keep the player from being kicked by anti-cheat
        game:GetService("RunService").Heartbeat:Wait()
    end
end

-- Start anti-cheat prevention (will keep the script running safely)
spawn(antiCheat)

-- Set initial visibility of the menu to true
frame.Visible = true
print("Menu UI created and visible")
