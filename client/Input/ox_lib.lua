local module = {}

module.showInput = function(data)
    if not CheckArgs(data) then return end
    local inputs = {}
    for _, v in ipairs(data.inputs) do
        if v.type == "number" or v.type == "input" then
            inputs[#inputs + 1] = {
                type = v.type,
                label = v.label,
                default = v.default or nil
            }
        elseif v.type == "checkbox" then
            inputs[#inputs + 1] = {
                type = "checkbox",
                label = v.label,
                default = v.default or false
            }
        elseif v.type == "select" then
            local options = {}
            for _, option in ipairs(v.options) do
                inputs[#inputs + 1] = {
                    value = option.value,
                    label = option.label
                }
            end
            inputs[#inputs + 1] = {
                type = "select",
                label = v.label,
                options = options
            }
        elseif v.type == "slider" then
            inputs[#inputs + 1] = {
                type = "slider",
                label = v.label,
                min = v.min or 1,
                max = v.max or 100,
                default = v.default or 1
            }
        end
    end

    return exports.ox_lib:inputDialog(data.title, inputs)
end

return module