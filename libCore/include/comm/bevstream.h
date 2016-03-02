#ifndef BEVSTREAM_H
#define BEVSTREAM_H

#include "comm.h"
//#define PACKET_SIGN 0xAD
//#define PACKET_HEAD PACKET_SIGN + 1
//#define PACKET_END PACKET_SIGN + 1
//
//
//#define PT_RPC_BASE	100
//#define PT_RPC_STATIC 0xf0000000
//#define PT_RPC_SWITCH 0x08000000
//
//#define MAXPACKETLEN 65535
//#define MAXBUFERLEN	655350

#include <event.h>
#include "buf.h"


struct bufferevent;

//·â×°bufferevent
class BevStream
{
public:
	BevStream(bufferevent* bev=NULL);
	virtual ~BevStream(){}

	void decode();
	void decodeText();
	virtual void doMsg(Buf* buf=NULL)=0;
	virtual void close() = 0;

	int newpacket(uint size);

	virtual void write(void* data, uint len);
	virtual void write(const Buf& buf);
	virtual void copyOnWrite(void* data, uint len);

	void setSeed(int seed);

	void setUserData(const char* ud)
	{
		userData_=ud;
	}

private:
	void decodeInplace(void* data, uint size);
	void innerWrite(void* data, uint size);
	void innerWrite(const Buf& buf);

protected:
	bufferevent* bev_;
	int packetWriteSN_;
	int packetReadSN_;
	uint packLen_;
	int seed_;
	bool conn_;
	std::string userData_;

};


#endif //BEVSTREAM_H


