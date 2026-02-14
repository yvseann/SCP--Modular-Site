local fixShadows = {}

local CS = game:GetService("CollectionService")

function fixShadows._init()
	local shadowParts = CS:GetTagged("FIXSHADOWSPLEASE")

	for _, part in ipairs(shadowParts) do
		if part:IsA("BasePart") then
			part.Transparency = -math.huge
			if part.Material ~= Enum.Material.ForceField then
				part.Material = Enum.Material.ForceField
				warn("Modules/FixShadows.luau || Part is not Forcefield Material! Fixing...")
			end
		else
			warn("Modules/FixShadows.luau || Part is not a Part! why is it not a part. is it a like script orr what is going on here")
		end
	end
end

return fixShadows