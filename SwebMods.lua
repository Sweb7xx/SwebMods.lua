-- Sweb Mod Menu for Roblox Rivals
-- Created by 4503
-- Version 2.0 (Simplified)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local SwebModMenu = {
    Enabled = true,
    Aimbot = {
        Enabled = false,
        TeamCheck = true,
        TargetPart = "Head"
    },
    ESP = {
        Enabled = false,
        TeamCheck = true,
        BoxESP = true,
        NameESP = true
    }
}

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SwebModMenu"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.Size = UDim2.new(0, 300, 0, 350)

-- Add UI Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
TitleBar.Size = UDim2.new(1, 0, 0, 30)

-- Add UI Corner to Title Bar
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 6)
TitleCorner.Parent = TitleBar

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Font = Enum.Font.GothamSemibold
TitleLabel.Text = "Sweb Mod Menu v2.0"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Parent = TitleBar
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Make UI Draggable
local dragging = false
local dragInput
local dragStart
local startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.Size = UDim2.new(1, -20, 1, -50)

-- Create Toggle Function
local function createToggle(parent, position, text, initialState, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = text .. "Toggle"
    toggleFrame.Parent = parent
    toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleFrame.Position = position
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = toggleFrame
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "Label"
    toggleLabel.Parent = toggleFrame
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Position = UDim2.new(0, 10, 0, 0)
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Font = Enum.Font.GothamSemibold
    toggleLabel.Text = text
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "Button"
    toggleButton.Parent = toggleFrame
    toggleButton.AnchorPoint = Vector2.new(1, 0.5)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleButton.Position = UDim2.new(0.95, 0, 0.5, 0)
    toggleButton.Size = UDim2.new(0, 40, 0, 20)
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = toggleButton
    
    local toggleIndicator = Instance.new("Frame")
    toggleIndicator.Name = "Indicator"
    toggleIndicator.Parent = toggleButton
    toggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    toggleIndicator.Position = UDim2.new(0, 2, 0.5, 0)
    toggleIndicator.AnchorPoint = Vector2.new(0, 0.5)
    toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 8)
    indicatorCorner.Parent = toggleIndicator
    
    local state = initialState or false
    local function updateToggle()
        local pos = state and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
        local color = state and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(200, 200, 200)
        
        toggleIndicator.BackgroundColor3 = color
        TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {
            Position = pos,
            BackgroundColor3 = color
        }):Play()
        
        if callback then
            callback(state)
        end
    end
    
    updateToggle()
    
    toggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            updateToggle()
        end
    end)
    
    return toggleFrame
end

-- Create Toggles
local aimbotToggle = createToggle(ContentFrame, UDim2.new(0, 0, 0, 10), "Enable Aimbot", false, function(state)
    SwebModMenu.Aimbot.Enabled = state
    print("Aimbot:", state)
end)

local teamCheckToggle = createToggle(ContentFrame, UDim2.new(0, 0, 0, 60), "Aimbot Team Check", true, function(state)
    SwebModMenu.Aimbot.TeamCheck = state
    print("Aimbot Team Check:", state)
end)

local espToggle = createToggle(ContentFrame, UDim2.new(0, 0, 0, 110), "Enable ESP", false, function(state)
    SwebModMenu.ESP.Enabled = state
    print("ESP:", state)
end)

local espTeamToggle = createToggle(ContentFrame, UDim2.new(0, 0, 0, 160), "ESP Team Check", true, function(state)
    SwebModMenu.ESP.TeamCheck = state
    print("ESP Team Check:", state)
end)

local boxEspToggle = createToggle(ContentFrame, UDim2.new(0, 0, 0, 210), "Box ESP", true, function(state)
    SwebModMenu.ESP.BoxESP = state
    print("Box ESP:", state)
end)

local nameEspToggle = createToggle(ContentFrame, UDim2.new(0, 0, 0, 260), "Name ESP", true, function(state)
    SwebModMenu.ESP.NameESP = state
    print("Name ESP:", state)
end)

-- Load External Script Button
local loadScriptButton = Instance.new("TextButton")
loadScriptButton.Name = "LoadScriptButton"
loadScriptButton.Parent = ContentFrame
loadScriptButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
loadScriptButton.Position = UDim2.new(0, 0, 0, 310)
loadScriptButton.Size = UDim2.new(1, 0, 0, 30)
loadScriptButton.Font = Enum.Font.GothamSemibold
loadScriptButton.Text = "Load SwebMods.lua"
loadScriptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
loadScriptButton.TextSize = 14

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = loadScriptButton

loadScriptButton.MouseButton1Click:Connect(function()
    local success, result = pcall(function()
        return loadstring(game:HttpGet('https://raw.githubusercontent.com/Sweb7xx/SwebMods.lua/refs/heads/main/SwebMods.lua'))()
    end)
    
    if not success then
        warn("Failed to load script: " .. tostring(result))
    else
        print("SwebMods.lua loaded successfully!")
    end
end)

-- Simple Aimbot Implementation
RunService.RenderStepped:Connect(function()
    if SwebModMenu.Enabled and SwebModMenu.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local closestPlayer = nil
        local shortestDistance = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and 
               player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild(SwebModMenu.Aimbot.TargetPart) then
                
                if SwebModMenu.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end
                
                local targetPart = player.Character[SwebModMenu.Aimbot.TargetPart]
                local screenPoint = Camera:WorldToScreenPoint(targetPart.Position)
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local screenPosition = Vector2.new(screenPoint.X, screenPoint.Y)
                
                local distance = (screenPosition - screenCenter).Magnitude
                
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
        
        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild(SwebModMenu.Aimbot.TargetPart) then
            local targetPart = closestPlayer.Character[SwebModMenu.Aimbot.TargetPart]
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetPart.Position)
        end
    end
end)

print("Sweb Mod Menu v2.0 loaded successfully!")
