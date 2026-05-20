--!strict
--[[
    Name: Displays
    Description: Handles the Information Display Logic

    Author: Sean_Developer (yvseann)
]]

local modules = game:GetService("ServerScriptService").Modules

local objectHelper = require(modules.Helpers.objectHelper)
local timerHelper = require(modules.Helpers.timerHelper)

local prefix = "Modules/Events/Displays.luau || "
local Displays = {}

function Displays.normalOperation() -- I do nothing!
    return
end

function Displays:alphaWarhead()
    local displays = objectHelper:getTagged("CheckpointScreen")
    
    for _, display in ipairs(displays) do
		local surfaceGui = objectHelper:findObject(display, "SurfaceGui")
        if not surfaceGui then return end

        local headText = objectHelper:findNamedObject(surfaceGui, "Important2")
		local infoText = objectHelper:findNamedObject(surfaceGui, "Info2")
		local detonationLabel = objectHelper:findNamedObject(surfaceGui, "Detonation")
        local gradient = objectHelper:findNamedObject(surfaceGui, "Gradient")
		local clearance = objectHelper:findNamedObject(surfaceGui, "Clearance")
        local countdown = objectHelper:findNamedObject(surfaceGui, "CountDown")

        if not headText or not infoText or not detonationLabel or not gradient or not clearance or not countdown then
            warn(prefix.. "A text label could not be found! Returning to prevent error.")
            return
        end

        clearance.Visible = false

        headText.Visible = true
        infoText.Visible = true
        detonationLabel.Visible = true
        gradient.Visible = true
        countdown.Visible = true

        timerHelper:msTimer(countdown)
    end
    
end

return Displays