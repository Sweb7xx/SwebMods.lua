print("SwebScript: Rage Menu loaded successfully!")

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SwebScriptRage"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 10, 0.4, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "SwebScript Rage"
Title.TextColor3 = Color3.fromRGB(255, 0, 4)
Title.TextSize = 18

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.BorderSizePixel = 0

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 5)
UICornerClose.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Rage Features
local espEnabled = false
local aimbotEnabled = false
local speedhackEnabled = false
local triggerbotEnabled = false
local noRecoilEnabled = false

local function createButton(name, position, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = MainFrame
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Position = position
    button.Size = UDim2.new(0.8, 0, 0, 30)
    button.Font = Enum.Font.Gotham
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.AnchorPoint = Vector2.new(0.5, 0)
    button.Position = position

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = button

    button.MouseButton1Click:Connect(callback)
    return button
end

-- Rage Features Handlers
local function toggleESP()
    espEnabled = not espEnabled
    -- Simple ESP: Draw box around players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local espBox = Instance.new("Frame")
                espBox.Size = UDim2.new(0, 100, 0, 100)
                espBox.Position = UDim2.new(0, -50, 0, -50)
                espBox.BackgroundTransparency = 1
                espBox.BorderColor3 = Color3.fromRGB(255, 0, 0)
                espBox.BorderSizePixel = 2
                espBox.Parent = player.Character.HumanoidRootPart

                -- Adding box outline to player
                local top = Instance.new("Frame")
                top.Size = UDim2.new(1, 0, 0, 2)
                top.Position = UDim2.new(0, 0, 0, -50)
                top.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                top.Parent = espBox

                local bottom = Instance.new("Frame")
                bottom.Size = UDim2.new(1, 0, 0, 2)
                bottom.Position = UDim2.new(0, 0, 1, 50)
                bottom.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                bottom.Parent = espBox

                local left = Instance.new("Frame")
                left.Size = UDim2.new(0, 2, 1, 0)
                left.Position = UDim2.new(0, -50, 0, 0)
                left.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                left.Parent = espBox

                local right = Instance.new("Frame")
                right.Size = UDim2.new(0, 2, 1, 0)
                right.Position = UDim2.new(1, 50, 0, 0)
                right.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                right.Parent = espBox
            end
        end
    end
end

local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        RunService:BindToRenderStep("Aimbot", 1, function()
            -- Rage Aimbot: Lock onto nearest player and instantly shoot
            local closestPlayer = nil
            local closestDist = math.huge
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local charPos = player.Character.Head.Position
                    local screenPos = Camera:WorldToScreenPoint(charPos)
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(LocalPlayer:GetMouse().X, LocalPlayer:GetMouse().Y)).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPlayer = player
                    end
                end
            end
            if closestPlayer then
                local targetPart = closestPlayer.Character:FindFirstChild("Head")
                if targetPart then
                    local screenPos = Camera:WorldToScreenPoint(targetPart.Position)
                    local mouseX, mouseY = LocalPlayer:GetMouse().X, LocalPlayer:GetMouse().Y
                    mousemoverel(screenPos.X - mouseX, screenPos.Y - mouseY)
                    -- Simulate a click (triggerbot)
                    if triggerbotEnabled then
                        local click = Instance.new("InputObject")
                        click.UserInputType = Enum.UserInputType.MouseButton1
                        game:GetService("UserInputService").InputBegan:Fire(click)
                    end
                end
            end
        end)
    else
        RunService:UnbindFromRenderStep("Aimbot")
    end
end

local function toggleSpeedhack()
    speedhackEnabled = not speedhackEnabled
    if speedhackEnabled then
        -- Set walk speed to 100 (or higher)
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
    else
        -- Reset to default walk speed
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end

local function toggleTriggerbot()
    triggerbotEnabled = not triggerbotEnabled
end

local function toggleNoRecoil()
    noRecoilEnabled = not noRecoilEnabled
    if noRecoilEnabled then
        -- Set custom camera field of view or disable gun recoil (not the actual Roblox way, but a simulation)
        -- You can add a custom method to simulate no recoil by modifying the camera angle
        Camera.FieldOfView = 120
    else
        Camera.FieldOfView = 70
    end
end

-- Create Buttons for Rage Features
createButton("ESP", UDim2.new(0.5, 0, 0, 50), toggleESP)
createButton("Aimbot", UDim2.new(0.5, 0, 0, 90), toggleAimbot)
createButton("Speedhack", UDim2.new(0.5, 0, 0, 130), toggleSpeedhack)
createButton("Triggerbot", UDim2.new(0.5, 0, 0, 170), toggleTriggerbot)
createButton("No Recoil", UDim2.new(0.5, 0, 0, 210), toggleNoRecoil)

-- Status label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0, 350)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "SwebScript v1.0 - Rage Mode"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 12

-- Notification that script has loaded
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "SwebScript Rage",
    Text = "Rage cheat menu loaded successfully!",
    Duration = 5
})

-- Return success message
return "SwebScript Rage Cheat Menu loaded successfully!"
