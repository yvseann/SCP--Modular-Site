local Helicopter = {}

local CS = game:GetService("CollectionService")
local TS = game:GetService("TweenService")

local function TweenVel(Motor, EndV, time)
	local prop = { MaxVelocity = EndV }
	local info = TweenInfo.new(time, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	return TS:Create(Motor, info, prop)
end

function Helicopter.startPropeller(startTime)
	local HeliObject = CS:GetTagged("Helicopter")
    local tween

	for _, heli in HeliObject do
		local object = heli:GetDescendants()

		for _, objectPart in object do
			if objectPart:IsA("Motor6D") then
				tween = TweenVel(objectPart, 0.2, startTime)
                tween:Play()
			end
		end
	end
    return tween
end

function Helicopter.stopPropeller(stopTime)
	local HeliObject = CS:GetTagged("Helicopter")
    local tween

	for _, heli in HeliObject do
		local object = heli:GetDescendants()

		for _, objectPart in object do
			if objectPart:IsA("Motor6D") then
                tween = TweenVel(objectPart, 0, stopTime)
                tween:Play()
			end
		end
	end
    return tween
end

function Helicopter.flyToTarget(speed, waitTime, startTime)
    task.wait(5)
    local tween = Helicopter.startPropeller(startTime)
    tween.Completed:Wait()
    task.wait(waitTime)

	local HeliObject = CS:GetTagged("Helicopter")

	for _, heli: Model in HeliObject do
		local target = heli:FindFirstChild("Target")
		if not target.Value then
			warn("Modules/Nuke/Evacuation/Helicopter.luau || Target not found in helicopter!")
			return
		end

		local cframeValue = Instance.new("CFrameValue")
		cframeValue.Value = heli:GetPivot()

		local tweenInfo = TweenInfo.new(speed)
		local tween = TS:Create(cframeValue, tweenInfo, {
			Value = CFrame.new(target.Value.Position),
		})
		cframeValue.Changed:Connect(function()
			heli:PivotTo(cframeValue.Value)
		end)
		tween:Play()
	end
end

function Helicopter.land(speed, waitTime, stopTime)
	local HeliObject = CS:GetTagged("Helicopter")

	for _, heli: Model in HeliObject do
		local inital = heli:FindFirstChild("Inital")
		if not inital.Value then
			warn("Modules/Nuke/Evacuation/Helicopter.luau || Inital not found in helicopter!")
			return
		end

		local cframeValue = Instance.new("CFrameValue")
		cframeValue.Value = heli:GetPivot()

		local tweenInfo = TweenInfo.new(speed)
		local tween = TS:Create(cframeValue, tweenInfo, {
			Value = CFrame.new(inital.Value.Position),
		})
		cframeValue.Changed:Connect(function()
			heli:PivotTo(cframeValue.Value)
		end)
		tween:Play()
        tween.Completed:Wait()
        task.wait(waitTime)
        Helicopter.stopPropeller(stopTime)
	end
end

return Helicopter
