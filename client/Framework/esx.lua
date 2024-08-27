ESX = exports["es_extended"]:getSharedObject()
local module = {}

module.getName = function()
    local playerdata = ESX.GetPlayerData()
    if not playerdata?.firstName then
        return {
            fullName = "",
            firstName = "",
            lastName = ""
        }
    end
    return {
        fullName = playerdata.firstName .. " " .. playerdata.lastName,
        firstName = playerdata.firstName,
        lastName = playerdata.lastName
    }
end

module.getJob = function()
    local playerdata = ESX.GetPlayerData()
    if not playerdata?.job then
        return {
            name = "",
            label = "",
            grade = 0,
            grade_label = ""
        }
    end
    return {
        name = playerdata.job.name,
        label = playerdata.job.label,
        grade = playerdata.job.grade,
        grade_label = playerdata.job.grade_label
    }
end

module.triggerServerCallback = function(name, cb, ...)
    ESX.TriggerServerCallback(name, cb, ...)
end

module.getSex = function()
    local ped = PlayerPedId()
    local pedModel = GetEntityModel(ped)
    local playerdata = ESX.GetPlayerData()
    local sex
    if pedModel == `mp_m_freemode_01` or pedModel == `mp_f_freemode_01` then
        sex = playerdata?.sex and (playerdata.sex == "m" and "male" or "female") or "male"
    else
        sex = IsPedMale(ped) and "male" or "female"
    end

    return sex
end

module.notify = function(message, type, time)
    ESX.ShowNotification(message, type, time)
end

return module