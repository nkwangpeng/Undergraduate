#pragma once
#include<string>
#include<map>
#include<vector>

#define MAX_PACKET 48000

// ServerSocket 命令目标

struct header {
	char fileName[260];//Windows下完全限定文件名必须少于260个字符，目录名必须小于248个字符。
	bool isAck;  //判断数据报是否为ack包
	int seq;	//数据包的序列号
	int clientPort;	//客户端的端口
	int serverPort;	//服务器端的端口
	int dataLen;	//传输数据长度
	int totalLen;	//传输数据的总长度
	WORD checkSum; //校验和
};

struct tempForDownAndUp {//为了开启一个线程随意创建的临时变量
	CString strData;
	int clientPort;
	int initClientPort;
};
unsigned short ChecksumCompute(unsigned short * buffer, int size);
class ServerSocket : public CAsyncSocket
{
public:
	ServerSocket();		//默认构造函数
	virtual ~ServerSocket();	//析构函数
	virtual void OnSend(int nErrorCode);
	bool waitACK(ServerSocket& skt, header* hd); //等待客户端传过来的ack包
	CString initReply100();	//初始化100状态，即得到服务器根目录下的文件
	void Reply110(CString str, int clientPort, int serverPort, ServerSocket& skt);  //回答客户端的110状态
	void Reply120(CString str, int clientPort, int serverPort, ServerSocket& skt);	//回答客户端的120状态
	char* CStringToPChar(CString str);
	virtual void OnReceive(int nErrorCode);
	virtual void OnAccept(int nErrorCode);
	bool processFile(ServerSocket& skt, u_char* raw, int clientPort);		//切片读取文件
	// std::map<int, std::vector<int> > clientPortMap;			//存储客户端的通信端口
};


