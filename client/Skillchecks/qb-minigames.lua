local module = {}

module.skillbar = function(difficulty, buttons)
    local registeredButtons = ""
    if buttons then
        for _, v in pairs(buttons) do
            registeredButtons = registeredButtons .. v
        end
    else
        registeredButtons = "e"
    end

    local success = exports["qb-minigames"]:Skillbar(difficulty or "medium", registeredButtons)
    return success
end

return module