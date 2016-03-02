#include <stdio.h>
#include "DBServer.h"

int main(int argc, char *argv[])
{
#ifdef WIN32
#	ifdef _DEBUG
	_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF|_CRTDBG_LEAK_CHECK_DF);
#	endif
#endif
	DBServer game;
	if ( !game.init(argc, argv))
	{
		ERROR("init failed!");
	}
	else
	{
		game.start();
	}

	return 0;
}