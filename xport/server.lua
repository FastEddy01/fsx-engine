FSXEngine = {}

FSXEngine.config = Config
FSXEngine.core = Core
FSXEngine.system = System

FSXEngine.log = file_logger

RegisterNetEvent('fsx-engine:log', function(msg, ref)

	local playerMeta = FSXEngine.system.players.GetMeta(source)

	ref = (playerMeta and playerMeta.info) ~= nil and playerMeta.info.guid or ref

	FSXEngine.log(msg, ref)

end)

local function GetEngine()
	return FSXEngine
end

exports('GetServerEngine', function()
	return GetEngine()
end)