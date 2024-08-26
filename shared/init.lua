Elite = {
    Locale = {},
    cache = {}
}
Elite.Locale.__index = Elite.Locale

local LibConfig = {
    Settings = {
        Debug = false,
        Framework = "auto", --[[
            Options:
                "auto",
                "esx",
                "qb",
                "qbox",
                "custom"
        ]]
        Inventory = "auto", --[[
            Options:
                "auto",
                "esx" (native, not recommended),
                "qb" (native, not recommended),
                "ox_inventory",
                "qb-inventory",
                "custom"
        ]]
        Target = "auto", --[[
            Options:
                "auto",
                "ox",
                "qb",
                "custom"
        ]]
        Database = "auto", --[[
            Options:
                "auto",
                "esx",
                "qb",
                "qbox",
                "custom"
        ]]
        Utils = "utils" -- Don"t change this!
    },
    Modules = {
        Framework = {
            client = {
                ["es_extended"] = "esx.lua",
                ["qb-core"] = "qb.lua",
                ["qbx_core"] = "qbx.lua",
                ["custom"] = "custom.lua"
            },
            server = {
                ["es_extended"] = "esx.lua",
                ["qb-core"] = "qb.lua",
                ["qbx_core"] = "qbx.lua",
                ["custom"] = "custom.lua"
            },
        },
        Inventory = {
            client = {
                ["ox_inventory"] = "ox_inventory.lua",
                ["qb-inventory"] = "qb-inventory.lua",
                ["qb-core"] = "qb.lua",
                ["es_extended"] = "esx.lua",
                ["custom"] = "custom.lua"
            },
            server = {
                ["ox_inventory"] = "ox_inventory.lua",
                ["qb-inventory"] = "qb-inventory.lua",
                ["qb-core"] = "qb.lua",
                ["es_extended"] = "esx.lua",
                ["custom"] = "custom.lua"
            },
        },
        Target = {
            client = {
                ["ox_target"] = "ox.lua",
                ["qb-target"] = "qb.lua",
                ["custom"] = "custom.lua"
            }
        },
        Database = {
            server = {
                ["es_extended"] = "esx.lua",
                ["qb-core"] = "qb.lua",
                ["qbx_core"] = "qbx.lua",
                ["custom"] = "custom.lua"
            }
        },
        Progressbar = {
            client = {
                ["progressbar"] = "qb.lua",
                ["es_extended"] = "esx.lua",
                ["ox_lib"] = "ox.lua",
                ["custom"] = "custom.lua"
            }
        },
        Utils = {
            client = {
                ["utils"] = "utils.lua"
            },
            server = {
                ["utils"] = "utils.lua"
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
    local currentVersion = GetResourceMetadata(resourceName, "version", 0)
    if not currentVersion then return print(("^1Unable to determine current resource version for '%s' ^0"):format(resourceName)) end
    PerformHttpRequest("https://elite-website-sable.vercel.app/api/release?script_name="..resourceName, function(status, response)
        if status ~= 200 then return end
        local data = json.decode(response)[1]
        if currentVersion ~= data.version then
            print("^2[UPDATE] ^7An update for ^2"..resourceName.." ^7is available.")
            print("Current version: ^1v"..currentVersion.."^0. Latest version: ^5v"..data.version.."^0.")
            print("Check out our discord (^4https://discord.gg/hM228ZYhbY^0) for changelogs.")
        else
            print("^4[INFO] ^7Resource ^2"..resourceName.." (v"..currentVersion..") ^7has been started successfully.")
        end
    end, "GET")
end

local resourceName = GetCurrentResourceName()
local isLib = GetResourceMetadata(resourceName, "isLib", 0)
if isLib then
    if resourceName ~= "elite-lib" then
        return print(("Change resource name from %s to elite-lib in order to use our resources!"):format(resourceName))
    else
        if isServer then
            updateCheck(resourceName)
            print("^4[INFO] ^0"..resourceName.." started successfully.")
        end
    end
elseif not isLib and isServer then
    print("^4[INFO] ^0Resource "..resourceName.." started and paired with elite-lib")
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

if isServer and isLib then
    RegisterServerEvent("elite-lib:server:utils:debugger", function(table, indent)
        Elite.debugger(table, indent)
    end)
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
    local file = LoadResourceFile("elite-lib", modulePath)
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
                if framework == "utils" or framework == "custom" or GetResourceState(framework) ~= "missing" or (setting and framework == setting) then
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
                missingCategories[#missingCategories + 1] = name
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
                    while GetResourceState(framework) == "starting" and framework ~= "utils" and framework ~= "custom" do Wait(100) end
                    if framework == "utils" or framework == "custom" or GetResourceState(framework) ~= "missing" or (setting and framework == setting) then
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

local function translateKey(phrase, subs)
    if type(phrase) ~= "string" then
        error("TypeError: translateKey function expects arg #1 to be a string")
    end

    if not subs then return phrase end
    local result = phrase

    for k, v in pairs(subs) do
        local templateToFind = "%%{" .. k .. "}"
        result = result:gsub(templateToFind, tostring(v))
    end

    return result
end

function Elite.Locale.new(_, opts)
    local self = setmetatable({}, Elite.Locale)

    self.fallback = opts.fallbackLang and Elite.Locale:new({
        warnOnMissing = false,
        phrases = opts.fallbackLang.phrases,
    }) or false

    self.warnOnMissing = type(opts.warnOnMissing) ~= "boolean" and true or opts.warnOnMissing

    self.phrases = {}
    self:extend(opts.phrases or {})

    return self
end

function Elite.Locale:extend(phrases, prefix)
    for key, phrase in pairs(phrases) do
        local prefixKey = prefix and ("%s.%s"):format(prefix, key) or key
        if type(phrase) == "table" then
            self:extend(phrase, prefixKey)
        else
            self.phrases[prefixKey] = phrase
        end
    end
end

function Elite.Locale:clear()
    self.phrases = {}
end

function Elite.Locale:replace(phrases)
    phrases = phrases or {}
    self:clear()
    self:extend(phrases)
end

function Elite.Locale:locale(newLocale)
    if (newLocale) then
        self.currentLocale = newLocale
    end
    return self.currentLocale
end

function Elite.Locale:t(key, subs)
    local phrase, result
    subs = subs or {}

    if type(self.phrases[key]) == "string" then
        phrase = self.phrases[key]
    else
        if self.warnOnMissing then
            print(("^3Warning: Missing phrase for key: '%s'"):format(key))
        end
        if self.fallback then
            return self.fallback:t(key, subs)
        end
        result = key
    end

    if type(phrase) == "string" then
        result = translateKey(phrase, subs)
    end

    return result
end

function Elite.Locale:has(key)
    return self.phrases[key] ~= nil
end

function Elite.Locale:delete(phraseTarget, prefix)
    if type(phraseTarget) == "string" then
        self.phrases[phraseTarget] = nil
    else
        for key, phrase in pairs(phraseTarget) do
            local prefixKey = prefix and prefix .. "." .. key or key

            if type(phrase) == "table" then
                self:delete(phrase, prefixKey)
            else
                self.phrases[prefixKey] = nil
            end
        end
    end
end