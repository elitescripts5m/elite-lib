local data = {}

local inventory = exports.ox_inventory

data.openInventory = function(playerId, inventoryType, inventoryData)
    if not CheckArgs(playerId, inventoryType, inventoryData) then return end
    return inventory:forceOpenInventory(playerId, inventoryType, inventoryData)
end

data.addItem = function(inventoryName, item, count, metadata)
    if not CheckArgs(inventoryName, item, count) then return end
    local success = inventory:AddItem(inventoryName, item, count)
    return success
end

data.removeItem = function(inventoryName, item, count, metadata)
    if not CheckArgs(inventoryName, item, count) then return end
    local success = inventory:RemoveItem(inventoryName, item, count)
    return success
end

data.canCarryItem = function(inventoryName, item, count, metadata)
    if not CheckArgs(inventoryName, item, count) then return end
    return inventory:CanCarryItem(inventoryName, item, count, metadata)
end

data.getItemCount = function(inventoryName, item, metadata)
    if not CheckArgs(inventoryName, item) then return end
    return inventory:GetItemCount(inventoryName, item, metadata)
end

data.registerStash = function(stashName, stashLabel, stashSlots, stashMaxWeight, stashOwner, stashGroups)
    if not CheckArgs(stashName, stashLabel, stashSlots, stashMaxWeight) then return end
    inventory:RegisterStash(stashName, stashLabel, stashSlots, stashMaxWeight, stashOwner, stashGroups)
end

data.setDurability = function(inventoryName, itemSlot, durability)
    if not CheckArgs(inventoryName, itemSlot, durability) then return end
    inventory:SetDurability(inventoryName, itemSlot, durability)
end

return data