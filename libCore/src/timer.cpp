#include "timer.h"
#include "arch.h"

Timer* Timer::timer_ = NULL;

LUA_IMPLE(Timer, Timer);
LUA_METD(Timer)
LUA_METD_END
LUA_FUNC(Timer)
L_METHOD(Timer, addTimer)
L_METHOD(Timer, delTimer)
LUA_FUNC_END



Timer* Timer::get()
{
	return timer_;
}

Timer::Timer()
{
	m_L = NULL;
	timer_ = this;
}

Timer::~Timer()
{

}


bool Timer::init()
{
	m_L = LuaSvr::get()->L();
	return true;
}

//增加定时操作
int Timer::addTimer(lua_State *L)
{
	Timer *timer = Timer::get();
	if (!timer)
		return 0;
	
	int exp,cycle,id;
	Lua::argParse(L, "iii", &exp, &cycle, &id);
	
	stTime timeInfo;
	timeInfo.index = id;	//id
	timeInfo.lasttime = timer_get_time();	//上一次执行时间
	timeInfo.cycle = cycle;					//时间周期
	timeInfo.expires = exp;					//有效期

	timer->timerMap_.insert(std::make_pair(id, timeInfo));
	return 0;
}

//删除定时操作
int Timer::delTimer(lua_State *L)
{
	Timer *timer = Timer::get();
	if(!timer)
		return 0;
	
	int id;
	Lua::argParse(L, "i", &id);
	if (id > 0)
	{
		TimerMap::iterator iter = timer->timerMap_.find(id);
		if (iter != timer->timerMap_.end())
		{
			timer->timerMap_.erase(iter);
			lua_pushboolean(L, true);
			return 1;
		}
	}
	lua_pushboolean(L, false);
	return 1;
}

//执行定时器操作
int Timer::update(unsigned int dtime)
{
	if (timerMap_.empty())
	{
		return 0;
	}

	//当前时间
	unsigned int curTime = timer_get_time();
	uint64 timeDiff = 0;
	
	int ret = 0;
	TimerMap::iterator iter = timerMap_.begin();
	for(; iter != timerMap_.end() ;)
	{
		ret = 1;
		stTime &timer = iter->second;
		//时间间隔
		timeDiff = GetTimeDiff(curTime, timer.lasttime);
		
		//时间到，执行完就删除
		if(timer.expires <= 0 && timeDiff >= timer.cycle)
		{
			ret = callTimer(iter, timer.index, 0);
			timer.lasttime = curTime;
			//ret = 1;
		}
		//有效期时间到
		else if( timer.expires > 0 && timeDiff >= timer.expires)
		{
			ret = callTimer(iter, timer.index, 0);
			timer.expires = 0;
			timer.lasttime = curTime;
		}

		if (ret != 1)
		{
			timerMap_.erase(iter++);
		}
		else
		{
			iter++;
		}
	}
	return 1;
}

//调用lua脚本
int Timer::callTimer(TimerMap::iterator& iter, unsigned int id, unsigned int diff)
{
	int res = 0;
	LuaSvr::get()->getRef("CHandlerTimer");
	lua_pushinteger(m_L, id);

	if (LuaSvr::scriptCall(m_L, 1, 1))
	{
		res = lua_tointeger(m_L, -1);
		lua_pop(m_L, 1);
	}
	return res;
}