local AntiCheat = {}

-- Tables
AntiCheat.isTouchingFloor = {} -- [player] = true/false
AntiCheat.detections = {} -- [player] = count

-- Helper Functions
function touchingFloor(player, character, root)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { root.Parent }

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rayLength = humanoid and humanoid.HipHeight + 2 or 5
	for x = -1, 1 do
		for z = -1, 1 do
			local origin = root.Position + Vector3.new(x, 0, z)
			local raycast = workspace:Raycast(origin, Vector3.new(0, -rayLength, 0), params)
			if raycast and raycast.Instance then
				AntiCheat.isTouchingFloor[player] = true
				return true
			end
		end
	end
	AntiCheat.isTouchingFloor[player] = false
	return false
end

-- Detection Handling
local function registerDetection(player)
	AntiCheat.detections[player] = (AntiCheat.detections[player] or 0) + 1
	warn("Modules/AntiCheat.luau || Flying Cheat Detected for %s (%d times)"):format(player.Name, AntiCheat.detections[player])

	if AntiCheat.detections[player] >= 3 then
		player:Kick("ANTICHEAT SYSTEM | 3 STRIKES!")
	end
end

-- Visible to Server
function AntiCheat.fly(player, character, root, MAX_AIR_TIME)
	local lastTouchedFloor = tick()
	local lastGoodPosition = root.CFrame

	task.spawn(function()
		while character.Parent do
			task.wait(0.1) -- throttle checks slightly
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if not humanoid then
				break
			end

			if touchingFloor(player, character, root) then
				lastTouchedFloor = tick()
				lastGoodPosition = root.CFrame
			end

			local timeSinceFloor = tick() - lastTouchedFloor
			local state = humanoid:GetState()

			-- Only flag if they're not in a legitimate airborne state
			if timeSinceFloor > MAX_AIR_TIME then
				if
					state ~= Enum.HumanoidStateType.Freefall
					and state ~= Enum.HumanoidStateType.Jumping
					and state ~= Enum.HumanoidStateType.Climbing
				then
					registerDetection(player)
					player:LoadCharacter()
				end
			end
		end
	end)
end


return AntiCheat