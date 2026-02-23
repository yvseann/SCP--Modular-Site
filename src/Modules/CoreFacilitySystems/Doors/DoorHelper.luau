--[[
TODO:

Add more functions. Example: Door tween animation
Keycard functions
Closed/OpenPos calculations
Playsound
]]

local DoorHelper = {}

function DoorHelper.requireChild(parent, childName)
	local child = parent:FindFirstChild(childName)
	if not child then
		warn("Modules/CoreFacilitySystems/Doors/DoorHelper.luau || "..childName .. " NOT FOUND!")
		return nil
	end
	return child
end

function DoorHelper.requireSound(parent, soundName, flagName, door)
	local sound = parent:FindFirstChild(soundName)
	if not sound then
		warn("Modules/CoreFacilitySystems/Doors/DoorHelper.luau || "..soundName .. " not found. Door ".. door.."!")
		door[flagName] = false
		return nil
	end
	return sound
end

function DoorHelper.requireIsOpen(door)
	local isOpen = door:FindFirstChild("IsOpen")
	if not isOpen or not isOpen:IsA("BoolValue") then
		warn("Modules/CoreFacilitySystems/Doors/DoorHelper.luau || IsOpen BoolValue missing on door ".. door.."!")
		return nil
	end
	return isOpen
end

function DoorHelper.getRandomSound(parent, prefix)
	local sounds = {}

	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("Sound") and obj.Name:match("^" .. prefix .. "%d+$") then
			table.insert(sounds, obj)
		end
	end

	if #sounds == 0 then
		warn("No sounds found for prefix: " .. prefix)
		return nil
	end

	return sounds[math.random(1, #sounds)]
end


return DoorHelper