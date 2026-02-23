--[[
	Author: Sean_Developer (yvseann)

	File: init.server.luau
	Description: Controls the server functionality using modules.
]]

game.Lighting.ClockTime = 00

local Modules = script.Parent.Modules

local dataStoreManager = require(Modules.DataStoreManager)
local AntiCheat = require(Modules.AntiCheat)
local Cameras = require(Modules.CoreFacilitySystems.Camera)
local Door = require(Modules.CoreFacilitySystems.Door)
local Displays = require(Modules.Events.Displays)
local Light = require(Modules.CoreFacilitySystems.lightOld) -- will soon be deprecated

local Helicopter = require(Modules.Events.Nuke.Evacuation.Helicopter)

local MAX_AIR_TIME = 3

Door._init()

-- Player Added
game.Players.PlayerAdded:Connect(function(plr)
	--testing thing

	Cameras.testCamera(game.Workspace.TEST_CAM, plr)

	-- AntiCheat stuff
	plr.CharacterAdded:Connect(function(character)
		task.wait() -- just in case
		local root = character:WaitForChild("HumanoidRootPart")

		AntiCheat.fly(plr, character, root, MAX_AIR_TIME) -- yeah
	end)

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


task.wait(5)
warn("NUKE EVENT DEBUG!!!")
Displays:alphaWarhead()

Helicopter.flyToTarget(1, 2, 7)
task.wait(10)
Helicopter.land(1, 3, 6)