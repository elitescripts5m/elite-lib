local oxtarget = exports.ox_target
local module = {}

module.addEntityTarget = function(netIds, options)
    if not CheckArgs(netIds, options) then return end
    oxtarget:addEntity(netIds, options)
end

module.addLocalEntityTarget = function(entity, options)
    if not CheckArgs(entity, options) then return end
    oxtarget:addLocalEntity(entity, options)
end

module.addCircleZone = function(circledata)
    if not CheckArgs(circledata.coords, circledata.options) then return end
    oxtarget:addSphereZone(circledata)
end

module.addBoxZone = function(boxdata)
    if not CheckArgs(boxdata.coords, boxdata.size, boxdata.options) then return end
    oxtarget:addBoxZone({
        coords = boxdata.coords,
        size = boxdata.size,
        options = boxdata.options,
        debugPoly = boxdata.debugPoly,
        heading = boxdata.heading,
        minZ = boxdata.minZ,
        maxZ = boxdata.maxZ
    })
end

return module