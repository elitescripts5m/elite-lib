local inventory = exports["qb-inventory"]
local module = {}

module.openInventory = function(inventoryType, inventoryData)
    if not CheckArgs(inventoryType, inventoryData) then return end
    inventory:OpenInventory(inventoryType, inventoryData)
end

module.getInventory = function()
    return QBCore.Functions.GetPlayerData().items
end

module.getCurrentWeapon = function()
    local playerPed = PlayerPedId()
    local weaponHash = GetSelectedPedWeapon(playerPed)
    local weapon = nil
    for _, item in pairs(module.getInventory()) do
        if item.name == weaponHash then
            weapon = item
            break
        end
    end
    return weapon
end

local function isValidMetadata(itemInfo, metadata)
    for index, value in pairs(metadata) do
        if not (itemInfo[index] and itemInfo[index] == value) then
            return false
        end
    end
    return true
end

module.getItemCount = function(itemName, metadata)
    if not CheckArgs(itemName) then return end
    local count = 0
    if metadata then
        for _, v in pairs(module.getInventory()) do
            if v.name == itemName then
                if isValidMetadata(v.info, metadata) then
                    count = count + v.amount
                end
            end
        end
    else
        count = inventory:GetItemCount(itemName)
    end
    return count
end

module.getItemLabel = function(itemName)
    return QBCore.Shared.Items[itemName].label or "Unknown"
end

return module