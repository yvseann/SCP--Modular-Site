local heavyDoor = {}

local DS = require(script.Parent.Parent.Parent.DataStoreManager)
local doorHelper = require(script.Parent.DoorHelper)


local TS = game:GetService("TweenService")

heavyDoor.bPush = true
heavyDoor.bDeny = true

local function requireIsOpen(door)
	local isOpen = door:FindFirstChild("IsOpen")
	if not isOpen or not isOpen:IsA("BoolValue") then
		warn("Modules/CoreFacilitySystems/Doors/HeavyDoor.luau || IsOpen BoolValue missing on door!")
		return nil
	end
	return isOpen
end

local function requireIsOpened(door)
	local isOpened = door:FindFirstChild("IsOpened")
	if not isOpened or not isOpened:IsA("BoolValue") then
		warn("Modules/CoreFacilitySystems/Doors/HeavyDoor.luau || IsOpen BoolValue missing on door!")
		return nil
	end
	return isOpened
end

function heavyDoor.open(plr, door)
	if not plr or not door then
		warn("Modules/CoreFacilitySystems/Doors/HeavyDoor.luau || PLR OR DOOR NOT FOUND!")
		return
	end

	local keyAccess = DS.getData(plr, "Keycard")

	local keyRequired = doorHelper.requireChild(door, "keyLevel")
	local button1 = doorHelper.requireChild(door, "Button1")
	local door1 = doorHelper.requireChild(door, "Door1")

	if not keyRequired or not button1 or not door1 then
		return
	end

	local bPush = doorHelper.requireSound(button1, "Push", "bPush", heavyDoor)
	local bSuccess = doorHelper.requireSound(button1, "Success", "bSuccess", heavyDoor)
	local bDeny = doorHelper.requireSound(button1, "Deny", "bDeny", heavyDoor)

	local bOpen = doorHelper.getRandomSound(door1, "Open")
	local bClose = doorHelper.getRandomSound(door1, "Close")

	local closedPos = door1:GetAttribute("ClosedPos")
	local openPos = door1:GetAttribute("OpenPos")
	if not closedPos then
		door1:SetAttribute("ClosedPos", door1.CFrame)
		door1:SetAttribute("OpenPos", door1.CFrame * CFrame.new(3.5, 0, 0))
		closedPos = door1:GetAttribute("ClosedPos")
		openPos = door1:GetAttribute("OpenPos")
	end

	local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local closeTweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local openTween = TS:Create(door1, tweenInfo, { CFrame = openPos })
	local closeTween = TS:Create(door1, closeTweenInfo, { CFrame = closedPos })

	local dPart2 = doorHelper.requireChild(door, "Door2")

	local closedPos2 = dPart2:GetAttribute("ClosedPos2")
	local openPos2 = dPart2:GetAttribute("OpenPos2")
	if not closedPos2 then
		dPart2:SetAttribute("ClosedPos2", dPart2.CFrame)
		dPart2:SetAttribute("OpenPos2", dPart2.CFrame * CFrame.new(2.2, 0, 0))
		closedPos2 = dPart2:GetAttribute("ClosedPos2")
		openPos2 = dPart2:GetAttribute("OpenPos2")
	end

	-- local openPos2 = closedPos2 * CFrame.new(2.2, 0, 0)

	local openTween2 = TS:Create(dPart2, tweenInfo, { CFrame = openPos2 })
	local closeTween2 = TS:Create(dPart2, closeTweenInfo, { CFrame = closedPos2 })

	if heavyDoor.bPush and bPush then
		bPush:Play()
	end

	local isOpen = requireIsOpen(door)
	if not isOpen then
		return
	end

	local isOpened = requireIsOpened(door)
	if not isOpened then
		return
	end

	if isOpen.Value then
		if heavyDoor.bDeny and bDeny then
			bDeny:Play()
		end
		return
	end

	if keyAccess >= keyRequired.Value then
		if isOpened.Value == false then
			isOpen.Value = true
			isOpened.Value = true
			if bSuccess then
				bSuccess:Play()
			end
			if bOpen then
				bOpen:Play()
			end
			openTween:Play()
			openTween2:Play()
			openTween.Completed:Wait()
			isOpen.Value = false
		else
			isOpen.Value = true
			isOpened.Value = false
			if bClose then
				bClose:Play()
			end
			closeTween:Play()
			closeTween2:Play()
			closeTween.Completed:Wait()
			isOpen.Value = false
		end
	else
		if heavyDoor.bDeny and bDeny then
			bDeny:Play()
		end
	end
end

return heavyDoor
