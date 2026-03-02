local validWarheads = {
    alpha = true,
    omega = true,
}

local warheadType = {
    Transform = function(text)
        if type(text) ~= "string" then
            return nil
        end
        return text:lower()
    end,

    Validate = function(value)
        if not value or not validWarheads[value] then
            return false, "Warhead must be 'alpha' or 'omega'."
        end
        return true
    end;

    Parse = function(value)
        return value
    end;

    Autocomplete = function(text)
        local results = {}
        local lower = text:lower()

        for option in pairs(validWarheads) do
            if option:sub(1, #lower) == lower then
                table.insert(results, option)
            end
        end

        return results
    end;
}

return function(registry)
    registry:RegisterType("warhead", warheadType)
end
