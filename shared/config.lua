Config = {}

Config.Settings = {
    Debug = true,
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
            "ox_inventory", (Recommended)
            "qb-inventory",
            "esx", (native, not recommended)
            "qb", (native, not recommended)
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
    Progressbar = "auto", --[[
        Options:
            "auto",
            "es_extended",
            "progressbar", (QBCore)
            "ox_lib",
            "custom"
    ]]
    Menu = "auto", --[[
        Options:
            "auto",
            "esx_default_menu",
            "ox_lib",
            "qb-menu",
            "custom"
    ]]
    Utils = "utils" -- Don"t change this!
}

Config.Modules = {
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
            ["progressbar"] = "progressbar.lua",
            ["es_extended"] = "es_extended.lua",
            ["ox_lib"] = "ox_lib.lua",
            ["custom"] = "custom.lua"
        }
    },
    Menu = {
        client = {
            ["qb-menu"] = "qb-menu.lua",
            ["esx_menu_default"] = "esx_menu_default.lua",
            ["ox_lib"] = "ox_lib.lua",
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

return Config