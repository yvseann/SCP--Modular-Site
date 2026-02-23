local twoDoor = {}

local DS = require(script.Parent.Parent.Parent.DataStoreManager)
local doorHelper = require(script.Parent.DoorHelper)

local TS = game:GetService("TweenService")

twoDoor.bPush = true
twoDoor.bDeny = true

function twoDoor.open(plr, door)
	if not plr or not door then
		warn("Modules/CoreFacilitySystems/Doors/BlastDoor.luau || PLR OR DOOR NOT FOUND! BLASTDOOR.LUAU")
		return
	end

	local keyAccess = DS.getData(plr, "Keycard")

	local keyRequired = doorHelper.requireChild(door, "keyLevel")
	local button1 = doorHelper.requireChild(door, "Button1")
	local door1 = doorHelper.requireChild(door, "Door1")

	if not keyRequired or not button1 or not door1 then return end

	local bPush = doorHelper.requireSound(button1, "Push", "bPush", twoDoor)
	local bSuccess = doorHelper.requireSound(button1, "Success", "bSuccess", twoDoor)
	local bDeny = doorHelper.requireSound(button1, "Deny", "bDeny", twoDoor)

	local bOpen1 = doorHelper.requireSound(door1, "Open1", "bOpen1", twoDoor)
	local bClose1 = doorHelper.requireSound(door1, "Close1", "bClose1", twoDoor)

	local dPart1 = doorHelper.requireChild(door, "Door1")
	local closedPos = dPart1.CFrame
	local openPos = closedPos * CFrame.new(4, 0, 0)

	local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local openTween = TS:Create(dPart1, tweenInfo, { CFrame = openPos })
	local closeTween = TS:Create(dPart1, tweenInfo, { CFrame = closedPos })

	local dPart2 = doorHelper.requireChild(door, "Door2")

	local closedPos2 = dPart2.CFrame
	local openPos2 = closedPos2 * CFrame.new(4, 0, 0)

	local openTween2 = TS:Create(dPart2, tweenInfo, { CFrame = openPos2 })
	local closeTween2 = TS:Create(dPart2, tweenInfo, { CFrame = closedPos2 })

	if twoDoor.bPush and bPush then
		bPush:Play()
	end

	local isOpen = doorHelper.requireIsOpen(door)
	if not isOpen then
		return
	end

	if isOpen.Value then
		if twoDoor.bDeny and bDeny then
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
		if twoDoor.bDeny and bDeny then
			bDeny:Play()
		end
	end
end

return twoDoor
