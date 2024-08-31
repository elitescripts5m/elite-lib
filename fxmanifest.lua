fx_version "cerulean"
game "gta5"
name "Elite Lib"
author "Elite Scripts"
version "1.0.1"

dependencies {
    "/server:7290",
    "/onesync",
    "oxmysql"
}

server_script "@oxmysql/lib/MySQL.lua"

files {
    "shared/config.lua",
    "client/**/*.lua",
    "server/**/*.lua"
}

shared_script "shared/init.lua"
isLib "true"
lua54 "yes"