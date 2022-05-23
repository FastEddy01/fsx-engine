Vehicle = {}

Vehicle.spawn = function(model, coords, networked, teleportInto, callback)
	model = Model.hash(model)
	if not IsModelInCdimage(model) or Model.blacklisted(model) then return end
	Model.load(model)
	coords = Model.coords(coords, 4)
	local veh = CreateVehicle(model, coords, (networked or true), false)
	local netid = NetworkGetNetworkIdFromEntity(veh)
	SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetNetworkIdCanMigrate(netid, true)
    SetVehicleNeedsToBeHotwired(veh, false)
    SetVehRadioStation(veh, 'OFF')
    SetVehicleFuelLevel(veh, 100.0)
    SetModelAsNoLongerNeeded(model)
	if teleportInto then TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1) end
	if callback then callback(veh) end
end

Vehicle.clearspawn = function(coords, radius)
	coords = Model.coords(coords, 3)
    local vehicles = GetGamePool('CVehicle')
    local closeVeh = {}
	for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - coords)
        if distance <= radius then
            closeVeh[#closeVeh + 1] = vehicles[i]
        end
    end
	if #closeVeh > 0 then return false, closeVeh[1] end
	return true
end

Vehicle.despawn = function(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteVehicle(vehicle)
end