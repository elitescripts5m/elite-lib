local module = {}
module.state = false

function module.showProgress(data)
    local promise = promise.new()
    local disableControl = data.disableControl or {}

    exports["progressbar"]:Progress({
        name = "progress",
        duration = data.duration,
        label = data.label,
        useWhileDead = data.useWhileDead,
        canCancel = data.canCancel,
        controlDisables = {
            disableMovement = disableControl.move ~= false,
            disableCarMovement = disableControl.car ~= false,
            disableMouse = disableControl.mouse ~= false,
            disableCombat = disableControl.combat ~= false
        },
        animation = data.animation and {
            animDict = data.animation.dict,
            anim = data.animation.clip,
            flags = data.animation.flag
        },
        prop = data.prop and {
            model = data.prop.model,
            bone = data.prop.bone,
            coords = data.prop.pos,
            rotation = data.prop.rot
        },
    }, function(cancelled)
        promise:resolve(not cancelled)
    end)
    local success = Citizen.Await(promise)

    return success
end

function module.cancelProgress()
    TriggerEvent("progressbar:client:cancel")
end

function module.isProgressActive()
    return module.state
end

RegisterNetEvent("progressbar:setstatus", function (state)
    module.state = state
end)

return module