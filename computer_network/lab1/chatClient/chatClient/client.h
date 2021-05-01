/*
code by 1811431 wangpeng
2020-10-20
*/
#include "winsock.h"
#include <atlstr.h>

#define CLI_MESSAGE WM_USER+100

class client
{
public:
	client();   //默认构造函数
	~client();
	bool InitClient(HWND hwnd, INT port, CString ip);
	SOCKET clientsocket;
private:
	HWND hwnd;
	INT port;
	sockaddr_in serveraddr;
};