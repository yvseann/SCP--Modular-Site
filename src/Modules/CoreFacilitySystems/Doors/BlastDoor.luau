local blastDoor = {}

blastDoor.bPush = true
blastDoor.bDeny = true

function blastDoor.open(door)
	local button1 = door:FindFirstChild("Button1")
	if not button1 then
		return
	end

	local bPush = button1:FindFirstChild("Push")
	if not bPush then
		warn("bPush not found! Error BlastDoor.luau!")
		blastDoor.bPush = false
	end
	local bDeny = button1:FindFirstChild("Deny")
	if not bDeny then
		warn("bDeny not found! Error BlastDoor.luau!")
		blastDoor.bPush = false
	end

	if blastDoor.bPush then
		bPush:Play()
	end

	blastDoor.isOpen = door:FindFirstChild("IsOpen")
	if not blastDoor.isOpen or not blastDoor.isOpen:IsA("BoolValue") then
		warn("Error BlastDoor.luau! openFound not found for door?")
		return
	end
	
	if blastDoor.isOpen.Value then
		if blastDoor.bPush then
            warn("NO!")
			bDeny:Play()
		end
		return
	end

	blastDoor.isOpen.Value = true

    task.wait(5)
    blastDoor.isOpen.Value = false
        
    end

return blastDoor
