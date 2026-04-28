--!strict
--[[
    Author: Sean_Developer (yvseann)

    File: InteractionSystem.luau
    Description: System used for creating interaction prompts.
]]

local InteractionSystem = {}
local prefix = "Modules/Interactions/InteractionSystem.luau || "

function InteractionSystem.__init()
    return
end

function InteractionSystem.Interacted(interaction: StringValue)
    -- get objectvalue in interaction to see whatever it was interacted with, and then find stringvalue of interaction
    interaction = interaction:FindFirstChild("interactionType") :: StringValue
    if not interaction then
        warn(prefix.. "Interaction type does not exist. Interaction will not work. How the hell was this called?")
        return
    end
    if not interaction:IsA("StringValue") then
        warn(prefix.. "Interaction type '".. interaction.Value.."' is not a string value. Sean, fix your stuff.")
    end
    
    -- check if interaction exists
    -- DoorInteraction.Interacted(interaction)
end

return InteractionSystem