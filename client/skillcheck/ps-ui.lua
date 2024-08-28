local module = {}

module.skillbar = function(difficulty, buttons)
    local circles = 0
    local time = 0
    if difficulty == "easy" then
        circles = 1
        time = 25
    elseif difficulty == "normal" then
        circles = 2
        time = 20
    elseif difficulty == "hard" then
        circles = 4
        time = 15
    end
    exports["ps-ui"]:Circle(function(success)
        return success
    end, circles, time)
end

return module