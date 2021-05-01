/*
code by 1811431 wangpeng
2020-10-19
*/
#include "pch.h"
#include "Server.h"
#include "chatServer.h"
Server::Server() {}  //��д���캯��
Server::~Server() {} //��д��������
bool Server::bulidServer(HWND hwnd, INT port) {
	WSADATA wsadata;
	int faultDetails = WSAStartup(MAKEWORD(2, 2), &wsadata);  //����汾��2.2����ǰ�趨��WSADATA wsaData;���Լ�¼����Socket��ϸ��Ϣ
	if (faultDetails!=0) {
		AfxMessageBox("WSAStartup��ʼ��ʧ��");
		return false;
	}
	serversocket = socket(AF_INET, SOCK_STREAM, 0);//������ʽ�����
	WSAAsyncSelect(serversocket,hwnd, SER_MESSAGE, FD_ACCEPT | FD_READ | FD_CLOSE);  //��һ��socket�Ͻ�����windows��ϢΪ�����������¼����ṩ��д���ݵ��첽֪ͨ����
	//sockaddr�ṹ���ںܴ��ȱ�ݣ����õ�ѡ����ѡ��ʹ��sockaddr_in���ٽ����������ת��
	serveraddr.sin_family = AF_INET;   //�����ַ��
	serveraddr.sin_port = htons(port);	//����˿ں�
	serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);   //����32λip��ַ 
	faultDetails = bind(serversocket, (SOCKADDR*)&serveraddr, sizeof(serveraddr));    //ִ��bind����
	if (faultDetails != 0) {
		AfxMessageBox("bindִ��ʧ��");
		return false;
	}
	faultDetails = listen(serversocket,4);  //����Ŀ���Ƕ���ͨ�ţ�������õȴ�����Ϊ4����ȻҲ���Ը���
	if (faultDetails != 0) {
		AfxMessageBox("listenִ��ʧ��");
		return false;
	}
	return true;
}

