local resource_name = GetCurrentResourceName()
FSXEngine.system.http.vChecker('fxserver-exclusives', resource_name, GetResourceMetadata(resource_name, "version"))