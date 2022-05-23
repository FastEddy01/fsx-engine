FSXEngine = {}

FSXEngine.config = Config
FSXEngine.core = Core
FSXEngine.system = System

local function GetEngine()
	return FSXEngine
end

exports('GetServerEngine', function()
	return GetEngine()
end)