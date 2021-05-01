/*
code by 1811431 wangpeng
2020-10-19
*/
#include "pch.h"
#include "Server.h"
#include "chatServer.h"
Server::Server() {}  //重写构造函数
Server::~Server() {} //重写析构函数
bool Server::bulidServer(HWND hwnd, INT port) {
	WSADATA wsadata;
	int faultDetails = WSAStartup(MAKEWORD(2, 2), &wsadata);  //定义版本号2.2，先前需定义WSADATA wsaData;用以记录可用Socket详细信息
	if (faultDetails!=0) {
		AfxMessageBox("WSAStartup初始化失败");
		return false;
	}
	serversocket = socket(AF_INET, SOCK_STREAM, 0);//采用流式服务端
	WSAAsyncSelect(serversocket,hwnd, SER_MESSAGE, FD_ACCEPT | FD_READ | FD_CLOSE);  //在一个socket上接收以windows消息为基础的网络事件。提供读写数据的异步通知功能
	//sockaddr结构存在很大的缺陷，更好的选择是选择使用sockaddr_in，再将其进行类型转换
	serveraddr.sin_family = AF_INET;   //定义地址族
	serveraddr.sin_port = htons(port);	//定义端口号
	serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);   //定义32位ip地址 
	faultDetails = bind(serversocket, (SOCKADDR*)&serveraddr, sizeof(serveraddr));    //执行bind函数
	if (faultDetails != 0) {
		AfxMessageBox("bind执行失败");
		return false;
	}
	faultDetails = listen(serversocket,4);  //由于目标是多人通信，因此设置等待队列为4，当然也可以更多
	if (faultDetails != 0) {
		AfxMessageBox("listen执行失败");
		return false;
	}
	return true;
}

