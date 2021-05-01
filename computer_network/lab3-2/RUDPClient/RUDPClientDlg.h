
// RUDPClientDlg.h: 头文件
//

#include "ClientSocket.h"
#include <deque>
#include<map>
using namespace std;

#pragma once


// CRUDPClientDlg 对话框
class CRUDPClientDlg : public CDialogEx
{
// 构造
public:
	CRUDPClientDlg(CWnd* pParent = nullptr);	// 标准构造函数

// 对话框数据
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_RUDPCLIENT_DIALOG };
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
	void ShowFile();
	// 连接按钮
	CButton m_connect;
	// 下载按钮
	CButton m_download;
	// 上传按钮
	CButton m_upload;
	// 服务器的IP地址 默认为127.0.0.1
	CString m_ip;
	// 客户端日志
	CString window_num;
	CEdit m_log;
	// 服务器端口号 默认为60000
	int m_port;
	// 文件列表控件
	CListBox m_fileList;
	deque<CString> str_fileDeque;//文件双向队列-deque
	bool nextPortList[5535];//下一个将被分配的端口,从65535开始分配
							//nextPortList[i] == false表示端口60001+i没有被本程序分配
	afx_msg void OnBnClickedButtonConnect();
	bool receiveFile(ClientSocket& skt, int clientPort,bool * window_mask);
	afx_msg void OnBnClickedButtonDownload();
	afx_msg void OnBnClickedButtonUpload();
	int findNextPort();//找到下一个将被分配的端口
	ClientSocket usock;// 生成 UDP Socket（用作起始连接）Port=65535
	bool curFile[10];//表示当前选中了第几个文件
	int fileWait;//有多少个文件还没有开始下载
	map<string, int>fileSeq;//记录哪个文件到了哪个seq，用于判断重复seq
	//deque<CWinThread*>threadDeque;//线程地址队列

	afx_msg void OnSelchangeListFile();
	afx_msg void OnBnClickedButtonClear();
};
