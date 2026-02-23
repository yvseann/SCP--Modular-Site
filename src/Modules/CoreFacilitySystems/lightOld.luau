local Light = {}

--==VARIABLES==--
--SERVICES--
local collectionService = game:GetService("CollectionService")

--SWITCHES--
local primarySwitch = collectionService:GetTagged("PrimarySwitch")
local secondarySwitch = collectionService:GetTagged("SecondarySwitch")
local alarmSwitch = collectionService:GetTagged("AlarmSwitch")

--LIGHTS--
local primaryLight = collectionService:GetTagged("PrimaryLight")
local secondaryLight = collectionService:GetTagged("SecondaryLight")

--VALUES--
local primaryLightOn = true
local secondaryLightOn = true
local alarmOn = false

--==FUNCTIONS==--

local function toggleNode(node, value)
	local targets = { "Core", "EVENT HORIZON 01", "Main Core", "Rays", "SurfaceLight" }
	for _, name in ipairs(targets) do
		local child = node:FindFirstChild(name)
		if child then
			if value == false then
				if child:IsA("ParticleEmitter") then
					child:Clear()
				end
			end
			child.Enabled = value
		end
	end
end

local function switchPrimary()
	for _, light in pairs(primaryLight) do
		local beam = light:FindFirstChild("Beam")
		local node = light:FindFirstChild("Node")

		if beam then
			beam.Enabled = primaryLightOn
		end
		if node then
			toggleNode(node, primaryLightOn)
		end
	end
end

local function switchSecondary()
	for _, light in pairs(secondaryLight) do
		local node = light:FindFirstChild("Node")
		if node then
			-- Normal case: toggle the node and its children
			toggleNode(node, secondaryLightOn)
		else
			-- Fallback: look for PointLight directly inside the light
			local pointLight = light:FindFirstChildWhichIsA("PointLight")
			if pointLight then
				pointLight.Enabled = secondaryLightOn

				if secondaryLightOn == true then
					light.Material = Enum.Material.Neon
				else
					light.Material = Enum.Material.SmoothPlastic
				end
			end
		end
	end
end

local function driveLever(lever, isOn)
	if not lever or not lever:IsA("MeshPart") then
		return
	end

	local remoteModel = lever:FindFirstAncestor("Remote")
	if not remoteModel then
		warn("Remote not found for lever:", lever.Name)
		return
	end

	local remote = remoteModel:FindFirstChild("Remote")
	if not remote then
		warn("Remote not found for lever:", lever.Name)
		return
	end

	local hinge = remote:FindFirstChild("Toggle")
	if not hinge or not hinge:IsA("HingeConstraint") then
		warn("HingeConstraint not found")
		return
	end

	local targetAngle = isOn and 0 or 179

	hinge.MotorMaxTorque = 100000
	hinge.TargetAngle = targetAngle
end

--==LIGHT SWITCHES==--
local primarySwitchDebounce = false
local secondarySwitchDebounce = false

-- Primary
for _, switch in pairs(primarySwitch) do
	driveLever(switch, primaryLightOn)
	local clickDetector = switch.Parent.Touch:FindFirstChild("ClickDetector")
	if clickDetector then
		clickDetector.MouseClick:Connect(function()
			if not primarySwitchDebounce then
				primarySwitchDebounce = true

				local sound = switch:FindFirstChild("Sound")
				if sound then
					sound:Play()
				end

				primaryLightOn = not primaryLightOn
				driveLever(switch, primaryLightOn)

				task.spawn(switchPrimary)

				task.delay(3, function()
					primarySwitchDebounce = false
				end)
			end
		end)
	end
end

-- Secondary
for _, switch in pairs(secondarySwitch) do
	driveLever(switch, secondaryLightOn)
	local clickDetector = switch.Parent.Touch:FindFirstChild("ClickDetector")
	if clickDetector then
		clickDetector.MouseClick:Connect(function()
			if not secondarySwitchDebounce then
				secondarySwitchDebounce = true

				local sound = switch:FindFirstChild("Sound")
				if sound then
					sound:Play()
				end

				secondaryLightOn = not secondaryLightOn
				driveLever(switch, secondaryLightOn)

				task.spawn(switchSecondary)

				task.delay(3, function()
					secondarySwitchDebounce = false
				end)
			end
		end)
	end
end

-- Alarm stub
for _, switch in pairs(alarmSwitch) do
	print("Alarm Switch found, named: " .. switch.Name)
	driveLever(switch, alarmOn)
end

--==DEVELOPER LIGHTS==--
local devswitch = collectionService:GetTagged("devswitch")
local devswitchon = true
local devlight = collectionService:GetTagged("devlight")
local devSwitchDebounce = false

local function switchdev()
	for _, light in pairs(devlight) do
		local node = light:FindFirstChild("Node")
		if node then
			toggleNode(node, devswitchon)
		end
	end
end

for _, switch in pairs(devswitch) do
	driveLever(switch, devswitchon)
	local clickDetector = switch.Parent.Touch:FindFirstChild("ClickDetector")
	if clickDetector then
		clickDetector.MouseClick:Connect(function()
			if not devSwitchDebounce then
				devSwitchDebounce = true

				local sound = switch:FindFirstChild("Sound")
				if sound then
					sound:Play()
				end

				devswitchon = not devswitchon
				driveLever(switch, devswitchon)

				task.spawn(switchdev)

				task.delay(1, function()
					devSwitchDebounce = false
				end)
			end
		end)
	end
end

return Light
