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

	self.RankRequired = model:GetAttribute("RankRequired") or 0

	self.TweenTime = model:GetAttribute("TweenTime") or 1
	self.MoveIncrement = model:GetAttribute("MoveIncrement") or 5
	self.WaitTime = model:GetAttribute("WaitTime") or 2

	self.FrontDoor = model:WaitForChild("FrontDoor")
	self.BackDoor = model:WaitForChild("BackDoor")

	self.Buttons = model.Parent:WaitForChild("Buttons")

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

	local frontOffset = CFrame.new(self.MoveIncrement, 0, 0)
	local backOffset = CFrame.new(-self.MoveIncrement, 0, 0)

	local frontTween = TweenService:Create(self.FrontDoor, tweenInfo, { CFrame = self.FrontDoor.CFrame :: CFrame * frontOffset })

	local backTween = TweenService:Create(self.BackDoor, tweenInfo, { CFrame = self.BackDoor.CFrame * backOffset })

	task.spawn(play, frontTween)
	task.spawn(play, backTween)
	KeypadOne:SetOpening()
	KeypadTwo:SetOpening()

	for part, original in pairs(self.OriginalCFrames) do
		if part ~= self.FrontDoor and part ~= self.BackDoor then
			local offset = (part:IsDescendantOf(self.FrontDoor)) and frontOffset or backOffset
			local tween = TweenService:Create(part, tweenInfo, { CFrame = original * offset })
			task.spawn(play, tween)
		end
	end

	task.wait(self.TweenTime)
	KeypadOne:SetOpen()
	KeypadTwo:SetOpen()
	task.wait(self.WaitTime)
	KeypadOne:SetClosing()
	KeypadTwo:SetClosing()

	for part, original in pairs(self.OriginalCFrames) do
		local tween = TweenService:Create(part, tweenInfo, { CFrame = original })
		task.spawn(play, tween)
	end

	task.wait(self.TweenTime)
	KeypadOne:SetClosed()
	KeypadTwo:SetClosed()
	self.IsOpen = false
end

return EZDoor