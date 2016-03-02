#include "lunar.h"

class StringBuilder;
class LuaGlobal
{
public:
	LUA_EXPORT(LuaGlobal)

	//export function
	static int TableToStr(lua_State* L);
	static int Log(lua_State* L);
	static int Info(lua_State* L);
	static int Error(lua_State* L);
	static int GetServerID(lua_State* L);
	static int GetConfig(lua_State* L);
	static int GetMTime(lua_State* L);
	static int StopServer(lua_State* L);
	static int GetHashCode(lua_State* L);
};
