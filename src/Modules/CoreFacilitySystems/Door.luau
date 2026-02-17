local Door = {}

local CS = game:GetService("CollectionService")
Door.BSTAGGED = CS:GetTagged("BlastDoor")
Door.HDTAGGED = CS:GetTagged("HeavyDoor")
Door.TWOTAGGED = CS:GetTagged("TwoDoor")

local blastDoor = require(script.Parent.Doors.BlastDoor)
local heavyDoor = require(script.Parent.Doors.HeavyDoor)
local twoDoor = require(script.Parent.Doors.TwoDoor)

function Door._init()
    for _, BSDOOR in Door.BSTAGGED do
        local Touch = BSDOOR:GetChildren()
        for _, part in pairs(Touch) do
            if part.Name == "Touch" then
				local CD = part:FindFirstChild("ClickDetector")
				if not CD then
					warn("Modules/CoreFacilitySystems/Doors/Door.luau || NO TOUCH FOUND IN BlastDoor.")
					return
				end
				CD.MouseClick:Connect(function(plr)
					blastDoor.open(plr, BSDOOR)
				end)
            end
        end
    end

    for _,  HDDOOR in Door.HDTAGGED do
        local Touch = HDDOOR:GetChildren()

		for _, part in pairs(Touch) do
			if part.Name == "Touch" then
				local CD = part:FindFirstChild("ClickDetector")
				if not CD then
					warn("Modules/CoreFacilitySystems/Doors/Door.luau || NO TOUCH FOUND IN HeavyDoor.")
					return
				end
				CD.MouseClick:Connect(function(plr)
					heavyDoor.open(plr, HDDOOR)
				end)
			end
		end
    end

	for _, TWODOOR in Door.TWOTAGGED do
		local Touch = TWODOOR:GetChildren()

		for _, part in pairs(Touch) do
			if part.Name == "Touch" then
				local CD = part:FindFirstChild("ClickDetector")
				if not CD then
					warn("Modules/CoreFacilitySystems/Doors/Door.luau || NO TOUCH FOUND IN TwoDoor.")
					return
				end
				CD.MouseClick:Connect(function(plr)
					twoDoor.open(plr, TWODOOR)
				end)
			end
		end
	end
end


return Door