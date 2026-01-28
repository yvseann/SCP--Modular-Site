local Door = {}

local CS = game:GetService("CollectionService")
Door.BSTAGGED = CS:GetTagged("BlastDoor")

local blastDoor = require(script.Parent.Doors.BlastDoor)

function Door.init()

    for _, BSDOOR in Door.BSTAGGED do
        local Touch = BSDOOR:FindFirstChild("Touch")
        if not Touch then
            warn("NO TOUCH FOUND IN BlastDoor. Modules.Door.luau") 
            return
        end

        local CD = Touch:FindFirstChild("ClickDetector")
        if not CD then
			warn("NO TOUCH FOUND IN BlastDoor. Modules.Door.luau")
            return
        end

        CD.MouseClick:Connect(function()
			blastDoor.open(BSDOOR)
        end)
    end
end


return Door