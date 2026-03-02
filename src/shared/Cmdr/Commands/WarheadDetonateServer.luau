local Modules = game.ServerScriptService.Modules
local nuke = require(Modules.Events.Nuke.Nuke)

return function(context, warhead)
	if warhead == "omega" then
		nuke.omegaWarhead()
        context:Reply("Omega warhead detonated.")
	elseif warhead == "alpha" then
		nuke.alphaWarhead()
		context:Reply("Alpha warhead detonated.")
    else
        context:Reply("Invalid warhead '".. warhead.. "'. Valid options are: 'alpha', 'omega'.")
	end
end
