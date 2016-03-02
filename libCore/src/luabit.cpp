#include "luabit.h"
#include "celltype.h"

LUA_IMPLE(Bit, Bit);
LUA_METD(Bit)
LUA_METD_END
LUA_FUNC(Bit)
L_METHOD(Bit, bnot)
L_METHOD(Bit, band)
L_METHOD(Bit, band64)
L_METHOD(Bit, bor)
L_METHOD(Bit, bor64)
L_METHOD(Bit, bxor)
L_METHOD(Bit, blsh)
L_METHOD(Bit, blsh64)
L_METHOD(Bit, brsh)
L_METHOD(Bit, brsh64)
L_METHOD(Bit, onBit)
L_METHOD(Bit, offBit)
L_METHOD(Bit, isBitOn)
LUA_FUNC_END


int Bit::bnot(lua_State* L)
{
	int value = lua_tonumber(L, -1);
	lua_pushnumber(L, ~value);
	return 1;
}
int Bit::band(lua_State* L)
{
	int rvalue = lua_tointeger(L, -1);
	int lvalue = lua_tointeger(L, -2);
	lua_pushnumber(L, rvalue&lvalue);
	return 1;
}
int Bit::band64(lua_State* L)
{
	int64 rvalue = lua_tointeger(L, -1);
	int64 lvalue = lua_tointeger(L, -2);
	lua_pushnumber(L, rvalue&lvalue);
	return 1;
}
int Bit::bor(lua_State* L)
{
	int rvalue = lua_tointeger(L, -1);
	int lvalue = lua_tointeger(L, -2);
	lua_pushnumber(L, rvalue|lvalue);
	return 1;
}
int Bit::bor64(lua_State* L)
{
	int64 rvalue = lua_tointeger(L, -1);
	int64 lvalue = lua_tointeger(L, -2);
	lua_pushnumber(L, rvalue|lvalue);
	return 1;
}
int Bit::bxor(lua_State* L)
{
	int rvalue = lua_tointeger(L, -1);
	int lvalue = lua_tointeger(L, -2);
	lua_pushnumber(L, rvalue^lvalue);
	return 1;
}
int Bit::blsh(lua_State* L)
{
	int rvalue = lua_tointeger(L, -1);
	int lvalue = lua_tointeger(L, -2);
	lua_pushnumber(L, rvalue<<lvalue);
	return 1;
}
int Bit::blsh64(lua_State* L)
{
	int64 rvalue = lua_tointeger(L, -1);
	int64 lvalue = lua_tointeger(L, -2);
	lua_pushnumber(L, rvalue<<lvalue);
	return 1;
}
int Bit::brsh(lua_State* L)
{
	int rvalue = lua_tointeger(L, -1);
	int lvalue = lua_tointeger(L, -2);
	lua_pushnumber(L, rvalue>>lvalue);
	return 1;
}
int Bit::brsh64(lua_State* L)
{
	int64 rvalue = lua_tointeger(L, -1);
	int64 lvalue = lua_tointeger(L, -2);
	lua_pushnumber(L, rvalue>>lvalue);
	return 1;
}
int Bit::onBit(lua_State* L)
{
	unsigned int num = lua_tointeger(L, 1);
	unsigned int idx = lua_tointeger(L, 2);
	unsigned mask = 1;

	if( idx >= 1 && idx <= 32)
	{
		if (idx > 1)
			mask <<= (idx - 1);
		num |= mask;
		lua_pushinteger(L, num);
		return 1;
	}
	lua_pushinteger(L, num);
	return 1;
}
int Bit::offBit(lua_State* L)
{
	unsigned int num = lua_tointeger(L, 1);
	unsigned int idx = lua_tointeger(L, 2);
	unsigned mask = 1;

	if( idx >= 1 && idx <= 32)
	{
		if (idx > 1)
			mask <<= (idx - 1);
		num ^= mask;
		num &= mask;
		lua_pushinteger(L, num);
		return 1;
	}
	lua_pushinteger(L, num);
	return 1;
}
int Bit::isBitOn(lua_State* L)
{
	unsigned int num = lua_tointeger(L, 1);
	unsigned int idx = lua_tointeger(L, 2);
	unsigned mask = 1;

	if( idx >= 1 && idx <= 32)
	{
		if (idx > 1)
			mask <<= (idx - 1);
		if (mask & num)
		{
			lua_pushinteger(L, 1);
			return 1;
		}
	}
	lua_pushinteger(L, 0);
	return 1;
}

