#ifndef MSG_H
#define MSG_H

//协议定义
#define PT_SERVER_START 0x1000001
#define PT_SERVER_OFFLINE 0x1000002
#define PT_SERVER_STOP	0x1000003

#define PT_CLIENT_OFFLINE 0x1000004
#define PT_CLIENT_SWITCH_SERVER 0x1000005
#define PT_REDIECT_MSG 0x1000006
#define PT_NETTEST_MSG 10254

#define Svr_Gateway 1
#define Svr_Game 2
#define Svr_Fight 3
#define Svr_Match 4
#define HEART_BEAT 30
#define CMD_LOGIN 3


#endif //MSG_H

