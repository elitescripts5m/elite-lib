local module = {}

local function validatePlayer(player)
    if not player then
        local funcInfo = debug.getinfo(2, "nSl")
        local funcName = funcInfo.name or "unknown function"
        DebugPrint(("Framework player is not valid in function '%s'"):format(funcName), "error")
        return false
    end
    return true
end

module.getPlayerFromId = function(playerId)
    if not CheckArgs(playerId) then return end
    return
end

module.getPlayerFromIdentifier = function(playerIdentifier)
    if not CheckArgs(playerIdentifier) then return end
    return
end

module.getIdentifier = function(frPlayer)
    if not CheckArgs(frPlayer) or not validatePlayer(frPlayer) then return end
    return
end

module.RegisterServerCallback = function(name, callback)
    if not CheckArgs(name, callback) then return end
    return
end

module.getSource = function(frPlayer)
    if not CheckArgs(frPlayer) or not validatePlayer(frPlayer) then return end
    return
end

module.getName = function(frPlayer)
    if not CheckArgs(frPlayer) or not validatePlayer(frPlayer) then return end
    -- local table = {
    --     fullName = "",
    --     firstName = "",
    --     lastName = ""
    -- }

    return
end

module.getJob = function(frPlayer)
    if not CheckArgs(frPlayer) or not validatePlayer(frPlayer) then return end
    -- local table = {
    --     name = "",
    --     label = "",
    --     grade = 0,
    --     grade_name = "",
    --     grade_label = "",
    -- }

    return
end

module.getAllPlayers = function()
    return
end

module.setJob = function(frPlayer, job, grade)
    if not CheckArgs(frPlayer, job, grade) or not validatePlayer(frPlayer) then return end
end

module.doesJobExist = function(job, grade)
    if not CheckArgs(job, grade) then return end
    return
end

module.getCoords = function(frPlayer)
    if not CheckArgs(frPlayer) or not validatePlayer(frPlayer) then return end
    local coords = vec3(0, 0, 0)
    return coords
end

module.getJobs = function()
    -- local table = {
    --     {
    --         name = "",
    --         label = "",
    --         grades = {
    --             {
    --                 grade = 0,
    --                 name = "",
    --                 label = ""
    --             }
    --         }
    --     }
    -- }

    return
end

module.getMetadata = function(playerId, index)
    if not CheckArgs(playerId, index) then return end
    return
end

module.setMetadata = function(playerId, index, value)
    if not CheckArgs(playerId, index, value) then return end
    return
end

module.notify = function(playerId, message, type, time)
    if not CheckArgs(playerId, message) then return end
end

module.createUsableItem = function(itemName, func)
    if not CheckArgs(itemName, func) then return end
end

return module