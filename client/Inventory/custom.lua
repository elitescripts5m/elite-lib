local module = {}

module.openInventory = function(inventoryType, inventoryData)
    if not CheckArgs(inventoryType, inventoryData) then return end
    return
end

module.getCurrentWeapon = function()
    return
end

module.getInventory = function()
    return
end

module.getItemCount = function(itemName, metadata)
    if not CheckArgs(itemName) then return end
    return
end

module.getItemLabel = function(itemName)
    return
end

return module