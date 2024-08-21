QBCore = exports['qb-core']:GetCoreObject()
local data = {}

data.openInventory = function(inventoryType, inventoryData)
    if not CheckArgs(inventoryType, inventoryData) then return end
    --[[ NOT AVAILABLE ]]
    return false
end

data.getCurrentWeapon = function()
    local playerPed = PlayerPedId()
    local weaponHash = GetSelectedPedWeapon(playerPed)
    local weapon = nil
    for _, item in pairs(QBCore.Functions.GetPlayerData().items) do
        if item.name == weaponHash then
            weapon = item
            break
        end
    end
    return weapon
end

data.getItemCount = function(itemName, metadata)
    if not CheckArgs(itemName) then return end
    local count = 0
    for _, item in pairs(QBCore.Functions.GetPlayerData().items) do
        if item.name == itemName then
            count = count + item.amount
        end
    end
    return count
end

return data