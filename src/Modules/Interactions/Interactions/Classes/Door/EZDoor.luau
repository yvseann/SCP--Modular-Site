local EZDoor = {}

EZDoor.__index = EZDoor

function EZDoor.new(model)
    local self = setmetatable({}, EZDoor)

    self.Model = model
    self.IsOpen = false
    self.RankRequired = model:GetAttribute("RankRequired") or 0
    self.IsLocked = model:GetAttribute("IsLocked") or false
    return self
end

function EZDoor:Open()
    print("This door should open")
end

function EZDoor:Close()

end

return EZDoor