-- SwebMods.lua (hosted at https://raw.githubusercontent.com/Sweb7xx/SwebMods.lua/main/SwebMods.lua)

-- Create UI
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local aimbotButton = Instance.new("TextButton")
local speedButton = Instance.new("TextButton")
local toggleButton = Instance.new("TextButton")

screenGui.Parent = game.Players.LocalPlayer.PlayerGui
screenGui.Name = "ModMenu"

frame.Parent = screenGui
frame.Size = UDim2.new(0, 250, 0, 400)
frame.Position = UDim2.new(0.8, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

-- Aimbot Button
aimbotButton.Parent = frame
aimbotButton.Size = UDim2.new(0, 230, 0, 60)
aimbotButton.Position = UDim2.new(0, 10, 0, 10)
aimbotButton.Text = "Toggle Aimbot"
aimbotButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Speed Boost Button
speedButton.Parent = frame
speedButton.Size = UDim2.new(0, 230, 0, 60)
speedButton.Position = UDim2.new(0, 10, 0, 80)
speedButton.Text = "Toggle Speed Boost"
speedButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Toggle Menu Button (For hiding/showing the menu)
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
            local direction = (targetPos - myPos).unit
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
    else
        aimbotButton.Text = "Aimbot: OFF"
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
    else
        speedButton.Text = "Speed Boost: OFF"
        disableSpeedBoost()
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

-- Set UI to visible initially
frame.Visible = menuVisible
