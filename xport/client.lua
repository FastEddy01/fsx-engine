FSXEngine = {}

FSXEngine.config = Config
FSXEngine.core = Core
FSXEngine.env = Enviorment

FSXEngine.log = function(msg, ref)
	TriggerEvent('fsx-engine:log', msg, ref)
end

local function GetEngine()
	return FSXEngine
end

exports('GetClientEngine', function()
	return GetEngine()
end)