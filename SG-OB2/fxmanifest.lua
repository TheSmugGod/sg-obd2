fx_version 'cerulean'
game 'gta5'

author 'Smug God'
description 'OBD2 Scanner Script for FiveM'
version '1.0.0'
lua54 'yes'

-- Define the script dependency
dependencies {
    'ox_lib',
    'es_extended',   --comment me out if using qb
    --'qb-core'      --comment me out if useing esx
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

-- Specify the entry point for your script
client_script 'client.lua'
server_script 'server.lua'
