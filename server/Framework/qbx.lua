local module = {}
local qbox = exports.qbx_core

--[[
    We are trying to add all functionality to qbox. But we are still waiting for some functions that does not yet exist in qbox, that exists in other frameworks.
    Feel free to update this file with their updated functions and exports as soon as they arrive. Thanks for your patience.
]]

QBCore = exports["qb-core"]:GetCoreObject() -- This has to go!

local function validatePlayer(player)
    if not player or not player.PlayerData or not player.PlayerData.source then
        local funcInfo = debug.getinfo(2, "nSl")
        local funcName = funcInfo.name or "unknown function"
        DebugPrint(("Framework player is not valid in function '%s'"):format(funcName), "error")
        return false
    end
    return true
end

module.getPlayerFromId = function(playerId)
    if not CheckArgs(playerId) then return end
    local player = qbox:GetPlayer(playerId)
    return player
end

module.getPlayerFromIdentifier = function(playerIdentifier)
    if not CheckArgs(playerIdentifier) then return end
    local player = qbox:GetPlayerByCitizenId(playerIdentifier)
    return player
end

module.getIdentifier = function(frPlayer)
    if not CheckArgs(frPlayer) or not validatePlayer(frPlayer) then return end
    local identifier = frPlayer.PlayerData.citizenid
    return identifier
end

module.registerServerCallback = function(name, callback)
    if not CheckArgs(name, callback) then return end
    return QBCore.Functions.CreateCallback(name, callback)
end

module.getSource = function(frPlayer)
    if not CheckArgs(frPlayer) or not validatePlayer(frPlayer) then return end
    return frPlayer.PlayerData.source
end

module.getName = function(frPlayer)
    if not CheckArgs(frPlayer) or not validatePlayer(frPlayer) then return end
    local response = {
        fullName = frPlayer.PlayerData.charinfo.firstname .. " " .. frPlayer.PlayerData.charinfo.lastname,
        firstName = frPlayer.PlayerData.charinfo.firstname,
        lastName = frPlayer.PlayerData.charinfo.lastname
    }

    return response
end

module.getJob = function(frPlayer)
    if not CheckArgs(frPlayer) or not validatePlayer(frPlayer) then return end
    local job = frPlayer.PlayerData.job
    local response = {
        name = job.name,
        label = job.label,
        grade = job.grade.level,
        grade_label = job.grade.name,
    }

    return response
end

module.getAllPlayers = function()
    return qbox:GetQBPlayers()
end

module.setJob = function(frPlayer, job, grade)
    if not CheckArgs(frPlayer, job, grade) or not validatePlayer(frPlayer) then return end
    frPlayer.Functions.SetJob(job, grade)
end

module.doesJobExist = function(job, grade)
    if not CheckArgs(job, grade) then return end
    local jobs = qbox:GetJobs()
    return jobs[job] and jobs[job].grades[tonumber(grade)] ~= nil
end

module.getCoords = function(frPlayer)
    if not CheckArgs(frPlayer) or not validatePlayer(frPlayer) then return end
    local ped = GetPlayerPed(frPlayer.PlayerData.source)
    if not ped or ped == -1 then return end
    local coords = GetEntityCoords(ped)
    return vec3(coords.x, coords.y, coords.z)
end

module.getJobs = function()
    local jobs = qbox:GetJobs()
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

        response[#response + 1] = jobInfo
    end

    return response
end

module.getMetadata = function(playerId, index)
    if not CheckArgs(playerId, index) then return end
    local player = qbox:GetPlayer(playerId)
    if not player then return nil end
    return player.Functions.GetMetaData(index) or nil
end

module.setMetadata = function(playerId, index, value)
    if not CheckArgs(playerId, index, value) then return end
    local player = qbox:GetPlayer(playerId)
    if player then
        player.Functions.SetMetaData(index, value)
        return true
    end
    return false
end

module.notify = function(playerId, message, type, time)
    if not CheckArgs(playerId, message) then return end
    TriggerClientEvent("QBCore:Notify", playerId, message, type or nil, time or nil)
end

module.createUsableItem = function(itemName, func)
    if not CheckArgs(itemName, func) then return end
    qbox:CreateUseableItem(itemName, func)
end

return module