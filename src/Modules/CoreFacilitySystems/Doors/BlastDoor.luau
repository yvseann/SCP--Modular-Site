local blastDoor = {}

local DS = require(script.Parent.Parent.Parent.DataStoreManager)

blastDoor.bPush = true
blastDoor.bDeny = true

local function requireChild(parent, childName)
	local child = parent:FindFirstChild(childName)
	if not child then
		warn(childName .. " NOT FOUND!")
		return nil
	end
	return child
end

local function requireSound(parent, soundName, flagName)
	local sound = parent:FindFirstChild(soundName)
	if not sound then
		warn(soundName .. " not found! Error BlastDoor.luau!")
		blastDoor[flagName] = false
		return nil
	end
	return sound
end

local function requireIsOpen(door)
	local isOpen = door:FindFirstChild("IsOpen")
	if not isOpen or not isOpen:IsA("BoolValue") then
		warn("IsOpen BoolValue missing on door!")
		return nil
	end
	return isOpen
end

function blastDoor.open(plr, door)
	if not plr or not door then
		warn("PLR OR DOOR NOT FOUND! BLASTDOOR.LUAU")
		return
	end

	local keyAccess = DS.getData(plr, "Keycard")

	local keyRequired = requireChild(door, "keyLevel")
	if not keyRequired then
		return
	end

	local button1 = requireChild(door, "Button1")
	if not button1 then
		return
	end

	local bPush = requireSound(button1, "Push", "bPush")
	local bSuccess = requireSound(button1, "Success", "bSuccess")
	local bDeny = requireSound(button1, "Deny", "bDeny")

	if blastDoor.bPush and bPush then
		bPush:Play()
	end

	local isOpen = requireIsOpen(door)
	if not isOpen then
		return
	end

	if isOpen.Value then
		if blastDoor.bDeny and bDeny then
			bDeny:Play()
		end
		return
	end

	if keyAccess >= keyRequired.Value then
		isOpen.Value = true
        bSuccess:Play()
		task.wait(5)
		isOpen.Value = false
	else
		if blastDoor.bDeny and bDeny then
			bDeny:Play()
		end
	end
end

return blastDoor
