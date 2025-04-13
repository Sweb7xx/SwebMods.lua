-- main.lua
-- Rivals Mod Menu (Custom UI, Speed Boost, Aimbot)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera

-- Create UI
local gui = Instance.new("ScreenGui")
gui.Name = "ModMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Rivals Mod Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

-- Utility: Create buttons
local function createButton(text, posY, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 30)
	button.Position = UDim2.new(0, 5, 0, posY)
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.Gotham
	button.TextSize = 14
	button.Text = text
	button.Parent = frame
	button.MouseButton1Click:Connect(callback)
end

-- === Mod Functions ===

-- Speed Boost Toggle
local speedEnabled = false
createButton("Toggle Speed Boost", 40, function()
	speedEnabled = not speedEnabled
	humanoid.WalkSpeed = speedEnabled and 80 or 16
end)

-- Aimbot (smooth aim to closest enemy)
local aimbotEnabled = false
createButton("Toggle Aimbot", 80, function()
	aimbotEnabled = not aimbotEnabled
end)

-- Reset Mods
createButton("Reset Mods", 120, function()
	speedEnabled = false
	aimbotEnabled = false
	humanoid.WalkSpeed = 16
end)

-- Aimbot Logic (Smooth aim assist)
local function getClosestTarget()
	local closest, shortest = nil, math.huge
	for _, target in pairs(Players:GetPlayers()) do
		if target ~= player and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (target.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
			if distance < shortest then
				shortest = distance
				closest = target
			end
		end
	end
	return closest
end

RunService.RenderStepped:Connect(function()
	if aimbotEnabled then
		local closest = getClosestTarget()
		if closest and closest.Character and closest.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = closest.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				-- Smoothly adjust the camera's CFrame towards the target
				local targetPos = hrp.Position
				local camPos = camera.CFrame.Position
				local newCFrame = CFrame.new(camPos, targetPos)
				camera.CFrame = camera.CFrame:Lerp(newCFrame, 0.1)  -- Smooth aiming (tweak 0.1 for speed)
			end
		end
	end
end)
