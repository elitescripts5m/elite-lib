fx_version "cerulean"
game "gta5"
name "Elite Bridge"
author "Elite Scripts"
version "1.0"

dependencies {
    "/server:7290",
    "/onesync",
    "oxmysql"
}

files {
    "client/**/*.lua",
    "server/**/*.lua"
}

server_script "@oxmysql/lib/MySQL.lua"
shared_script "shared/*.lua"
lua54 "yes"