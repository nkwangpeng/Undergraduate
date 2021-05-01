
// chatServerDlg.h: 头文件
//

#pragma once
#include "Server.h"

// CchatServerDlg 对话框
class CchatServerDlg : public CDialogEx
{
// 构造
public:
	CchatServerDlg(CWnd* pParent = nullptr);	// 标准构造函数

// 对话框数据
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_CHATSERVER_DIALOG };
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
	afx_msg LRESULT OnServerMessage(WPARAM wParam, LPARAM lParam);
	DECLARE_MESSAGE_MAP()
public:
	Server server;
	SOCKET client_socket[512];
	SOCKADDR_IN client_addr[512];
	int client_num;
	int client_port;
	CListCtrl client_user;
	CString recvDetails;
	afx_msg void OnBnClickedButton1();
};
