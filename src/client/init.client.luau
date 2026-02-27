local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")

local Cmdr = require(Shared.Parent.CmdrClient)

Cmdr:SetActivationKeys({ Enum.KeyCode.F2 })
