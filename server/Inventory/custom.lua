local module = {}

module.openInventory = function(playerId, inventoryType, inventoryData)
    if not CheckArgs(playerId, inventoryType, inventoryData) then return end
    return
end

module.addItem = function(inventoryName, item, count, metadata)
    if not CheckArgs(inventoryName, item, count) then return end
    return
end

module.removeItem = function(inventoryName, item, count, metadata, slot)
    if not CheckArgs(inventoryName, item, count) then return end
    return
end

module.canCarryItem = function(inventoryName, item, count, metadata)
    if not CheckArgs(inventoryName, item, count) then return end
    return
end

module.getItemCount = function(inventoryName, item, metadata)
    if not CheckArgs(inventoryName, item) then return end
    return
end

module.getItemsByName = function(inventoryName, itemName, metadata)
    if not CheckArgs(inventoryName, itemName) then return end
    return
end

module.getItemLabel = function(itemName)
    if not CheckArgs(itemName) then return end
    return
end

module.registerStash = function(stashName, stashLabel, stashSlots, stashMaxWeight, stashOwner, stashGroups)
    if not CheckArgs(stashName, stashLabel, stashSlots, stashMaxWeight) then return end
end

module.setDurability = function(inventoryName, itemSlot, durability)
    if not CheckArgs(inventoryName, itemSlot, durability) then return end
end

return module