local module = {}

function module.showProgress(data)
    if not CheckArgs(data) then return end
    return true
end

function module.cancelProgress()

end

function module.isProgressActive()
    return false
end

return module