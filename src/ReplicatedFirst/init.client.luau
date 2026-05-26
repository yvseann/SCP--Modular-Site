--!strict
-- Services and stuff
local player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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

local throbber = loadingGUI:WaitForChild("SavingLoadingIcon") :: ImageLabel

-- skip text

local skipText = loadingGUI:WaitForChild("SkipText"):WaitForChild("Text") :: TextLabel
local skipTextShadow = loadingGUI:WaitForChild("SkipText"):WaitForChild("TextShadow") :: TextLabel

-- Intro UI stuff

local introContainer = loadingGUI:WaitForChild("IntroContainer") :: Frame

-- postload stuff
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
	for _, instance in ipairs(loadingGUI:GetDescendants()) do
		if instance:IsA("Frame") then
			local fadeOut = TweenService:Create(instance, tweenInfo, { BackgroundTransparency = 1 })
			fadeOut:Play()
			lastTween = fadeOut
		elseif instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
			local fadeOut = TweenService:Create(instance, tweenInfo, { ImageTransparency = 1 })
			local fadeOut2 = TweenService:Create(instance, tweenInfo, { BackgroundTransparency = 1 })
			fadeOut:Play()
			fadeOut2:Play()
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

	local Packages = game:GetService("ReplicatedStorage").RojoBeingAnnoying

	local Hologram = require(Packages.Hologram) :: any
	Hologram.InitialiseGlobally(true, true)
	Hologram:SetAlwaysOnTop(true)
	Hologram:SetDisabledSides({"Left", "Right", "Bottom", "Back", "Top"})
end

local function transition(skipped, connection)
	if not skipped then
		connection:Disconnect()

		task.wait(2)

		postLoad()
	end
end

-- loading stuff

repeat
	task.wait()
until game:IsLoaded()

local function addAsset(list, name, id)
	table.insert(list, {
		Name = name,
		Id = id,
	})
end

local function checkIfValid(instance, list)
	if instance:IsA("MeshPart") then
		if instance.MeshId ~= "" then
			addAsset(list, instance.Name, instance.MeshId)
		end
		if instance.TextureID ~= "" then
			addAsset(list, instance.Name, instance.TextureID)
		end
	elseif instance:IsA("SpecialMesh") then
		if instance.MeshId ~= "" then
			addAsset(list, instance.Name, instance.MeshId)
		end
		if instance.TextureId ~= "" then
			addAsset(list, instance.Name, instance.TextureId)
		end
	elseif instance:IsA("Decal") or instance:IsA("Texture") then
		if instance.Texture ~= "" then
			addAsset(list, instance.Name, instance.Texture)
		end
	elseif instance:IsA("SurfaceAppearance") then
		for _, map in ipairs({ "ColorMap", "MetalnessMap", "NormalMap", "RoughnessMap" }) do
			local id = instance[map]
			if id and id ~= "" then
				addAsset(list, instance.Name .. "_" .. map, id)
			end
		end
	elseif instance:IsA("Sound") then
		if instance.SoundId ~= "" then
			addAsset(list, instance.Name, instance.SoundId)
		end
	elseif instance:IsA("Animation") then
		if instance.AnimationId ~= "" then
			addAsset(list, instance.Name, instance.AnimationId)
		end
	elseif instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
		if instance.Image ~= "" then
			addAsset(list, instance.Name, instance.Image)
		end
	end
end

local assetsToLoad = {}

for _, inst in ipairs(game.Workspace:GetDescendants()) do
	checkIfValid(inst, assetsToLoad)
end

for _, inst in ipairs(StarterGui:GetDescendants()) do
	checkIfValid(inst, assetsToLoad)
end

for _, inst in ipairs(ReplicatedStorage:GetDescendants()) do
	checkIfValid(inst, assetsToLoad)
end

local ids = {}
for _, asset in ipairs(assetsToLoad) do
	table.insert(ids, asset.Id)
end

local loaded = 0
local total = #assetsToLoad

local loadingTimeout = 20
local timedOut = false

task.spawn(function()
	task.wait(loadingTimeout)
	if not timedOut then
		RobloxError.Visible = true
		timedOut = true
	end
end)

local connection
task.spawn(function()
	connection = RunService.RenderStepped:Connect(function(dt)
		throbber.Rotation += 180 * dt
	end)
end)

local skipped

local UISConnection
UISConnection = UserInputService.InputBegan:Connect(function()
	local keyDown = UserInputService:IsKeyDown(Enum.KeyCode.Space)
	if keyDown then
		skipped = true
		Status.Text = "Skipped."
		transition(skipped, connection)
		UISConnection:Disconnect()
	end
end)

ContentProvider:PreloadAsync(ids, function()
	loaded += 1

	local asset = assetsToLoad[loaded]

	Status.Text = "Loading " .. asset.Name .. " (" .. loaded .. "/" .. total .. ")"
	StatusShadow.Text = Status.Text

	loadingBarProgress.Size = UDim2.fromScale(loaded / total, 1)
	--task.wait(0.05) -- removed to let the player in the game as soon as possible
end)


task.wait(5)

-- Loading finished!
Status.Text = "Finished."
StatusShadow.Text = "Finished."
transition(skipped, connection)
