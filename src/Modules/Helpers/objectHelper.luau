--!strict
--[[
    Name: objectHelper
    Description: More in depth object stuff

    Author: Sean_Developer (yvseann)
]]

local CS = game:GetService("CollectionService")
local prefix = "Modules/Helpers/objectHelper.luau || "

local objectHelper = {}

function objectHelper:getTagged(tag)
	local tagged
	for i = 1, 3 do
		tagged = CS:GetTagged(tag)
		if #tagged == 0 then
			warn(prefix .. "getTagged returned empty table for " .. tag .. ". Retrying attempt " .. i .. "!")
			task.wait()
		else
			break
		end
	end
	return tagged
end

function objectHelper:findObject(root, target)
	local desc = root:GetDescendants(root)

    for _, obj in ipairs(desc) do
        if obj:IsA(target) then
            return obj
        end
    end

    warn(prefix.. "findObject could not find target ".. target.."!")
    return nil
end

function objectHelper:findNamedObject(root, name)
	local obj = root:FindFirstChild(name)

		if obj then return obj end

	warn(prefix.. "findNamedObject could not find object named ".. name.. "!")
	return nil
end

return objectHelper