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
	local datatype = type(coords)
	coords = ((datatype == 'vector3' or datatype == 'table') and vector == 4) and vector4((coords.x or 0.0), (coords.y or 0.0), (coords.z or 0.0), (coords.h or coords.w or 0.0)) or coords
	coords = ((datatype == 'vector4' or datatype == 'table') and vector == 3) and vector3((coords.x or 0.0), (coords.y or 0.0), (coords.z or 0.0)) or coords
	return coords
end

Model.blacklisted = function(model)
	return Config.model_blacklist[Model.hash(model)] ~= nil
end