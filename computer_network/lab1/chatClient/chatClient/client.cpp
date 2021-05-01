// Client.cpp: implementation of the CClient class.

#include "framework.h"
#include "chatClient.h"
#include "client.h"

client::client(){}
client::~client() {}
bool client::InitClient(HWND hwnd, INT port, CString ip)
{
	WSADATA wasdata;
	int faultDetails;
	faultDetails = WSAStartup(MAKEWORD(2,2), &wasdata);
	if (faultDetails != 0)
	{
		AfxMessageBox("WSAStartup½¨Á¢Ê§°Ü");
		return false;
	}
	clientsocket = socket(AF_INET, SOCK_STREAM, IPPROPO_TCP);
	WSAAsyncSelect(clientsocket, hwnd, CLI_MESSAGE, FD_CONNECT | FD_READ | FD_CLOSE);
	serveraddr.sin_port = htons(port);
	serveraddr.sin_family = AF_INET;
	const char* b = CStringA(ip);
	serveraddr.sin_addr.S_un.S_addr = inet_addr(b);
	faultDetails= connect(clientsocket, (SOCKADDR*)&serveraddr, sizeof(serveraddr));
	return true;
}