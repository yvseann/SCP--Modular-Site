local heavyDoor = {}

local DS = require(script.Parent.Parent.Parent.DataStoreManager)

local TS = game:GetService("TweenService")

heavyDoor.bPush = true
heavyDoor.bDeny = true

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
		warn(soundName .. " not found! Error HeavyDoor.luau!")
		heavyDoor[flagName] = false
		return nil
	end
	return sound
end

local function getRandomSound(parent, prefix)
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

local function requireIsOpen(door)
	local isOpen = door:FindFirstChild("IsOpen")
	if not isOpen or not isOpen:IsA("BoolValue") then
		warn("IsOpen BoolValue missing on door!")
		return nil
	end
	return isOpen
end

function heavyDoor.open(plr, door)
	if not plr or not door then
		warn("PLR OR DOOR NOT FOUND! HeavyDoor.luau")
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

	local bOpen = getRandomSound(door1, "Open")
	local bClose = getRandomSound(door1, "Close")

	local dPart1 = requireChild(door, "Door1")
	local closedPos = dPart1.CFrame
	local openPos = closedPos * CFrame.new(3.5, 0, 0)

	local tweenInfo = TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local closeTweenInfo = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local openTween = TS:Create(dPart1, tweenInfo, { CFrame = openPos })
	local closeTween = TS:Create(dPart1, closeTweenInfo, { CFrame = closedPos })

	local dPart2 = requireChild(door, "Door2")

	local closedPos2 = dPart2.CFrame
	local openPos2 = closedPos2 * CFrame.new(2.2, 0, 0)

	local openTween2 = TS:Create(dPart2, tweenInfo, { CFrame = openPos2 })
	local closeTween2 = TS:Create(dPart2, closeTweenInfo, { CFrame = closedPos2 })

	if heavyDoor.bPush and bPush then
		bPush:Play()
	end

	local isOpen = requireIsOpen(door)
	if not isOpen then
		return
	end

	if isOpen.Value then
		if heavyDoor.bDeny and bDeny then
			bDeny:Play()
		end
		return
	end

	if keyAccess >= keyRequired.Value then
		isOpen.Value = true

		bSuccess:Play()
		openTween:Play()
		openTween2:Play()
		bOpen:Play()

		openTween.Completed:Wait()
		task.wait(5)
		closeTween:Play()
		closeTween2:Play()

		bClose:Play()
		closeTween.Completed:Wait()
		isOpen.Value = false
	else
		if heavyDoor.bDeny and bDeny then
			bDeny:Play()
		end
	end
end

return heavyDoor