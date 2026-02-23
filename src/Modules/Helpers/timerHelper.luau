local RS = game:GetService("RunService")

local prefix = "Modules/Helpers/timerHelper.luau || "
local timerHelper = {}

local function formatTime(timeInSeconds)
	local minutes = math.floor(timeInSeconds / 60)
	local seconds = math.floor(timeInSeconds % 60)
	local milliseconds = math.floor((timeInSeconds % 1) * 1000)

	return string.format("%02d:%02d.%03d", minutes, seconds, milliseconds)
end

function timerHelper:msTimer(textLabel)
	if not textLabel or not textLabel:IsA("TextLabel") then
		warn(prefix .. "msTimer textLabel parameter does not exist or is not a TextLabel! Returning to prevent error.")
		return
	end

	local duration = 90
	local startTime = time()
	local endTime = startTime + duration

	local connection
	connection = RS.Heartbeat:Connect(function()
		local now = time()
		local timeLeft = endTime - now

		if timeLeft <= 0 then
			textLabel.Text = formatTime(0)
			connection:Disconnect()
			return
		end

		textLabel.Text = formatTime(timeLeft)
	end)
end

return timerHelper
