local events = {}

local function hash(e)
	local str = ('%s-%s-%s'):format(e.name, e.salt, e.type)
	return Core.string.hash(str)
end

local function register_event(name, etype, salt)
	events[name] = {
		name = name,
		salt = salt or Core.string.random(10),
		type = etype or 'server'
	}
	return hash(events[name])
end

local function get_event(name)
	if events[name] == nil then
		return
	end
	local e = events[name]
	return hash(e), e.type
end

local function create_event(name, callback)
	if events[name] ~= nil then return end
	local event_hash = register_event(name)
	RegisterNetEvent(event_hash, callback)
end

local function trigger_event(name, src, ...)
	local event_hash, event_type = get_event(name)
	if event_hash == nil or event_type == nil then
		return
	end
	if event_type == 'server' then
		TriggerEvent(event_hash, ...)
	elseif event_type == 'client' and src ~= nil then
		TriggerClientEvent(event_hash, src, ...)
	end
end

Event.Create = create_event
Event.Trigger = trigger_event

RegisterNetEvent(Core.event.server, function(client_events)
	for k, v in pairs(client_events) do
		events[k] = events[k] or v
	end
end)