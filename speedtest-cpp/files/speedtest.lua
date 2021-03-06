local core = require("orange/core"); 

local function speedtest_start(opts) 
	-- forkshell can not tell us if it actually succeeded or not. You have to check status!
	CORE.forkshell("speedtest start"); 

	local result = {}; 
	result["status"] = "Speedtest started!"; 
	return result; 
end

local function speedtest_status(opts)
	local status = core.shell("speedtest status"); 
	local time = core.shell("date '+%s'", "%s"); 
	local result = {}; 
	if( not status or status == "" ) then 
		result["status"] = "Could not retreive speedtest status!"; 
	end
	for line in status:gmatch("[^\r\n]+") do
		local key, value = line:match("(%S+)%s+(.+)"); 
		if( key == "timestamp" ) then 
			value = tonumber(value); 
			result["age"] = tonumber(time) - value; 
		end
		local n = tonumber(value); 
		if(n ~= nil) then value = n; end 
		result[key:lower()] = value; 
	end

	return result; 
end

local function speedtest_stop(opts)
	local status = core.shell("speedtest stop"); 
	local result = {}; 
	if( not status or status == "" ) then 
		result["status"] = "Could not retreive speedtest status!"; 
	else
		result["status"] = string.gsub(status, "\n", ""); 
	end
	return result; 
end

return {
	["start"] = speedtest_start, 
	["stop"] = speedtest_stop,
	["status"] = speedtest_status
}; 
