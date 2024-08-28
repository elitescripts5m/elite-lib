local module = {}

module.showInput = function(data)
    if not CheckArgs(data) then return end
    local inputs = {}
    for _, v in ipairs(data.inputs) do
        inputs[#inputs + 1] = {
            text = v.text,
            name = v.name,
            type = v.type,
            isRequired = v.required or false,
            options = v.options or nil
        }
    end

    local input = exports["qb-input"]:ShowInput({
        header = data.title,
        submitText = data.submit or "Submit",
        inputs = inputs
    })

    local result = {}
    for k, v in pairs(input) do
        result[tonumber(k)] = v
    end

    return result
end

return module