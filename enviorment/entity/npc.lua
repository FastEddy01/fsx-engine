Npc = {}

Npc.spawn = function(model, coords, freeze, networked, callback)

	model = Model.hash(model)

	if not IsModelInCdimage(model) then return end

	Model.load(model)

	coords = Model.coords(coords, 4)

	local entity = CreatePed(nil, model, coords, (networked or true), false)
	local netid = NetworkGetNetworkIdFromEntity(entity)

	SetNetworkIdCanMigrate(netid, true)
	FreezeEntityPosition(entity, (freeze or false))
    SetModelAsNoLongerNeeded(model)

	if callback then callback(entity) end

end

Npc.delete = function(entity)

	DeleteEntity(entity)

end