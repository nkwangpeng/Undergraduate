
// RUDPServerDlg.h: 头文件
//
#include <deque>
#include <map>
#include "ServerSocket.h"
using namespace std;

#pragma once


// CRUDPServerDlg 对话框
class CRUDPServerDlg : public CDialogEx
{
	// 构造
public:
	CRUDPServerDlg(CWnd* pParent = nullptr);	// 标准构造函数

// 对话框数据
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_RUDPSERVER_DIALOG };
#endif

protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV 支持


// 实现
protected:
	HICON m_hIcon;

	// 生成的消息映射函数
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	void displayString(CEdit& editCtrl, CString& str);
	CString FicowGetDirectory();//选择文件夹，并返回路径
	void ShowFile();//将文件显示在列表框控件中
	void RecursiveFindFile(CString strRootPath, bool isRecursive);//查找文件夹下的所有文件
	// 打开文件夹按钮
	CButton m_folder;
	// 开始按钮
	CButton m_start;
	// 服务器日志编辑框控件
	CEdit m_log;
	// 服务器端口，默认选择60000端口
	int m_port;
	// 文件列表控件
	CListBox m_fileList;	//用来显示文件列表
	afx_msg void OnEnChangeEditPort();
	afx_msg void OnBnClickedButtonFolder();
	deque<CString> str_fileDeque;//文件双向队列-deque
	afx_msg void OnBnClickedButtonStart();
	int findNextPort();
	bool nextPortList[5535];//下一个将被分配的端口,从60001开始分配
							//nextPortList[i] == false表示端口60001+i没有被本程序分配
	//deque<ServerSocket>socketDeque;//存储socket的双端队列
	map<int, int>clientToServerMap;//客户端的端口和服务器端口的映射
	ServerSocket usock;// 生成 UDP Socket（用作起始连接）Port=60000
	CString strDirectoryPath;//打开的文件目录
	bool receiveFile(ServerSocket& skt, int clientPort);
	map<string, int>fileSeq;//记录哪个文件到了哪个seq，用于判断重复seq
	afx_msg void OnBnClickedButtonClear();
};
