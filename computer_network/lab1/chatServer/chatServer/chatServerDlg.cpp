
// chatServerDlg.cpp: 实现文件
//

#include "pch.h"
#include "chatServer.h"
#include "chatServerDlg.h"
#include "afxdialogex.h"
#include <cstring>

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
public:
};

CAboutDlg::CAboutDlg() : CDialogEx(IDD_ABOUTBOX)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}



// CchatServerDlg 对话框



CchatServerDlg::CchatServerDlg(CWnd* pParent /*=nullptr*/)
	: CDialogEx(IDD_CHATSERVER_DIALOG, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	client_num = 0;
	client_port = 4000;
	recvDetails = _T("");
}

void CchatServerDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_EDIT2, client_num);		//将绘图的组件换个名字
	DDX_Text(pDX, IDC_EDIT1, client_port);		//将绘图的组件换个名字
	DDV_MinMaxInt(pDX, client_port, 1024, 65535);	//将绘图的组件换个名字
	DDX_Control(pDX, IDC_LIST4, client_user);		//将绘图的组件换个名字
	DDX_Text(pDX, IDC_EDIT3, recvDetails);
}

BEGIN_MESSAGE_MAP(CchatServerDlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_MESSAGE(SER_MESSAGE, OnServerMessage)
	ON_BN_CLICKED(IDC_BUTTON1, &CchatServerDlg::OnBnClickedButton1)
END_MESSAGE_MAP()


// CchatServerDlg 消息处理程序

BOOL CchatServerDlg::OnInitDialog()
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
	client_user.SetExtendedStyle(LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES);
	client_user.InsertColumn(0, "用户名");		//初始化用户列表
	client_user.SetColumnWidth(0, 100);
	client_user.InsertColumn(1, "IP地址");		//初始化用户列表
	client_user.SetColumnWidth(1, 100);
	return TRUE;  // 除非将焦点设置到控件，否则返回 TRUE
}

void CchatServerDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CchatServerDlg::OnPaint()
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
HCURSOR CchatServerDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}


void CchatServerDlg::OnBnClickedButton1()
{
	// TODO: 在此添加控件通知处理程序代码
	UpdateData(true);
	if (server.bulidServer(m_hWnd, client_port)) {  //调用建立服务器的函数buildserver
		char b[50] ="服务器建立成功，端口号为：";
		char a[10];
		_itoa_s(client_port, a, 10);
		strcat_s(b, a);
		MessageBox(b);   //提示建立服务器成功
	}
}

LRESULT CchatServerDlg::OnServerMessage(WPARAM wParam, LPARAM lParam) {   // wParam参数 指明网络事件套接口，多个套接口指定同一个用户消息，那么就需要根据wParam判断到底是哪个套接口待处理
																		//lParam参数包含信息:底字指定发生网络事件
	char buf[1024];                 //接受缓冲区，定义大小为1024个字符
	CString temp;
	CEdit* temp1 = NULL;
	int len = sizeof(SOCKADDR);
	switch (lParam)
	{
	case FD_ACCEPT:          //case1：接受客户端的请求
		client_socket[client_num] = accept(server.serversocket, (SOCKADDR*)&client_addr[client_num], &len);  //接受一个特定socket请求等待队列中的连接请求
		client_num++;   //服务器连接的客户数目加一
		UpdateData(false);
		break;
		int i;
	case FD_READ:			//case2：读取客户端请求的内容
		for (i = 0; i < client_num; i++)  //循环寻找此客户端的套接字
		{
			if (wParam == client_socket[i])		//找到此客户端的套接字
			{
				recv(client_socket[i], buf, 1024, 0);  //接受客户端发送过来的内容，存到缓存区buf中
				break;
			}
		}
		//以下在List中显示，
		if (buf[0] == 1)			//这里实现了一个小逻辑，在客户端发送信息时，如果第一次发送，即执行connect，此时发送的内容为用户名。这里的信息首字符为1，则将此客户端的用户名
									//和ip地址加到CListCtrl中
		{
			for(int j=0;j<strlen(buf);j++) buf[j]=buf[j+1];   //将这个信息位1去掉
			client_user.InsertItem(client_num - 1, buf);
			temp = inet_ntoa(client_addr[i].sin_addr);   //获取ip地址信息
			client_user.SetItemText(client_num - 1, 1, temp);		//ip地址信息加到CListCtrl中
		}
		else
		{
			for (int i = 0; i < client_num; i++)
				send(client_socket[i], buf, strlen(buf) + 1, 0);   //如果不是第一次发送，即用户发来的是消息内容，转发到各客户端
		}
		recvDetails += buf;
		recvDetails += (char)0x0d;
		recvDetails += (char)0x0a;
		temp1 = (CEdit*)GetDlgItem(IDC_EDIT3);  //加和消息内容
		temp1->SetWindowText(recvDetails);	   //更新消息框内容
		temp1->LineScroll(temp1->GetLineCount());
		break;
	case FD_CLOSE:			//case3：客户端关闭
		for (int i = 0; i < client_num; i++)//循环寻找此客户端的套接字
		{
			if (wParam == client_socket[i])  //客户端的套接字
			{
				temp = inet_ntoa(client_addr[i].sin_addr);
				for (int j = 0; j < client_user.GetItemCount(); j++)
				{
					if (client_user.GetItemText(j, 1) == temp)
					{
						client_user.DeleteItem(j);		//从列表中删去这一行
						break;
					}
				}
				for (int j = i; j < client_num - 1; j++)   //更新套接字缓冲队列以及客户端地址缓冲队列
				{
					client_socket[j] = client_socket[j + 1];
					client_addr[j] = client_addr[j + 1];
				}
				break;
			}
		}
		client_num--;   //客户端的数目减少一
		UpdateData(false);
		break;
	}
	return 0; 
}
