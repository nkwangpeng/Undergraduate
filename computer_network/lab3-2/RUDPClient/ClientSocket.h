#pragma once
#include <fstream>
#include <map>

#define MAX_PACKET 48000
// ClientSocket 命令目标
struct header {
	char fileName[260];//Windows下完全限定文件名必须少于260个字符，目录名必须小于248个字符。
	bool isAck;
	int seq;
	int clientPort;
	int serverPort;
	int dataLen;
	int totalLen;
	int fileSize;
	WORD checkSum;
};

struct tempUpload {
	CString filePath;
	//int initClientPort;
};
unsigned short ChecksumCompute(unsigned short * buffer, int size);
class ClientSocket : public CAsyncSocket
{
public:
	ClientSocket();
	virtual ~ClientSocket();
	void initReceive200(CString s);		//接收服务器发来的200状态，初始化待下载的文件列表
	int waitFor220(ClientSocket& skt, int clientPort);	//等待服务器的220响应，即是否允许继续下载文件
	bool uploadFile(CString filePath, ClientSocket& skt, int clientPort, int serverPort);	//上传文件
	bool waitACK(ClientSocket& skt, header* hd);	//等待服务器的ack包，用于向服务器上传文件时的超时重传
	virtual void OnReceive(int nErrorCode);			//接受服务器的数据包
	bool processFile(ClientSocket& skt, u_char* raw,int clientPort , bool* window_mask);	//处理文件，将文件分段等
};


