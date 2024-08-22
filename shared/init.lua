Elite = { cache = {} }
local LibConfig = {
    Settings = {
        Debug = false,
        Framework = "auto", --[[
            Options:
                "auto",
                "esx",
                "qb",
                "qbox"
        ]]
        Inventory = "auto", --[[
            Options:
                "auto",
                "esx" (native),
                "qb" (native),
                "ox_inv",
                "qb_inv"
        ]]
        Target = "auto", --[[
            Options:
                "auto",
                "ox",
                "qb"
        ]]
        Database = "auto" --[[
            Options:
                "auto",
                "esx",
                "qb",
                "qbox"
        ]]
    },
    Modules = {
        Framework = {
            client = {
                ["es_extended"] = "esx.lua",
                ["qb-core"] = "qb.lua",
                ["qbx_core"] = "qbx.lua"
            },
            server = {
                ["es_extended"] = "esx.lua",
                ["qb-core"] = "qb.lua",
                ["qbx_core"] = "qbx.lua"
            },
        },
        Inventory = {
            client = {
                ["ox_inventory"] = "ox_inv.lua",
                ["qb-inventory"] = "qb_inv.lua",
                ["qb-core"] = "qb.lua",
                ["es_extended"] = "esx.lua"
            },
            server = {
                ["ox_inventory"] = "ox_inv.lua",
                ["qb-inventory"] = "qb_inv.lua",
                ["qb-core"] = "qb.lua",
                ["es_extended"] = "esx.lua"
            },
        },
        Target = {
            client = {
                ["ox_target"] = "ox.lua",
                ["qb-target"] = "qb.lua"
            }
        },
        Database = {
            server = {
                ["es_extended"] = "esx.lua",
                ["qb-core"] = "qb.lua",
                ["qbx_core"] = "qbx.lua"
            }
        }
    }
}
local isServer = IsDuplicityVersion()
local printtypes = {
    ["error"] = "^1[ERROR] ^0",
    ["success"] = "^2[SUCCESS] ^0",
    ["info"] = "^4[INFO] ^0"
}

function DebugPrint(message, type)
    if not LibConfig.Settings.Debug then return end
    local prefix = printtypes[type] or printtypes["error"]
    print(prefix .. message)
end

local function updateCheck(resourceName)
    -- local currentVersion = GetResourceMetadata(resourceName, "version")
	-- if not currentVersion then return print(("^1Unable to determine current resource version for '%s' ^0"):format(resourceName)) end
    -- PerformHttpRequest("API_LÄNK_HÄR", function(status, response)
    --     if status ~= 200 then return end
    --     local data = json.decode(response)
    --     if currentVersion ~= data.tag_name then
    --         print("^2[UPDATE] ^7An update for ^2"..resourceName.." (v"..data.tag_name..") ^7is available. Check out our discord (https://discord.gg/hM228ZYhbY) for changelogs.")
    --     else
    --         print("^4[INFO] ^7Resource ^2"..resourceName.." ("..currentVersion..") ^7has been started successfully.")
    --     end
    -- end, "GET")
end

local resourceName = GetCurrentResourceName()
local isLib = GetResourceMetadata(resourceName, "isLib", 0)
if isLib then
    if resourceName ~= "elite-bridge" then
        return print(("Change resource name from %s to elite-bridge in order to use our resources!"):format(resourceName))
    else
        if isServer then
            updateCheck(resourceName)
            print("^4[INFO] ^0"..resourceName.." started successfully.")
        end
    end
elseif not isLib and isServer then
    print("^4[INFO] ^0Resource "..resourceName.." started and paired with elite-bridge")
    updateCheck(resourceName)
end

function CheckArgs(...)
    local funcInfo = debug.getinfo(2, "nSl")
    local funcName = funcInfo.name or "unknown function"

    for i = 1, select("#", ...) do
        local arg = select(i, ...)
        local argName = debug.getlocal(2, i)
        if arg == nil then
            DebugPrint(("Missing required argument '%s' in %s"):format(argName or "unknown argument", funcName), "error")
            return false
        end
    end
    return true
end

function AddCache(key, value)
    if not CheckArgs(key, value) then return end
    Elite.cache[key] = value
    DebugPrint(("Cache added: '%s' = %s"):format(key, value), "info")
end

function RemoveCache(key)
    if not CheckArgs(key) then return end
    for k, _ in pairs(Elite.cache) do
        if k == key then
            table.remove(Elite.cache, key)
            DebugPrint(("Cache removed w/ index: '%s'"):format(key), "info")
            break
        end
    end
end

local function loadBridgeModule(modulePath)
    local file = LoadResourceFile("elite-bridge", modulePath)
    if not file then
        DebugPrint(("Failed to load module %s: File not found"):format(modulePath), "error")
        return nil
    end

    local func, err = load(file, modulePath)
    if not func then
        DebugPrint(("Failed to load module %s: %s"):format(modulePath, err), "error")
        return nil
    end

    local success, module = pcall(func)
    if not success then
        DebugPrint(("Failed to load module %s: %s"):format(modulePath, module), "error")
        return nil
    end

    return module
end

local function setup()
    local missingCategories = {}
    local loadedModules = {
        client = {},
        server = {}
    }

    for name, setting in pairs(LibConfig.Settings) do
        if setting == "auto" then
            LibConfig.Settings[name] = nil
            DebugPrint(("Auto-detecting %s modules"):format(name), "info")
        elseif setting then
            if name ~= "Debug" then
                DebugPrint(("%s module forced to %s"):format(name, setting), "info")
            end
        end
    end

    for name, module in pairs(LibConfig.Modules) do
        local setting = LibConfig.Settings[name]

        if isServer and module.server then
            for framework, path in pairs(module.server) do
                if loadedModules.server[name] then break end
                if setting and framework ~= setting then goto continue end
                if GetResourceState(framework) ~= "missing" or (setting and framework == setting) then
                    local data = loadBridgeModule("server/" .. name .. "/" .. path)
                    if data then
                        for funcName, func in pairs(data) do Elite[funcName] = func end
                        DebugPrint(("%s %s server module loaded"):format(framework, name), "success")
                        loadedModules.server[name] = true
                    else
                        DebugPrint(("Failed to load %s %s server module"):format(framework, name), "error")
                    end
                end
                ::continue::
            end
            if not loadedModules.server[name] and name ~= "Target" then
                table.insert(missingCategories, name)
            end
        elseif not isServer and module.client then
            for framework, path in pairs(module.client) do
                if loadedModules.client[name] then break end
                CreateThread(function()
                    if name == "Target" and GetResourceState("ox_target") ~= "missing" and framework ~= "ox_target" then
                        DebugPrint(("Skipping %s %s client module because ox_target is available"):format(framework, name), "info")
                        return
                    elseif name == "Framework" and GetResourceState("qbx_core") ~= "missing" and framework == "qb-core" then
                        DebugPrint(("Skipping %s %s client module because qbx_core is available"):format(framework, name), "info")
                        return
                    end
                    if setting and framework ~= setting then return end
                    while GetResourceState(framework) == "starting" do Wait(100) end
                    if GetResourceState(framework) ~= "missing" or (setting and framework == setting) then
                        local data = loadBridgeModule("client/" .. name .. "/" .. path)
                        if data then
                            for funcName, func in pairs(data) do Elite[funcName] = func end
                            DebugPrint(("%s %s client module loaded"):format(framework, name), "success")
                            loadedModules.client[name] = true
                        else
                            DebugPrint(("Failed to load %s %s client module"):format(framework, name), "error")
                        end
                    end
                end)
            end
        end
    end

    if isServer then
        for _, category in ipairs(missingCategories) do
            DebugPrint(("No active resources found for category %s, functionality will not work"):format(category), "error")
        end
    else
        local ped = PlayerPedId()
        local playerId = PlayerId()
        local serverId = GetPlayerServerId(playerId)
        local addToCache = {
            ped = ped,
            playerId = playerId,
            serverId = serverId
        }
        for k, v in pairs(addToCache) do
            AddCache(k, v)
        end
    end
end

setup()