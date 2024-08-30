local module = {}

module.skillbar = function(difficulty, buttons)
    local success = exports.ox_lib:skillCheck(difficulty or "medium", buttons or {"e"})
    return success
end

return module