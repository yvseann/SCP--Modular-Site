--!strict
--[[
    Name: TouchKeypad
    Description: Does the logic for keypad stuff

    Author: Sean_Developer (yvseann)
]]

local TouchKeypad = {}
TouchKeypad.__index = TouchKeypad

function TouchKeypad.new(model)
    local self = setmetatable({}, TouchKeypad)

    self.Model = model
    self.Prox = model:WaitForChild("ProximityPrompt")
    self.ScreenPart = model:WaitForChild("SCREEN")

    self.GUI = self.ScreenPart:WaitForChild("SCREENGUI")
    self.GuiOpen = self.GUI:WaitForChild("Door_Open")
    self.GuiClosed = self.GUI:WaitForChild("Door_Closed")
    self.GuiOpening = self.GUI:WaitForChild("Door_Opening")
    self.GuiClosing = self.GUI:WaitForChild("Door_Closing")
    self.GuiError = self.GUI:WaitForChild("Error")
    self.GuiLocked = self.GUI:WaitForChild("Locked")

	self.SurfaceAppearance = model:FindFirstChildOfClass("SurfaceAppearance")

	self.Door = model:FindFirstChildOfClass("ProximityPrompt").object.Value

    return self
end

function TouchKeypad:HideImages()
	for _, image in ipairs(self.GUI:GetDescendants()) do
		if image:IsA("ImageLabel") then
			image.Visible = false
		end
	end
end

function TouchKeypad:__init()
	if self.Door:GetAttribute("IsLocked") == true then
		print("DOOR")
		self:SetLocked()
	else
		self:SetClosed()
	end
end

function TouchKeypad:SetOpen()
	self:HideImages()
	self.GuiOpen.Visible = true
	self.Prox.Enabled = false
	self.SurfaceAppearance.EmissiveTint = Color3.new(0, 17, 255)
end

function TouchKeypad:SetClosed()
	self:HideImages()
	self.GuiClosed.Visible = true
	self.Prox.Enabled = true
	self.SurfaceAppearance.EmissiveTint = Color3.new(0, 17, 255)
end

function TouchKeypad:SetOpening()
	self:HideImages()
	self.GuiOpening.Visible = true
	self.Prox.Enabled = false
	self.SurfaceAppearance.EmissiveTint = Color3.new(255, 30, 0)
end

function TouchKeypad:SetClosing()
	self:HideImages()
	self.GuiClosing.Visible = true
	self.Prox.Enabled = false
	self.SurfaceAppearance.EmissiveTint = Color3.new(255, 30, 0)
end

function TouchKeypad:SetError()
	for _, image in ipairs(self.GUI:GetDescendants()) do
		self:HideImages()
		self.GuiError.Visible = true
		self.Prox.Enabled = false
		self.SurfaceAppearance.EmissiveTint = Color3.new(255,0, 0)
	end
end

return TouchKeypad