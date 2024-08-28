local module = {}

function module.showProgress(data)
    if not CheckArgs(data) then return end
    return exports.ox_lib:progressBar({
        duration = data.duration,
        label = data.label,
        useWhileDead = data.useWhileDead,
        canCancel = data.canCancel,
        disable = data.disableControl,
        anim = data.animation,
        prop = {
            model = data.prop?.model,
            bone = data.prop?.bone,
            pos = data.prop?.pos,
            rot = data.prop?.rot
        }
    })
end

function module.cancelProgress()
    exports.ox_lib:cancelProgress()
end

function module.isProgressActive()
    return exports.ox_lib:progressActive()
end

return module