String = string

-- Splits a string on the given character
String.split = function(heystack, needle)
	local result = {}
	local from = 1
	local delim_from, delim_to = String.find(heystack, needle, from)
	while delim_from do
		result[#result+1] = String.sub(heystack, from, delim_from - 1)
		from = delim_to + 1
		delim_from, delim_to = String.find(heystack, needle, from)
	end
	result[#result+1] = String.sub(heystack, from)
	return result
end

String.characters = {}
String.randomChar = function()
	if #String.characters == 0 then
		for i = 1, 62, 1 do
			local char = (i <= 10 and i + 47 or false) or (i <= 36 and i + 54 or false) or i + 60
			String.characters[i] = String.char(char)
		end
	end
	return String.characters[math.random(1, #String.characters)]
end

String.random = function(length)
	length = length > 128 and 128 or length
	local str = ''
	repeat
		str = str .. String.randomChar()
	until String.len(str) == length
	return str
end

String.guid = function()
	local str, result = '', 1
	repeat
		str = String.random(32)
		result = MySQL.Sync.fetchAll('SELECT COUNT(*) as count FROM users WHERE guid = ?', { str })
	until result[1].count == 0
	return str
end

String.hash = sha256