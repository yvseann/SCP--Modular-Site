local TouchKeypad = require(script.Parent.Parent.Keypads.TouchKeypad)
local instances = {}

local TouchKeypadRegistry = {}

function TouchKeypadRegistry.Get(model)
	if not instances[model] then
		instances[model] = TouchKeypad.new(model)
	end
	return instances[model]
end

return TouchKeypadRegistry
