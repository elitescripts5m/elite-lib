local module = {}
local playerColumns = nil
local vehicleColumns = nil

module.getUserData = function(args, additionalColumns, callback)
    if not CheckArgs(args, callback) then return end
    if playerColumns == nil then
        MySQL.Async.fetchAll("SHOW COLUMNS FROM players", {}, function(columnsResult)
            playerColumns = {}
            for _, column in ipairs(columnsResult) do
                playerColumns[column.Field] = true
            end
            if not playerColumns then
                playerColumns = false
            end
        end)
    end
    if not playerColumns then
        return callback(nil)
    end

    local baseColumns = { "citizenid", "charinfo", "job" }
    local validColumns = {}
    local params = {}
    local conditions = {}

    for _, col in ipairs(baseColumns) do
        validColumns[#validColumns + 1] = col
    end

    if additionalColumns then
        for key, value in pairs(additionalColumns) do
            if type(value) == "table" then
                validColumns[#validColumns + 1] = key
            elseif type(value) == "string" and value:find(" as ") then
                local col, alias = value:match("^(.-) as (.+)$")
                validColumns[#validColumns + 1] = col
            else
                validColumns[#validColumns + 1] = value
            end
        end
    end

    local foundColumns = {}
    for _, col in ipairs(validColumns) do
        if playerColumns and playerColumns[col:gsub("`", "")] then
            foundColumns[#foundColumns + 1] = col
        end
    end

    local useOr = args.useOr
    args.useOr = nil

    for k, v in pairs(args) do
        local columnName = k == "identifier" and "citizenid" or k
        if v:find("%%") then
            conditions[#conditions + 1] = columnName .. " LIKE @" .. k
        else
            conditions[#conditions + 1] = columnName .. " = @" .. k
        end
        params["@" .. k] = v
    end
    local query = "SELECT " .. table.concat(foundColumns, ", ") .. " FROM players WHERE " .. table.concat(conditions, useOr and " OR " or " AND ")
    MySQL.Async.fetchAll(query, params, function(result)
        if result and #result > 0 then
            local row = result[1]
            local userData = {
                citizenid = row.citizenid,
                identifier = row.citizenid
            }

            local charInfo = json.decode(row.charinfo)
            userData.firstname = charInfo.firstname
            userData.lastname = charInfo.lastname
            userData.dob = charInfo.birthdate
            userData.sex = charInfo.gender == 0 and "male" or "female"

            for key, value in pairs(additionalColumns or {}) do
                if type(value) == "table" then
                    local jsonData = json.decode(row[key])
                    if jsonData then
                        for _, subfield in ipairs(value) do
                            if type(subfield) == "string" and subfield:find(" as ") then
                                local subcol, alias = subfield:match("^(.-) as (.+)$")
                                userData[alias] = jsonData[subcol]
                            else
                                userData[subfield] = jsonData[subfield]
                            end
                        end
                    end
                elseif type(value) == "string" and value:find(" as ") then
                    local col, alias = value:match("^(.-) as (.+)$")
                    if row[col] then
                        userData[alias] = row[col]
                    end
                else
                    if row[value] then
                        userData[value] = row[value]
                    end
                end
            end

            callback(userData)
        else
            callback(nil)
        end
    end)
end

module.getVehicleData = function(args, additionalColumns, callback)
    if not CheckArgs(args, callback) then return end
    if vehicleColumns == nil then
        MySQL.Async.fetchAll("SHOW COLUMNS FROM player_vehicles", {}, function(columnsResult)
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

    local baseColumns = { "citizenid", "plate", "hash", "state" }
    local validColumns = {}
    local params = {}
    local conditions = {}

    for _, col in ipairs(baseColumns) do
        validColumns[#validColumns + 1] = col
    end

    if additionalColumns then
        for key, value in pairs(additionalColumns) do
            if type(value) == "table" then
                validColumns[#validColumns + 1] = key
            elseif type(value) == "string" and value:find(" as ") then
                local col, alias = value:match("^(.-) as (.+)$")
                validColumns[#validColumns + 1] = col
            else
                validColumns[#validColumns + 1] = value
            end
        end
    end

    local foundColumns = {}
    for _, col in ipairs(validColumns) do
        if vehicleColumns and vehicleColumns[col:gsub("`", "")] then
            foundColumns[#foundColumns + 1] = col
        end
    end

    for k, v in pairs(args) do
        if k == "owner" then
            conditions[#conditions + 1] = "citizenid = @" .. k
        else
            conditions[#conditions + 1] = k .. " = @" .. k
        end
        params["@" .. k] = v
    end

    local query = "SELECT " .. table.concat(foundColumns, ", ") .. " FROM player_vehicles WHERE " .. table.concat(conditions, " AND ")
    MySQL.Async.fetchAll(query, params, function(result)
        if #result > 0 then
            local vehicles = {}
            local remaining = #result

            for _, vehicle in ipairs(result) do
                local ownerIdentifier = vehicle.citizenid
                module.getUserData({ identifier = ownerIdentifier }, additionalColumns, function(userData)
                    local vehicleData = {
                        owner = userData and {
                            identifier = ownerIdentifier,
                            name = userData.firstname .. " " .. userData.lastname,
                            dob = userData.dob,
                            sex = userData.sex
                        } or nil,
                        plate = vehicle.plate,
                        hash = vehicle.hash,
                        stored = vehicle.state
                    }

                    for key, value in pairs(additionalColumns or {}) do
                        if type(value) == "table" then
                            local jsonData = json.decode(vehicle[key])
                            if jsonData then
                                for _, subfield in ipairs(value) do
                                    if type(subfield) == "string" and subfield:find(" as ") then
                                        local subcol, alias = subfield:match("^(.-) as (.+)$")
                                        vehicleData[alias] = jsonData[subcol]
                                    else
                                        vehicleData[subfield] = jsonData[subfield]
                                    end
                                end
                            end
                        elseif type(value) == "string" and value:find(" as ") then
                            local col, alias = value:match("^(.-) as (.+)$")
                            if vehicle[col] then
                                vehicleData[alias] = vehicle[col]
                            end
                        else
                            if vehicle[value] then
                                vehicleData[value] = vehicle[value]
                            end
                        end
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