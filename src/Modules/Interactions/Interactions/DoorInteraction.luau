--!strict
--[[
    Name: DoorInteraction
    Description: Handles the door interaction

    Author: Sean_Developer (yvseann)
]]
local DoorInteraction = {}

function DoorInteraction.Interacted(door, plr, interaction)
	local Registry = script.Parent.Registry
	local EZDoorRegistry = require(Registry.DoorRegistry)

	if door:FindFirstChild("FrontDoor") and door:FindFirstChild("BackDoor") then
		local EZDoor = EZDoorRegistry.Get(door) :: any
		if not EZDoor.IsOpen and EZDoor.RankRequired < 1 then
			for _, keypad in ipairs(EZDoor.Model.Parent.Buttons:GetDescendants()) do
				if keypad:FindFirstChild("GRANTED") then
					keypad.GRANTED:Play()
				end
			end
			EZDoor:Open()
		else
			for _, keypad in ipairs(EZDoor.Model.Parent.Buttons:GetDescendants()) do
				if keypad:FindFirstChild("DENIED") then
					keypad.DENIED:Play()
				end
			end
		end
	end
end

return DoorInteraction
