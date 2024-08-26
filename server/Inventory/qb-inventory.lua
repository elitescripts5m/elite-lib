local module = {}
local QBCore = exports["qb-core"]:GetCoreObject()
local inventory = exports["qb-inventory"]

module.openInventory = function(playerId, inventoryType, inventoryData)
    if not CheckArgs(playerId, inventoryType, inventoryData) then return end
    return inventory:OpenInventory(playerId, inventoryType, inventoryData)
end

module.addItem = function(inventoryName, item, count, slot, metadata)
    if not CheckArgs(inventoryName, item, count) then return end
    if item == "money" then
        local Player = QBCore.Functions.GetPlayer(inventoryName)
        if Player then
            Player.Functions.AddMoney("cash", count)
            return true
        end
    else
        local success = inventory:AddItem(inventoryName, item, count, slot, metadata, "elite-lib")
        return success
    end
end

local function isValidMetadata(itemInfo, metadata)
    for index, value in pairs(metadata) do
        if not (itemInfo[index] and itemInfo[index] == value) then
            return false
        end
    end
    return true
end

local function removeItemWithMetadata(Player, inventoryName, item, count, metadata)
    local items = Player.Functions.GetItemsByName(item)
    if not items then return false end

    local cachedSlots = {}
    local removeCount = count
    local success = false

    for _, v in pairs(items) do
        if isValidMetadata(v.info, metadata) then
            local removeAmount = math.min(v.amount, removeCount)
            cachedSlots[#cachedSlots + 1] = { slot = v.slot, count = removeAmount }
            removeCount = removeCount - removeAmount
            if removeCount <= 0 then
                for _, slotItem in pairs(cachedSlots) do
                    if inventory:RemoveItem(inventoryName, item, slotItem.count, slotItem.slot, "elite-lib") then
                        TriggerClientEvent("inventory:client:ItemBox", inventoryName, QBCore.Shared.Items[item], "remove", 1)
                    end
                end
                success = true
                break
            end
        end
    end

    return success
end

module.removeItem = function(inventoryName, item, count, slot, metadata)
    if not CheckArgs(inventoryName, item, count) then return end

    local Player = QBCore.Functions.GetPlayer(inventoryName)
    if not Player then return false end

    if item == "money" then
        Player.Functions.RemoveMoney("cash", count)
        return true
    end

    if metadata then
        return removeItemWithMetadata(Player, inventoryName, item, count, metadata)
    else
        return inventory:RemoveItem(inventoryName, item, count, slot, "elite-lib")
    end
end

module.canCarryItem = function(inventoryName, item, count, metadata)
    if not CheckArgs(inventoryName, item, count) then return end
    if item == "money" then
        return true
    else
        local canCarry, reason = inventory:CanAddItem(inventoryName, item, count)
        return canCarry
    end
end

module.getItemCount = function(inventoryName, item, metadata)
    if not CheckArgs(inventoryName, item) then return end
    if item == "money" then
        local Player = QBCore.Functions.GetPlayer(inventoryName)
        if Player then
            return Player.Functions.GetMoney("cash")
        end
    else
        return inventory:GetItemCount(inventoryName, item)
    end
end

module.registerStash = function(stashName, stashLabel, stashSlots, stashMaxWeight, stashOwner, stashGroups)
    if not CheckArgs(stashName, stashLabel, stashSlots, stashMaxWeight) then return end
    inventory:CreateStash({
        name = stashName,
        label = stashLabel,
        slots = stashSlots,
        maxweight = stashMaxWeight
    })
end

module.setDurability = function(inventoryName, itemSlot, durability)
    if not CheckArgs(inventoryName, itemSlot, durability) then return end
    local item = inventory:GetItemBySlot(inventoryName, itemSlot)
    if item then
        item.info.durability = durability
        inventory:SetItemData(inventoryName, item.name, "info", item.info)
    end
end

return module