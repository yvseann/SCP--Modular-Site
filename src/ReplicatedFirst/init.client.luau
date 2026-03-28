--!strict
-- Services and stuff
local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- remove default loading screen and guis
ReplicatedFirst:RemoveDefaultLoadingScreen()
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

-- Setup GUI
local loadingGUI = ReplicatedFirst:WaitForChild("IntroSequence"):Clone() :: ScreenGui
loadingGUI.Parent = player.PlayerGui

-- Loading container stuff
local loadingContainer = loadingGUI:WaitForChild("LoadingContainer") :: Frame

-- loading bar
local loadingbar = loadingContainer:WaitForChild("1_LoadingBar") :: Frame
local loadingBarProgress = loadingbar:WaitForChild("Bar") :: Frame

-- text stuff
local barObject = loadingbar:WaitForChild("BarObject") :: Frame
local Status = barObject:WaitForChild("Status") :: TextLabel
local StatusShadow = barObject:WaitForChild("StatusShadow") :: TextLabel
local RobloxError = loadingContainer:WaitForChild("2_RobloxError") :: Frame

-- throbber

local throbber = loadingGUI:WaitForChild("SavingLoadingIcon")

-- skip text

local skipText = loadingGUI:WaitForChild("SkipText"):WaitForChild("Text") :: TextLabel
local skipTextShadow = loadingGUI:WaitForChild("SkipText"):WaitForChild("TextShadow") :: TextLabel

-- Intro UI stuff

local introContainer = loadingGUI:WaitForChild("IntroContainer") :: Frame

task.wait(5)

local function postLoad()
	local invisTextGoal = {}
	invisTextGoal.TextTransparency = 1

	local invisImageGoal = {}
	invisImageGoal.ImageTransparency = 1

	local tweenInfo = TweenInfo.new(
		1, -- time
		Enum.EasingStyle.Cubic, -- easing style
		Enum.EasingDirection.In, -- easing direction
		0, -- repeat count
		false, -- reverses
		0 -- delay time
	)

	-- add spaces to these. It is important that
	-- there IS spaces. They must be SPACED. they
	-- prefer being SPACED and they look better like that.
	-- well no they look better COMPACT but my
	-- linter dislikes it and fixes it automatically
	-- but i want it to be consistent because like what if
	-- someone doesnt use the same linter so just
	-- make it spaced out please? okay thanks.
	local loadTween = TweenService:Create(loadingContainer, tweenInfo, { Position = UDim2.fromScale(1.5, 0.5) })
	local introTween = TweenService:Create(introContainer, tweenInfo, { Position = UDim2.fromScale(0.5, 0.5) })
	local skipTween = TweenService:Create(skipText, tweenInfo, invisTextGoal)
	local skipTweenShadow = TweenService:Create(skipTextShadow, tweenInfo, invisTextGoal)
	local throbberTween = TweenService:Create(throbber, tweenInfo, invisImageGoal)

	introTween:Play()
	loadTween:Play()
	skipTween:Play()
	skipTweenShadow:Play()
	throbberTween:Play()

	introTween.Completed:Wait()
	local lastTween

	task.wait(5)
	-- stuff i need
	local shared = ReplicatedStorage.Shared
	local objectHelper = require(shared.Helpers.objectHelper)
	local camera = game.Workspace.CurrentCamera :: Camera
	local camPart = objectHelper:getTagged("cineCam")
	
	-- setup the camera
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = camPart[1].CFrame
	
	for _, instance in ipairs(loadingGUI:GetDescendants()) do
		if instance:IsA("Frame") then
			local fadeOut = TweenService:Create(instance, tweenInfo, { BackgroundTransparency = 1 })
			fadeOut:Play()
			lastTween = fadeOut
		elseif instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
			local fadeOut = TweenService:Create(instance, tweenInfo, { ImageTransparency = 1 })
			local fadeOut2 = TweenService:Create(instance, tweenInfo, { BackgroundTransparency = 1 })
			fadeOut:Play()
			fadeOut2:play()
			lastTween = fadeOut

		elseif instance:IsA("TextLabel") or instance:IsA("TextButton") then
			local fadeOut = TweenService:Create(instance, tweenInfo, { TextTransparency = 1 })
			fadeOut:Play()
			lastTween = fadeOut
		end
	end

	if lastTween then
		lastTween.Completed:Wait()
	end

	loadingGUI:Destroy()

end

postLoad()
