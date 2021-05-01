/*
code by 1811431 wangpeng
2020-10-19
*/
#pragma once
#include "winsock.h"
#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "winsock.h"

#define SER_MESSAGE WM_USER+100
class Server
{
public:
	bool bulidServer(HWND hwnd, INT port);	//判断是否成功建立了服务器，需要参数端口号和对应的窗口句柄
	HWND m_hwnd;  //窗口句柄
	UINT m_port;	//端口号
	sockaddr_in serveraddr;   //sockaddr和sockaddr_in可以进行类型转换,使用Socketaddr兼容性好，使用socketaddr_in方则便数据引用
							  //包括地址族，端口号，32位ip地址三个属性。
	SOCKET serversocket;	  //socket类
	Server();  //默认构造函数
	~Server();	//析构函数
};