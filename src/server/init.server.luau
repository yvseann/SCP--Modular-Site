--!strict
--[[
	Author: Sean_Developer (yvseann)

	File: init.server.luau
	Description: Controls the server functionality using modules.
]]

local Modules = script.Parent.Modules
local Shared = game:GetService("ReplicatedStorage").Shared
local Packages = game:GetService("ReplicatedStorage").Packages

local Cmdr = require(Packages.cmdr)

local InteractionSystem = require(Modules.Interactions.InteractionSystem)
local dataStoreManager = require(Modules.DataStoreManager)

Cmdr:RegisterDefaultCommands()
Cmdr:RegisterCommandsIn(Shared.Cmdr.Commands)
Cmdr:RegisterHooksIn(Shared.Cmdr.Hooks)
Cmdr:RegisterTypesIn(Shared.Cmdr.Types)

InteractionSystem.__init()

-- Player Added
game.Players.PlayerAdded:Connect(function(plr)
	-- Data Store Manager
	dataStoreManager.loadData(plr)
end)

-- Player Removing
game.Players.PlayerRemoving:Connect(function(plr)
	dataStoreManager.saveData(plr)
end)

-- In a case a developer shuts down servers, we need to save the data
game:BindToClose(function()
	print("server/server.init.luau DATASTORE | Server shutting down, saving all players...")
	for _, plr in ipairs(game.Players:GetPlayers()) do
		dataStoreManager.saveData(plr)
	end
end)

-- Okay but what if a player crashes and doesnt save? Let's add periodic saving.
task.spawn(function()
	while task.wait(300) do -- 5 minutes
		print("server/server.init.luau DATASTORE | Saving all players...")
		for _, plr in ipairs(game.Players:GetPlayers()) do
			dataStoreManager.saveData(plr)
		end
	end
end)