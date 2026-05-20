--!strict
--[[
    Name: Nuke
    Description: Handles the Nuke Logic

    Author: Sean_Developer (yvseann)
]]

local SoundService = game:GetService("SoundService")

local Modules = game:GetService("ServerScriptService").Modules
local objectHelper = require(Modules.Helpers.objectHelper)

local Displays = require(script.Parent.Parent.Displays)

local Nuke = {}
local prefix = "Modules/Events/Nuke/Nuke.luau || "

local function playSound(sound)
	if sound:IsA("Sound") then
		sound:Play()
	else
		warn(prefix.. "Found sound ".. sound.Name.. "is not actually a Sound Instance!")
	end
end

function Nuke.alphaWarhead()
	local warheadSiren = objectHelper:findNamedObject(SoundService, "WarheadSiren")
	local warheadMusic = objectHelper:findNamedObject(SoundService, "WarheadMusic")
	local announceAlpha = objectHelper:findNamedObject(SoundService, "AnnounceAlpha")
	local siren = objectHelper:findNamedObject(SoundService, "Siren")
	if not warheadSiren or not announceAlpha or not siren then
		return
	end

	playSound(siren)

	task.wait(2.5)
	playSound(announceAlpha)

	task.delay(2.5, function()
		Displays:alphaWarhead()
    end)

	announceAlpha.Ended:Wait()
	playSound(warheadSiren)
	playSound(warheadMusic)
end


function Nuke.omegaWarhead()
	print("I do nothing yet")
end

return Nuke