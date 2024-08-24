local module = {}

module.addEntityTarget = function(netIds, options)
    if not CheckArgs(netIds, options) then return end
end

module.addCircleZone = function(circledata)
    if not CheckArgs(circledata.coords, circledata.options) then return end
end

module.addBoxZone = function(boxdata)
    if not CheckArgs(boxdata.coords, boxdata.size, boxdata.options) then return end
end

return module