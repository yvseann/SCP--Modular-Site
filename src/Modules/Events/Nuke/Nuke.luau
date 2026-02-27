local SoundService = game:GetService("SoundService")

local Modules = game:GetService("ServerScriptService").Modules
local objectHelper = require(Modules.Helpers.objectHelper)

local Displays = require(script.Parent.Parent.Displays)

local Nuke = {}

function Nuke.alphaWarhead()
	local warheadSiren = objectHelper:findNamedObject(SoundService, "WarheadSiren")
	local announceAlpha = objectHelper:findNamedObject(SoundService, "AnnounceAlpha")
	local siren = objectHelper:findNamedObject(SoundService, "Siren")
	if not warheadSiren or not announceAlpha or not siren then
		return
	end

	siren:Play()
	siren.Ended:Wait()
	announceAlpha:Play()

	task.delay(2.5, function()
		Displays:alphaWarhead()
	end)

	announceAlpha.Ended:Wait()
	warheadSiren:Play()
end


function Nuke.omegaWarhead()
	print("I do nothing yet")
end

return Nuke