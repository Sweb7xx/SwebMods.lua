print("SwebScript Rivals loaded successfully!")

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI Setup
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
MainFrame.Size = UDim2.new(0, 200, 0, 300)
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
Title.Text = "SwebScript Rivals"
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

-- ESP Box Setup
local espEnabled = false
local espObjects = {}

local function toggleESP()
    espEnabled = not espEnabled
    for _, obj in pairs(espObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    espObjects = {}

    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local function createESP(character)
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local box = Instance.new("BillboardGui")
                        box.Adornee = character.HumanoidRootPart
                        box.Size = UDim2.new(0, 100, 0, 100)
                        box.AlwaysOnTop = true
                        box.Parent = character

                        local frame = Instance.new("Frame")
                        frame.Size = UDim2.new(1, 0, 1, 0)
                        frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                        frame.BorderSizePixel = 0
                        frame.Parent = box

                        table.insert(espObjects, box)
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

        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function(character)
                if espEnabled then
                    createESP(character)
                end
            end)
        end)
    end
end

-- Aimbot Setup
local aimbotEnabled = false
local aimbotTarget = nil
local aimbotPart = "Head" -- Target part (Head or HumanoidRootPart)
local aimbotDistance = 150 -- Maximum distance for aimbot

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = aimbotDistance

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(aimbotPart) then
            local pos = player.Character[aimbotPart].Position
            local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(pos)

            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(LocalPlayer:GetMouse().X, LocalPlayer:GetMouse().Y)).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end

local function aimbot()
    if aimbotEnabled and aimbotTarget and aimbotTarget.Character then
        local part = aimbotTarget.Character:FindFirstChild(aimbotPart)
        if part then
            local pos = part.Position
            local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(pos)
            if onScreen then
                mousemoverel((screenPos.X - LocalPlayer:GetMouse().X), (screenPos.Y - LocalPlayer:GetMouse().Y))
            end
        end
    end
end

local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled

    if aimbotEnabled then
        RunService:BindToRenderStep("Aimbot", 1, function()
            aimbotTarget = getClosestPlayer()
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then -- Right-click
                aimbot()
            end
        end)
    else
        RunService:UnbindFromRenderStep("Aimbot")
    end
end

-- Create Buttons
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

createButton("ESP", UDim2.new(0.5, 0, 0, 50), toggleESP)
createButton("Aimbot", UDim2.new(0.5, 0, 0, 90), toggleAimbot)

-- Status label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0, 250)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "SwebScript v1.0"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 12

-- Notification that script has loaded
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "SwebScript Rivals",
    Text = "Cheat menu loaded successfully!",
    Duration = 5
})

-- Return success message
return "SwebScript Rivals loaded successfully!"
