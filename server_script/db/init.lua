--print(package.path)
--package.path = "../server_script/?.lua;" .. package.path
--package.path = "./?.lua" .. package.path
--print(package.path)
--C++层类
C_LuaNetWork = LuaNetwork		--网络
C_Bit = Bit						--位操作

C_Connection = Connection 		--连接
--C++层类函数
C_TableToStr = TableToStr 		--表转换成字符串
C_Log = Log 					--日志
C_Info = Info 					--日志
C_Error = Error 				--日志
C_GetServerID = GetServerID 	--服务器ID
C_GetConfig = GetConfig 		--日志
C_GetMTime = GetMTime 			--时间
C_StopServer = StopServer 		--进程停止
C_GetHashCode = GetHashCode 	--hash值


--启动服务器C层入口
function c_main()
	print("\n\n\n\n\n\n")
	print("=====dbb=c_main=====1111==========")

	--require "test"
	require "db.loadRequire"
	
	print(C_Bit)
	print(C_Bit.bnot)
	print(C_LuaNetWork)
	print(C_Connection)

	init()
end

--定时器，C层调用
function CHandlerTimer(id)
	print("====db =CHandlerTimer============")
	return timer.DoTimer(id)
end


G_ServerId = 0

function init()
	print("====db==init===============")
	G_ServerId = C_GetServerID()
	print("G_ServerId = " .. G_ServerId)

	--timer.CallLater(Net.TestSendPacket, 1000)

	mysql.mysql_init()
	hiredis.hiredis_init()
end


function CHandlerMsg(target, sn, eid, fid, data, startPos, size)
	Net.doHandlerMsg(target, sn, eid, fid, data, startPos, size)
end


function CHandlerConnect()
	print("=======db =CHandlerConnect=============")
end

function CHandlerDisticonnect()
	print("======db =CHandlerDisticonnect==============")	
end

--错误信息
function CHandlerError(err)
	print("======db ==CHandlerError=============")
	--print(err)
end















