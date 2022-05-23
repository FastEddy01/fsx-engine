Camera = {
	cams = {}
}

function Camera.create(name, pos, rot, fov)
	if name ~= (nil or '') then
		if Camera.cams[name] == nil then
			pos = type(pos) == 'vector3'	and pos		or vector3(0.0, 0.0, 0.0)
			rot = type(rot) == 'vector3'	and rot		or vector3(0.0, 0.0, 0.0)
			fov = type(fov) == 'number'		and fov		or 90.0
			Camera.cams[name] = {
				cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', pos, rot, fov, false, 0),
				pos = pos,
			}
			SetCamActive(Camera.cams[name].cam, false)
		else
			print('camera with the name '..name..' already exist cant create...')
		end
	else
		print('camera can\'t be created without a proper name...')
	end
end

function Camera.toggle(name, callback)
	local retval = false
	local info = Camera.cams[name]
	if info.cam ~= nil then
		local active = not IsCamActive(info.cam)
		if not active then
			ClearFocus()
		else
			SetFocusPosAndVel(info.pos, 0.0, 0.0, 0.0)
		end
		SetCamActive(info.cam, active)
		RenderScriptCams(active, false, 1.0, false, false)
		retval = true
	else
		print('camera with the name '..name..' doesn\'t exist cant activate...')
	end
	if callback then callback(retval) end
end