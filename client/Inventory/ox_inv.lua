local inventory = exports.ox_inventory
local module = {}

module.openInventory = function(inventoryType, inventoryData)
    if not CheckArgs(inventoryType, inventoryData) then return end
    inventory:openInventory(inventoryType, inventoryData)
end

module.getCurrentWeapon = function()
    return inventory:getCurrentWeapon()
end

module.getItemCount = function(itemName, metadata)
    if not CheckArgs(itemName) then return end
    return inventory:GetItemCount(itemName, metadata)
end

return module