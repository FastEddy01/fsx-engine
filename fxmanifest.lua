fx_version 'cerulean'
games { 'gta5' }

--[[

          ::::::::::       ::::::::       :::    :::             :::                :::::::                :::::::
         :+:             :+:    :+:      :+:    :+:           :+:+:               :+:   :+:              :+:   :+:
        +:+             +:+              +:+  +:+              +:+               +:+   +:+              +:+   +:+
       :#::+::#        +#++:++#++        +#++:+               +#+               +#+   +:+              +#+   +:+
      +#+                    +#+       +#+  +#+              +#+               +#+   +#+              +#+   +#+
     #+#             #+#    #+#      #+#    #+#             #+#       #+#     #+#   #+#      #+#     #+#   #+#
    ###              ########       ###    ###           #######     ###      #######       ###      #######

    +++++++::::::::::::::###################################################################::::::::::::::+++++++

              ::::::::::       ::::    :::       ::::::::       :::::::::::       ::::    :::       ::::::::::
             :+:              :+:+:   :+:      :+:    :+:          :+:           :+:+:   :+:       :+:
            +:+              :+:+:+  +:+      +:+                 +:+           :+:+:+  +:+       +:+
           +#++:++#         +#+ +:+ +#+      :#:                 +#+           +#+ +:+ +#+       +#++:++#
          +#+              +#+  +#+#+#      +#+   +#+#          +#+           +#+  +#+#+#       +#+
         #+#              #+#   #+#+#      #+#    #+#          #+#           #+#   #+#+#       #+#
        ##########       ###    ####       ########       ###########       ###    ####       ##########

]]--

author 'Sm1Ly'
description 'Fx Server Exclusives Engine | handle, manipulate & create player data, player cameras, vehicles, file logs, rest apis and much more'
version '1.0.0'

lua54 'yes'

shared_scripts {

	-- load main configuration
	"config/config.lua",

	-- select the wanted configuration
	"config/gta5/*.lua",
	-- "config/gta4/*.lua",
	-- "config/rdr/*.lua",

	-- load core parts
	"core/libs/ext/*.lua",
	"core/libs/lua/*.lua",

	-- load core
	"core/core.lua",

	-- load the exporting of the core and config
	"xport/shared.lua"

}

server_scripts {
	-- load system parts
	"system/server/*.lua",
	"system/network/*.lua",
	-- load system
	"system/system.lua",
	-- load the exporting of the system, core and config
	"xport/server.lua"
}

client_scripts {
	-- load enviorment parts
	"enviorment/entity/*.lua",
	"enviorment/vision/*.lua",
	-- load enviorment
	"enviorment/enviorment.lua",
	-- load the exporting of the enviorment, core and config
	"xport/client.lua"
}

-- load the update checker
server_script "auto_update_check.lua"

dependency "oxmysql"