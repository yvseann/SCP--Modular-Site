--!strict
--[[
    Name: client
    Description: Handles the client side code

    Author: Sean_Developer (yvseann)
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cmdr = require(ReplicatedStorage.CmdrClient)

cmdr:SetActivationKeys( { Enum.KeyCode.F2 } )