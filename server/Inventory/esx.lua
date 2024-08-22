local module = {}
ESX = exports["es_extended"]:getSharedObject()

module.openInventory = function(playerId, inventoryType, inventoryData)
    --[[ NOT AVAILABLE ]]
    return false
end

module.addItem = function(inventoryName, item, count, metadata)
    if not CheckArgs(inventoryName, item, count) then return end
    local xPlayer = ESX.GetPlayerFromId(inventoryName)
    if xPlayer then
        if item == "money" then
            xPlayer.addMoney(count)
            return true
        else
            xPlayer.addInventoryItem(item, count)
            return true
        end
    end
    return false
end

module.removeItem = function(inventoryName, item, count, metadata)
    if not CheckArgs(inventoryName, item, count) then return end
    local xPlayer = ESX.GetPlayerFromId(inventoryName)
    if xPlayer then
        if item == "money" then
            xPlayer.removeMoney(count)
            return true
        else
            xPlayer.removeInventoryItem(item, count)
            return true
        end
    end
    return false
end

module.canCarryItem = function(inventoryName, item, count, metadata)
    --[[ NOT AVAILABLE ]]
    return true
end

module.getItemCount = function(inventoryName, item, metadata)
    if not CheckArgs(inventoryName, item) then return end
    local xPlayer = ESX.GetPlayerFromId(inventoryName)
    if xPlayer then
        if item == "money" then
            return xPlayer.getMoney()
        else
            local inventoryItem = xPlayer.getInventoryItem(item)
            return inventoryItem and inventoryItem.count or 0
        end
    end
    return 0
end

module.registerStash = function(stashName, stashLabel, stashSlots, stashMaxWeight, stashOwner, stashGroups)
    return false
end

module.setDurability = function(inventoryName, itemSlot, durability)
    if not CheckArgs(inventoryName, itemSlot, durability) then return end
    local xPlayer = ESX.GetPlayerFromId(inventoryName)
    if xPlayer then
        local item = xPlayer.getInventoryItem(itemSlot)
        if item then
            item.info.durability = durability
            xPlayer.setInventoryItem(item.name, item.count, item.info)
            return true
        end
    end
    return false
end

return module