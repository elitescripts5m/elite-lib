local resourceName = GetCurrentResourceName()
if resourceName ~= "elite-bridge" then
    return print(("Change resource name from %s to elite-bridge in order to use our resources!"):format(resourceName))
end

Elite = {}
local server = IsDuplicityVersion()
local printtypes = {
    ["error"] = "^1[ERROR] ^0",
    ["success"] = "^2[SUCCESS] ^0",
    ["info"] = "^4[INFO] ^0"
}

function DebugPrint(message, type)
    if not Config.Settings.Debug then return end
    local prefix = printtypes[type] or printtypes["error"]
    print(prefix .. message)
end

function CheckArgs(...)
    local funcInfo = debug.getinfo(2, "nSl")
    local funcName = funcInfo.name or "unknown function"

    for i = 1, select("#", ...) do
        local arg = select(i, ...)
        local argName = debug.getlocal(2, i)
        if arg == nil then
            print(("^1[ERROR] ^0Missing required argument '%s' in %s"):format(argName or "unknown argument", funcName))
            return false
        end
    end
    return true
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

    for name, setting in pairs(Config.Settings) do
        if setting == "auto" then
            Config.Settings[name] = nil
            DebugPrint(("Auto-detecting %s modules"):format(name), "info")
        elseif setting then
            if name ~= "Debug" then
                DebugPrint(("%s module forced to %s"):format(name, setting), "info")
            end
        end
    end

    for name, module in pairs(Config.Modules) do
        local setting = Config.Settings[name]

        if server and module.server then
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
        elseif not server and module.client then
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

    if server then
        for _, category in ipairs(missingCategories) do
            DebugPrint(("No active resources found for category %s, functionality will not work"):format(category), "error")
        end
    end
end

setup()