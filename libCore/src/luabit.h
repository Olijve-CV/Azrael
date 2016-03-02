#ifndef LUABIT_H
#define LUABIT_H

#include "lunar.h"

class Bit
{
public:
	LUA_EXPORT(Bit)

	//export function
	static int bnot(lua_State* L);
	static int band(lua_State* L);
	static int band64(lua_State* L);
	static int bor(lua_State* L);
	static int bor64(lua_State* L);
	static int bxor(lua_State* L);
	static int blsh(lua_State* L);
	static int blsh64(lua_State* L);
	static int brsh(lua_State* L);
	static int brsh64(lua_State* L);
	static int onBit(lua_State* L);
	static int offBit(lua_State* L);
	static int isBitOn(lua_State* L);
};


#endif //!LUABIT_H

