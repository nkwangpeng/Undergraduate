
// chatClientDlg.cpp: 实现文件
//

#include "pch.h"
#include "framework.h"
#include "chatClient.h"
#include "chatClientDlg.h"
#include "afxdialogex.h"

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


// CchatClientDlg 对话框



CchatClientDlg::CchatClientDlg(CWnd* pParent /*=nullptr*/)
	: CDialogEx(IDD_CHATCLIENT_DIALOG, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	name = _T("");
	port = 4000;
	recvDetails = _T("");
	sendDetails = _T("");
}

void CchatClientDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_IPADDRESS1, ip);
	DDX_Text(pDX, IDC_EDIT3, name);
	DDV_MaxChars(pDX, name, 20);
	DDX_Text(pDX, IDC_EDIT2, port);
	DDV_MinMaxInt(pDX, port, 1024, 65535);
	DDX_Text(pDX, IDC_EDIT5, recvDetails);
	DDX_Text(pDX, IDC_EDIT4, sendDetails);
	DDV_MaxChars(pDX, sendDetails, 200);
}

BEGIN_MESSAGE_MAP(CchatClientDlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_MESSAGE(CLI_MESSAGE, OnclientMessage)
	ON_BN_CLICKED(IDC_BUTTON1, &CchatClientDlg::OnBnClickedButton1)
	ON_BN_CLICKED(IDC_BUTTON2, &CchatClientDlg::OnBnClickedButton2)
	ON_WM_CLOSE()
END_MESSAGE_MAP()


// CchatClientDlg 消息处理程序

BOOL CchatClientDlg::OnInitDialog()
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

	return TRUE;  // 除非将焦点设置到控件，否则返回 TRUE
}

void CchatClientDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CchatClientDlg::OnPaint()
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
HCURSOR CchatClientDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}



void CchatClientDlg::OnBnClickedButton1()
{
	// TODO: 在此添加控件通知处理程序代码
	UpdateData(true);
	char temp[20];
	temp[0] = 1;   //此时发送的是用户名，有一个信息位
	temp[1] = 0;
	const char* m = CStringA(name);
	strcat_s(temp, m);
	BYTE a1, a2, a3, a4;
	ip.GetAddress(a1, a2, a3, a4);
	CString a;
	a.Format("%d.%d.%d.%d", a1, a2, a3, a4);
	client.InitClient(m_hWnd, port, a);
	send(client.clientsocket, temp, strlen(temp) + 1, 0);
}



LRESULT CchatClientDlg::OnclientMessage(WPARAM wParam, LPARAM lParam) {   //连接服务器
	CEdit* temp = NULL;
	char q[1024];
	switch (lParam)
	{
	case FD_CONNECT:
		MessageBox("连接服务器成功！");
		break;
	case FD_READ:
		recv(client.clientsocket, q, 1024, 0);//接受服务器的消息
		recvDetails += q;
		recvDetails += (char)0x0d;
		recvDetails += (char)0x0a;
		temp = (CEdit*)GetDlgItem(IDC_EDIT5);  //加和消息内容
		temp->SetWindowText(recvDetails);	   //更新消息框内容
		temp->LineScroll(temp->GetLineCount());
		break;
	default:
		MessageBox("服务器断开连接！");  //默认断开连接
	}
	return 0;
}



void CchatClientDlg::OnBnClickedButton2()   //给服务器发送聊天内容，在此之前一定是已经创建了client客户端，并且已经成功连接服务器
{
	// TODO: 在此添加控件通知处理程序代码
	UpdateData(true);
	CString temp;
	temp = name;
	temp += "说:";
	temp += sendDetails;
	send(client.clientsocket, temp, strlen(temp) + 1, 0);  //调用send函数向服务器发送消息。
	sendDetails = "";  //将消息框清空
	UpdateData(false);
}


void CchatClientDlg::OnClose()
{
	// TODO: 在此添加消息处理程序代码和/或调用默认值
	closesocket(client.clientsocket);
	WSACleanup();
	CDialogEx::OnClose();
}
