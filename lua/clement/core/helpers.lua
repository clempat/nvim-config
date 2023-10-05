local M = {}

-- Function to URL-encode a string
M.urlencode = function(str)
	-- Define a table of character replacements
	local replacements = {
		[" "] = "%20",
		["["] = "%5B",
		["]"] = "%5D",
		-- Add more replacements as needed
	}

	local encoded_str = string.gsub(str, ".", function(match)
		return replacements[match] or match
	end)

	return encoded_str
end

return M
