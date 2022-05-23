FSXEngine = {}

FSXEngine.config = Config
FSXEngine.core = Core
FSXEngine.env = Enviorment

local function GetEngine()
	return FSXEngine
end

exports('GetClientEngine', function()
	return GetEngine()
end)