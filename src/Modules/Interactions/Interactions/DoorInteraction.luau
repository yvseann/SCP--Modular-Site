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
		if not EZDoor.IsOpen then
			EZDoor:Open()
		end
	end
end

return DoorInteraction
