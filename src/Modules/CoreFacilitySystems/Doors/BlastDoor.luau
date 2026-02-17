local blastDoor = {}

local DS = require(script.Parent.Parent.Parent.DataStoreManager)

local TS = game:GetService("TweenService")

blastDoor.bPush = true
blastDoor.bDeny = true

local function requireChild(parent, childName)
	local child = parent:FindFirstChild(childName)
	if not child then
		warn("Modules/CoreFacilitySystems/Doors/TwoDoor.luau || "..childName .. " NOT FOUND!")
		return nil
	end
	return child
end

local function requireSound(parent, soundName, flagName)
	local sound = parent:FindFirstChild(soundName)
	if not sound then
		warn("Modules/CoreFacilitySystems/Doors/TwoDoor.luau || "..soundName .. " not found!")
		blastDoor[flagName] = false
		return nil
	end
	return sound
end

local function requireIsOpen(door)
	local isOpen = door:FindFirstChild("IsOpen")
	if not isOpen or not isOpen:IsA("BoolValue") then
		warn("Modules/CoreFacilitySystems/Doors/TwoDoor.luau || IsOpen BoolValue missing on door!")
		return nil
	end
	return isOpen
end

function blastDoor.open(plr, door)
	if not plr or not door then
		warn("Modules/CoreFacilitySystems/Doors/BlastDoor.luau || PLR OR DOOR NOT FOUND! BLASTDOOR.LUAU")
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

	local door1 = requireChild(door, "Door1")
	if not door1 then
		return
	end

	local bPush = requireSound(button1, "Push", "bPush")
	local bSuccess = requireSound(button1, "Success", "bSuccess")
	local bDeny = requireSound(button1, "Deny", "bDeny")

	local bOpen1 = requireSound(door1, "Open1", "bOpen1")
	local bClose1 = requireSound(door1, "Close1", "bClose1")

	local dPart1 = requireChild(door, "Door1")
	local closedPos = dPart1.CFrame
	local openPos = closedPos * CFrame.new(-4, 0, 0)

	local tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local closeTweenInfo = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local openTween = TS:Create(dPart1, tweenInfo, { CFrame = openPos })
	local closeTween = TS:Create(dPart1, closeTweenInfo, { CFrame = closedPos })

	local dPart2 = requireChild(door, "Door2")

	local closedPos2 = dPart2.CFrame
	local openPos2 = closedPos2 * CFrame.new(4, 0, 0) 

	local openTween2 = TS:Create(dPart2, tweenInfo, { CFrame = openPos2 })
	local closeTween2 = TS:Create(dPart2, closeTweenInfo, { CFrame = closedPos2 })

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
		openTween:Play()
		openTween2:Play()
		bOpen1:Play()

		openTween.Completed:Wait()
		task.wait(5)
		closeTween:Play()
		closeTween2:Play()

		bClose1:Play()
		closeTween.Completed:Wait()
		isOpen.Value = false
	else
		if blastDoor.bDeny and bDeny then
			bDeny:Play()
		end
	end
end

return blastDoor