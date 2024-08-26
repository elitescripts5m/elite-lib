local module = {}
local inventory = exports.ox_inventory

module.openInventory = function(playerId, inventoryType, inventoryData)
    if not CheckArgs(playerId, inventoryType, inventoryData) then return end
    return inventory:forceOpenInventory(playerId, inventoryType, inventoryData)
end

module.addItem = function(inventoryName, item, count, metadata)
    if not CheckArgs(inventoryName, item, count) then return end
    local success = inventory:AddItem(inventoryName, item, count)
    return success
end

module.removeItem = function(inventoryName, item, count, metadata, slot)
    if not CheckArgs(inventoryName, item, count) then return end
    local success = inventory:RemoveItem(inventoryName, item, count, slot, metadata)
    return success
end

module.canCarryItem = function(inventoryName, item, count, metadata)
    if not CheckArgs(inventoryName, item, count) then return end
    return inventory:CanCarryItem(inventoryName, item, count, metadata)
end

module.getItemCount = function(inventoryName, item, metadata)
    if not CheckArgs(inventoryName, item) then return end
    return inventory:GetItemCount(inventoryName, item, metadata)
end

module.getItemsByName = function(inventoryName, itemName, metadata)
    if not CheckArgs(inventoryName, itemName) then return end
    return inventory:Search(inventoryName, "slots", itemName, metadata)
end

module.getItemLabel = function(itemName)
    if not CheckArgs(itemName) then return end
    return inventory:Items(itemName).label
end

module.registerStash = function(stashName, stashLabel, stashSlots, stashMaxWeight, stashOwner, stashGroups)
    if not CheckArgs(stashName, stashLabel, stashSlots, stashMaxWeight) then return end
    inventory:RegisterStash(stashName, stashLabel, stashSlots, stashMaxWeight, stashOwner, stashGroups)
end

module.setDurability = function(inventoryName, itemSlot, durability)
    if not CheckArgs(inventoryName, itemSlot, durability) then return end
    inventory:SetDurability(inventoryName, itemSlot, durability)
end

return module