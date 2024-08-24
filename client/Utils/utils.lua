local module = {}
local peds = {}
local blips = {}

module.loadModel = function(model)
    if not CheckArgs(model) then return end
	if not IsModelValid(model) then return end
    if not HasModelLoaded(model) then
        local time = 500
        while not HasModelLoaded(model) and time > 0 do time -= 1 RequestModel(model) Wait(0) end
    end
end

module.unloadModel = function(model)
    if not CheckArgs(model) then return end
    SetModelAsNoLongerNeeded(model)
end

module.loadAnimDict = function(animDict)
    if not CheckArgs(animDict) then return end
    if not DoesAnimDictExist(animDict) then return end
    while not HasAnimDictLoaded(animDict) do RequestAnimDict(animDict) Wait(5) end
end

module.unloadAnimDict = function(animDict)
    if not CheckArgs(animDict) then return end
    RemoveAnimDict(animDict)
end

module.playAnim = function(animDict, animName, duration, flag, ped)
    if not CheckArgs(animDict, animName) then return end
	module.loadAnimDict(animDict)
	TaskPlayAnim(ped and ped or PlayerPedId(), animDict, animName, 8.0, -8.0, duration or 30000, flag or 50, 1, false, false, false)
end

module.stopAnim = function(animDict, animName, ped)
    if not CheckArgs(animDict, animName) then return end
	StopAnimTask(ped or PlayerPedId(), animDict, animName, 0.5)
	module.unloadAnimDict(animDict)
end

module.spawnVehicle = function(model, coords)
    if not CheckArgs(model, coords) then return end
	module.loadModel(model)
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, false)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(vehicle), true)
	Wait(100)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, "OFF")
    SetVehicleFuelLevel(vehicle, 100.0)
	SetVehicleModKit(vehicle, 0)
	SetVehicleOnGroundProperly(vehicle)
	module.unloadModel(model)
    return vehicle
end

module.spawnPed = function(model, coords, freeze, collision, scenario, anim, synced)
    if not CheckArgs(model, coords) then return end
	module.loadModel(model)
	local ped = CreatePed(0, model, coords.x, coords.y, coords.z - 1, coords.w, synced and synced or false, false)
	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, freeze and freeze or true)
    if collision then SetEntityNoCollisionEntity(ped, PlayerPedId(), false) end
    if scenario then TaskStartScenarioInPlace(ped, scenario, 0, true) end
    if anim then
        module.loadAnimDict(anim[1])
        TaskPlayAnim(ped, anim[1], anim[2], 0.5, 1.0, -1, 1, 0.2, false, false, false)
    end
    module.unloadModel(model)
	peds[#peds + 1] = ped
    return ped
end

module.createBlip = function(data)
    if not CheckArgs(data) then return end
    local blip
    if data.entity then
        blip = AddBlipForEntity(data.entity)
    elseif data.coords then
        blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
    else
        return nil
    end
    SetBlipAsShortRange(blip, true)
    SetBlipSprite(blip, data.sprite or 106)
    SetBlipColour(blip, data.colour or 5)
    SetBlipScale(blip, data.scale or 0.7)
    SetBlipDisplay(blip, data.display or 6)
    if data.category then SetBlipCategory(blip, data.category) end
    if data.label then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(tostring(data.label))
        EndTextCommandSetBlipName(blip)
    end
    return blip
end

AddEventHandler("onResourceStop", function(resource) -- Not sure if this is working correctly. Has to be looked at.
    if resource ~= GetCurrentResourceName() then return end
	for i = 1, #peds do
        DeletePed(peds[i])
    end
    for i = 1, #blips do
        RemoveBlip(blips[i])
    end
end)

return module