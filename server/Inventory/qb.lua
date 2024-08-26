local module = {}
local QBCore = exports["qb-core"]:GetCoreObject()

module.openInventory = function(playerId, inventoryType, inventoryData)
    --[[ NOT AVAILABLE ]]
    print("The function for 'openInventory' does not exist in qb-core. Use either qb-inventory, ox_inventory or any other option in elite-lib.")
    return false
end

module.addItem = function(inventoryName, item, count, metadata)
    if not CheckArgs(inventoryName, item, count) then return end
    local Player = QBCore.Functions.GetPlayer(inventoryName)
    if Player then
        if item == "money" then
            Player.Functions.AddMoney("cash", count)
            return true
        else
            return Player.Functions.AddItem(item, count, false, metadata)
        end
    end
    return false
end

module.removeItem = function(inventoryName, item, count, metadata, slot)
    if not CheckArgs(inventoryName, item, count) then return end
    if metadata then
        print("qb-core does not support metadata with their native functions. Please, change your inventory settings to 'qb-inventory' or something else that supports metadata.")
        return false
    end
    local Player = QBCore.Functions.GetPlayer(inventoryName)
    if Player then
        if item == "money" then
            Player.Functions.RemoveMoney("cash", count)
            return true
        else
            return Player.Functions.RemoveItem(item, count)
        end
    end
    return false
end

module.canCarryItem = function(inventoryName, item, count, metadata)
    if metadata then
        print("qb-core does not support metadata with their native functions. Please, change your inventory settings to 'qb-inventory' or something else that supports metadata.")
        return false
    end
    if GetResourceState("qb-inventory") == "missing" then
        return true
    else
        if item == "money" then
            return true
        else
            local canCarry, reason = exports["qb-inventory"]:CanAddItem(inventoryName, item, count)
            return canCarry
        end
    end
end

module.getItemCount = function(inventoryName, item, metadata)
    if not CheckArgs(inventoryName, item) then return end
    if metadata then
        print("qb-core does not support metadata with their native functions. Please, change your inventory settings to 'qb-inventory' or something else that supports metadata.")
        return false
    end
    local Player = QBCore.Functions.GetPlayer(inventoryName)
    if Player then
        if item == "money" then
            return Player.Functions.GetMoney("cash")
        else
            return Player.Functions.GetItemByName(item) and Player.Functions.GetItemByName(item).amount or 0
        end
    end
    return 0
end

module.getItemsByName = function(inventoryName, itemName, metadata)
    if not CheckArgs(inventoryName, itemName) then return end
    return nil
end

module.getItemLabel = function(itemName)
    if not CheckArgs(itemName) then return end
    return QBCore.Shared.Items[itemName].label
end

module.registerStash = function(stashName, stashLabel, stashSlots, stashMaxWeight, stashOwner, stashGroups)
    --[[ NOT AVAILABLE ]]
    print("The function for 'registerStash' does not exist in qb-core. Use either qb-inventory, ox_inventory or any other option in elite-lib.")
    return false
end

module.setDurability = function(inventoryName, itemSlot, durability)
    if not CheckArgs(inventoryName, itemSlot, durability) then return end
    local Player = QBCore.Functions.GetPlayer(inventoryName)
    if Player then
        local item = Player.Functions.GetItemBySlot(itemSlot)
        if item then
            item.info.durability = durability
            Player.Functions.SetInventory(Player.PlayerData.items)
            return true
        end
    end
    return false
end

return module