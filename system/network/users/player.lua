Player = {}

Player.VerifyMeta = function(Data)

	local Meta = Data or {}

	Meta.state = {}
	Meta.state.connecting 	= (Data and Data.state and Data.state.connecting) ~= nil 	and Data.state.connecting 	or true
	Meta.state.joining 		= (Data and Data.state and Data.state.joining) ~= nil 		and Data.state.joining 		or false
	Meta.state.mainMenu 	= (Data and Data.state and Data.state.mainMenu) ~= nil 		and Data.state.mainMenu 	or false

	Meta.stats = {}
	Meta.stats.level 		= (Data and Data.stats and Data.stats.level) ~= nil 		and Data.stats.level 		or 0
	Meta.stats.exp 			= (Data and Data.stats and Data.stats.exp) ~= nil 			and Data.stats.exp 			or 0
	Meta.stats.coins 		= (Data and Data.stats and Data.stats.coins) ~= nil 		and Data.stats.coins 		or 0

	return Meta

end

Player.SaveMeta = function(Data)

	if (Data or Data.info or Data.info.guid) == nil then
		print('^1USER:SAVE:FATAL_ERROR | no guid given!!!^0')
		return false
	end

	Log('started saving metadata', Data.info.guid)

	local retval = true
	local message = {}

	if (Data.info and Data.info.name and Data.info.guid and Data.info.identifiers) ~= nil then
		MySQL.Async.insert('INSERT INTO users (name, guid, identifiers) VALUES (:name, :guid, :identifiers) ON DUPLICATE KEY UPDATE name = :name, identifiers = :identifiers', {
			name = Data.info.name,
			guid = Data.info.guid,
			identifiers = json.encode(Data.info.identifiers)
		})
		message[#message + 1] = '^2USER:SAVE:SUCCESS | guid: '..(Data.info.guid or 'none')..' | saved user info^0'
	else
		retval = false
		message[#message + 1] = '^1USER:SAVE:ERROR   | guid: '..(Data.info.guid or 'none')..' | an error happend when trying to save user info^0'
	end

	if (Data.stats and Data.stats.level and Data.stats.exp and Data.stats.coins) ~= nil then
		MySQL.Async.insert('INSERT INTO users_stats (guid, stats) VALUES (:guid, :stats) ON DUPLICATE KEY UPDATE stats = :stats', {
			guid = Data.info.guid,
			stats = json.encode(Data.stats)
		})
		message[#message + 1] = '^2USER:SAVE:SUCCESS | guid: '..(Data.info.guid or 'none')..' | saved user stats^0'
	else
		retval = false
		message[#message + 1] = '^1USER:SAVE:ERROR   | guid: '..(Data.info.guid or 'none')..' | an error happend when trying to save user stats^0'
	end

	for i = 1, #message, 1 do print(message[i]) end

	Log('done saving metadata', Data.info.guid)

	return retval

end

Player.LoadSavedMeta = function(src)

	-- get current metadata
	local Meta = Players.GetMeta(src)

	Log('started loading metadata', Meta.info.guid)

	-- fetch the saved metadata
	Meta.stats = json.decode(MySQL.Sync.fetchSingle('SELECT stats FROM users_stats WHERE guid = ?', { Meta.info.guid }).stats or '[]')

	-- verify the integerity of the saved metadata
	Meta = Player.VerifyMeta(Meta)

	Log('done loading metadata', Meta.info.guid)

	-- updated the metadata
	Players.AddMeta(src, Meta)

end

Player.Connect = function(playerName, setKickReason, deferrals)
	local src = source
	local Meta = {
		info = {
			name = playerName,
			src = src,
			identifiers = GetPlayerIdentifiers(src)
		}
	}
    deferrals.defer()
    Citizen.Wait(500)
    deferrals.update('Hello '..playerName..', were looking for your save data...')
	local result
	for i = 1, #Meta.info.identifiers, 1 do
		local current = Meta.info.identifiers[i]
		result = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifiers LIKE ?', { '%'..current..'%' })
		Citizen.Wait(100)
		if result[1] ~= nil then break end
	end
	local firstTime = false
	if result[1] == nil or result[1].guid == nil then
		firstTime = true
		deferrals.update('Welcome '..playerName..', its your first time here so we are creating some player data. please hold on...')
		Meta.info.guid = FSXEngine.core.string.guid()
		Citizen.Wait(1000)
	else
		deferrals.update('Welcome back '..playerName..', setting up your saved data. please hold on...')
		Meta.info.guid = result[1].guid
		Meta.info.identifiers = FSXEngine.core.table.expand(Meta.info.identifiers, json.decode(result[1].identifiers), false)
	end
	Log('connecting to server', Meta.info.guid)
	Meta = Player.VerifyMeta(Meta)
	if (not firstTime) or (firstTime and Player.SaveMeta(Meta)) then
		Players.AddMeta(src, Meta)
		exports.connectqueue:connQueue(src, playerName, setKickReason, deferrals)
	end
end

Player.Joining = function(tempId)
	local src = source
	local Meta = Players.GetMeta(tempId)
	Log('joining the server', Meta.info.guid)
	Meta.state.connecting = false
	Meta.state.joining = true
	Players.AddMeta(src, Meta)
	Players.DelMeta(tempId)
	Player.LoadSavedMeta(src)
end

Player.Joined = function(src)
	src = source or src
	local Meta = Players.GetMeta(src)
	Log('joined the server', Meta.info.guid)
	Meta.state.joining = false
	Meta.state.mainMenu = true
	Players.AddMeta(src, Meta)
end

Player.Dropped = function()
	local Meta = Players.GetMeta(source)
	if Meta ~= nil then
		Log('left the server', Meta.info.guid)
		Player.VerifyMeta(Meta, true)
		Player.SaveMeta(Meta)
	end
end

AddEventHandler('playerConnecting', Player.Connect)
AddEventHandler('playerJoining', Player.Joining)
AddEventHandler('playerSpawned', Player.Joined)
AddEventHandler('playerDropped', Player.Dropped)