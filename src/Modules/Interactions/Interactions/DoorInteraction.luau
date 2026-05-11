local DoorInteraction = {}

function DoorInteraction.Interacted(door)
    -- figure out what door it is and do whatever calculations i need for htat
    -- BlastDoor.Dowhatever(door)
    print("Hello!")

    local Registry = script.Parent.Registry
    local EZDoorRegistry = require(Registry.DoorRegistry)

    local EZDoor = EZDoorRegistry.Get(door)
    EZDoor:Open()
end

return DoorInteraction