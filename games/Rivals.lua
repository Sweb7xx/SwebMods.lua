local player = game.Players.LocalPlayer
local aimPart = "Head"
local enabled = true

-- Get Closest Enemy
local function getClosestEnemy()
    local closest, distance = nil, math.huge
    for _, target in pairs(game.Players:GetPlayers()) do
        if target ~= player and target.Character and target.Character:FindFirstChild(aimPart) then
            local mag = (target.Character[aimPart].Position - player.Character.HumanoidRootPart.Position).Magnitude
            if mag < distance then
                distance = mag
                closest = target
            end
        end
    end
    return closest
end

-- Hook the gun
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if tostring(self) == "FireBullet" and method == "FireServer" and enabled then
        local enemy = getClosestEnemy()
        if enemy and enemy.Character and enemy.Character:FindFirstChild(aimPart) then
            args[2] = enemy.Character[aimPart].Position
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, unpack(args))
end)

print("[Silent Aim] Loaded. Shoot to auto-hit enemies through walls.")
