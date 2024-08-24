local module = {}

module.getUserData = function(args, additionalColumns, callback)
    if not CheckArgs(args, callback) then return end
    return callback(nil)
end

module.getVehicleData = function(args, additionalColumns, callback)
    if not CheckArgs(args, callback) then return end
    return callback({})
end

return module