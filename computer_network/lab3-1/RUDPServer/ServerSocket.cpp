// ServerSocket.cpp: 实现文件
//

#include "pch.h"
#include "RUDPServer.h"
#include "ServerSocket.h"
#include "RUDPServerDlg.h"
#include <string>
#include <fstream>
#include <vector>
#include <thread>
#include <ctime>
#include <iostream>
#include <algorithm>

//#define _CRT_SECURE_NO_WARNINGS
using namespace std;

// ServerSocket

ServerSocket::ServerSocket()
{
}

ServerSocket::~ServerSocket()
{
}


// ServerSocket 成员函数

unsigned short ChecksumCompute(unsigned short * buffer, int size) {
	unsigned long cksum = 0;
	while (size > 1)
	{
		cksum += *buffer++;
		size -= sizeof(unsigned short);
	}
	if (size)
	{
		cksum += *(unsigned char *)buffer;
	}
	cksum = (cksum >> 16) + (cksum & 0xffff);
	cksum += (cksum >> 16);
	return (unsigned short)(~cksum);
}

void copyData(char* srcData, char* destData, int len) {
	assert(srcData != NULL && destData != NULL);
	for (int i = 0; i < len; i++)
	{
		destData[i] = srcData[i];
	}
}

void copyDataUchar(u_char* srcData, u_char* destData, int len) {
	assert(srcData != NULL && destData != NULL);
	for (int i = 0; i < len; i++)
	{
		destData[i] = srcData[i];
	}
}

void ServerSocket::OnSend(int nErrorCode)
{
	// TODO: 在此添加专用代码和/或调用基类

	CAsyncSocket::OnSend(nErrorCode);
}

bool ServerSocket::waitACK(ServerSocket &skt,header* hd)
{
	CRUDPServerDlg* pdlg = (CRUDPServerDlg*)AfxGetApp()->GetMainWnd();
	// A buffer for the incoming data.
	char m_szBuffer[4096];
	// What ReceiveFrom Returns.
	int nRead;
	CString host, strp;
	UINT port;
	// 获取接收信息
	//Sleep(15);
	while (1) {
		nRead = skt.ReceiveFrom(m_szBuffer, 4096, host, port, 0);
		if (nRead > 0) break;
	}
	if (ChecksumCompute((unsigned short*)m_szBuffer, nRead) != 0)
	{
		pdlg->displayString(pdlg->m_log, CString("ACK包校验和不为0，丢弃该包"));
		return false;
	}
	// 按 ReceiveFrom 的返回值来判断如何继续
	CString out; int ierr;
	switch (nRead) {
	case 0:
		// this->Close();
		break;
	case SOCKET_ERROR:
		ierr = GetLastError();
		if (ierr== WSAEWOULDBLOCK) {  // currently no data available
			Sleep(5);  // wait and try again
			break;
		}
		//out.Format(L"error: %d", ierr);
		//AfxMessageBox(out);
		//skt.Close();
	default:
		header* recvhd = (header*)(m_szBuffer);	//reinterpret_cast强制类型转换将char型转换为header型，因为ack包传来的只有header
		if (recvhd->isAck) {
			if (hd->clientPort == recvhd->clientPort && hd->serverPort == recvhd->serverPort && hd->seq == recvhd->seq) {
				return true;//ACK的相关信息和当前头部信息对应的话，返回true。传输下一个数据报
			}
		}
	}
	return false;
}

//"200"回复的格式：200 file/file/file
CString ServerSocket::initReply100() {	//收到来自服务器的100 请求后，发送200 文件列表应答给客户端
	CRUDPServerDlg* pdlg = (CRUDPServerDlg*)AfxGetApp()->GetMainWnd(); //应用程序活动主窗口的指针
	CString s = L"200 ";//回应“100”请求

	for (size_t i = 0; i < pdlg->str_fileDeque.size(); ++i) {
		s += pdlg->str_fileDeque[i];
		s += L"/";//每个文件之间用'/'间隔
	}
	return s;
}

void ServerSocket::Reply110(CString s, int clientPort, int serverPort, ServerSocket& skt) {
	//获取客户端想要接收的文件的序号
	int pos = s.Find(L" ");		//传过来的是文件的索引
	CString fileNumStr = s.Mid(pos + 1);	//截取空格后的字符串
	int fileNum = _ttoi(fileNumStr);	//将CString转换成整形

	//设置文件路径和文件流
	CRUDPServerDlg* pdlg = (CRUDPServerDlg*)AfxGetApp()->GetMainWnd();
	CString file = pdlg->str_fileDeque[fileNum];
	CString filePath = pdlg->strDirectoryPath + file;	//待写文件的路径
	ifstream in(filePath, ifstream::ate | ifstream::binary);
	int fileSize=in.tellg();//获取文件大小

	in.seekg(0);//设置文件指针，指向文件开头

	int splice = int(fileSize / MAX_PACKET) + 1;//这个文件会被分成多少片。
	u_char send[50000];//声明要发送的数组
	header* hd = (header*)send;//初始化header
	hd->clientPort = clientPort;
	hd->serverPort = serverPort;
	/*int nameStart = filePath.ReverseFind(_T('\\')) + 1;
	for (int i = nameStart, j = 0; i < filePath.GetLength(); i++,j++) {
		hd->fileName[j] = filePath[i];
	}
	hd->fileName[filePath.GetLength() - nameStart] = '\0';*/

	//给hd->fileName赋值，支持多国语言文件名
	int ns = filePath.ReverseFind(_T('\\')) + 1;
	int nameLen = filePath.GetLength() - ns;
	CString name = filePath.Right(nameLen);
	//CString cs("Hello");
	// Convert a TCHAR string to a LPCSTR
	CT2CA pszConvertedAnsiString(name);
	// construct a std::string using the LPCSTR input
	std::string strFileName(pszConvertedAnsiString);
	//string s = "hello world";
	const char* p = strFileName.c_str();
	memcpy(&hd->fileName[0], p, strlen(p));
	hd->fileName[strlen(p)] = '\0';

	vector<char> buffer(MAX_PACKET, 0); //声明读取文件时用到的vector容器，且内容全置为0

	int seq = 0;//初始化发送序列号
	int retransNum = 0;// 重传次数，下面会用到，重传次数>=30时，认为文件传输完毕但没有收到ack，或者认为客户端已死，结束传输。
	while (!in.eof()) {
		int restData= fileSize - seq * buffer.capacity();//记录还有多少数据等待发送
		int curPos = in.tellg();//保存当前文件读取位置，便于重传

		hd->seq = seq;//设置头部序列号
		hd->isAck = false;//表明这个包不是ack包
		if (restData < 0)//剩余数据为负，代表传输完成，结束传输
			break;
		if (restData < buffer.capacity()) {//剩余数据量小于buffer的容量，只读取和剩余数据量等同大小的块
			in.read(buffer.data(), restData); // vector::data -> A pointer to the first element in the array used internally by the vector.
											//读取指定大小的文件进入vector容器，从vector容器中的第一个元素的位置开始写入
			hd->dataLen = restData;//设置此数据报中数据段的长度
			in.setf(std::ios::eofbit);
		}
		else {
			in.read(buffer.data(), buffer.capacity());
			hd->dataLen = buffer.capacity();//设置此数据报中数据段的长度
		}
		u_char* temp = new u_char[buffer.size()];
		copy(buffer.begin(), buffer.end(), temp);
		hd->dataLen += 4;
		//char* cbuffer = &buffer[0];//声明一个指向buffer开始地址的指针
		hd->totalLen = hd->dataLen + sizeof(struct header);//设置数据报有效部分总长度 = 数据长度 + 报头长度
		copyDataUchar(temp, send + sizeof(struct header), hd->dataLen);
		hd->checkSum = 0;
		//memcpy(send, hd, sizeof(struct header));//send数组的开始部分设置为数据报头部
		//char* t = &send[sizeof(struct header)];//设置t指向send数组中紧连着头部的第一个地址
		//memcpy(t, cbuffer, buffer.size());//将buffer存入send中头部之后的位置
		hd->checkSum = ChecksumCompute((unsigned short*)hd, hd->totalLen);
		//准备要送出去的东西
		int se=skt.SendTo(send, hd->totalLen , clientPort, _T("127.0.0.1"), 0);//发送send到客户端的相应通信端口

		//ACK处理
		clock_t begin = clock();//记录当前时间（开始等待ACK）
		double elapsed_secs = 0;//elapsed_secs用于记录等了ACK多少时间了
		while (1) {//进入死循环，等待ACK
			bool crecv = waitACK(skt,hd);//传入服务器socket和头部信息
			if (!crecv) {//如果没有收到ACK
				crecv = waitACK(skt,hd);//继续等ACK
				clock_t end = clock();
				elapsed_secs = double(end - begin) / CLOCKS_PER_SEC;//过了0.2秒就重传，过了20次未收到ACK就终止传输
				if (retransNum >= 20) {//重传次数>=20时，认为文件传输完毕但没有收到ack，或者认为客户端已死，结束传输。
					break;
				}
				if (elapsed_secs >= 0.5) {
					CString out;
					out.Format(L": %s  \n", L"收不到ack，服务器正在重传");
					out = L"\r\n" + out;
					pdlg->displayString(pdlg->m_log, out);
					in.seekg(curPos);//重置文件指针至之前读取位置
					retransNum++;//重传次数+1
					break;
				}
			}
			else {//收到ACK
				seq++;//序列号+1
				retransNum = 0;//重置重传次数
				CString file(hd->fileName);//显示日志记录
				CString out;
				out.Format(L":(ACK) %d  \n", hd->seq);
				out = L"\r\n" + out;
				out = out + file;
				pdlg->displayString(pdlg->m_log, out);
				break;
			}
		}
		if (retransNum >= 20) {//重传次数>=20时，认为文件传输完毕但没有收到ack，或者认为客户端已死，结束传输。
			CString file(hd->fileName);//显示日志记录
			CString out;
			out.Format(L"终止传输:\n");
			out = L"\r\n" + out;
			out = out + file;
			pdlg->displayString(pdlg->m_log, out);
			break;
		}
	}
}

void ServerSocket::Reply120(CString str, int clientPort, int serverPort, ServerSocket& skt)
{
	CRUDPServerDlg* pdlg = (CRUDPServerDlg*)AfxGetApp()->GetMainWnd();
	char retchar[4096];
	CString s;
	s.Format(L"220 %d\n", serverPort);
	char temp[1024];
	int len = WideCharToMultiByte(CP_ACP, 0, s, -1, NULL, 0, NULL, NULL);
	WideCharToMultiByte(CP_ACP, 0, s, -1, temp, len, NULL, NULL);
	header* hd = (header*)retchar;
	hd->dataLen = strlen((char*)(temp));
	hd->totalLen = hd->dataLen + sizeof(struct header);//设置数据报有效部分总长度 = 数据长度 + 报头长度
	copyData(temp, (retchar + sizeof(header)), hd->dataLen);
	hd->checkSum = 0;
	hd->checkSum = ChecksumCompute((unsigned short*)hd, hd->totalLen);
	skt.SendTo(retchar, hd->totalLen, clientPort, _T("127.0.0.1"), 0);//通知客户端，服务器已经为上传指令开启了新的端口

	while (1) {
		skt.Listen();
		bool done = pdlg->receiveFile(skt, serverPort);
		if (done) {//重新构建文件列表，发送给客户端。
			pdlg->str_fileDeque.clear();
			pdlg->RecursiveFindFile(pdlg->strDirectoryPath, 0);
			pdlg->ShowFile();
			pdlg->displayString(pdlg->m_log, CString("服务器传输更新后的文件列表"));
			CString s = skt.initReply100();		//获取服务器根目录下的文件列表
			pdlg->displayString(pdlg->m_log, s);
			char retchar[4096];
			char temp[1024];
			int len = WideCharToMultiByte(CP_ACP, 0, s, s.GetLength(), NULL, 0, NULL, NULL);
			WideCharToMultiByte(CP_ACP, 0, s, s.GetLength(), temp, len, NULL, NULL);

			header* hd = (header*)retchar;
			hd->dataLen = strlen((char*)temp);
			hd->totalLen = hd->dataLen + sizeof(struct header);
			copyData(temp, (retchar + sizeof(header)), hd->dataLen);
			hd->checkSum = 0;
			hd->checkSum = ChecksumCompute((unsigned short*)hd, hd->totalLen);
			// map<int, vector<int>>::iterator it = skt.clientPortMap.begin();
			// bool find = false;
			// for (it = skt.clientPortMap.begin(); it != skt.clientPortMap.end();) {
			// 	for (int i = 0; i<it->second.size(); i++) {
			// 		if (it->second[i] == clientPort) {
			// 			find = true;
			// 			break;
			// 		}
			// 		it++;
			// 	}
			// 	if (find)
			// 		break;
			// }
			// 	//;//std::cout << it->first << " => " << it->second << '\n';
			// pdlg->usock.SendTo(retchar, strlen(retchar), it->first, _T("127.0.0.1"), 0);
			pdlg->usock.SendTo(retchar, hd->totalLen , clientPort, _T("127.0.0.1"), 0);
			break;
		}
	}
}

char* ServerSocket::CStringToPChar(CString str) {
	int len = str.GetLength();
	char* ret = new char[len + 1];

	for (int i = 0; i < len; ++i) {
		ret[i] = str[i];
	}
	ret[len] = '\0';
	return ret;
}

UINT Downloader(tempForDownAndUp* t) // 数据包捕获工作者线程的控制函数
{
	CRUDPServerDlg* pdlg = (CRUDPServerDlg*)AfxGetApp()->GetMainWnd();
	int serverPort = pdlg->findNextPort() + 60001;//生成新的socket，占用一个新的端口，用于回应客户端的下载指令
	ServerSocket skt;		//为新线程创建套接字
	BOOL Flag = skt.Create(serverPort, SOCK_DGRAM, FD_CLOSE | FD_READ | FD_ACCEPT | FD_CONNECT);
	while (!Flag) {//端口被占用的话就遍历端口数组
		serverPort = pdlg->findNextPort() + 60001;
		Flag = skt.Create(serverPort, SOCK_DGRAM, FD_CLOSE | FD_READ | FD_ACCEPT | FD_CONNECT);
	}
	skt.Reply110(t->strData, t->clientPort, serverPort, skt);
	return 0;
}

UINT Uploader(tempForDownAndUp* t) // 数据包捕获工作者线程的控制函数
{
	CRUDPServerDlg* pdlg = (CRUDPServerDlg*)AfxGetApp()->GetMainWnd();
	int serverPort = pdlg->findNextPort() + 60001;//生成新的socket，占用一个新的端口，用于回应客户端的上传指令
	ServerSocket skt;
	BOOL Flag = skt.Create(serverPort, SOCK_DGRAM, FD_CLOSE | FD_READ | FD_ACCEPT | FD_CONNECT);
	while (!Flag) {//端口被占用的话就遍历端口数组
		serverPort = pdlg->findNextPort() + 60001;
		Flag = skt.Create(serverPort, SOCK_DGRAM, FD_CLOSE | FD_READ | FD_ACCEPT | FD_CONNECT);
	}
	// skt.clientPortMap[t->initClientPort].push_back(t->clientPort);
	skt.Reply120(t->strData, t->clientPort, serverPort, skt);
	return 0;
}

void ServerSocket::OnReceive(int nErrorCode)
{
	// TODO: 在此添加专用代码和/或调用基类
	//CRUDPServerDlg* pdlg = (CRUDPServerDlg*)AfxGetApp()->GetMainWnd();
	CRUDPServerDlg* pdlg = (CRUDPServerDlg*)AfxGetApp()->GetMainWnd();
	// A buffer for the incoming data.
	char m_szBuffer[4096];	//接收客户端报文的缓冲区，大小为
	// What ReceiveFrom Returns.
	int nRead;
	CString host, strp;
	UINT port;
	// 获取接收信息
	nRead = ReceiveFrom(m_szBuffer, 4096, host, port, 0);  //返回接收到的字节数
	/*
	参数一：输入数据的缓冲区。
	参数二：缓冲区的字节长度。
	参数三：IP地址
	参数四：存储一个端口的 UINT。
	参数五：指定调用了的方式。一般为0
	*/
	if (ChecksumCompute((unsigned short *)m_szBuffer, nRead) != 0)
	{
		pdlg->displayString(pdlg->m_log, CString("校验和不为0，丢弃该包"));
		return;
	}
	// 按 ReceiveFrom 的返回值来判断如何继续
	switch (nRead){
		// 如果未发生错误， ReceiveFrom() 则返回已接收的字节数。 
		// 如果连接已关闭，则返回0。 
		// 否则，将返回值 SOCKET_ERROR，并通过调用 GetLastError() 来检索特定的错误代码。
	case 0:
		// this->Close();
		break;
	case SOCKET_ERROR:
		AfxMessageBox(_T("产生了错误"));
		Close();
	default:
		// terminate the string
		m_szBuffer[nRead] = _T('\0');
		char* temp = &m_szBuffer[sizeof(struct header)];
		CString strTextOut;
		strTextOut = string(temp).c_str();
		if (strTextOut.Left(3) == "100") {//收到客户端的"100"请求 如果前三个字符为1、0、0，代表客户端传来的是100请求
			CString s = initReply100();//获取文件列表，构建即将发送的数据x
			pdlg->displayString(pdlg->m_log, s);
			char temp[1024];
			int len = WideCharToMultiByte(CP_ACP, 0, s , s.GetLength(), NULL, 0, NULL, NULL);
			WideCharToMultiByte(CP_ACP, 0, s, s.GetLength(), temp, len, NULL, NULL);
			char retchar[4096];
			// clientPortMap[port];//插入空的键
			header* hd = (header*)retchar;
			hd->dataLen = strlen((char*)temp);
			hd->totalLen = hd->dataLen + sizeof(struct header);
			copyData(temp, (retchar + sizeof(header)), hd->dataLen);
			hd->checkSum = 0;
			hd->checkSum = ChecksumCompute((unsigned short*)hd, hd->totalLen);
			pdlg->usock.SendTo(retchar, hd->totalLen, port, _T("127.0.0.1"), 0);  //传出200请求以及选中的文件
		/*
		参数一：发送数据的缓冲区
		参数二：缓冲区的字节长度
		参数三：标识套接字应用程序的端口
		参数四：此对象与套接字的网络地址
		参数五：指定调用了的方式。一般为0
		*/
		}
		else if (strTextOut.Left(3) == "110") {//收到客户端的"110"请求
			tempForDownAndUp* t = new tempForDownAndUp;
			t->clientPort = port;
			t->strData = strTextOut;

			// 调用 AfxBeginThread() 函数启动工作者线程
			// AfxBeginThread() 函数将返回一个指向新创建线程对象的指针
			//CRUDPClientDlg* p = (CRUDPClientDlg*)AfxGetMainWnd();
			CWinThread* m_Downloader = AfxBeginThread(
				(AFX_THREADPROC)Downloader, // pfnThreadProc：指向工作者线程的控制函数，它的值不能为NULL
				t,
				THREAD_PRIORITY_NORMAL // 用于指定线程的优先级
			);
			if (m_Downloader != nullptr) {
			}
			else {
				AfxMessageBox(L"Download Thread Create Failed.");
			}
		}
		else if (strTextOut.Left(3) == "120") {
			tempForDownAndUp* t = new tempForDownAndUp;
			t->clientPort = port;
			t->strData = strTextOut;
			t->initClientPort = port;
			CWinThread* m_Uploader = AfxBeginThread(
				(AFX_THREADPROC)Uploader, // pfnThreadProc：指向工作者线程的控制函数，它的值不能为NULL
				t,	//传递入线程的参数,注意它的类型为:LPVOID,所以我们可以传递一个结构体入线程.
				THREAD_PRIORITY_NORMAL // 用于指定线程的优先级
			);
			if (m_Uploader != nullptr) {
			}
			else {
				AfxMessageBox(L"Upload Thread Create Failed.");
			}
		}
	}

	CAsyncSocket::OnReceive(nErrorCode);
}


void ServerSocket::OnAccept(int nErrorCode)
{
	// TODO: 在此添加专用代码和/或调用基类

	AfxMessageBox(_T("asd"));

	CAsyncSocket::OnAccept(nErrorCode);
}


bool CRUDPServerDlg::receiveFile(ServerSocket& skt, int clientPort)
{
	CRUDPServerDlg* pdlg = (CRUDPServerDlg*)AfxGetApp()->GetMainWnd();
	// A buffer for the incoming data.
	u_char m_szBuffer[50000];
	// What ReceiveFrom Returns.
	int nRead;
	CString host, strp;
	UINT port;
	// 获取接收信息
	//Sleep(5);
	while (1) {
		nRead = skt.ReceiveFrom(m_szBuffer, 50000, host, port, 0);
		if (nRead > 0) break;
	}
	if (ChecksumCompute((unsigned short*)m_szBuffer, nRead) != 0)			//²î´í¼ìÑé
	{
		pdlg->displayString(pdlg->m_log, CString("校验和不为0，丢弃该包"));
		return false;
	}
	// 按 ReceiveFrom 的返回值来判断如何继续
	CString out; int ierr;
	switch (nRead) {
	case 0:
		break;
	case SOCKET_ERROR:
		ierr = GetLastError();
		if (ierr == WSAEWOULDBLOCK) {  // currently no data available
			Sleep(5);  // wait and try again
			break;
		}
		out.Format(L"error: %d", ierr);
		AfxMessageBox(out);
		skt.Close();
	default:
		CString strTextOut = (CString)m_szBuffer;

		/*if (strTextOut.Left(3) == "200") {
			skt.initReceive200(strTextOut);
		}
		else */{//收到文件报文的话
			header* recvhd = (header*)(m_szBuffer);
			string str(recvhd->fileName);
			if (fileSeq.find(str) == fileSeq.end()) {//如果文件名不在map容器里，说明是新的文件，把它插入容器中
				fileSeq[str] = int(-1);
			}
			bool done = skt.processFile(skt, m_szBuffer, clientPort);//处理报文
			return done;
		}
	}
	return false;
}

bool ServerSocket::processFile(ServerSocket& skt, u_char* raw, int clientPort)
{
	CRUDPServerDlg* pdlg = (CRUDPServerDlg*)AfxGetApp()->GetMainWnd();
	header* recvhd = (header*)(raw);

	string str(recvhd->fileName);
	map<string, int>::iterator it = pdlg->fileSeq.find(str);//在map容器中找到文件

	//CString -> string -> char*
	//CString cs("Hello");
	// Convert a TCHAR string to a LPCSTR
	CT2CA pszConvertedAnsiString(pdlg->strDirectoryPath);
	// construct a std::string using the LPCSTR input
	std::string DirectoryPath(pszConvertedAnsiString);

	u_char* temp = &raw[sizeof(struct header)];//创建一个指向数据段起始地址的指针
	string fileName(recvhd->fileName);
	string filePath = DirectoryPath + fileName;
	const char* cfilePath = filePath.c_str();	//获取将要写操作的文件名

	std::basic_ofstream<u_char> myfile(cfilePath, ios::out | ios::app | ios::binary);

	if (recvhd->seq == it->second + 1) {//如果收到的是期待收到的报文，写入文件。
										//it->second指示的是文件中已经有了第几号报文，期待的下一个报文就是it->second+1
		myfile.write(temp, recvhd->dataLen-4);
		it->second++;
		CString file(recvhd->fileName);//更新日志
		CString out;
		out.Format(L":(seq) %d  ", recvhd->seq);
		out = L"\r\n" + out;
		out = out + file;
		pdlg->displayString(pdlg->m_log, out);

		char retchar[4096];
		header* hd = (header*)retchar;//生成ACK
		hd->clientPort = clientPort;
		hd->serverPort = recvhd->serverPort;
		hd->isAck = true;
		hd->dataLen = 0;
		hd->seq = recvhd->seq;//确认这个报文被接收了
		hd->totalLen = hd->dataLen + sizeof(struct header);
		hd->checkSum = 0;
		hd->checkSum = ChecksumCompute((unsigned short*)hd, hd->totalLen);
		skt.SendTo(retchar, hd->totalLen, recvhd->serverPort, _T("127.0.0.1"), 0);
	}
	else {//resend previous ACK //如果收到的不是期待收到的报文，重发ACK，确认信息是文件目前收到的最后一个报文的序列号。
		CString file(recvhd->fileName);//更新日志
		CString out;
		out.Format(L":(seq) %d  ", recvhd->seq);
		out = L"\r\n" + out;
		out = out + file;
		pdlg->displayString(pdlg->m_log, out);

		char retchar[4096];
		header* hd = (header*)retchar;//生成ACK
		hd->clientPort = clientPort;
		hd->serverPort = recvhd->serverPort;
		hd->isAck = true;
		memcpy(hd->fileName, recvhd->fileName, 260);
		hd->dataLen = 0;
		hd->seq = it->second;//如果收到的不是期待收到的报文，重发ACK，确认信息是文件目前收到的最后一个报文的序列号it->second。
		hd->totalLen = hd->dataLen + sizeof(struct header);
		hd->checkSum = 0;
		hd->checkSum = ChecksumCompute((unsigned short*)hd, hd->totalLen);

		skt.SendTo(retchar, hd->totalLen, recvhd->serverPort, _T("127.0.0.1"), 0);
	}


	if (recvhd->dataLen < MAX_PACKET) {//当报文中数据段的长度小于报文最大长度的时候，说明接收完毕
		return 1;
	}
	else
		return 0;
}
