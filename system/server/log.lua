function Log(msg, ref)

	-- set time
	local date_stamp = os.date("%d_%b_%Y"):lower()
	local time_stamp = os.date("%X")

	-- create a folder for the logs if it doesnt exist
	os.execute('mkdir logs')

	-- create a folder for current year if it doesnt exist
	os.execute('cd ./logs && mkdir '..date_stamp)

	-- create the string that contains the log file location
	local file_name = ('./logs/%s/%s.log'):format(date_stamp, (ref or 'system'))

	-- open an existing or create a new file
	local file = io.open(file_name, "a+")

	-- format the message
	msg = ('%s | %s'):format(time_stamp, msg)
	msg = file:lines()() ~= nil and '\n'..msg or msg

	-- add the message to the log file
	file:write(msg)

	-- close the log file
	file:close()

end