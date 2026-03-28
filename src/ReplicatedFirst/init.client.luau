-- Services and stuff
local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterGui = game:GetService("StarterGui")

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

local introContainer = loadingGUI:WaitForChild("IntroContainer")

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

	-- do NOT add spaces to these. It is important that
	-- there is NO spaces. They must be COMPACT. they
	-- prefer being compact and they look better like that.
	local loadTween = TweenService:Create(loadingContainer, tweenInfo,{ UDim2.fromScale(1.5, 0.5) })
	local introTween = TweenService:Create(introContainer, tweenInfo,{ UDim2.fromScale(0.5, 0.5) })
	local skipTween = TweenService:Create(skipText, tweenInfo, invisTextGoal)
	local skipTweenShadow = TweenService:Create(skipTextShadow, tweenInfo, invisTextGoal)
	local throbberTween = TweenService:Create(throbber, tweenInfo, invisImageGoal)

	introTween:Play()
	loadTween:Play()
	skipTween:Play()
	skipTweenShadow:Play()
	throbberTween:Play()

	introTween.Completed:Wait()

	task.wait(2)
	for _, instance in ipairs(loadingGUI:GetDescendants()) do
		if instance:IsA("Frame") or instance:IsA("TextButton") or instance:IsA("TextLabel") then
			local fadeOut = TweenService:Create(instance, tweenInfo,{ BackgroundTransparency = 1 })
			fadeOut:Play()
		elseif instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
			local fadeOut = TweenService:Create(instance, tweenInfo,{ ImageTransparency = 1 })
			fadeOut:Play()
		elseif instance:IsA("TextLabel") or instance:IsA("TextButton") then
			local fadeOut = TweenService:Create(instance, tweenInfo,{ TextTransparency= 1 })
			fadeOut:Play()
        else
            warn("Instance is not valid GUI element with transparency!")
		end
	end

	loadingGUI:Destroy()
end

postLoad()
