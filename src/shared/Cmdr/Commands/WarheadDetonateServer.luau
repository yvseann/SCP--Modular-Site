local Modules = game.ServerScriptService.Modules
local nuke = require(Modules.Events.Nuke.Nuke)

return function(context, warhead)
	if type(warhead) ~= "string" then
		context:Reply("You must specify a warhead: 'alpha' or 'omega'.")
		return
	end

	local w = warhead:lower()

	if w == "omega" then
		nuke.omegaWarhead()
        context:Reply("Omega warhead detonated.")
	elseif w == "alpha" then
		nuke.alphaWarhead()
		context:Reply("Alpha warhead detonated.")
    else
        context:Reply("Invalid warhead '".. warhead.. "'. Valid options are: 'alpha', 'omega'.")
	end
end
