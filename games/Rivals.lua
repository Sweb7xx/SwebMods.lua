print("SwebScript Rivals loaded successfully!")

-- Initialize services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

-- Create main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SwebScriptRivals"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0, 10, 0.4, 0)
MainFrame.Size = UDim2.new(0, 250, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "SwebScript Rivals"
Title.TextColor3 = Color3.fromRGB(255, 0, 4)
Title.TextSize = 20

-- Aimbot Variables
local aimbotEnabled = false
local aimbotTarget = nil
local aimbotPart = "Head" -- Aim for the head
local aimbotSensitivity = 0.5 -- Lower = smoother aim

-- Function to get the closest player
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(aimbotPart) then
            local targetPart = player.Character[aimbotPart]
            local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
            
            if onScreen then
                local mousePos = Vector2.new(LocalPlayer:GetMouse().X, LocalPlayer:GetMouse().Y)
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer
end

-- Aimbot function (move mouse to target)
local function aimbot()
    if aimbotEnabled and aimbotTarget then
        local targetPart = aimbotTarget.Character[aimbotPart]
        local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)

        if onScreen then
            local mousePos = Vector2.new(LocalPlayer:GetMouse().X, LocalPlayer:GetMouse().Y)
            local difference = Vector2.new(screenPos.X, screenPos.Y) - mousePos

            -- Move mouse towards target with sensitivity
            mousemoverel(difference.X * aimbotSensitivity, difference.Y * aimbotSensitivity)
        end
    end
end

-- Function to toggle aimbot on/off
local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled

    if aimbotEnabled then
        -- Continuously update target
        RunService:BindToRenderStep("Aimbot", 1, function()
            aimbotTarget = getClosestPlayer()
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then -- Right mouse button
                aimbot()
            end
        end)
    else
        RunService:UnbindFromRenderStep("Aimbot")
    end
end

-- Create buttons
local function createButton(name, position, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = MainFrame
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Position = position
    button.Size = UDim2.new(0.8, 0, 0, 35)
    button.Font = Enum.Font.Gotham
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.AnchorPoint = Vector2.new(0.5, 0)
    button.Position = position
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Toggle aimbot
createButton("Aimbot", UDim2.new(0.5, 0, 0, 90), toggleAimbot)

-- ESP Function (already working)
local espEnabled = false
local espObjects = {}

local function toggleESP()
    espEnabled = not espEnabled
    -- Clear existing ESP
    for _, obj in pairs(espObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    espObjects = {}

    if espEnabled then
        -- Create ESP for all players
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local function createESP(character)
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "SwebESP"
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = character
                        
                        table.insert(espObjects, highlight)
                    end
                end
                
                if player.Character then
                    createESP(player.Character)
                end

                player.CharacterAdded:Connect(function(character)
                    if espEnabled then
                        createESP(character)
                    end
                end)
            end
        end
    end
end

-- Create ESP button
createButton("ESP", UDim2.new(0.5, 0, 0, 50), toggleESP)

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "SwebScript Rivals",
    Text = "Cheat menu loaded successfully!",
    Duration = 5
})

return "SwebScript Rivals loaded successfully!"
