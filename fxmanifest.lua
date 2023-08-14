--[[ ===================================================== ]]--
--[[            AM ELEVATOR - POR - AMonkeys               ]]--
--[[ ===================================================== ]]--

fx_version 'cerulean'
game 'gta5'

author 'AMonkeys'
description 'QB Elevators'
version '1.0.0'

shared_scripts {
    'TU SERVER/shared/locale.lua',
    'locales/es.lua', -- Cambia el idioma
    'config.lua',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/main.lua',
}

server_scripts {
    'server/update.lua',
}

lua54 'yes'
