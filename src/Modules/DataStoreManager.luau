--[[
	Name: DataStoreManager
	Author: yvseann/Sean_Developer
	Description: Module that handles the saving and loading of user data.
]]

--[[ TODO
	Loaded data for players flags
	Type safety on load, check typeof(savedValue) == typeof(statInstance.Value)
	error backoff - if saving fails, try again later
	metadata - LastSave for each player.
]]

-->: Services
local dataStoreService = game:GetService("DataStoreService")
local runService = game:GetService("RunService")

local Stat = {}
Stat.__index = Stat

-- Constructor
function Stat.new(name, statType, defaultValue)
	local self = setmetatable({}, Stat)
	self.Name = name
	self.Type = statType or "IntValue"
	self.Default = defaultValue or 0
	return self
end

-- Create Instance

function Stat:createInstance(parent)
	local stat = Instance.new(self.Type)
	stat.Name = self.Name
	stat.Value = self.Default
	stat.Parent = parent
	return stat
end

-- Datastore Module
local DataStoreManager = {}
DataStoreManager.loadedData = false

DataStoreManager.stats = {
	Stat.new("Credits", "IntValue", 100),
	Stat.new("Level", "IntValue", 1),
	Stat.new("XP","IntValue",  0),
	Stat.new("Reputation", "IntValue", 0),
	Stat.new("Keycard", "IntValue", 1)
}

local keys = {
	live = "90IEF890Iopodad[apl=-pw-a=dolJMFDOI=ifufoiJIJF=[09uje=u=8UFJ=8uf==jf",
	dev = "DEVKEY",
}

--: Init the DataStore
function DataStoreManager._init(plr)
	if plr and plr:IsA("Player") then
		warn("Modules/DataStoreManager.luau || Initializing Folders for " .. plr.Name)

		local playerStats = Instance.new("Folder")
		playerStats.Name = "playerStats"
		playerStats.Parent = plr

		-- Loop through Stat objects
		for _, statObj in ipairs(DataStoreManager.stats) do
			statObj:createInstance(playerStats)
		end
	else
		error("Modules/DataStoreManager.luau || Failed to find player.")
	end
end

-->: Get Keys
function DataStoreManager.getStore()
	if runService:IsStudio() then
		print("Modules/DataStoreManager.luau || RUNNING IN DEVELOPER ENVIRONMENT")
		return dataStoreService:GetDataStore(keys.dev)
	else
		print("Modules/DataStoreManager.luau || LIVE ENVIRONMENT DATASTORE")
		return dataStoreService:GetDataStore(keys.live)
	end
end

function DataStoreManager.saveData(plr)
	local tableToSave = {}

	local plrStats = plr:FindFirstChild("playerStats")
	if not plrStats then
		DataStoreManager._init(plr)
		plrStats = plr:FindFirstChild("playerStats")
	end

	for _, statObj in ipairs(DataStoreManager.stats) do
		local statInstance = plrStats:FindFirstChild(statObj.Name)
		if statInstance then
			tableToSave[statObj.Name] = statInstance.Value
		end
	end

	-- finally save stuff

	local dataStore = DataStoreManager.getStore()
	local success, err = pcall(function()
		dataStore:UpdateAsync(plr.UserId, function()
			return tableToSave
		end)
	end)

	if success then
		print("Modules/DataStoreManager.luau || SUCCESSFULLY SAVED DATA FOR ".. plr.Name)
	else
		warn("Modules/DataStoreManager.luau || FAILED TO SAVE DATA FOR ".. plr.Name .. ":".. err)
	end
end

function DataStoreManager.loadData(plr)
	local dataStore = DataStoreManager.getStore()

	local data
	local success, err = pcall(function()
		data = dataStore:GetAsync(plr.UserId)
	end)

	if success and data then
		print("Modules/DataStoreManager.luau || GOT DATA FOR ".. plr.Name.. "!")
		local plrStats = plr:FindFirstChild("playerStats")
		if not plrStats then
			DataStoreManager._init(plr)
			plrStats = plr:FindFirstChild("playerStats")
		end

		for statName, savedValue in pairs(data) do
			local statInstance = plrStats:FindFirstChild(statName)
			if statInstance then
				statInstance.Value = savedValue
				print("Modules/DataStoreManager.luau || ".. plr.Name.. ": ".. statInstance.Name.. " loaded!")
			else
				warn("Modules/DataStoreManager.luau || Missing stat '" .. statName .. "' for " .. plr.Name)
			end
		end

	else
		warn("Modules/DataStoreManager.luau || Player " .. plr.Name .. " has no data!")
		DataStoreManager._init(plr)
	end

	if not success then
		warn("Modules/DataStoreManager.luau || FAILED TO LOAD DATA! ERR: ".. tostring(err))
		return
	end

	DataStoreManager.loadedData = true
end

function DataStoreManager.getData(plr, dataName)
	if not plr or not dataName then
		warn("Modules/DataStoreManager.luau || getData called with invalid arguments")
		return nil
	end

	local plrStats = plr:FindFirstChild("playerStats")
	if not plrStats then
		warn("Modules/DataStoreManager.luau || No stats folder found for " .. plr.Name)
		return nil
	end

	local stat = plrStats:FindFirstChild(dataName)
	if not stat then
		warn("Modules/DataStoreManager.luau || Stat '" .. dataName .. "' does not exist for " .. plr.Name)
		return nil
	end

	return stat.Value
end

return DataStoreManager