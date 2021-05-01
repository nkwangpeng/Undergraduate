
// RUDPServerDlg.cpp: 实现文件
//

#include "pch.h"
#include "framework.h"
#include "RUDPServer.h"
#include "RUDPServerDlg.h"
#include "afxdialogex.h"
#include "ServerSocket.h"

using namespace std;

#ifdef _DEBUG
#define new DEBUG_NEW
#endif
int window_len;

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


// CRUDPServerDlg 对话框



CRUDPServerDlg::CRUDPServerDlg(CWnd* pParent /*=nullptr*/)
	: CDialogEx(IDD_RUDPSERVER_DIALOG, pParent)
	, m_port(0)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CRUDPServerDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_BUTTON_FOLDER, m_folder);
	DDX_Control(pDX, IDC_BUTTON_START, m_start);
	DDX_Control(pDX, IDC_EDIT_LOG, m_log);
	DDX_Text(pDX, IDC_EDIT_PORT, m_port);
	DDX_Text(pDX, IDC_WINDOW_NUM, window_num);
	DDX_Control(pDX, IDC_LIST_FILE, m_fileList);
}

BEGIN_MESSAGE_MAP(CRUDPServerDlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_EN_CHANGE(IDC_EDIT_PORT, &CRUDPServerDlg::OnEnChangeEditPort)
	ON_BN_CLICKED(IDC_BUTTON_FOLDER, &CRUDPServerDlg::OnBnClickedButtonFolder)
	ON_BN_CLICKED(IDC_BUTTON_START, &CRUDPServerDlg::OnBnClickedButtonStart)
	ON_BN_CLICKED(IDC_BUTTON_CLEAR, &CRUDPServerDlg::OnBnClickedButtonClear)
END_MESSAGE_MAP()


// CRUDPServerDlg 消息处理程序

BOOL CRUDPServerDlg::OnInitDialog()
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
	window_num = _T("5");
	GetDlgItem(IDC_WINDOW_NUM)->SetWindowTextW(window_num);
	m_port = 60000;//设置默认端口号为60000
	CString t;
	t.Format(_T("%d"), m_port);
	GetDlgItem(IDC_EDIT_PORT)->SetWindowTextW(t);

	return TRUE;  // 除非将焦点设置到控件，否则返回 TRUE
}

void CRUDPServerDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CRUDPServerDlg::OnPaint()
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
HCURSOR CRUDPServerDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

int CRUDPServerDlg::findNextPort()
{
	for (int i = 0; i < 5534; ++i) {
		if (nextPortList[i] == false) {
			nextPortList[i] = true;
			return i;
		}
	}
	return -1;//找不到就返回-1
}

void CRUDPServerDlg::displayString(CEdit& editCtrl, CString& str)
{
	CString tmp;
	editCtrl.GetWindowTextW(tmp);
	editCtrl.SetWindowTextW(tmp + str);
	//UpdateData(true);
	//Invalidate(true);
	UpdateWindow();
}

//选择文件夹，并返回路径
CString CRUDPServerDlg::FicowGetDirectory()
{
	BROWSEINFO bi;  //BROWSEINFO结构中包含有用户选中目录的重要信息
	TCHAR name[MAX_PATH];  //定义编译器所支持的最长全路径名的长度。
	ZeroMemory(&bi, sizeof(BROWSEINFO));	//内存初始化为0
	bi.hwndOwner = AfxGetMainWnd()->GetSafeHwnd();
	bi.pszDisplayName = name;
	bi.lpszTitle = _T("选择文件夹目录");
	bi.ulFlags = BIF_RETURNFSANCESTORS;
	LPITEMIDLIST idl = SHBrowseForFolder(&bi);	//打开文件目录对话框
	if (idl == NULL)
		return _T("");
	CString strDirectoryPath;
	SHGetPathFromIDList(idl, strDirectoryPath.GetBuffer(MAX_PATH));	 //如果选择了路径则复制路径,返回路径长度
	strDirectoryPath.ReleaseBuffer();	//更新字符串的长度
	if (strDirectoryPath.IsEmpty())
		return _T("");
	if (strDirectoryPath.Right(1) != "\\") //从右边开始取字符串
		strDirectoryPath += "\\";

	return strDirectoryPath;
}

void CRUDPServerDlg::ShowFile()
{
	m_fileList.ResetContent();	//清空fileList中的内容
	unsigned sz = str_fileDeque.size();
	for (unsigned i = 0; i < sz; i++)
	{
		m_fileList.InsertString(-1, str_fileDeque[i]); //索引号,设定为-1时,项目条被插入到列表的末尾;
	}
}

//查找文件夹下的所有文件
void CRUDPServerDlg::RecursiveFindFile(CString strRootPath, bool isRecursive = false)
{
	/*
	   主要是CFileFind类的使用。
	   重要方法;
	   FindFile()
	   FindNextFile()
	*/
	// strRootPath 为目录名;  
	CFileFind finder;
	CString FilePath;
	if (strRootPath.Right(1) != "/")
		strRootPath += "/";
	strRootPath += "*.*";  //表示显示所有命名、所有类型的文件

	BOOL res = finder.FindFile(strRootPath);    // 开始遍历root文件夹下有没有文件或文件夹;  
	while (res)       // res为1，表示仍有nextFile;  
	{
		res = finder.FindNextFile(); //遍历目录或文件时，判断当前目录下是否有下一个目录或文件
		FilePath = finder.GetFilePath();  //获得文件路径

		if (finder.IsDots())  continue;       // 如果文件为“.”或“..”，则跳过本次循环;  

		if (finder.IsDirectory())     // 找到的是文件夹;  
		{
			if(isRecursive)
				RecursiveFindFile(FilePath);        // 递归;  
		}
		else if (!finder.IsDirectory())       // 找到的是文件;  
		{
			str_fileDeque.push_back((finder.GetFileName()));    // 显示文件名文件双向队列-deque
		}
	}
}


void CRUDPServerDlg::OnEnChangeEditPort()
{
	// TODO:  如果该控件是 RICHEDIT 控件，它将不
	// 发送此通知，除非重写 CDialogEx::OnInitDialog()
	// 函数并调用 CRichEditCtrl().SetEventMask()，
	// 同时将 ENM_CHANGE 标志“或”运算到掩码中。
	// TODO:  在此添加控件通知处理程序代码

	UpdateData(true);
}


void CRUDPServerDlg::OnBnClickedButtonFolder()
{
	// TODO: 在此添加控件通知处理程序代码

	str_fileDeque.clear();//每次打开前清空deque
	strDirectoryPath = FicowGetDirectory();//选择文件夹，并返回路径
	RecursiveFindFile(strDirectoryPath);
	ShowFile();
}


void CRUDPServerDlg::OnBnClickedButtonStart()
{
	// TODO: 在此添加控件通知处理程序代码
	window_len = this->GetDlgItemInt(IDC_WINDOW_NUM);
	CString outWindow;
	outWindow.Format(L"初始化滑动窗口数为：%d \r\n", window_len);
	this->displayString(this->m_log, outWindow);
	BOOL createFlag = usock.Create(m_port, SOCK_DGRAM, FD_CLOSE | FD_READ | FD_ACCEPT | FD_CONNECT);	//数据报服务端，即底层使用UDP协议
	//在一个socket 上接收以windows 消息为基础的网络事件。提供读写数据的异步通知功能 
	// 生成失败会报错
	if (createFlag == 0)
	{
		MessageBox(_T("Socket create failed."));
		usock.Close();
		return;
	}

	CString t;
	t.Format(_T("服务器成功启动，绑定端口为: %d\r\n"), m_port);
	// 更新日志
	displayString(m_log, t);

}


void CRUDPServerDlg::OnBnClickedButtonClear()
{
	// TODO: 在此添加控件通知处理程序代码

	m_log.SetWindowTextW(_T(""));		//清空日志
}
