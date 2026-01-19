local CameraShared = {}
--==VARIABLES==--
--SERVICES--
local RunService = game:GetService("RunService")

--==FUNCTIONS==--

local function isValid(instance)
	return instance and instance.Parent ~= nil
end

--==MAIN==--

local RADIUS = 50

function CameraShared.testCamera(cameraModel, player)
	-- VALIDATION
	if not (cameraModel and cameraModel:IsA("Model")) then
		warn("Cameras.testCamera: invalid camera model")
		return
	end

	if not (player and player:IsA("Player")) then
		warn("Cameras.testCamera: invalid player")
		return
	end

	local camBase = cameraModel:FindFirstChild("Camera")
	local movePart = camBase and camBase:FindFirstChild("MovePart")
	local glass = movePart and movePart:FindFirstChild("Glass")

	if not glass or not glass:IsA("BasePart") then
		warn("Cameras.testCamera: missing MovePart.Glass")
		return
	end

	-- CLEANUP ANY EXISTING TEST GUI FOR THIS PLAYER
	local guiName = "CameraTestGui"
	local existing = player.PlayerGui:FindFirstChild(guiName)
	if existing then
		existing:Destroy()
	end

	-- GUI + VIEWPORT SETUP
	local camGui = Instance.new("SurfaceGui")
	camGui.Name = guiName
	camGui.Parent = player.PlayerGui
	camGui.Adornee = game.Workspace:WaitForChild("TEST_FRAME"):WaitForChild("monitor"):WaitForChild("Screen")
	camGui.AlwaysOnTop = false
	camGui.LightInfluence = 1

	local viewport = Instance.new("ViewportFrame")
	viewport.Name = "CameraViewport"
	viewport.Size = UDim2.fromScale(1, 1)
	viewport.BackgroundTransparency = 1
	viewport.CurrentCamera = nil -- we set it below
	viewport.Parent = camGui
	viewport.Ambient = Color3.fromRGB(80, 80, 80)

	-- WorldModel is REQUIRED for proper 3D rendering
	local worldModel = Instance.new("WorldModel")
	worldModel.Name = "CameraWorld"
	worldModel.Parent = viewport

	-- Viewport camera
	local vpCam = Instance.new("Camera")
	vpCam.Name = "ViewportCamera"
	vpCam.Parent = worldModel
	viewport.CurrentCamera = vpCam

	-- MAP REAL INSTANCES -> CLONES
	local cloneMap = {}

	-- Utility: create or get a clone of a BasePart (world or character)
	local function getOrCreateClone(realPart)
		if not realPart:IsA("BasePart") then
			return nil
		end

		local existingClone = cloneMap[realPart]
		if existingClone and isValid(existingClone) then
			return existingClone
		end

		local clone = Instance.new(realPart.ClassName)
		clone.Name = realPart.Name
		clone.Anchored = true
		clone.CanCollide = false
		clone.CanQuery = false
		clone.CanTouch = false
		clone.CastShadow = realPart.CastShadow
		clone.Material = realPart.Material
		clone.Color = realPart.Color
		clone.Transparency = realPart.Transparency
		clone.Reflectance = realPart.Reflectance
		clone.Size = realPart.Size

		-- Copy mesh if there is one
		local mesh = realPart:FindFirstChildOfClass("SpecialMesh")
		if mesh then
			local meshClone = mesh:Clone()
			meshClone.Parent = clone
		end

		clone.Parent = worldModel
		cloneMap[realPart] = clone
		return clone
	end

	-- INITIAL COLLECTION OF NEARBY PARTS USING SPATIAL QUERY
	local function gatherNearbyParts()
		local origin = glass.Position
		local overlapParams = OverlapParams.new()
		overlapParams.FilterType = Enum.RaycastFilterType.Exclude
		overlapParams.FilterDescendantsInstances = { worldModel } -- never hit clones

		-- This returns only BaseParts
		local nearbyParts = game.Workspace:GetPartBoundsInRadius(origin, RADIUS, overlapParams)

		for _, part in ipairs(nearbyParts) do
			-- Ignore parts inside the viewport world itself or other non-render things if you want
			if part:IsDescendantOf(worldModel) then
				continue
			end

			-- You can add more filtering here (e.g. ignore tools, projectiles, etc.)
			getOrCreateClone(part)
		end
	end

	gatherNearbyParts()

	-- LIVE UPDATE LOOP (RENDERSTEPPED) WITH CLEANUP CONTROL
	local alive = true
	local connection

	local function cleanup()
		if not alive then
			return
		end
		alive = false

		if connection then
			connection:Disconnect()
			connection = nil
		end

		for real, clone in pairs(cloneMap) do
			if clone and clone.Parent then
				clone:Destroy()
			end
			cloneMap[real] = nil
		end

		if camGui and camGui.Parent then
			camGui:Destroy()
		end
	end

	-- Auto-cleanup when player leaves
	player.AncestryChanged:Connect(function(_, parent)
		if not parent then
			cleanup()
		end
	end)

	-- Main per-frame update
	connection = RunService.RenderStepped:Connect(function()
		if not alive then
			return
		end

		-- If camera or glass is gone, stop
		if not isValid(glass) or not isValid(cameraModel) or not isValid(player) then
			cleanup()
			return
		end

		-- Update viewport camera to match real camera glass
		local cf = glass.CFrame
		vpCam.CFrame = CFrame.new(cf.Position, cf.Position + cf.LookVector)

		-- Optionally: re-gather nearby parts every N frames (lightweight refresh)
		-- You can add a frame counter + modulus to do this occasionally.
		-- For now, we rely on the initial set + sync of existing ones.

		-- Sync all clones
		for realPart, clonePart in pairs(cloneMap) do
			if not isValid(realPart) then
				if clonePart and clonePart.Parent then
					clonePart:Destroy()
				end
				cloneMap[realPart] = nil
			else
				-- Only BaseParts are in cloneMap
				if clonePart and clonePart.Parent then
					clonePart.CFrame = realPart.CFrame
					clonePart.Size = realPart.Size
					clonePart.Color = realPart.Color
					clonePart.Material = realPart.Material
					clonePart.Transparency = realPart.Transparency
					clonePart.Reflectance = realPart.Reflectance
					clonePart.CastShadow = realPart.CastShadow
				end
			end
		end
	end)

	-- Return a handle so you can manually stop this camera test if needed
	return {
		Stop = cleanup,
	}
end

return CameraShared
