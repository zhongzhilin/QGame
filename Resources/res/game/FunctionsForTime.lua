local _M = global.funcGame

local datetime = require("datetime")

local define = global.define
local luaCfg = global.luaCfg

--转换为当前时区的时间
function _M.convertCurrZoneTime(tm)
    local zone = tonumber(os.date("%H",0))
    tm = tm + zone*3600
    return tm
end

--获取当前时间最近的半点时间12：30
function _M.getHalfTimeStamp()
    local serverTime = global.dataMgr:getServerTime()
    local restS = 1800-serverTime%1800

    local ret = serverTime+restS
    ret = _M._toFormatTime(ret)
    ret = ret.hour..":"..ret.minute

    return ret
end

--获取当前时间最近的整点时间戳
function _M.getIntegalTimeStamp()
    local serverTime = global.dataMgr:getServerTime()
    local restS = 3600-serverTime%3600
    local ret = serverTime+restS
    return ret
end

function _M.getServerDateSecs()
    local serverTime = global.dataMgr:getServerTime()
    return datetime.get_passed_secs_inday(serverTime)
end

function _M.getServerDateTime()
    local serverTime = global.dataMgr:getServerTime()
    return datetime.tosvrgmtm(serverTime)
end
-- 数字英文格式：xxx xxx
function _M.toFormatNumberEN(value)
    local format = false
    if format == false then
        return value
    end
    
	local content = ""
    
	local number = value or 0
	local message = tostring(number)
	
	local position = nil
	local length = string.len(message)
	for i=1, length do
		local v = string.sub(message, i, i)
		if v == "." then
			position = i
			break
		end
	end    
    
	local integer = message
	local decimal = nil
	if position then
		integer = string.sub(message, 1, position - 1)
		decimal = string.sub(message, position + 1, length)
	end
	
	local unit = 3
	local count = math.ceil(string.len(integer) / unit)
    
	if count == 1 then
		content = integer
	else
		local index = -1
		for i=1, count do
			
			local sIndex = index - unit + 1
			local eIndex = index
            
			local text = string.sub(integer, sIndex, eIndex)
            
			if i == 1 then
				content = text
			elseif i == count then
				if text == "+" or text == "-" then
					content = text .. content
				else
					content = text .. " " .. content
				end
			else
				content = text .. " " .. content
			end
            
			index = index - unit 
		end
	end
    
	if decimal then
		content = content .. "." .. decimal
	end
	
	return content
end

-- 时间中文格式： x时 x分 
function _M.formatTimeText(value, nosec, num)
    local list = {
        {HQCONST.SECONDS_ONE_DAY, 10473}, 
        {HQCONST.SECONDS_ONE_HOUR, 10471},
        {HQCONST.SECONDS_ONE_MINUTE, 10472},
    }

    if not nosec then
        table.insert(list, {1, 10309})
    end

    local text = ""
    local time = math.ceil(value or 0)
    num = num or #list

    local index = 0
    local count = #list
    for i=1, count do
        local args = list[i]
        local unit, id = args[1], args[2]
        if time >= unit then
            local value = math.floor(time / unit)
            time = time % unit

            local string = global.luaCfg:get_local_string(id, value)
            text = global.luaCfg:get_local_string(10474, text, string)
            index = index + 1
        end

        if index == num then
            break
        end
    end
    return text
end

--[[
格式化日期
YYYY年MM月DD日hh:mm:ss
--]]

function _M._formatDateText(value, fmtStr, lite)
    local date
    if type(value) == "number" then
        date = os.date("*t", value)
    elseif type(value) == "table" then
        date = value
    else
        date = {}
    end

    local _getStr = function(v, l)
        local s = tostring(v)
        if #s <= l then
            if lite then
                return s
            else
                local f = "%0" .. l .. "d"
                return string.format(f, v)
            end
        else
            return string.sub(s, -l, -1)
        end
    end

    local text = fmtStr
    text = string.gsub(text, "[Yy]+", function(s) return _getStr(date.year, #s) end)
    text = string.gsub(text, "[M]+", function(s) return _getStr(date.month, #s) end)
    text = string.gsub(text, "[Dd]+", function(s) return _getStr(date.day, #s) end)
    text = string.gsub(text, "[Hh]+", function(s) return _getStr(date.hour, #s) end)
    text = string.gsub(text, "[m]+", function(s) return _getStr(date.min, #s) end)
    text = string.gsub(text, "[Ss]+", function(s) return _getStr(date.sec, #s) end)
    return text
end

function _M.formatDateText(value, fmtStr, lite)
    local date = datetime.totm(value)
    if global and global.luaCfg then
        fmtStr = global.luaCfg:get_local_string(fmtStr)
    end
    return _M._formatDateText(date, fmtStr, lite)
end

function _M.formatHMSText(value)
    local hour = 0
    if value >= HQCONST.SECONDS_ONE_HOUR then
        hour = math.floor(value / HQCONST.SECONDS_ONE_HOUR)
        value = value % HQCONST.SECONDS_ONE_HOUR
    end
    
    local min = 0
    if value >= HQCONST.SECONDS_ONE_MINUTE then
        min = math.floor(value / HQCONST.SECONDS_ONE_MINUTE)
        value = value % HQCONST.SECONDS_ONE_MINUTE
    end
    
    local sec = math.floor(value)
    return string.format("%02d:%02d:%02d", 
                    hour, min, sec)
end

function _M.inTimeRange(time, startTime, endTime)
    time = os.time(time)
    startTime = os.time(startTime)
    endTime = os.time(endTime)
    if time >= startTime and time < endTime then
        return true
    else
        return false
    end
end

function _M.formatConfigTime(time, dailyRefresh)
    local data = {
        year = tonumber("20" .. string.sub(time, 1, 2)),
        month = tonumber(string.sub(time, 3, 4)),
        day = tonumber(string.sub(time, 5, 6)),
    }

    if dailyRefresh == true then
        local time = global.miscData:getDailyRereshTime()
        local tm = datetime.tosvrgmtm(time)
        data.hour = tm.hour
        data.min = tm.min
        data.sec = tm.sec
    end

    return data
end

----时间戳转换成对应时间table
function _M.formatTimeToTime(s,isWorldTime)
    
    s = s or 0
    if isWorldTime then
        
        if s == 0 then

            return {
                year  = 0,
                month = 0,
                day   = 0,
                hour  = 0,
                minute = 0,
                second = 0,
            }   
        end

        s = s - global.dataMgr:getServerTimeZoneAdd()
    end    

    local time = {
        year  = tonumber(os.date("%Y", s)), 
        month = tonumber(os.date("%m", s)), 
        day   = tonumber(os.date("%d", s)),
        hour  = tonumber(os.date("%H", s)),
        minute = tonumber(os.date("%M", s)),
        second = tonumber(os.date("%S", s)),
    }
    return time
end

----字符串日期转换成时间戳   
function _M.formatStringToTime(s)
    local time = os.time({
        year  = tonumber(string.sub(s,1,4)), 
        month = tonumber(string.sub(s,5,6)), 
        day   = tonumber(string.sub(s,7,8)), 
        hour  = tonumber(string.sub(s,9,10))}) 
    return time
end

--时间中文格式： x时 
function _M.formatTimeToDHMS1(value)
    if value >= define.DAY then
		return string.format(global.luaCfg:get_local_string(10903), math.floor(value / define.DAY))
    elseif value >= define.HOUR then
        return string.format(global.luaCfg:get_local_string(10904), math.floor(value / define.HOUR))
    elseif value >= define.MINUTE then
        return string.format(global.luaCfg:get_local_string(10905), math.floor(value / define.MINUTE))
    else
        return string.format(global.luaCfg:get_local_string(10906), math.floor(value))
	end    
end

--时间中文格式： x时 x分 
function _M.formatTimeToDHMS2(value)
	local time = ""
	local number = value
	local count = 0
    
	local day, dayText
	if number >= define.DAY then
		day = math.floor(number / define.DAY)
		dayText = string.format(global.luaCfg:get_local_string(10903), day)
		number = number % define.DAY
	end
    
	local hour, hourText
	if number >= define.HOUR then
		hour = math.floor(number / define.HOUR)
		hourText = string.format(global.luaCfg:get_local_string(10907), hour)
		number = number % define.HOUR
	end
    
	local minute, minuteText
	if number >= define.MINUTE then
		minute = math.floor(number / define.MINUTE)
		minuteText = string.format(global.luaCfg:get_local_string(10908), minute)
		number = number % define.MINUTE
	end
    
	local second, secondText
	if number >= 0 then
        if (day and day > 0)
            or (hour and hour > 0)
            or (minute and minute > 0) then
          	second = math.floor(number)
        else
        	if number > 10 then
          		second = math.floor(number)
          	else
          		second = math.ceil(number)
          	end
        end
		secondText = string.format(global.luaCfg:get_local_string(10906), second)
	end
    
	local list = {
        {day, dayText},
        {hour, hourText},
        {minute, minuteText},
        {second, secondText},
    }
    
	
	local count = table.getn(list)
	for i=1, count do
		local data = list[i]
		local dataValue = data[1]
		local dataText = data[2]
		if dataValue and dataValue > 0 then
			local temp = list[i + 1]
			if temp ~= nil then
				local tempValue = temp[1]
				local tempText = temp[2]
				if tempValue and tempValue > 0 then
					time = string.format("%s%s", dataText, tempText)
				else
					time = dataText
				end
			else
				time = dataText
			end
            
			break
		end
	end
    
	if time == "" then
		time = global.luaCfg:get_local_string(10821)
	end
    
	--log.debug("toFormatTime:%s", time)
	return time
end

--时间格式： 12:30
function _M.formatTimeToHM(value,isConvert)
    if isConvert then
        value = _M.convertCurrZoneTime(value)
    end
    local d = _M._toFormatTime(value)
    if value == 0 then
        d.hour = 24
    end
    return string.format("%02d:%02d", 
                    d.hour, d.minute)
end

-- 倒计时形势 00:00
function _M.formatTimeToMS( time )
    
    local str = ""    
    local min = math.floor(time / 60)
    time = time % 60
    local sec = math.floor(time) 

    str =  string.format('%02d:%02d',min,sec) 
    return str
end

--时间格式： 12:30:00
function _M.formatTimeToHMS(value)
    
    local d = _M._toFormatTime(value)
    if d.day == 0 then
        return string.format("%02d:%02d:%02d", 
                    d.hour, d.minute, d.second)
    else
        return string.format("%02d:%02d:%02d", 
                    d.day * 24 + d.hour, d.minute, d.second)
    end
end

function _M.formatTimeToDHMS(value)
    local d = _M._toFormatTime(value)
    if d.day == 0 then
        return string.format("%02d:%02d:%02d", 
                    d.hour, d.minute, d.second)
    else
        return string.format("%dD %02d:%02d:%02d", 
                    d.day,d.hour, d.minute, d.second)
    end
end

--时间格式： 2016-04-03 ff:ff:ff
function _M.formatTimeToYMDHMS(value)
    local d = _M.formatTimeToTime(value)
    return string.format("%d-%d-%d %02d:%02d:%02d",d.year,d.month,d.day,
                d.hour, d.minute, d.second)
end

--时间格式： 2016-04-03
function _M.formatTimeToYMD(value)
    local d = _M.formatTimeToTime(value)
    return string.format("%d-%d-%d",d.year,d.month,d.day,
                d.hour, d.minute, d.second)
end
--时间格式： 04-03 ff:ff
function _M.formatTimeToMDHMS(value)
    local d = _M.formatTimeToTime(value)
    return string.format("%02d-%02d %02d:%02d",d.month,d.day,
                d.hour, d.minute)
end

function _M.formatTimeToHMSByLargeTime(value)
    local d = _M.formatTimeToTime(value)
    return string.format("%02d:%02d:%02d",d.hour, d.minute, d.second)
end

function _M._toFormatTime(time)
    local data = {
        day = 0,
        hour = 0,
        minute = 0,
        second = 0,
        time = time,
    }
    local value = time
    if value >= define.DAY then
        data.day = math.floor(value / define.DAY)
        value = value % define.DAY
    end
    
    if value >= define.HOUR then
        data.hour = math.floor(value / define.HOUR)
        value = value % define.HOUR
    end
    
    if value >= define.MINUTE then
        data.minute = math.floor(value / define.MINUTE)
        value = value % define.MINUTE
    end
    
    data.second = math.floor(value)
    return data
end

--多久之前，
function _M.getDurationToNow(time)
    local timeData = _M._toFormatTime(global.dataMgr:getServerTime()-time)
    local str = ""
    if timeData.day <= 0 then
        if timeData.hour <= 0 then
            if timeData.minute <= 0 then
                if timeData.second <= 0 then
                else
                    str = string.format("%s%s",timeData.second,global.luaCfg:get_local_string(10089))
                end
            else
                str = string.format("%s%s",timeData.minute,global.luaCfg:get_local_string(10088))
            end
        else
            str = string.format("%s%s",timeData.hour,global.luaCfg:get_local_string(10087))
        end
    else
        str = string.format("%s%s",timeData.day,global.luaCfg:get_local_string(10086))
    end
    return str
end



local printTime = 0
local id = 0
function _M:printWithTime(msg)
    local time = os.clock()
    print("[printWithTime]",msg,time - printTime,"id:",id)
    printTime = time
    id = id + 1
end