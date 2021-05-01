
// RUDPClientDlg.cpp: 实现文件
//

#include "pch.h"
#include "framework.h"
#include "RUDPClient.h"
#include "RUDPClientDlg.h"
#include "afxdialogex.h"
#include <string>
#include <fstream>
#include <iterator>
#include <vector>

//#include "ClientSocket.h"

using namespace std;

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// 用于应用程序“关于”菜单项的 CAboutDlg 对话框

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

	// 对话框数据
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_ABOUTBOX };
#endif

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

// 实现
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialogEx(IDD_ABOUTBOX)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()


// CRUDPClientDlg 对话框



CRUDPClientDlg::CRUDPClientDlg(CWnd* pParent /*=nullptr*/)
	: CDialogEx(IDD_RUDPCLIENT_DIALOG, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CRUDPClientDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_BUTTON_CONNECT, m_connect);
	DDX_Control(pDX, IDC_BUTTON_DOWNLOAD, m_download);
	DDX_Control(pDX, IDC_BUTTON_UPLOAD, m_upload);
	DDX_Text(pDX, IDC_EDIT_IP, m_ip);
	DDX_Control(pDX, IDC_EDIT_LOG, m_log);
	DDX_Text(pDX, IDC_EDIT_PORT, m_port);
	DDX_Control(pDX, IDC_LIST_FILE, m_fileList);
}

BEGIN_MESSAGE_MAP(CRUDPClientDlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON_CONNECT, &CRUDPClientDlg::OnBnClickedButtonConnect)
	ON_BN_CLICKED(IDC_BUTTON_DOWNLOAD, &CRUDPClientDlg::OnBnClickedButtonDownload)
	ON_BN_CLICKED(IDC_BUTTON_UPLOAD, &CRUDPClientDlg::OnBnClickedButtonUpload)
	ON_LBN_SELCHANGE(IDC_LIST_FILE, &CRUDPClientDlg::OnSelchangeListFile)
	ON_BN_CLICKED(IDC_BUTTON_CLEAR, &CRUDPClientDlg::OnBnClickedButtonClear)
END_MESSAGE_MAP()


// CRUDPClientDlg 消息处理程序

BOOL CRUDPClientDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// 将“关于...”菜单项添加到系统菜单中。

	// IDM_ABOUTBOX 必须在系统命令范围内。
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != nullptr)
	{
		BOOL bNameValid;
		CString strAboutMenu;
		bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
		ASSERT(bNameValid);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// 设置此对话框的图标。  当应用程序主窗口不是对话框时，框架将自动
	//  执行此操作
	SetIcon(m_hIcon, TRUE);			// 设置大图标
	SetIcon(m_hIcon, FALSE);		// 设置小图标

	// TODO: 在此添加额外的初始化代码

	fileWait = 0;

	//初始化选中文件列表
	for (int i = 0; i < 10; ++i) {
		curFile[i] = false;
	}

	//初始化nextPortList
	for (unsigned i = 0; i < size(nextPortList); ++i)
		nextPortList[i] = false;
	nextPortList[0] = true;

	m_ip = _T("127.0.0.1");//设置默认ip为127.0.0.1
	GetDlgItem(IDC_EDIT_IP)->SetWindowTextW(m_ip);

	m_port = 60000;//设置默认端口号为60000
	CString t;
	t.Format(_T("%d"), m_port);
	GetDlgItem(IDC_EDIT_PORT)->SetWindowTextW(t);

	return TRUE;  // 除非将焦点设置到控件，否则返回 TRUE
}

void CRUDPClientDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialogEx::OnSysCommand(nID, lParam);
	}
}

// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。  对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void CRUDPClientDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // 用于绘制的设备上下文

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// 使图标在工作区矩形中居中
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// 绘制图标
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

//当用户拖动最小化窗口时系统调用此函数取得光标
//显示。
HCURSOR CRUDPClientDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}
void copyData(char* srcData, char* destData, int len) {
	assert(srcData != NULL && destData != NULL);
	for (int i = 0; i < len; i++)
	{
		destData[i] = srcData[i];
	}
}
int CRUDPClientDlg::findNextPort()
{
	//客户端的传输socket从65534开始
	for (int i = 5534; i >= 0; --i) {
		if (nextPortList[i] == false) {
			nextPortList[i] = true;
			return i;
		}
	}
	return -1;//找不到就返回-1
}


void CRUDPClientDlg::ShowFile()
{
	m_fileList.ResetContent();
	unsigned sz = str_fileDeque.size();
	for (unsigned i = 0; i < sz; i++) {
		m_fileList.InsertString(-1, str_fileDeque[i]);
	}
}

void CRUDPClientDlg::displayString(CEdit& editCtrl, CString& str)
{
	CString tmp;
	editCtrl.GetWindowTextW(tmp);
	editCtrl.SetWindowTextW(tmp + str);
	//UpdateData(true);
	//Invalidate(true);
	UpdateWindow();
}

void CRUDPClientDlg::OnBnClickedButtonConnect()
{
	// TODO: 在此添加控件通知处理程序代码

	//int port = findNextPort();
	int port = findNextPort() + 60000;
	//ClientSocket skt;
	BOOL Flag = usock.Create(port, SOCK_DGRAM, FD_READ | FD_WRITE | FD_OOB | FD_ACCEPT | FD_CONNECT | FD_CLOSE);
	while (!Flag) {//端口被占用的话就遍历端口数组
		port = findNextPort() + 60000;
		Flag = usock.Create(port, SOCK_DGRAM, FD_READ | FD_WRITE | FD_OOB | FD_ACCEPT | FD_CONNECT | FD_CLOSE);
	}

	Flag = usock.Connect(m_ip, m_port);
	CString t;
	t.Format(_T("Try to connect %s:%d"), m_ip, m_port);

	// 更新日志
	displayString(m_log, t);

	//请求文件列表
	char retchar[4096];
	char s[20] = "100";//"100"请求的格式：100
	header* hd = (header*)retchar;
	hd->dataLen = strlen((char*)(s));
	hd->totalLen = hd->dataLen + sizeof(struct header);
	copyData(s, (retchar + sizeof(header)), hd->dataLen);
	hd->checkSum = 0;
	hd->checkSum = ChecksumCompute((unsigned short*)hd, hd->totalLen);
	usock.SendTo(retchar, hd->totalLen, 60000, _T("127.0.0.1"), 0);
}

//用于接收收到的文件分片
bool CRUDPClientDlg::receiveFile(ClientSocket& skt, int clientPort) {
	CRUDPClientDlg* pdlg = (CRUDPClientDlg*)AfxGetApp()->GetMainWnd();
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
		m_szBuffer[nRead] = _T('\0');
		u_char* temp = &m_szBuffer[sizeof(struct header)];
		CString strTextOut;
		strTextOut = string((char*)temp).c_str();
		if (strTextOut.Left(3) == "200") {
			skt.initReceive200(strTextOut);
		}
		else {//收到文件报文的话
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

//处理文件分片
bool ClientSocket::processFile(ClientSocket& skt, u_char* raw, int clientPort) {
	//CRUDPClientDlg* pdlg = (CRUDPClientDlg*)AfxGetApp()->GetMainWnd();
	CRUDPClientDlg* pdlg = (CRUDPClientDlg*)AfxGetApp()->GetMainWnd();
	header* recvhd = (header*)(raw);

	string str(recvhd->fileName);
	map<string, int>::iterator it = pdlg->fileSeq.find(str);//在map容器中找到文件
	

	u_char* temp = &raw[sizeof(struct header)];//创建一个指向数据段起始地址的指针
	std::basic_ofstream<u_char> myfile(recvhd->fileName, ios::out | ios::app | ios::binary);

	if (recvhd->seq == it->second + 1) {//如果收到的是期待收到的报文，写入文件。
										//it->second指示的是文件中已经有了第几号报文，期待的下一个报文就是it->second+1
		myfile.write(temp ,recvhd->dataLen-4);
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
	

	if (recvhd->dataLen < MAX_PACKET) {//当报文中数据段的长度小于报文最大长度的时候，说明接收完毕，关闭socket
		return 1;
	}
	else
		return 0;
}

UINT Uploader(tempUpload* t) // 数据包捕获工作者线程的控制函数
{
	CRUDPClientDlg* pdlg = (CRUDPClientDlg*)AfxGetApp()->GetMainWnd();
	char retchar[4096];
	CString s;
	s.Format(L"120");
	char temp[1024];
	int len = WideCharToMultiByte(CP_ACP, 0, s, -1, NULL, 0, NULL, NULL);
	WideCharToMultiByte(CP_ACP, 0, s, -1, temp, len, NULL, NULL);

	int port = pdlg->findNextPort() + 60001;
	ClientSocket skt;
	BOOL Flag = skt.Create(port, SOCK_DGRAM, FD_READ | FD_WRITE | FD_OOB | FD_ACCEPT | FD_CONNECT | FD_CLOSE);
	while (!Flag) {//端口被占用的话就遍历端口数组
		port = pdlg->findNextPort() + 60001;
		Flag = skt.Create(port, SOCK_DGRAM, FD_READ | FD_WRITE | FD_OOB | FD_ACCEPT | FD_CONNECT | FD_CLOSE);
	}
	header* hd = (header*)retchar;
	hd->dataLen = strlen((char*)(temp));
	hd->totalLen = hd->dataLen + sizeof(struct header);
	copyData(temp, (retchar + sizeof(header)), hd->dataLen);
	hd->checkSum = 0;
	hd->checkSum = ChecksumCompute((unsigned short*)hd, hd->totalLen);

	skt.SendTo(retchar, hd->totalLen, 60000, _T("127.0.0.1"), 0);

	int serverPort = -1;
	while (1) {
		skt.Listen();
		serverPort = skt.waitFor220(skt, port);
		if (serverPort == -1)
			continue;
		else
			break;
	}
	bool done = false;
	while (1) {
		skt.Listen();
		done = skt.uploadFile(t->filePath, skt, port, serverPort);
		if (done) {
			pdlg->str_fileDeque.clear();
			char m_szBuffer[4096];
			CString host, strp;
			UINT port;
			while (1) {
				int nRead = skt.ReceiveFrom(m_szBuffer, 4096, host, port, 0);
				if (nRead > 0)break;
			}
			char* temp = &m_szBuffer[sizeof(struct header)];
			CString strTextOut;
			strTextOut = string(temp).c_str();
			pdlg->displayString(pdlg->m_log, strTextOut);
			skt.initReceive200(strTextOut);
			break;
		}
	}
	return 0;
}

UINT Downloader(PVOID hWnd) // 下载线程的控制函数
{
	CRUDPClientDlg* pdlg = (CRUDPClientDlg*)AfxGetApp()->GetMainWnd();
	if (pdlg == nullptr)
	{
		AfxMessageBox(L"sad");
	}
	char retchar[4096];
	CString s;
	s.Format(L"110");// "110"指令的格式：110 filenum///////filenum filenum
	for (int i = 0; i < 10; ++i) {
		if (pdlg->curFile[i]) {
			CString t;
			t.Format(L" %d", i);
			s.Append(t);
			pdlg->curFile[i] = false;//这个文件有线程对应了，所以重置它在选择文件列表中的值
			break;
		}
	}
	char temp[1024];
	int len = WideCharToMultiByte(CP_ACP, 0, s, -1, NULL, 0, NULL, NULL);
	WideCharToMultiByte(CP_ACP, 0, s, -1, temp, len, NULL, NULL);
	int port = pdlg->findNextPort() + 60001;
	ClientSocket skt;
	BOOL Flag = skt.Create(port, SOCK_DGRAM, FD_READ | FD_WRITE | FD_OOB | FD_ACCEPT | FD_CONNECT | FD_CLOSE);
	while (!Flag) {//端口被占用的话就遍历端口数组
		port = pdlg->findNextPort() + 60001;
		Flag = skt.Create(port, SOCK_DGRAM, FD_READ | FD_WRITE | FD_OOB | FD_ACCEPT | FD_CONNECT | FD_CLOSE);
	}
	header* hd = (header*)retchar;
	hd->dataLen = strlen((char*)(temp));
	hd->totalLen = hd->dataLen + sizeof(struct header);
	copyData(temp, (retchar + sizeof(header)), hd->dataLen);
	hd->checkSum = 0;
	hd->checkSum = ChecksumCompute((unsigned short*)hd, hd->totalLen);
	skt.SendTo(retchar, hd->totalLen, 60000, _T("127.0.0.1"), 0);

	while (1) {
		skt.Listen();
		bool done = pdlg->receiveFile(skt, port);
		if (done)
			break;
	}
	return 0;
}

void CRUDPClientDlg::OnBnClickedButtonDownload()
{
	// TODO: 在此添加控件通知处理程序代码
	m_fileList.SetSel(-1, FALSE);//取消选中所有条目。deselect all items.

	while (fileWait != 0) {
		// 调用 AfxBeginThread() 函数启动工作者线程
		// AfxBeginThread() 函数将返回一个指向新创建线程对象的指针
		//CRUDPClientDlg* p = (CRUDPClientDlg*)AfxGetMainWnd();
		CWinThread* m_Uploader = AfxBeginThread(
			(AFX_THREADPROC)Downloader, // pfnThreadProc：指向工作者线程的控制函数，它的值不能为NULL
			NULL, // 
			THREAD_PRIORITY_NORMAL // 用于指定线程的优先级
		);
		if (m_Uploader != nullptr) {
			//threadDeque.push_back(m_Downloader);
			fileWait--;
		}
		else {
			AfxMessageBox(L"Download Thread Create Failed.");
		}
	}
}


void CRUDPClientDlg::OnBnClickedButtonUpload()
{
	// TODO: 在此添加控件通知处理程序代码

	CFileDialog dlg(TRUE);
	CString filePath;
	if (dlg.DoModal() == IDOK){
		filePath = dlg.GetPathName(); // return full path and filename
	}

	tempUpload* t = new tempUpload;
	t->filePath = filePath;

	CWinThread* m_Uploader = AfxBeginThread(
		(AFX_THREADPROC)Uploader, // pfnThreadProc：指向工作者线程的控制函数，它的值不能为NULL
		t, // 
		THREAD_PRIORITY_NORMAL // 用于指定线程的优先级
	);
	if (m_Uploader != nullptr) {
	}
	else {
		AfxMessageBox(L"Upload Thread Create Failed.");
	}
}

void CRUDPClientDlg::OnSelchangeListFile()
{
	// TODO: 在此添加控件通知处理程序代码

	int temp = m_fileList.GetCurSel(); // 获取listbox被选中的行的数目
	for (int i = 0; i < 10; ++i) {
		if (i == temp && curFile[i] == false) {//该文件之前未被选中，将文件序号添加进选择文件列表
			curFile[i] = true;
			fileWait++;
			break;
		}
		else if (i == temp && curFile[i] == true) {//该文件之前被选中，将文件序号从选择文件列表中删除
			curFile[i] = false;
			fileWait--;
			break;
		}
	}
}


void CRUDPClientDlg::OnBnClickedButtonClear()
{
	// TODO: 在此添加控件通知处理程序代码

	m_log.SetWindowTextW(_T(""));
}
