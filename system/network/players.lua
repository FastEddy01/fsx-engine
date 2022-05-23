Players = {}

Players.Guids = {}

Players.Connecting = {}
Players.Online = {}

local function AddMeta(source, meta)
	source = tonumber(source)
	if source > 60000 then
		Players.Connecting[source] = meta
	else
		Players.Online[source] = meta
	end
end
Players.AddMeta = AddMeta
exports('AddMeta', AddMeta)

local function GetMeta(source)
	source = tonumber(source)
	if source > 60000 then
		return Players.Connecting[source]
	else
		return Players.Online[source]
	end
end
Players.GetMeta = GetMeta
exports('GetMeta', GetMeta)

local function SetMeta(source, callback)
	source = tonumber(source)
	if source > 60000 then
		Players.Connecting[source] = callback(Players.Connecting[source])
	else
		Players.Online[source] = callback(Players.Online[source])
	end
end
Players.SetMeta = SetMeta
exports('SetMeta', SetMeta)

local function DelMeta(source)
	source = tonumber(source)
	if source > 60000 then
		Players.Connecting[source] = nil
	else
		Players.Online[source] = nil
	end
end
Players.DelMeta = DelMeta
exports('DelMeta', DelMeta)