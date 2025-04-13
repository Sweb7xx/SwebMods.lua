print("SwebScript Rivals loaded successfully!")

-- Your Rivals script code will go here
local notification = Instance.new("Message")
notification.Text = "SwebScript Rivals loaded successfully!"
notification.Parent = game.Workspace
wait(3)
notification:Destroy()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
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

-- Function to create buttons
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

-- Skeleton ESP
local skeletonESPEnabled = false
local skeletonObjects = {}

local function toggleSkeletonESP()
    skeletonESPEnabled = not skeletonESPEnabled
    
    -- Clear existing skeleton ESP
    for _, obj in pairs(skeletonObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    skeletonObjects = {}
    
    if skeletonESPEnabled then
        -- Create Skeleton ESP for all players
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local function createSkeletonESP(character)
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local function drawLine(startPart, endPart)
                            local startPos, startOnScreen = workspace.CurrentCamera:WorldToScreenPoint(startPart.Position)
                            local endPos, endOnScreen = workspace.CurrentCamera:WorldToScreenPoint(endPart.Position)
                            if startOnScreen and endOnScreen then
                                local line = Instance.new("LineHandleAdornment")
                                line.Adornee = workspace.CurrentCamera
                                line.Color3 = Color3.fromRGB(255, 0, 0)
                                line.Thickness = 2
                                line.CFrame = CFrame.new(startPart.Position, endPart.Position)
                                line.Parent = game.CoreGui
                                table.insert(skeletonObjects, line)
                            end
                        end

                        -- Draw skeleton lines between bones
                        local function addSkeletonBones(boneName1, boneName2)
                            local bone1 = character:FindFirstChild(boneName1)
                            local bone2 = character:FindFirstChild(boneName2)
                            if bone1 and bone2 then
                                drawLine(bone1, bone2)
                            end
                        end

                        -- Add ESP for bone pairs (skeleton)
                        addSkeletonBones("Head", "UpperTorso")
                        addSkeletonBones("UpperTorso", "LowerTorso")
                        addSkeletonBones("LowerTorso", "HumanoidRootPart")
                        addSkeletonBones("LeftUpperLeg", "LeftLowerLeg")
                        addSkeletonBones("RightUpperLeg", "RightLowerLeg")
                        addSkeletonBones("LeftUpperArm", "LeftLowerArm")
                        addSkeletonBones("RightUpperArm", "RightLowerArm")
                    end
                end

                if player.Character then
                    createSkeletonESP(player.Character)
                end

                player.CharacterAdded:Connect(function(character)
                    if skeletonESPEnabled then
                        createSkeletonESP(character)
                    end
                end)
            end
        end
        
        -- Handle new players joining
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function(character)
                if skeletonESPEnabled then
                    createSkeletonESP(character)
                end
            end)
        end)
    end
end

-- Create buttons
createButton("Skeleton ESP", UDim2.new(0.5, 0, 0, 50), toggleSkeletonESP)

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

-- Anti-cheat bypass attempts
local function bypassAntiCheat()
    -- Basic anti-cheat bypass attempts
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        -- Attempt to block anti-cheat reports
        if method == "FireServer" and tostring(self):find("Report") then
            return nil
        end

        return oldNamecall(self, ...)
    end)

    setreadonly(mt, true)
end

-- Try to bypass anti-cheat
pcall(bypassAntiCheat)

-- Return success message
return "SwebScript Rivals loaded successfully!"
