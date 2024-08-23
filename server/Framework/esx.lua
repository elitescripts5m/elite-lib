local module = {}
ESX = exports["es_extended"]:getSharedObject()

local function validatePlayer(player)
    if not player or not player.source then
        local funcInfo = debug.getinfo(2, "nSl")
        local funcName = funcInfo.name or "unknown function"
        DebugPrint(("Framework player is not valid in function '%s'"):format(funcName), "error")
        return false
    end
    return true
end

module.getPlayerFromId = function(playerId)
    if not CheckArgs(playerId) then return end
    local player = ESX.GetPlayerFromId(tonumber(playerId))
    return player
end

module.getPlayerFromIdentifier = function(playerIdentifier)
    if not CheckArgs(playerIdentifier) then return end
    local player = ESX.GetPlayerFromIdentifier(playerIdentifier)
    return player
end

module.getIdentifier = function(frPlayer)
    if not CheckArgs(frPlayer) or not validatePlayer(frPlayer) then return end
    local identifier = frPlayer.getIdentifier()
    return identifier
end

module.RegisterServerCallback = function(name, callback)
    if not CheckArgs(name, callback) then return end
    return ESX.RegisterServerCallback(name, callback)
end

module.getSource = function(frPlayer)
    if not CheckArgs(frPlayer) or not validatePlayer(frPlayer) then return end
    local frsource = frPlayer.source
    return frsource
end

module.getName = function(frPlayer)
    if not CheckArgs(frPlayer) or not validatePlayer(frPlayer) then return end
    local response = {
        fullName = frPlayer.getName(),
        firstName = frPlayer.get("firstName"),
        lastName = frPlayer.get("lastName")
    }

    return response
end

module.getJob = function(frPlayer)
    if not CheckArgs(frPlayer) or not validatePlayer(frPlayer) then return end
    local job = frPlayer.getJob()
    local response = {
        name = job.name,
        label = job.label,
        grade = job.grade,
        grade_name = job.grade_name,
        grade_label = job.grade_label,
    }

    return response
end

module.getAllPlayers = function()
    return ESX.GetExtendedPlayers()
end

module.setJob = function(frPlayer, job, grade)
    if not CheckArgs(frPlayer, job, grade) or not validatePlayer(frPlayer) then return end
    frPlayer.setJob(job, grade)
end

module.doesJobExist = function(job, grade)
    if not CheckArgs(job, grade) then return end
    return ESX.DoesJobExist(job, grade)
end

module.getCoords = function(frPlayer)
    if not CheckArgs(frPlayer) or not validatePlayer(frPlayer) then return end
    local ped = GetPlayerPed(frPlayer.source)
    if not ped or ped == -1 then return end
    local coords = GetEntityCoords(ped)
    return vec3(coords.x, coords.y, coords.z)
end

module.getJobs = function()
    local jobs = ESX.GetJobs()
    local response = {}

    for jobname, jobdata in pairs(jobs) do
        local jobInfo = {
            name = jobname,
            label = jobdata.label,
            grades = {}
        }

        for grade, gradeData in pairs(jobdata.grades) do
            jobInfo.grades[tonumber(grade)] = {
                grade = tonumber(grade),
                name = gradeData.name,
                label = gradeData.label
            }
        end

        table.insert(response, jobInfo)
    end

    return response
end

module.getMetadata = function(playerId, index)
    if not CheckArgs(playerId, index) then return end
    local player = ESX.GetPlayerFromId(tonumber(playerId))
    if not player then return nil end
    return player.getMeta(index) or nil
end

module.setMetadata = function(playerId, index, value)
    if not CheckArgs(playerId, index, value) then return end
    local player = ESX.GetPlayerFromId(tonumber(playerId))
    if player then
        player.setMeta(index, value)
        return true
    end
    return false
end

module.notify = function(playerId, message, type, time)
    -- "type" & "time" is not used by ESX by default. Feel free to add them if you are planning to use any other notification resource which includes them.
    if not CheckArgs(playerId, message) then return end
    local player = ESX.GetPlayerFromId(tonumber(playerId))
    player.showNotification(message)
end

return module