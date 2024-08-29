local module = {}

module.addEntityTarget = function(netIds, options)
    if not CheckArgs(netIds, options) then return end
end

module.addLocalEntityTarget = function(entity, options)
    if not CheckArgs(entity, options) then return end
end

module.addModelTarget = function(models, options)
    if not CheckArgs(models, options) then return end
end

module.addCircleZone = function(circledata)
    if not CheckArgs(circledata.coords, circledata.options) then return end
end

module.addBoxZone = function(boxdata)
    if not CheckArgs(boxdata.coords, boxdata.size, boxdata.options) then return end
end

return module