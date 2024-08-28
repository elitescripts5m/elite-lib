local module = {}

module.showInput = function(data)
    if not CheckArgs(data) then return end
    local result = {}
    ESX.UI.Menu.Open("dialog", GetCurrentResourceName(), data.id, {
        title = data.title
    }, function(input)
        result[1] = input.value
    end, function()
        result = nil
    end)

    return result
end

return module