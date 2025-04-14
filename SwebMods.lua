-- Sweb Mod Menu for Roblox Rivals
-- Created by 4503
-- Version 2.0

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local SwebModMenu = {
    Enabled = true,
    Aimbot = {
        Enabled = false,
        Sensitivity = 0.5,
        TeamCheck = true,
        VisibilityCheck = true,
        TargetPart = "Head",
        FOV = 250,
        ShowFOV = true
    },
    ESP = {
        Enabled = false,
        TeamCheck = true,
        BoxESP = true,
        NameESP = true,
        DistanceESP = true,
        TracerESP = false,
        Color = Color3.fromRGB(255, 0, 0),
        TeamColor = Color3.fromRGB(0, 255, 0),
        Transparency = 0.8
    },
    UI = {
        MainColor = Color3.fromRGB(25, 25, 25),
        AccentColor = Color3.fromRGB(0, 120, 255),
        TextColor = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamSemibold,
        Draggable = true
    }
}

-- Utility Functions
local function loadScript(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Failed to load script: " .. tostring(result))
    end
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Parent = parent
    stroke.Color = color
    stroke.Thickness = thickness or 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return stroke
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.Parent = parent
    corner.CornerRadius = UDim.new(0, radius or 6)
    return corner
end

local function createShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Parent = parent
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 24, 1, 24)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    return shadow
end

local function createToggle(parent, position, text, initialState, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = text .. "Toggle"
    toggleFrame.Parent = parent
    toggleFrame.BackgroundColor3 = SwebModMenu.UI.MainColor
    toggleFrame.BackgroundTransparency = 0.3
    toggleFrame.Position = position
    toggleFrame.Size = UDim2.new(0.9, 0, 0, 40)
    toggleFrame.AnchorPoint = Vector2.new(0.5, 0)
    createCorner(toggleFrame)
    createStroke(toggleFrame, SwebModMenu.UI.AccentColor)
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "Label"
    toggleLabel.Parent = toggleFrame
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Position = UDim2.new(0, 10, 0, 0)
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Font = SwebModMenu.UI.Font
    toggleLabel.Text = text
    toggleLabel.TextColor3 = SwebModMenu.UI.TextColor
    toggleLabel.TextSize = 16
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "Button"
    toggleButton.Parent = toggleFrame
    toggleButton.AnchorPoint = Vector2.new(1, 0.5)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleButton.Position = UDim2.new(0.95, 0, 0.5, 0)
    toggleButton.Size = UDim2.new(0, 44, 0, 24)
    createCorner(toggleButton, 12)
    
    local toggleIndicator = Instance.new("Frame")
    toggleIndicator.Name = "Indicator"
    toggleIndicator.Parent = toggleButton
    toggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    toggleIndicator.Position = UDim2.new(0, 2, 0.5, 0)
    toggleIndicator.AnchorPoint = Vector2.new(0, 0.5)
    toggleIndicator.Size = UDim2.new(0, 20, 0, 20)
    createCorner(toggleIndicator, 10)
    
    local state = initialState or false
    local function updateToggle()
        local pos = state and UDim2.new(1, -2, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
        local color = state and SwebModMenu.UI.AccentColor or Color3.fromRGB(200, 200, 200)
        local bgColor = state and SwebModMenu.UI.AccentColor or Color3.fromRGB(60, 60, 60)
        
        toggleIndicator.BackgroundColor3 = color
        TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {
            Position = pos,
            BackgroundColor3 = color
        }):Play()
        
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(60, 60, 60)
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
    
    return {
        Frame = toggleFrame,
        SetState = function(newState)
            state = newState
            updateToggle()
        end,
        GetState = function()
            return state
        end
    }
end

local function createSlider(parent, position, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = text .. "Slider"
    sliderFrame.Parent = parent
    sliderFrame.BackgroundColor3 = SwebModMenu.UI.MainColor
    sliderFrame.BackgroundTransparency = 0.3
    sliderFrame.Position = position
    sliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
    sliderFrame.AnchorPoint = Vector2.new(0.5, 0)
    createCorner(sliderFrame)
    createStroke(sliderFrame, SwebModMenu.UI.AccentColor)
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "Label"
    sliderLabel.Parent = sliderFrame
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Position = UDim2.new(0, 10, 0, 5)
    sliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
    sliderLabel.Font = SwebModMenu.UI.Font
    sliderLabel.Text = text
    sliderLabel.TextColor3 = SwebModMenu.UI.TextColor
    sliderLabel.TextSize = 16
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Parent = sliderFrame
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(0.7, 0, 0, 5)
    valueLabel.Size = UDim2.new(0.3, -10, 0, 20)
    valueLabel.Font = SwebModMenu.UI.Font
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = SwebModMenu.UI.TextColor
    valueLabel.TextSize = 16
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Name = "Background"
    sliderBg.Parent = sliderFrame
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    sliderBg.Position = UDim2.new(0, 10, 0, 35)
    sliderBg.Size = UDim2.new(1, -20, 0, 10)
    createCorner(sliderBg, 5)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.Parent = sliderBg
    sliderFill.BackgroundColor3 = SwebModMenu.UI.AccentColor
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    createCorner(sliderFill, 5)
    
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Name = "Knob"
    sliderKnob.Parent = sliderBg
    sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderKnob.Position = UDim2.new(0, 0, 0.5, 0)
    sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderKnob.Size = UDim2.new(0, 16, 0, 16)
    createCorner(sliderKnob, 8)
    
    local value = default or min
    local dragging = false
    
    local function updateSlider(newValue)
        value = math.clamp(newValue, min, max)
        local percent = (value - min) / (max - min)
        
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderKnob.Position = UDim2.new(percent, 0, 0.5, 0)
        valueLabel.Text = string.format("%.2f", value)
        
        if callback then
            callback(value)
        end
    end
    
    updateSlider(value)
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local relativeX = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            local percent = relativeX / sliderBg.AbsoluteSize.X
            updateSlider(min + (max - min) * percent)
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            local percent = relativeX / sliderBg.AbsoluteSize.X
            updateSlider(min + (max - min) * percent)
        end
    end)
    
    return {
        Frame = sliderFrame,
        SetValue = updateSlider,
        GetValue = function()
            return value
        end
    }
end

local function createDropdown(parent, position, text, options, default, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = text .. "Dropdown"
    dropdownFrame.Parent = parent
    dropdownFrame.BackgroundColor3 = SwebModMenu.UI.MainColor
    dropdownFrame.BackgroundTransparency = 0.3
    dropdownFrame.Position = position
    dropdownFrame.Size = UDim2.new(0.9, 0, 0, 40)
    dropdownFrame.AnchorPoint = Vector2.new(0.5, 0)
    dropdownFrame.ClipsDescendants = true
    createCorner(dropdownFrame)
    createStroke(dropdownFrame, SwebModMenu.UI.AccentColor)
    
    local dropdownLabel = Instance.new("TextLabel")
    dropdownLabel.Name = "Label"
    dropdownLabel.Parent = dropdownFrame
    dropdownLabel.BackgroundTransparency = 1
    dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    dropdownLabel.Size = UDim2.new(0.5, 0, 0, 40)
    dropdownLabel.Font = SwebModMenu.UI.Font
    dropdownLabel.Text = text
    dropdownLabel.TextColor3 = SwebModMenu.UI.TextColor
    dropdownLabel.TextSize = 16
    dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Name = "Selected"
    selectedLabel.Parent = dropdownFrame
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
    selectedLabel.Size = UDim2.new(0.4, 0, 0, 40)
    selectedLabel.Font = SwebModMenu.UI.Font
    selectedLabel.Text = default or options[1] or "Select"
    selectedLabel.TextColor3 = SwebModMenu.UI.TextColor
    selectedLabel.TextSize = 16
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local arrowButton = Instance.new("TextButton")
    arrowButton.Name = "Arrow"
    arrowButton.Parent = dropdownFrame
    arrowButton.BackgroundTransparency = 1
    arrowButton.Position = UDim2.new(0.95, -10, 0, 0)
    arrowButton.Size = UDim2.new(0, 40, 0, 40)
    arrowButton.Font = Enum.Font.SourceSansBold
    arrowButton.Text = "▼"
    arrowButton.TextColor3 = SwebModMenu.UI.TextColor
    arrowButton.TextSize = 18
    
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Name = "Options"
    optionsFrame.Parent = dropdownFrame
    optionsFrame.BackgroundColor3 = SwebModMenu.UI.MainColor
    optionsFrame.BackgroundTransparency = 0.1
    optionsFrame.Position = UDim2.new(0, 0, 0, 40)
    optionsFrame.Size = UDim2.new(1, 0, 0, #options * 30)
    optionsFrame.Visible = false
    createCorner(optionsFrame)
    
    local isOpen = false
    local selected = default or options[1] or "Select"
    
    local function updateDropdown()
        selectedLabel.Text = selected
        if callback then
            callback(selected)
        end
    end
    
    local function toggleDropdown()
        isOpen = not isOpen
        local targetSize = isOpen and UDim2.new(0.9, 0, 0, 40 + #options * 30) or UDim2.new(0.9, 0, 0, 40)
        optionsFrame.Visible = isOpen
        arrowButton.Text = isOpen and "▲" or "▼"
        
        TweenService:Create(dropdownFrame, TweenInfo.new(0.2), {
            Size = targetSize
        }):Play()
    end
    
    arrowButton.MouseButton1Click:Connect(toggleDropdown)
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = option
        optionButton.Parent = optionsFrame
        optionButton.BackgroundTransparency = 0.9
        optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.Font = SwebModMenu.UI.Font
        optionButton.Text = option
        optionButton.TextColor3 = SwebModMenu.UI.TextColor
        optionButton.TextSize = 14
        
        optionButton.MouseButton1Click:Connect(function()
            selected = option
            updateDropdown()
            toggleDropdown()
        end)
        
        optionButton.MouseEnter:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.7
            }):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.9
            }):Play()
        end)
    end
    
    updateDropdown()
    
    return {
        Frame = dropdownFrame,
        SetValue = function(newValue)
            if table.find(options, newValue) then
                selected = newValue
                updateDropdown()
            end
        end,
        GetValue = function()
            return selected
        end
    }
end

-- UI Creation
local function createUI()
    -- Check if menu already exists
    if game:GetService("CoreGui"):FindFirstChild("SwebModMenu") then
        game:GetService("CoreGui"):FindFirstChild("SwebModMenu"):Destroy()
    end
    
    -- Create main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SwebModMenu"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = ScreenGui
    mainFrame.BackgroundColor3 = SwebModMenu.UI.MainColor
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
    mainFrame.Size = UDim2.new(0, 400, 0, 450)
    mainFrame.ClipsDescendants = true
    createCorner(mainFrame, 8)
    createShadow(mainFrame)
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Parent = mainFrame
    titleBar.BackgroundColor3 = SwebModMenu.UI.AccentColor
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    createCorner(titleBar, 8)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Parent = titleBar
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    titleLabel.Font = SwebModMenu.UI.Font
    titleLabel.Text = "Sweb Mod Menu v2.0"
    titleLabel.TextColor3 = SwebModMenu.UI.TextColor
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "Close"
    closeButton.Parent = titleBar
    closeButton.BackgroundTransparency = 1
    closeButton.Position = UDim2.new(1, -40, 0, 0)
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "X"
    closeButton.TextColor3 = SwebModMenu.UI.TextColor
    closeButton.TextSize = 18
    
    closeButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "Minimize"
    minimizeButton.Parent = titleBar
    minimizeButton.BackgroundTransparency = 1
    minimizeButton.Position = UDim2.new(1, -80, 0, 0)
    minimizeButton.Size = UDim2.new(0, 40, 0, 40)
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = SwebModMenu.UI.TextColor
    minimizeButton.TextSize = 24
    
    local minimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        local targetSize = minimized and UDim2.new(0, 400, 0, 40) or UDim2.new(0, 400, 0, 450)
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {
            Size = targetSize
        }):Play()
    end)
    
    -- Make UI draggable
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)
    
    -- Tab system
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Parent = mainFrame
    tabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.Size = UDim2.new(0.3, 0, 1, -40)
    
    local tabContent = Instance.new("Frame")
    tabContent.Name = "TabContent"
    tabContent.Parent = mainFrame
    tabContent.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tabContent.Position = UDim2.new(0.3, 0, 0, 40)
    tabContent.Size = UDim2.new(0.7, 0, 1, -40)
    
    local tabs = {}
    local tabButtons = {}
    local currentTab = nil
    
    local function createTab(name)
        -- Create tab button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Button"
        tabButton.Parent = tabContainer
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tabButton.BackgroundTransparency = 1
        tabButton.Position = UDim2.new(0, 0, 0, #tabButtons * 40)
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.Font = SwebModMenu.UI.Font
        tabButton.Text = name
        tabButton.TextColor3 = SwebModMenu.UI.TextColor
        tabButton.TextSize = 16
        
        -- Create tab content
        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Name = name .. "Tab"
        tabFrame.Parent = tabContent
        tabFrame.BackgroundTransparency = 1
        tabFrame.Position = UDim2.new(0, 0, 0, 0)
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabFrame.ScrollBarThickness = 4
        tabFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        tabFrame.Visible = false
        tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        table.insert(tabButtons, tabButton)
        tabs[name] = tabFrame
        
        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                tabs[currentTab].Visible = false
                for _, btn in ipairs(tabButtons) do
                    btn.BackgroundTransparency = 1
                end
            end
            
            currentTab = name
            tabFrame.Visible = true
            tabButton.BackgroundTransparency = 0.5
        end)
        
        if #tabButtons == 1 then
            tabButton.BackgroundTransparency = 0.5
            tabFrame.Visible = true
            currentTab = name
        end
        
        return tabFrame
    end
    
    -- Create tabs
    local mainTab = createTab("Main")
    local aimbotTab = createTab("Aimbot")
    local espTab = createTab("ESP")
    local miscTab = createTab("Misc")
    
    -- Main Tab Content
    local welcomeLabel = Instance.new("TextLabel")
    welcomeLabel.Name = "WelcomeLabel"
    welcomeLabel.Parent = mainTab
    welcomeLabel.BackgroundTransparency = 1
    welcomeLabel.Position = UDim2.new(0, 0, 0, 10)
    welcomeLabel.Size = UDim2.new(1, 0, 0, 30)
    welcomeLabel.Font = SwebModMenu.UI.Font
    welcomeLabel.Text = "Welcome to Sweb Mod Menu"
    welcomeLabel.TextColor3 = SwebModMenu.UI.TextColor
    welcomeLabel.TextSize = 18
    
    local creatorLabel = Instance.new("TextLabel")
    creatorLabel.Name = "CreatorLabel"
    creatorLabel.Parent = mainTab
    creatorLabel.BackgroundTransparency = 1
    creatorLabel.Position = UDim2.new(0, 0, 0, 40)
    creatorLabel.Size = UDim2.new(1, 0, 0, 20)
    creatorLabel.Font = SwebModMenu.UI.Font
    creatorLabel.Text = "Created by 4503"
    creatorLabel.TextColor3 = SwebModMenu.UI.TextColor
    creatorLabel.TextSize = 14
    
    local mainToggle = createToggle(mainTab, UDim2.new(0.5, 0, 0, 80), "Enable Mod Menu", true, function(state)
        SwebModMenu.Enabled = state
    end)
    
    -- Aimbot Tab Content
    local aimbotToggle = createToggle(aimbotTab, UDim2.new(0.5, 0, 0, 10), "Enable Aimbot", false, function(state)
        SwebModMenu.Aimbot.Enabled = state
    end)
    
    local teamCheckToggle = createToggle(aimbotTab, UDim2.new(0.5, 0, 0, 60), "Team Check", true, function(state)
        SwebModMenu.Aimbot.TeamCheck = state
    end)
    
    local visibilityToggle = createToggle(aimbotTab, UDim2.new(0.5, 0, 0, 110), "Visibility Check", true, function(state)
        SwebModMenu.Aimbot.VisibilityCheck = state
    end)
    
    local fovToggle = createToggle(aimbotTab, UDim2.new(0.5, 0, 0, 160), "Show FOV", true, function(state)
        SwebModMenu.Aimbot.ShowFOV = state
    end)
    
    local sensitivitySlider = createSlider(aimbotTab, UDim2.new(0.5, 0, 0, 210), "Sensitivity", 0.1, 1, 0.5, function(value)
        SwebModMenu.Aimbot.Sensitivity = value
    end)
    
    local fovSlider = createSlider(aimbotTab, UDim2.new(0.5, 0, 0, 280), "FOV Size", 50, 500, 250, function(value)
        SwebModMenu.Aimbot.FOV = value
    end)
    
    local targetPartDropdown = createDropdown(aimbotTab, UDim2.new(0.5, 0, 0, 350), "Target Part", {"Head", "HumanoidRootPart", "Torso"}, "Head", function(value)
        SwebModMenu.Aimbot.TargetPart = value
    end)
    
    -- ESP Tab Content
    local espToggle = createToggle(espTab, UDim2.new(0.5, 0, 0, 10), "Enable ESP", false, function(state)
        SwebModMenu.ESP.Enabled = state
    end)
    
    local espTeamToggle = createToggle(espTab, UDim2.new(0.5, 0, 0, 60), "Team Check", true, function(state)
        SwebModMenu.ESP.TeamCheck = state
    end)
    
    local boxEspToggle = createToggle(espTab, UDim2.new(0.5, 0, 0, 110), "Box ESP", true, function(state)
        SwebModMenu.ESP.BoxESP = state
    end)
    
    local nameEspToggle = createToggle(espTab, UDim2.new(0.5, 0, 0, 160), "Name ESP", true, function(state)
        SwebModMenu.ESP.NameESP = state
    end)
    
    local distanceEspToggle = createToggle(espTab, UDim2.new(0.5, 0, 0, 210), "Distance ESP", true, function(state)
        SwebModMenu.ESP.DistanceESP = state
    end)
    
    local tracerEspToggle = createToggle(espTab, UDim2.new(0.5, 0, 0, 260), "Tracer ESP", false, function(state)
        SwebModMenu.ESP.TracerESP = state
    end)
    
    local transparencySlider = createSlider(espTab, UDim2.new(0.5, 0, 0, 310), "Transparency", 0, 1, 0.8, function(value)
        SwebModMenu.ESP.Transparency = value
    end)
    
    -- Misc Tab Content
    local loadScriptButton = Instance.new("TextButton")
    loadScriptButton.Name = "LoadScriptButton"
    loadScriptButton.Parent = miscTab
    loadScriptButton.BackgroundColor3 = SwebModMenu.UI.AccentColor
    loadScriptButton.Position = UDim2.new(0.5, 0, 0, 20)
    loadScriptButton.Size = UDim2.new(0.8, 0, 0, 40)
    loadScriptButton.AnchorPoint = Vector2.new(0.5, 0)
    loadScriptButton.Font = SwebModMenu.UI.Font
    loadScriptButton.Text = "Load SwebMods.lua"
    loadScriptButton.TextColor3 = SwebModMenu.UI.TextColor
    loadScriptButton.TextSize = 16
    createCorner(loadScriptButton, 6)
    
    loadScriptButton.MouseButton1Click:Connect(function()
        loadScript('https://raw.githubusercontent.com/Sweb7xx/SwebMods.lua/refs/heads/main/SwebMods.lua')
    end)
    
    local creditsLabel = Instance.new("TextLabel")
    creditsLabel.Name = "CreditsLabel"
    creditsLabel.Parent = miscTab
    creditsLabel.BackgroundTransparency = 1
    creditsLabel.Position = UDim2.new(0, 0, 0, 80)
    creditsLabel.Size = UDim2.new(1, 0, 0, 30)
    creditsLabel.Font = SwebModMenu.UI.Font
    creditsLabel.Text = "Sweb Mod Menu v2.0"
    creditsLabel.TextColor3 = SwebModMenu.UI.TextColor
    creditsLabel.TextSize = 18
    
    local authorLabel = Instance.new("TextLabel")
    authorLabel.Name = "AuthorLabel"
    authorLabel.Parent = miscTab
    authorLabel.BackgroundTransparency = 1
    authorLabel.Position = UDim2.new(0, 0, 0, 110)
    authorLabel.Size = UDim2.new(1, 0, 0, 20)
    authorLabel.Font = SwebModMenu.UI.Font
    authorLabel.Text = "Created by 4503"
    authorLabel.TextColor3 = SwebModMenu.UI.TextColor
    authorLabel.TextSize = 14
    
    return ScreenGui
end

-- Aimbot Implementation
local function setupAimbot()
    -- Create FOV circle
    local fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Radius = SwebModMenu.Aimbot.FOV
    fovCircle.Color = Color3.fromRGB(255, 255, 255)
    fovCircle.Thickness = 1
    fovCircle.Transparency = 1
    fovCircle.NumSides = 60
    fovCircle.Filled = false
    
    local function isVisible(part)
        if not SwebModMenu.Aimbot.VisibilityCheck then
            return true
        end
        
        local origin = Camera.CFrame.Position
        local direction = (part.Position - origin).Unit * 1000
        local ray = Ray.new(origin, direction)
        
        local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
        
        return hit and hit:IsDescendantOf(part.Parent)
    end
    
    local function isTeammate(player)
        if not SwebModMenu.Aimbot.TeamCheck then
            return false
        end
        
        return player.Team == LocalPlayer.Team
    end
    
    local function getClosestPlayerToCursor()
        local closestPlayer = nil
        local shortestDistance = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild(SwebModMenu.Aimbot.TargetPart) then
                if isTeammate(player) then
                    continue
                end
                
                local targetPart = player.Character[SwebModMenu.Aimbot.TargetPart]
                
                if not isVisible(targetPart) then
                    continue
                end
                
                local screenPoint = Camera:WorldToScreenPoint(targetPart.Position)
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local screenPosition = Vector2.new(screenPoint.X, screenPoint.Y)
                
                local distance = (screenPosition - screenCenter).Magnitude
                
                if distance < SwebModMenu.Aimbot.FOV and distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
        
        return closestPlayer
    end
    
    -- Update FOV circle
    RunService.RenderStepped:Connect(function()
        if SwebModMenu.Enabled and SwebModMenu.Aimbot.ShowFOV then
            fovCircle.Visible = true
            fovCircle.Position = UserInputService:GetMouseLocation()
            fovCircle.Radius = SwebModMenu.Aimbot.FOV
        else
            fovCircle.Visible = false
        end
    end)
    
    -- Aimbot logic
    RunService.RenderStepped:Connect(function()
        if SwebModMenu.Enabled and SwebModMenu.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target = getClosestPlayerToCursor()
            
            if target and target.Character and target.Character:FindFirstChild(SwebModMenu.Aimbot.TargetPart) then
                local targetPart = target.Character[SwebModMenu.Aimbot.TargetPart]
                local targetPosition = targetPart.Position
                
                local aimCFrame = CFrame.lookAt(Camera.CFrame.Position, targetPosition)
                
                -- Apply sensitivity for smoother aiming
                Camera.CFrame = Camera.CFrame:Lerp(aimCFrame, SwebModMenu.Aimbot.Sensitivity)
            end
        end
    end)
end

-- ESP Implementation
local function setupESP()
    local espObjects = {}
    
    local function createESPForPlayer(player)
        if player == LocalPlayer then return end
        
        local espObject = {}
        
        -- Box ESP
        local box = Drawing.new("Square")
        box.Visible = false
        box.Color = SwebModMenu.ESP.Color
        box.Thickness = 1
        box.Transparency = SwebModMenu.ESP.Transparency
        box.Filled = false
        
        -- Name ESP
        local name = Drawing.new("Text")
        name.Visible = false
        name.Color = SwebModMenu.ESP.Color
        name.Size = 18
        name.Center = true
        name.Outline = true
        name.OutlineColor = Color3.new(0, 0, 0)
        name.Font = 2
        
        -- Distance ESP
        local distance = Drawing.new("Text")
        distance.Visible = false
        distance.Color = SwebModMenu.ESP.Color
        distance.Size = 16
        distance.Center = true
        distance.Outline = true
        distance.OutlineColor = Color3.new(0, 0, 0)
        distance.Font = 2
        
        -- Tracer ESP
        local tracer = Drawing.new("Line")
        tracer.Visible = false
        tracer.Color = SwebModMenu.ESP.Color
        tracer.Thickness = 1
        tracer.Transparency = SwebModMenu.ESP.Transparency
        
        espObject.Box = box
        espObject.Name = name
        espObject.Distance = distance
        espObject.Tracer = tracer
        espObject.Player = player
        
        espObjects[player] = espObject
        
        return espObject
    end
    
    local function removeESPForPlayer(player)
        local espObject = espObjects[player]
        
        if espObject then
            for _, drawing in pairs(espObject) do
                if typeof(drawing) == "table" and drawing.Remove then
                    drawing:Remove()
                end
            end
            
            espObjects[player] = nil
        end
    end
    
    local function isTeammate(player)
        if not SwebModMenu.ESP.TeamCheck then
            return false
        end
        
        return player.Team == LocalPlayer.Team
    end
    
    -- Update ESP
    RunService.RenderStepped:Connect(function()
        for player, espObject in pairs(espObjects) do
            if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then
                for _, drawing in pairs(espObject) do
                    if typeof(drawing) == "table" and drawing.Visible ~= nil then
                        drawing.Visible = false
                    end
                end
                continue
            end
            
            if not SwebModMenu.Enabled or not SwebModMenu.ESP.Enabled or isTeammate(player) then
                for _, drawing in pairs(espObject) do
                    if typeof(drawing) == "table" and drawing.Visible ~= nil then
                        drawing.Visible = false
                    end
                end
                continue
            end
            
            local rootPart = player.Character.HumanoidRootPart
            local head = player.Character:FindFirstChild("Head")
            
            if not rootPart or not head then
                continue
            end
            
            local rootPos = rootPart.Position
            local headPos = head.Position
            
            local rootScreenPos, rootOnScreen = Camera:WorldToScreenPoint(rootPos)
            local headScreenPos, headOnScreen = Camera:WorldToScreenPoint(headPos)
            
            if not rootOnScreen and not headOnScreen then
                for _, drawing in pairs(espObject) do
                    if typeof(drawing) == "table" and drawing.Visible ~= nil then
                        drawing.Visible = false
                    end
                end
                continue
            end
            
            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            
            -- Calculate box dimensions
            local boxHeight = math.abs(headScreenPos.Y - rootScreenPos.Y)
            local boxWidth = boxHeight * 0.6
            
            local boxPosition = Vector2.new(rootScreenPos.X - boxWidth / 2, rootScreenPos.Y - boxHeight)
            local boxSize = Vector2.new(boxWidth, boxHeight)
            
            -- Update box ESP
            espObject.Box.Visible = SwebModMenu.ESP.BoxESP
            espObject.Box.Position = boxPosition
            espObject.Box.Size = boxSize
            espObject.Box.Color = isTeammate(player) and SwebModMenu.ESP.TeamColor or SwebModMenu.ESP.Color
            espObject.Box.Transparency = SwebModMenu.ESP.Transparency
            
            -- Update name ESP
            espObject.Name.Visible = SwebModMenu.ESP.NameESP
            espObject.Name.Position = Vector2.new(boxPosition.X + boxWidth / 2, boxPosition.Y - 20)
            espObject.Name.Text = player.Name
            espObject.Name.Color = isTeammate(player) and SwebModMenu.ESP.TeamColor or SwebModMenu.ESP.Color
            
            -- Update distance ESP
            local distanceValue = math.floor((Camera.CFrame.Position - rootPos).Magnitude)
            espObject.Distance.Visible = SwebModMenu.ESP.DistanceESP
            espObject.Distance.Position = Vector2.new(boxPosition.X + boxWidth / 2, boxPosition.Y + boxHeight + 5)
            espObject.Distance.Text = tostring(distanceValue) .. "m"
            espObject.Distance.Color = isTeammate(player) and SwebModMenu.ESP.TeamColor or SwebModMenu.ESP.Color
            
            -- Update tracer ESP
            espObject.Tracer.Visible = SwebModMenu.ESP.TracerESP
            espObject.Tracer.From = screenCenter
            espObject.Tracer.To = Vector2.new(rootScreenPos.X, rootScreenPos.Y)
             espObject.Tracer.Color = isTeammate(player) and SwebModMenu.ESP.TeamColor or SwebModMenu.ESP.Color
            espObject.Tracer.Transparency = SwebModMenu.ESP.Transparency
        end
    end)
    
    -- Create ESP for existing players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            createESPForPlayer(player)
        end
    end
    
    -- Handle player joining
    Players.PlayerAdded:Connect(function(player)
        createESPForPlayer(player)
    end)
    
    -- Handle player leaving
    Players.PlayerRemoving:Connect(function(player)
        removeESPForPlayer(player)
    end)
end

-- Initialize
local function init()
    createUI()
    setupAimbot()
    setupESP()
    
    -- Load external script
    loadScript('https://raw.githubusercontent.com/Sweb7xx/SwebMods.lua/refs/heads/main/SwebMods.lua')
    
    print("Sweb Mod Menu v2.0 loaded successfully!")
end

-- Run the script
init()
