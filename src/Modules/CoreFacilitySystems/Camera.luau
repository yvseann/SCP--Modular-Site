local Cameras = {}
--==VARIABLES==--
--SERVICES--
local collectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")

--CAMERATAGS--
Cameras.ezCam = collectionService:GetTagged("EZ_CAM")
Cameras.hczCam = collectionService:GetTagged("HCZ_CAM")
Cameras.lczCam = collectionService:GetTagged("LCZ_CAM")

--==FUNCTIONS==--

local function toggleAttachments(light)
	local attachment = light:FindFirstChildOfClass("Attachment")
	if attachment then
		local targets = { "Core", "Main Core" }
		for _, name in ipairs(targets) do
			local child = attachment:FindFirstChild(name)
			if child then
				child.Enabled = not child.Enabled
			end
		end
	end
end

local function oscillateCamera(camera)
	local camModel = camera:FindFirstChild("Camera")
	local movePartModel = camModel and camModel:FindFirstChild("MovePart")
	if not movePartModel or not movePartModel.PrimaryPart then
		return
	end
	local primary = movePartModel.PrimaryPart
	local baseCFrame = primary.CFrame
	local leftRotation = baseCFrame * CFrame.Angles(0, math.rad(-45), 0)
	local rightRotation = baseCFrame * CFrame.Angles(0, math.rad(45), 0)
	local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	-- proxy object to tween
	local proxy = Instance.new("CFrameValue")
	proxy.Value = baseCFrame
	-- update model each frame
	proxy:GetPropertyChangedSignal("Value"):Connect(function()
		movePartModel:SetPrimaryPartCFrame(proxy.Value)
	end)
	while task.wait() do
		-- rotate left
		local tweenLeft = TweenService:Create(proxy, tweenInfo, { Value = leftRotation })
		tweenLeft:Play()
		tweenLeft.Completed:Wait()
		task.wait(1.2) -- pause
		-- rotate right
		local tweenRight = TweenService:Create(proxy, tweenInfo, { Value = rightRotation })
		tweenRight:Play()
		tweenRight.Completed:Wait()
		task.wait(1.2) -- pause
	end
end

--==MAIN==--

local function setupCameraLoop(camera)
	task.spawn(function()
		local camModel = camera:FindFirstChild("Camera")
		local movePartModel = camModel and camModel:FindFirstChild("MovePart")
		if not movePartModel then
			warn("Modules/CoreFacilitySystems/Camera.luau || CAMERA MOVEPART NOT FOUND! " .. camera.Name)
			return
		end

		local light = movePartModel:FindFirstChild("Light")
		if not light then
			warn("Modules/CoreFacilitySystems/Camera.luau || CAMERA LIGHT NOT FOUND! " .. camera.Name)
			return
		end

		while task.wait(1.5) do
			toggleAttachments(light)
		end
	end)

	-- start oscillation
	task.spawn(function()
		oscillateCamera(camera)
	end)
end

local RADIUS = 50
function Cameras.testCamera(camera, player)
	-- GUI SETUP
	local camFrame = Instance.new("SurfaceGui")
	camFrame.Parent = player.PlayerGui
	camFrame.Adornee = workspace.TEST_FRAME.monitor.Screen
	camFrame.AlwaysOnTop = true
	camFrame.AlwaysOnTop = false

	local viewport = Instance.new("ViewportFrame")
	viewport.Size = UDim2.fromScale(1, 1)
	viewport.BackgroundTransparency = 1
	viewport.Parent = camFrame

	viewport.Ambient = Color3.fromRGB(80,80,80)
	viewport.ZIndex = 5

	local vpCam = Instance.new("Camera")
	vpCam.Parent = viewport
	viewport.CurrentCamera = vpCam

	-- REAL CAMERA PARTS
	local camModel = camera:FindFirstChild("Camera")
	local movePart = camModel and camModel:FindFirstChild("MovePart")
	local glass = movePart and movePart:FindFirstChild("Glass")

	if not glass then
		warn("Modules/CoreFacilitySystems/Camera.luau || TEST_CAM missing MovePart.Glass")
		return
	end

	-- FIND WORLD PARTS NEAR CAMERA
	local worldParts = {}
	for _, part in ipairs(workspace:GetDescendants()) do
		if part:IsA("BasePart") then
			if (part.Position - glass.Position).Magnitude <= RADIUS then
				table.insert(worldParts, part)
			end
		end
	end

	-- CLONE THEM INTO VIEWPORT
	local clones = {}
	for _, part in ipairs(worldParts) do
		local clone = part:Clone()
		clone.Parent = viewport
		clones[part] = clone
	end

	-- LIVE UPDATE LOOP
	task.spawn(function()
		while task.wait() do

			-- Update camera position
			local cf = glass.CFrame
			vpCam.CFrame = CFrame.new(cf.Position, cf.Position + cf.LookVector)

			-- Sync world clones
			for real, clone in pairs(clones) do
				if real.Parent then
					clone.CFrame = real.CFrame
					clone.Size = real.Size
					if clone:IsA("BasePart") then
						clone.Color = real.Color
						clone.Material = real.Material
						clone.Transparency = real.Transparency
						clone.Reflectance = real.Reflectance
					end
				end
			end
		end
	end)
end

for _, camera in pairs(Cameras.ezCam) do
	setupCameraLoop(camera)
end

for _, camera in pairs(Cameras.hczCam) do
	setupCameraLoop(camera)
end

for _, camera in pairs(Cameras.lczCam) do
	setupCameraLoop(camera)
end

return Cameras