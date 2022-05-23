Http = {}

Http.response = function(response)
	return Core.table.class({ response = response }, function(self, code, message, object)
		code = code or 500
		local data = { status = { code = code } }
		if code >= 200 and code <= 299 then
			data.message = message
			data.data = object
		end
		self.response.writeHead(code, {
			["Access-Control-Allow-Origin"] = "*",
			["Content-Type"] = "application/json"
		})
		self.response.send(json.encode(data))
	end)
end

Http.parameter = function()
	return Core.table.class({
		global = {}
	}, function(self, name, handler, bool)
		local param = self.global[name]
		if param == nil or (bool and param ~= nil) then
			self.global[name] = handler
		else
			error('the parameter you tried to create a handler for all ready exists', 0)
		end
	end)
end

Http.path = function(method, path, handler)
	return Core.table.class({
		path = path,
		method = method,
		handler = handler
	}, function(self, p, r)
		return self.handler(p, r)
	end)
end

Http.router = function()

	local temp_router = {
		paths = {}
	}

	function temp_router:handler(params, request, response)
		local Response = Http.response(response)
		local fullPath = Core.string.sub(request.path, 2)
		local path = Core.string.split(fullPath, '?')
		local sub = self.paths[path[1]]
		if sub == nil then
			Response(501)
			return false
		end
		if request.method ~= sub.method then
			Response(501)
			return false
		end
		local prms = {}
		if path[2] ~= nil then
			local temp = Core.string.split(path[2], '&')
			for k, v in pairs(temp) do
				local kv = Core.string.split(v, '=')
				prms[kv[1]] = kv[2] or true
				Core.table.remove(prms, 1)
			end
			for index, value in pairs(prms) do
				if params.global[index] ~= nil then
					prms[index] = params.global[index](value)
				end
			end
		end
		return self.paths[path[1]](prms, Response)
	end

	return Core.table.class(temp_router, function(self, method, path, handler)
		self.paths[path] = Http.path(method, path, handler)
	end)

end

Http.resHandler = function(method, uri, status, response, headers)
	local rtv = { status = tonumber(status), success = false, data = {}, headers = headers }
	if rtv.status >= 200 and rtv.status < 300 then
		rtv.success = true
		rtv.data = json.decode(response)
	else
		print('^8ERROR:ERINFO: Rest api request failed')
		print(('^8ERROR:METHOD: %s'):format(method))
		print(('^8ERROR:REQURI: %s'):format(uri))
		print(('^8ERROR:STCODE: %s^0'):format(status))
	end
	return rtv
end

Http.fetch = function(uri, callback)
	PerformHttpRequest(uri, function(status, response, headers)
		local rtv = Http.resHandler('GET', uri, status, response, headers)
		if callback ~= nil then
			return callback(rtv.success, rtv.data, rtv.headers)
		else
			return rtv.success, rtv.data, rtv.headers
		end
	end, 'GET', nil, { ['Accept'] = 'application/vnd.github.v3+json' })
end

Http.post = function(uri, callback, data)
	PerformHttpRequest(uri, function(status, response, headers)
		local rtv = Http.resHandler('POST', uri, status, response, headers)
		if callback ~= nil then
			return callback(rtv.success, rtv.data, rtv.headers)
		else
			return rtv.success, rtv.data, rtv.headers
		end
	end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end

Http.vChecker = function(repo_owner, repo_name, repo_version)
	local Uri = ('https://api.github.com/repos/%s/%s/releases/latest'):format(repo_owner, repo_name)
	-- check version of resource
	Http.fetch(Uri, function(success, response, headers)
		local str = ''
		if success then
			local latest_version = string.gmatch(response.name, "%d.%d.%d")()
			str = str .. ('\n^5ltst version: ^2%s^5\ncurr version: ^3%s\n'):format(latest_version, repo_version)
			if latest_version == repo_version then
				str = str .. '\n^2SUCC: everything is up to date...'
			else
				str = str .. ('\n^8WARN: your version of the %s is not up to date. you can download the latest version from the link below.'):format(repo_name)
				str = str .. ('\n^3DOWNLOAD: ^5%s'):format(response.html_url)
			end
		else
			str = str .. '\n^3WARN: could not verify the version of your resource...'
		end
		str = str .. '\n^2SUCC: resource is up and running...\n\n^9Created by ^8Sm1Ly^9 for servers build with the ^8CitizenFX Framework^9!\n^0'
		print(str)
	end)
end

Http.rest = function()

	local newRestApi = {
		route = Http.router(),
		param = Http.parameter(),
		responseHandler = Http.resHandler,
		fetch = Http.fetch,
		post = Http.post,
	}

	return Core.table.class({}, {
		__index = newRestApi,
		SetHttpHandler(function(req, res) newRestApi.route:handler(newRestApi.param, req, res) end)
	}, true)

end