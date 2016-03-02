--测试定时器

--
function testTimer1(args)
	print("======testTimer1===============")
	print_r(args)
	--timer.RemoveCallLater(timeId)
	--timeId = 0
end
local timeId = 0
local timerCount = 0
function testTimer2(args)
	timerCount = timerCount + 1
	print("======testTimer2============== timerCount=" .. timerCount)
	print_r(args)
	
	if timerCount >= 10 then
		--不要直接调用
		--timer.RemoveCallLater(timeId)
		timeId = 0
		return 0	--表示要删除这个定时器
	end
end
--只执行一次
--timer.CallLater(testTimer1, 1000, 0, {1,2,3})
--执行多次
--timeId = timer.CallLater(testTimer2, 1000, 1, {4,5,6})

