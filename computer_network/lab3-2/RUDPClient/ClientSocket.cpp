// ClientSocket.cpp: 实现文件
//

#include "pch.h"
#include "RUDPClient.h"
#include "ClientSocket.h"
#include "RUDPClientDlg.h"
#include <vector>
#include <string>
#include <iostream>

using namespace std;
// ClientSocket

ClientSocket::ClientSocket()
{
}

ClientSocket::~ClientSocket()
{
}

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
void copyDataUchar(u_char* srcData, u_char* destData, int len) {
	assert(srcData != NULL && destData != NULL);
	for (int i = 0; i < len; i++)
	{
		destData[i] = srcData[i];
	}
}

// ClientSocket 成员函数

//处理初始化数据报 //"200"回复的格式：200 file/file/file
void ClientSocket::initReceive200(CString s) {
	int curPos;
	int startPos = s.Find(' ');//找到文件列表开始的位置。
	curPos = startPos;
	CRUDPClientDlg* pdlg = (CRUDPClientDlg*)AfxGetApp()->GetMainWnd();

	while (curPos < s.GetLength()) {
		int nextFilePos = s.Find(_T("/"), curPos+1);
		if (nextFilePos < 0)
			break;
		int nCount = nextFilePos - curPos - 1;
		CString temp = s.Mid(curPos + 1, nCount);//截取文件名
		pdlg->str_fileDeque.push_back(temp);//将得到的数据填充进文件列表双端队列str_fileDeque
		curPos = nextFilePos;
	}

	pdlg->ShowFile();//在列表框控件m_fileList中展示
}

int ClientSocket::waitFor220(ClientSocket& skt, int clientPort)
{
	CRUDPClientDlg* pdlg = (CRUDPClientDlg*)AfxGetApp()->GetMainWnd();
	// A buffer for the incoming data.
	char m_szBuffer[4096];
	// What ReceiveFrom Returns.
	int nRead;
	CString host, strp;
	UINT port;
	// 获取接收信息
	//Sleep(5);
	while (1) {
		nRead = skt.ReceiveFrom(m_szBuffer, 4096, host, port, 0);
		if (nRead > 0) break;
	}
	if (ChecksumCompute((unsigned short*)m_szBuffer, nRead) != 0)
	{
		pdlg->displayString(pdlg->m_log, CString("220包校验和不为0，丢弃该包"));
		return -1;
	}
	// 按 ReceiveFrom 的返回值来判断如何继续
	CString out; int ierr;
	switch (nRead) {
	case 0:
		// this->Close();
		break;
	case SOCKET_ERROR:
		ierr = GetLastError();
		if (ierr == WSAEWOULDBLOCK) {  // currently no data available
			Sleep(5);  // wait and try again
			break;
		}
		//out.Format(L"error: %d", ierr);
		//AfxMessageBox(out);
		//skt.Close();
	default:
		// terminate the string
		m_szBuffer[nRead] = _T('\0');
		char* temp = &m_szBuffer[sizeof(struct header)];
		CString strTextOut;
		strTextOut = string(temp).c_str();
		if (strTextOut.Left(3) == "220") {//收到客户端的"200"回复
			int portStartPos = strTextOut.Find(_T(" "));
			int portEndPos = strTextOut.Find(_T("\n"));
			CString serverPortStr = strTextOut.Mid(portStartPos + 1, portEndPos - 1);
			int serverPort = _ttoi(serverPortStr);
			return serverPort;
		}
		else {
			break;
		}
	}

	return -1;
}

bool ClientSocket::uploadFile(CString filePath, ClientSocket& skt, int clientPort, int serverPort)
{
	CRUDPClientDlg* pdlg = (CRUDPClientDlg*)AfxGetApp()->GetMainWnd();
	ifstream in(filePath, ifstream::ate | ifstream::binary);
	int fileSize = in.tellg();//获取文件大小

	in.seekg(0);//设置文件指针，指向文件开头

	int splice = int(fileSize / MAX_PACKET) + 1;//这个文件会被分成多少片。
	u_char send[50000];//声明要发送的数组
	header* hd = (header*)send;//初始化header
	hd->clientPort = serverPort;
	hd->serverPort = clientPort;
	/*int nameStart = filePath.ReverseFind(_T('\\')) + 1;
	for (int i = nameStart, j = 0; i < filePath.GetLength(); i++,j++) {
		hd->fileName[j] = filePath[i];
	}
	hd->fileName[filePath.GetLength() - nameStart] = '\0';*/

	//给hd->fileName赋值，支持多国语言
	int ns = filePath.ReverseFind(_T('\\'))+1;
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
		int restData = fileSize - seq * buffer.capacity();//记录还有多少数据等待发送
		int curPos = in.tellg();//保存当前文件读取位置，便于重传

		hd->seq = seq;//设置头部序列号
		hd->isAck = false;//表明这个包不是ack包
		if (restData < 0)//剩余数据为负，代表传输完成，结束传输
			return true;
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
		hd->totalLen = hd->dataLen + sizeof(struct header);
		copyDataUchar(temp, send + sizeof(struct header), hd->dataLen);
		hd->checkSum = 0;
		hd->checkSum = ChecksumCompute((unsigned short*)hd, hd->totalLen);
		//准备要送出去的东西
		int se = skt.SendTo(send, hd->totalLen, serverPort, _T("127.0.0.1"), 0);//发送send到客户端的相应通信端口

		//ACK处理
		clock_t begin = clock();//记录当前时间（开始等待ACK）
		double elapsed_secs = 0;//elapsed_secs用于记录等了ACK多少时间了
		while (1) {//进入死循环，等待ACK
			bool crecv = waitACK(skt, hd);//传入服务器socket和头部信息
			if (!crecv) {//如果没有收到ACK
				crecv = waitACK(skt, hd);//继续等ACK
				clock_t end = clock();
				elapsed_secs = double(end - begin) / CLOCKS_PER_SEC;//过了0.5秒就重传，过了20次未收到ACK就终止传输
				if (retransNum >= 20) {//重传次数>=20时，认为文件传输完毕但没有收到ack，或者认为客户端已死，结束传输。
					break;
				}
				if (elapsed_secs >= 0.5) {
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
			out.Format(L"End transfer:\n");
			out = L"\r\n" + out;
			out = out + file;
			pdlg->displayString(pdlg->m_log, out);
			return true;
		}
	}
	return false;
}

bool ClientSocket::waitACK(ClientSocket& skt, header* hd)
{
	CRUDPClientDlg* pdlg = (CRUDPClientDlg*)AfxGetApp()->GetMainWnd();
	// A buffer for the incoming data.
	char m_szBuffer[4096];
	// What ReceiveFrom Returns.
	int nRead;
	CString host, strp;
	UINT port;
	// 获取接收信息
	//Sleep(15);
	Sleep(5);
	nRead = skt.ReceiveFrom(m_szBuffer, 4096, host, port, 0);
	if (ChecksumCompute((unsigned short*)m_szBuffer, nRead) != 0)
	{
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
		if (ierr == WSAEWOULDBLOCK) {  // currently no data available
			Sleep(5);  // wait and try again
			break;
		}
		//out.Format(L"error: %d", ierr);
		//AfxMessageBox(out);
		//skt.Close();
	default:
		header* recvhd = (header*)(m_szBuffer);
		if (recvhd->isAck) {
			if (hd->clientPort == recvhd->clientPort && hd->serverPort == recvhd->serverPort && hd->seq == recvhd->seq) {
				return true;//ACK的相关信息和当前头部信息对应的话，返回true。传输下一个数据报
			}
		}
	}
	return true;
}


void ClientSocket::OnReceive(int nErrorCode)
{
	// TODO: 在此添加专用代码和/或调用基类

	CRUDPClientDlg* pdlg = (CRUDPClientDlg*)AfxGetApp()->GetMainWnd();
	// A buffer for the incoming data.
	char m_szBuffer[4096];
	// What ReceiveFrom Returns.
	int nRead;
	CString host, strp;
	UINT port;
	// 获取接收信息
	//Sleep(5);
	nRead = ReceiveFrom(m_szBuffer, 4096, host, port, 0);
	if (ChecksumCompute((unsigned short*)m_szBuffer, nRead) != 0)			//²î´í¼ìÑé
	{
		pdlg->displayString(pdlg->m_log, CString("校验和不为0，丢弃该包"));
		return;
	}
	// 按 ReceiveFrom 的返回值来判断如何继续
	switch (nRead) {
		// 如果未发生错误， ReceiveFrom() 则返回已接收的字节数。 
		// 如果连接已关闭，则返回0。 
		// 否则，将返回值 SOCKET_ERROR，并通过调用 GetLastError() 来检索特定的错误代码。
	case 0:
		// this->Close();
		break;
	case SOCKET_ERROR:
		AfxMessageBox(_T("Error occurred"));
		Close();
	default:
		// terminate the string
		m_szBuffer[nRead] = _T('\0');
		char* temp = &m_szBuffer[sizeof(struct header)];
		CString strTextOut;
		strTextOut = string(temp).c_str();
		if (strTextOut.Left(3) == "200") {//收到客户端的"200"回复
			pdlg->str_fileDeque.clear();//接收服务器文件列表之前，清空自身的文件列表
			initReceive200(strTextOut);//处理文件列表数据
		}
		else {
			//processFile(m_szBuffer);
		}
	}

	CAsyncSocket::OnReceive(nErrorCode);
}
