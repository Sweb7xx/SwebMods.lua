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

-- Box ESP Function
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
                        local box = Instance.new("BoxHandleAdornment")
                        box.Name = "SwebESP"
                        box.Adornee = character.HumanoidRootPart
                        box.Size = character.HumanoidRootPart.Size + Vector3.new(2, 4, 2)
                        box.Color3 = Color3.fromRGB(255, 0, 0)
                        box.Transparency = 0.5
                        box.Parent = character
                        
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
        
        -- Handle new players joining
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function(character)
                if espEnabled then
                    createESP(character)
                end
            end)
        end)
    end
end

-- Aimbot variables
local aimbotEnabled = false
local aimbotTarget = nil
local aimbotPart = "Head" -- Target part (Head or HumanoidRootPart)
local maxDistance = 150 -- Max distance for aimbot
local aimbotSensitivity = 1 -- Lower = smoother

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = maxDistance -- 150m max range
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(aimbotPart) and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
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

-- Aimbot function
local function aimbot()
    if aimbotEnabled and aimbotTarget and aimbotTarget.Character and aimbotTarget.Character:FindFirstChild(aimbotPart) then
        local pos = aimbotTarget.Character[aimbotPart].Position
        local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(pos)
        
        if onScreen then
            mousemoverel(
                (screenPos.X - LocalPlayer:GetMouse().X) * aimbotSensitivity,
                (screenPos.Y - LocalPlayer:GetMouse().Y) * aimbotSensitivity
            )
        end
    end
end

-- Toggle aimbot
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

-- Infinite ammo function
local infiniteAmmoEnabled = false
local function toggleInfiniteAmmo()
    infiniteAmmoEnabled = not infiniteAmmoEnabled
    
    if infiniteAmmoEnabled then
        -- Hook into the ammo system
        local mt = getrawmetatable(game)
        local oldIndex = mt.__index
        setreadonly(mt, false)
        
        mt.__index = newcclosure(function(self, key)
            if infiniteAmmoEnabled and key == "Ammo" then
                return 999
            end
            return oldIndex(self, key)
        end)
        
        setreadonly(mt, true)
    end
end

-- Speed hack
local speedEnabled = false
local defaultSpeed = 16
local speedMultiplier = 2

local function toggleSpeed()
    speedEnabled = not speedEnabled
    
    if speedEnabled then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = defaultSpeed * speedMultiplier
        end
        
        LocalPlayer.CharacterAdded:Connect(function(character)
            if speedEnabled and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = defaultSpeed * speedMultiplier
            end
        end)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = defaultSpeed
        end
    end
end

-- No recoil function
local noRecoilEnabled = false
local function toggleNoRecoil()
    noRecoilEnabled = not noRecoilEnabled
    
    if noRecoilEnabled then
        -- Hook into the recoil system
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if noRecoilEnabled and method == "FireServer" and tostring(self) == "RecoilEvent" then
                return nil
            end
            
            return oldNamecall(self, ...)
        end)
        
        setreadonly(mt, true)
    end
end

-- Create buttons
createButton("ESP", UDim2.new(0.5, 0, 0, 50), toggleESP)
createButton("Aimbot", UDim2.new(0.5, 0, 0, 90), toggleAimbot)
createButton("Infinite Ammo", UDim2.new(0.5, 0, 0, 130), toggleInfiniteAmmo)
createButton("Speed Hack", UDim2.new(0.5, 0, 0, 170), toggleSpeed)
createButton("No Recoil", UDim2.new(0.5, 0, 0, 210), toggleNoRecoil)

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
