local module = {}
module.state = false

function module.showProgress(data)
    if not CheckArgs(data) then return end
    local promise = promise.new()
    local disableControl = data.disableControl or {}

    exports["progressbar"]:Progress({
        name = data.name or "progress",
        duration = data.duration,
        label = data.label,
        useWhileDead = data.useWhileDead,
        canCancel = data.canCancel,
        controlDisables = {
            disableMovement = disableControl.move or false,
            disableCarMovement = disableControl.car or false,
            disableMouse = disableControl.mouse or false,
            disableCombat = disableControl.combat or false
        },
        animation = data.animation and {
            animDict = data.animation.dict,
            anim = data.animation.clip,
            flags = data.animation.flag
        } or {},
        prop = data.prop and {
            model = data.prop.model,
            bone = data.prop.bone,
            coords = data.prop.pos,
            rotation = data.prop.rot
        } or {},
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