-- Sweb Mod Menu for Roblox Rivals
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local function loadScript(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Failed to load script: " .. tostring(result))
    end
end

local function createMenu()
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local AimbotButton = Instance.new("TextButton")
    local ESPButton = Instance.new("TextButton")
    
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 300, 0, 400)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    
    Title.Parent = Frame
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Text = "Sweb Mod Menu"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.BackgroundColor3 = Color3.new(0, 0, 0)
    
    AimbotButton.Parent = Frame
    AimbotButton.Size = UDim2.new(1, 0, 0, 50)
    AimbotButton.Position = UDim2.new(0, 0, 0, 60)
    AimbotButton.Text = "Toggle Aimbot"
    
    ESPButton.Parent = Frame
    ESPButton.Size = UDim2.new(1, 0, 0, 50)
    ESPButton.Position = UDim2.new(0, 0, 0, 120)
    ESPButton.Text = "Toggle ESP"
    
    return ScreenGui, AimbotButton, ESPButton
end

local function toggleAimbot()
    local aimbotEnabled = false
    AimbotButton.MouseButton1Click:Connect(function()
        aimbotEnabled = not aimbotEnabled
        if aimbotEnabled then
            -- Aimbot logic here
            print("Aimbot Enabled")
        else
            print("Aimbot Disabled")
        end
    end)
end

local function toggleESP()
    local espEnabled = false
    ESPButton.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        if espEnabled then
            -- ESP logic here
            print("ESP Enabled")
        else
            print("ESP Disabled")
        end
    end)
end

local function aimbot()
    RunService.RenderStepped:Connect(function()
        if aimbotEnabled then
            local target = nil
            local closestDistance = math.huge
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (Camera.CFrame.Position - player.Character.HumanoidRootPart.Position).magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        target = player
                    end
                end
            end
            if target then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end
    end)
end

local function esp()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local highlight = Instance.new("Highlight")
            highlight.Parent = player.Character
            highlight.FillColor = Color3.new(1, 0, 0)
            highlight.OutlineColor = Color3.new(0, 0, 0)
            highlight.Enabled = espEnabled
        end
    end
end

local ScreenGui, AimbotButton, ESPButton = createMenu()
toggleAimbot()
toggleESP()

loadScript('https://raw.githubusercontent.com/Sweb7xx/SwebMods.lua/refs/heads/main/SwebMods.lua')
