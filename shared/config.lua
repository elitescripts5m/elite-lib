Config = {
    Settings = {
        Debug = true,
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