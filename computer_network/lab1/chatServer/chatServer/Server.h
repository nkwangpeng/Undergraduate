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
	bool bulidServer(HWND hwnd, INT port);	//�ж��Ƿ�ɹ������˷���������Ҫ�����˿ںźͶ�Ӧ�Ĵ��ھ��
	HWND m_hwnd;  //���ھ��
	UINT m_port;	//�˿ں�
	sockaddr_in serveraddr;   //sockaddr��sockaddr_in���Խ�������ת��,ʹ��Socketaddr�����Ժã�ʹ��socketaddr_in�������������
							  //������ַ�壬�˿ںţ�32λip��ַ�������ԡ�
	SOCKET serversocket;	  //socket��
	Server();  //Ĭ�Ϲ��캯��
	~Server();	//��������
};