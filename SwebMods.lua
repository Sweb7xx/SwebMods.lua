-- main.lua
-- Sweb Mods: Rivals Cheat Menu

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera

-- === GUI Setup ===
local gui = Instance.new("ScreenGui")
gui.Name = "SwebModMenu"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

-- Try all safe parenting options
pcall(function()
    gui.Parent = gethui and gethui() or game.CoreGui
end)

if not gui.Parent or not gui:IsDescendantOf(game) then
    -- Fallback to PlayerGui if not injected to CoreGui
    gui.Parent = player:WaitForChild("PlayerGui")
end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 220)
frame.Position = UDim2.new(0, 30, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Sweb Mods"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

local function createButton(text, y, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.9, 0, 0, 30)
	button.Position = UDim2.new(0.05, 0, 0, y)
	button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.Gotham
	button.TextSize = 14
	button.Text = text
	button.AutoButtonColor = false
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	end)
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end)
	button.MouseButton1Click:Connect(callback)
	button.Parent = frame
end

-- === Mod Features ===

-- Speed Boost
local speedEnabled = false
createButton("Toggle Speed Boost", 50, function()
	speedEnabled = not speedEnabled
	humanoid.WalkSpeed = speedEnabled and 80 or 16
end)

-- Aimbot Toggle
local aimbotEnabled = false
createButton("Toggle Aimbot", 90, function()
	aimbotEnabled = not aimbotEnabled
end)

-- Reset Mods
createButton("Reset Mods", 130, function()
	speedEnabled = false
	aimbotEnabled = false
	humanoid.WalkSpeed = 16
end)

-- === Aimbot Logic (Smooth Aim Assist) ===

local function getClosestTarget()
	local closestPlayer = nil
	local shortestDistance = math.huge
	for _, target in pairs(Players:GetPlayers()) do
		if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (target.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
			if distance < shortestDistance then
				shortestDistance = distance
				closestPlayer = target
			end
		end
	end
	return closestPlayer
end

RunService.RenderStepped:Connect(function()
	if aimbotEnabled then
		local target = getClosestTarget()
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local targetPos = target.Character.HumanoidRootPart.Position
			local camPos = camera.CFrame.Position
			local newCFrame = CFrame.new(camPos, targetPos)
			camera.CFrame = camera.CFrame:Lerp(newCFrame, 0.05) -- Smooth aim
		end
	end
end)
