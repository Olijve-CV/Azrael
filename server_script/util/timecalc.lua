--定期保存的数据

local gtStandardTime = {2015,11,16,0,0,0}
local giStandardTime = os.time({year=2015, month=11, day=16, hour=0, min=0, sec=0})

--从1970年1月1日8点至今经过的秒数
function G_GetSecond()
	return os.time()
end

--时间戳,小时序号,从1开始
function G_GetHourNo(i)
	if not i then
		i=G_GetSecond()
	end
	return math.floor((i-giStandardTime)/3600+1)
end

--时间戳,天序号,从1开始
function G_GetDayNo(i)
	if not i then
		i=G_GetSecond()
	end
	return math.floor((i-giStandardTime)/3600/24+1)
end

--时间戳,周序号,从1开始
function G_GetWeekNo(i)
	if not i then
		i=G_GetSecond()
	end
	return math.floor((i-giStandardTime)/3600/24/7+1)
end

--时间戳,月序号,从1开始
function G_GetMonthNo(i)
	if not i then
		i=G_GetSecond()
	end
	local tTime = os.date("*t", i)
	return math.floor((tTime.year - gtStandardTime[1]) * 12 + (tTime.month - gtStandardTime[2]) + 1)
end



