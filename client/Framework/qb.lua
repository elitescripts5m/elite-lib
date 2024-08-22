QBCore = exports["qb-core"]:GetCoreObject()
local module = {}

module.getName = function ()
    local charinfo = QBCore.Functions.GetPlayerData().charinfo
    if not charinfo then
        return {
            fullName = "",
            firstName = "",
            lastName = ""
        }
    end
    return {
        fullName = charinfo.firstname .. " " .. charinfo.lastname,
        firstName = charinfo.firstname,
        lastName = charinfo.lastname
    }
end

module.getJob = function()
    local job = QBCore.Functions.GetPlayerData().job
    if not job then
        return {
            name = "",
            label = "",
            grade = 0,
            grade_label = ""
        }
    end
    return {
        name = job.name,
        label = job.label,
        grade = job.grade.level,
        grade_label = job.grade.name
    }
end

module.TriggerServerCallback = function(name, cb, ...)
    QBCore.Functions.TriggerCallback(name, cb, ...)
end

module.getSex = function()
    local ped = Elite.cache.ped
    local pedModel = GetEntityModel(ped)
    local charinfo = QBCore.Functions.GetPlayerData().charinfo
    local sex
    if pedModel == `mp_m_freemode_01` or pedModel == `mp_f_freemode_01` then
        sex = (charinfo.gender == 1 and "male" or "female") or "male"
    else
        sex = IsPedMale(ped) and "male" or "female"
    end

    return sex
end

return module