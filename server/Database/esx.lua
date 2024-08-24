local module = {}
local userColumns = nil
local vehicleColumns = nil

module.getUserData = function(args, additionalColumns, callback)
    if not CheckArgs(args, callback) then return end
    if userColumns == nil then
        MySQL.Async.fetchAll("SHOW COLUMNS FROM users", {}, function(columnsResult)
            userColumns = {}
            for _, column in ipairs(columnsResult) do
                userColumns[column.Field] = true
            end
            if not userColumns then
                userColumns = false
            end
        end)
    end
    if not userColumns then
        return callback(nil)
    end

    local baseColumns = { "firstname", "lastname", "sex", "dob", "identifier" }
    local validColumns = {}
    local params = {}
    local conditions = {}

    for _, col in ipairs(baseColumns) do
        validColumns[#validColumns + 1] = col
    end

    if additionalColumns then
        for _, col in ipairs(additionalColumns) do
            validColumns[#validColumns + 1] = col
        end
    end

    local foundColumns = {}
    for _, col in ipairs(validColumns) do
        if userColumns and userColumns[col:gsub("`", "")] then
            foundColumns[#foundColumns + 1] = col
        end
    end

    local useOr = args.useOr
    args.useOr = nil

    for k, v in pairs(args) do
        local columnName = k
        if v:find("%%") then
            conditions[#conditions + 1] = columnName .. " LIKE @" .. k
        else
            conditions[#conditions + 1] = columnName .. " = @" .. k
        end
        params["@" .. k] = v
    end

    local query = "SELECT " .. table.concat(foundColumns, ", ") .. " FROM users WHERE " .. table.concat(conditions, useOr and " OR " or " AND ")
    MySQL.Async.fetchAll(query, params, function(result)
        if result and #result > 0 then
            local userData = {}
            for _, col in ipairs(foundColumns) do
                userData[col:gsub("`", "")] = result[1][col:gsub("`", "")]
            end
            userData.sex = result[1].sex == "m" and "male" or "female"
            callback(userData)
        else
            callback(nil)
        end
    end)
end

module.getVehicleData = function(args, additionalColumns, callback)
    if not CheckArgs(args, callback) then return end
    if vehicleColumns == nil then
        MySQL.Async.fetchAll("SHOW COLUMNS FROM owned_vehicles", {}, function(columnsResult)
            vehicleColumns = {}
            for _, column in ipairs(columnsResult) do
                vehicleColumns[column.Field] = true
            end
            if not vehicleColumns then
                vehicleColumns = false
                return callback({})
            end
        end)
    end
    if not vehicleColumns then
        return callback({})
    end

    local baseColumns = { "owner", "plate", "vehicle", "stored" }
    local validColumns = {}
    local params = {}
    local conditions = {}

    for _, col in ipairs(baseColumns) do
        validColumns[#validColumns + 1] = col
    end

    if additionalColumns then
        for _, col in ipairs(additionalColumns) do
            validColumns[#validColumns + 1] = col
        end
    end

    local foundColumns = {}
    for _, col in ipairs(validColumns) do
        if vehicleColumns and vehicleColumns[col:gsub("`", "")] then
            foundColumns[#foundColumns + 1] = col
        end
    end

    for k, v in pairs(args) do
        foundColumns[#foundColumns + 1] = k .. " = @" .. k
        params["@" .. k] = v
    end

    local query = "SELECT " .. table.concat(foundColumns, ", ") .. " FROM owned_vehicles WHERE " .. table.concat(conditions, " AND ")
    MySQL.Async.fetchAll(query, params, function(result)
        if #result > 0 then
            local vehicles = {}
            local remaining = #result

            for _, vehicle in ipairs(result) do
                local ownerIdentifier = vehicle.owner
                module.getUserData({ identifier = ownerIdentifier }, { "firstname", "lastname" }, function(userData)
                    local vehicleData = {
                        owner = userData and {
                            identifier = ownerIdentifier,
                            name = userData.firstname .. " " .. userData.lastname
                        } or nil,
                        plate = vehicle.plate,
                        hash = json.decode(vehicle.vehicle).model,
                        stored = vehicle.stored
                    }

                    for _, col in ipairs(additionalColumns or {}) do
                        vehicleData[col] = vehicle[col]
                    end
                    vehicles[#vehicles + 1] = vehicleData
                    remaining = remaining - 1
                    if remaining == 0 then
                        callback(vehicles)
                    end
                end)
            end
        else
            callback({})
        end
    end)
end

return module