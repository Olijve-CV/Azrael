#ifndef TIMER_H
#define TIMER_H


#include <map>
#include "luasvr.h"
#include "lunar.h"

struct stTime
{
	unsigned int index;
	int expires;
	unsigned int cycle;
	unsigned int lasttime;
};


typedef std::map<int, stTime> TimerMap;

class Timer
{
public:
	LUA_EXPORT(Timer)
	Timer(void);
	~Timer(void);

	static Timer* get();
	virtual bool init();
	int update(unsigned int dtime);

protected:
	static int addTimer(lua_State* L);
	static int delTimer(lua_State* L);
	int callTimer(TimerMap::iterator& iter, unsigned int index, unsigned int diff);

private:
	TimerMap		timerMap_;
	static Timer*	timer_;
	lua_State*		m_L;
};


#endif //TIMER_H

