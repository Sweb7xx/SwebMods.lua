-- Sweb Mods - A mod menu for Rivals on Roblox
-- Created by Cody

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create the main GUI
local SwebMods = Instance.new("ScreenGui")
SwebMods.Name = "SwebMods"
SwebMods.ResetOnSpawn = false
SwebMods.Parent = playerGui

-- Create the main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.8, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(1, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 10, 40) -- Dark purple/blackish
mainFrame.BackgroundTransparency = 0.2 -- Slightly transparent
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = SwebMods

-- Add rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = mainFrame

-- Create title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 20, 80) -- Slightly lighter purple
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- Add rounded corners to title bar (top only)
local titleUICorner = Instance.new("UICorner")
titleUICorner.CornerRadius = UDim.new(0, 10)
titleUICorner.Parent = titleBar

-- Create title text
local titleText = Instance.new("TextLabel")
titleText.Name = "Title"
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Sweb Mods"
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 22
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Parent = titleBar

-- Create a container for the mod buttons
local buttonContainer = Instance.new("ScrollingFrame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(1, -20, 1, -60)
buttonContainer.Position = UDim2.new(0, 10, 0, 50)
buttonContainer.BackgroundTransparency = 1
buttonContainer.BorderSizePixel = 0
buttonContainer.ScrollBarThickness = 4
buttonContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 50, 150)
buttonContainer.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be updated as we add buttons
buttonContainer.Parent = mainFrame

-- Create a UIListLayout for organizing buttons
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = buttonContainer

-- Function to create mod buttons
local function createModButton(name, description, callback)
    local button = Instance.new("Frame")
    button.Name = name .. "Button"
    button.Size = UDim2.new(1, -10, 0, 60)
    button.BackgroundColor3 = Color3.fromRGB(50, 20, 70)
    button.BackgroundTransparency = 0.3
    button.BorderSizePixel = 0
    button.Parent = buttonContainer
    
    -- Add rounded corners to button
    local buttonUICorner = Instance.new("UICorner")
    buttonUICorner.CornerRadius = UDim.new(0, 8)
    buttonUICorner.Parent = button
    
    -- Button title
    local buttonTitle = Instance.new("TextLabel")
    buttonTitle.Name = "Title"
    buttonTitle.Size = UDim2.new(1, 0, 0, 25)
    buttonTitle.BackgroundTransparency = 1
    buttonTitle.Text = name
    buttonTitle.Font = Enum.Font.GothamSemibold
    buttonTitle.TextSize = 16
    buttonTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    buttonTitle.Parent = button
    
    -- Button description
    local buttonDesc = Instance.new("TextLabel")
    buttonDesc.Name = "Description"
    buttonDesc.Size = UDim2.new(1, -20, 0, 20)
    buttonDesc.Position = UDim2.new(0, 10, 0, 25)
    buttonDesc.BackgroundTransparency = 1
    buttonDesc.Text = description
    buttonDesc.Font = Enum.Font.Gotham
    buttonDesc.TextSize = 12
    buttonDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    buttonDesc.TextWrapped = true
    buttonDesc.TextXAlignment = Enum.TextXAlignment.Left
    buttonDesc.Parent = button
    
    -- Button click detector
    local clickButton = Instance.new("TextButton")
    clickButton.Name = "ClickDetector"
    clickButton.Size = UDim2.new(1, 0, 1, 0)
    clickButton.BackgroundTransparency = 1
    clickButton.Text = ""
    clickButton.Parent = button
    
    -- Connect the callback
    clickButton.MouseButton1Click:Connect(callback)
    
    -- Update the canvas size
    buttonContainer.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    
    return button
end

-- Create a close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
closeButton.BackgroundTransparency = 0.3
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.Parent = titleBar

-- Add rounded corners to close button
local closeUICorner = Instance.new("UICorner")
closeUICorner.CornerRadius = UDim.new(0, 15)
closeUICorner.Parent = closeButton

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    SwebMods.Enabled = false
end)

-- Create a toggle button to show/hide the menu
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0.5, 0)
toggleButton.AnchorPoint = Vector2.new(0, 0.5)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 20, 80)
toggleButton.BackgroundTransparency = 0.2
toggleButton.Text = "SM"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 20
toggleButton.Parent = SwebMods

-- Add rounded corners to toggle button
local toggleUICorner = Instance.new("UICorner")
toggleUICorner.CornerRadius = UDim.new(0, 25)
toggleUICorner.Parent = toggleButton

-- Toggle button functionality
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Example mod buttons (replace with actual functionality for Rivals)
createModButton("Speed Boost", "Increases your movement speed", function()
    -- Implement speed boost functionality here
    game.StarterPlayer.CharacterWalkSpeed = 50
end)

createModButton("Jump Power", "Enhances your jumping ability", function()
    -- Implement jump power functionality here
    game.StarterPlayer.CharacterJumpPower = 100
end)

createModButton("ESP", "See players through walls", function()
    -- Implement ESP functionality here
    -- This would require more complex code
end)

createModButton("Teleport", "Teleport to random locations", function()
    -- Implement teleport functionality here
end)

createModButton("Aimbot", "Auto-aim at enemies", function()
    -- Implement aimbot functionality here
    -- This would require more complex code
end)

-- Add more mod buttons as needed

-- Initial state
mainFrame.Visible = false -- Start with the menu hidden
