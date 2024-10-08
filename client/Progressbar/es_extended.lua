local module = {}
ESX = exports["es_extended"]:getSharedObject()

function module.showProgress(data)
    if not CheckArgs(data) then return end
    local promise = promise.new()
    ESX.Progressbar(data.label, data.duration, {
        FreezePlayer = data.controlDisables and data.controlDisables.move,
        animation = data.animation and {
            type = "anim",
            lib = data.animation.clip,
            dict = data.animation.dict
        },
        onFinish = function()
            promise:resolve(true)
        end, onCancel = function()
            promise:resolve(false)
        end
    })

    local success = Citizen.Await(promise)
    return success
end

function module.cancelProgress()
    exports["esx_progressbar"]:CancelProgressbar()
end

function module.isProgressActive()
    --[[ NOT AVAILABLE ]]
    return false
end

return module