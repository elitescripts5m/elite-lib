local oxtarget = exports.ox_target
local data = {}

data.addEntityTarget = function(netIds, options)
    if not CheckArgs(netIds, options) then return end
    oxtarget:addEntity(netIds, options)
end

data.addCircleZone = function(circledata)
    if not CheckArgs(circledata.coords, circledata.options) then return end
    oxtarget:addSphereZone(circledata)
end

data.addBoxZone = function(boxdata)
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

return data