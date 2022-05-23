Model = {}

Model.load = function(model)
    if HasModelLoaded(model) then return end
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(0)
	end
end

Model.hash = function(model)
	model = type(model) == 'string' and GetHashKey(model) or model
	return model
end

Model.coords = function(coords, vector)
	coords = coords or GetEntityCoords(PlayerPedId())
	coords.x = coords.x or 0.0
	coords.y = coords.y or 0.0
	coords.z = coords.z or 0.0
	coords.w = coords.h or coords.w
	local datatype = type(coords)
	coords = ((datatype == 'vector3' or datatype == 'table') and vector == 4) and vector4(coords.x, coords.y, coords.z, coords.w) or coords
	coords = ((datatype == 'vector4' or datatype == 'table') and vector == 3) and vector3(coords.x, coords.y, coords.z) or coords
	return coords
end

Model.blacklisted = function(model)
	return Config.model_blacklist[Model.hash(model)] ~= nil
end