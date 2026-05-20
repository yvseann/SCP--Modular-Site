--!strict
--[[
    Name: DoorRegistry
    Description: Register door

    Author: Sean_Developer (yvseann)
]]
local EZDoor = require(script.Parent.Parent.Classes.Door.EZDoor)

local instances = {}

local DoorRegistry = {}

function DoorRegistry.Get(model)
    if not instances[model] then
        instances[model] = EZDoor.new(model)
    end
    return instances[model]
end

return DoorRegistry
