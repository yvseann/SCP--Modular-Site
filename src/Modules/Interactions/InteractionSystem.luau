--!strict
--[[
    Author: Sean_Developer (yvseann)

    File: InteractionSystem.luau
    Description: System used for processing interactions with proximityprompts.
]]

local InteractionSystem = {}
local CollectionService = game:GetService("CollectionService")

local prefix = "Modules/Interactions/InteractionSystem.luau || "

local allowedInteractions: { [string]: any } = {}
local interactionFolderExists = true

function InteractionSystem._init()
	local interactives = CollectionService:GetTagged("Interactive")
	for _, interactive in ipairs(interactives) do
		if interactive:IsA("ProximityPrompt") then
			interactive.Triggered:Connect(function(plr)
				InteractionSystem.Interacted(interactive, plr)
			end)
		else
			for _, interactive in ipairs(interactive:GetDescendants()) do
				if interactive:IsA("ProximityPrompt") then
					interactive.Triggered:Connect(function(plr)
						InteractionSystem.Interacted(interactive, plr)
					end)
					break
				end
			end
		end
	end

	local InteractionsFolder = script.Parent:FindFirstChild("Interactions")

	if not InteractionsFolder or not InteractionsFolder:IsA("Folder") then
		warn(prefix .. "Interactions folder does not exist or is not a folder! Continuing but interactions may fail.")
		interactionFolderExists = false
		return
	end

	for _, module in ipairs(InteractionsFolder:GetDescendants()) do
		if module:IsA("ModuleScript") then
			local ok, result = pcall(require, module)
			if ok then
				allowedInteractions[module.Name] = result
			else
				warn(prefix .. "Failed to require module '" .. module.Name .. "': " .. tostring(result))
			end
		end
	end
end

function InteractionSystem.Interacted(interaction: ProximityPrompt, plr: Player)
	local interactionType = interaction:FindFirstChild("interactionType")
	if not interactionType or not interactionType:IsA("StringValue") or interactionType.Value == "" then
		warn(prefix .. "Invalid or missing interactionType StringValue.")
		return
	end

	local objectValue = interaction:FindFirstChild("object")
	if not objectValue or not objectValue:IsA("ObjectValue") or objectValue.Value == nil then
		warn(prefix .. "Invalid or missing object ObjectValue.")
		return
	end

	if not interactionFolderExists then
		warn(prefix .. "Interaction folder missing — cannot process interaction.")
		return
	end

	local module = allowedInteractions[interactionType.Value]
	if not module then
		warn(prefix .. "No interaction module found for type '" .. interactionType.Value .. "'.")
		return
	end

	if typeof(module.Interacted) == "function" then
		module.Interacted(objectValue.Value)
	else
		warn(prefix .. "Module '" .. interactionType.Value .. "' does not contain an Interacted() function.")
	end
end

return InteractionSystem
