FSXEngine = {}

FSXEngine.config = Config
FSXEngine.core = Core

local function GetEngine()
	return FSXEngine
end

exports('GetSharedEngine', function()
	return GetEngine()
end)