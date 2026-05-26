--!strict
--[[
    Name: EZDoor
    Description: Handles sliding door logic with proper CFrame tweening

    Author: Sean_Developer (yvseann)
]]

local EZDoor = {}
local TweenService = game:GetService("TweenService")

EZDoor.__index = EZDoor

function EZDoor:_cacheOriginalCFrames()
	for _, part in ipairs(self.Model:GetDescendants()) do
		if part:IsA("BasePart") then
			self.OriginalCFrames[part] = part.CFrame
		end
	end
end

function EZDoor.new(model)
	local self = setmetatable({}, EZDoor)

	self.Model = model
	self.IsOpen = false

	self.RankRequired = model:GetAttribute("RankRequired") or 0 :: number

	self.TweenTime = model:GetAttribute("TweenTime") or 1
	self.MoveIncrement = model:GetAttribute("MoveIncrement") or 4
	self.WaitTime = model:GetAttribute("WaitTime") or 2

	self.Buttons = model.Parent:WaitForChild("Buttons")

	self.OpenSound = model.Parent.SoundPart:WaitForChild("OPEN")
	self.CloseSound = model.Parent.SoundPart:WaitForChild("CLOSE")

	self.OriginalCFrames = {}
	self:_cacheOriginalCFrames()

	return self
end

local function play(tween)
	tween:Play()
end

function EZDoor:Open()
	local TouchKeypadRegistry = require(script.Parent.Parent.Parent.Parent.Controls.Registry.TouchKeypadRegistry)
	if self.IsLocked or self.IsOpen then
		return
	end

	local KeypadOne = TouchKeypadRegistry.Get(self.Buttons["TouchPanel_1"])
	local KeypadTwo = TouchKeypadRegistry.Get(self.Buttons["TouchPanel_2"])

	self.IsOpen = true

	local tweenInfo = TweenInfo.new(self.TweenTime)
	local offset = CFrame.new(self.MoveIncrement, 0, 0)

	self.OpenSound:Play()
	KeypadOne:SetOpening()
	KeypadTwo:SetOpening()

	for part, original in pairs(self.OriginalCFrames) do
		local tween = TweenService:Create(part, tweenInfo, {
			CFrame = original :: CFrame * offset,
		})
		task.spawn(play, tween)
	end

	task.wait(self.TweenTime)
	KeypadOne:SetOpen()
	KeypadTwo:SetOpen()
	task.wait(self.WaitTime)
	self.CloseSound:Play()
	KeypadOne:SetClosing()
	KeypadTwo:SetClosing()

	for part, original in pairs(self.OriginalCFrames) do
		local tween = TweenService:Create(part, tweenInfo, {
			CFrame = original,
		})
		task.spawn(play, tween)
	end

	task.wait(self.TweenTime)
	KeypadOne:SetClosed()
	KeypadTwo:SetClosed()
	self.IsOpen = false
end

return EZDoor
