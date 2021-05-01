#pragma comment(lib,"ws2_32.lib")
#include <iostream>
#include <WinSock2.h> 
#include <string.h>
#include <fstream>
#include <stdio.h>
#include <time.h>
using namespace std;

#define SERVER_PORT 8000 
#define BUFFER_SIZE 1024 
#define FILE_NAME_MAX_SIZE 512
int timeout = 1;
int window_left = 0;
int window_right = 0;
int cwnd = 1;
int ssthresh = 16;
int point = 0;// 改变窗口时已确认的数据seq
int repeat_ack = 0;
int lastSeq = 1;
size_t fileSize;

// 数据报头部 
typedef struct PackInfo
{
	unsigned short seq;
	unsigned short syn;
	unsigned short ack;
	PackInfo() {
		this->seq = 0;
		this->syn = 0;
		this->ack = 0;
	}
}PackInfo;
// 数据报
typedef struct Packet
{
	PackInfo head; //伪首部
	unsigned short buf_size;
	unsigned short Checksum; // 校验和
	time_t send_time; // 发送时间
	Packet* next;
	char data[BUFFER_SIZE]; // 数据缓冲区
	Packet() {
		this->head.seq = 0;
		this->head.syn = 0;
		this->head.ack = 0;
		this->buf_size = 0;
		this->Checksum = 0;
		this->send_time = 0;
		this->next = NULL;
		memset(this->data, 0, BUFFER_SIZE);
	}
} Packet;

typedef struct PacketList {
	Packet* first;
	Packet* tail;
	PacketList() {
		first = tail = NULL;
	}
	void insert(Packet* packet);
	void shift();
	//Packet find(int seq);
};

void PacketList::insert(Packet* packet) {
	if (first == NULL) {
		first = tail = packet;
		return;
	}
	tail->next = packet;
	tail = tail->next;
}

void PacketList::shift() {
	Packet* temp = first->next;
	delete first;
	first = temp;
}

unsigned short checksum(Packet packet) { // 校验和计算
	// 数据报内字段相加
	unsigned long sum = 0;
	sum += packet.head.seq;
	sum += packet.head.ack;
	sum += packet.head.syn;
	sum += packet.buf_size;
	sum += packet.Checksum;

	if (packet.buf_size % 2 == 0) { // 数据累加
		for (int i = 0; i < packet.buf_size; i += 2) {
			// char型数据左移8位与下一个char相加
			sum += (((unsigned short)packet.data[i]) << 8) | (unsigned short)packet.data[i + 1];
			sum = (sum >> 16) + (sum & 0xffff);
		}
	}
	else {// 补齐缺失的0位
		for (int i = 0; i < packet.buf_size - 1; i += 2) {
			sum += (((unsigned short)packet.data[i]) << 8) | (unsigned short)packet.data[i + 1];
			sum = (sum >> 16) + (sum & 0xffff);
		}
		sum += (((unsigned short)packet.data[packet.buf_size - 1]) << 8);
		sum = (sum >> 16) + (sum & 0xffff);
	}
	// 进位加回末尾
	if (sum >> 16 != 0)
		sum = (sum >> 16) + (sum & 0xffff);

	return ~sum;
}

SOCKET ShakeHands() {
	WORD wVersionRequested;
	WSAData wsaData;
	wVersionRequested = MAKEWORD(2, 2);
	// 开启服务
	WSAStartup(wVersionRequested, &wsaData);

	// 创建UDP套接字
	SOCKADDR_IN server_addr;
	memset(&server_addr, 0, sizeof(server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
	server_addr.sin_port = htons(SERVER_PORT);

	// 创建socket
	SOCKET server_socket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if (server_socket == -1) {
		perror("Create Socket Failed:");
		exit(1);
	}

	// 绑定套接字
	if (-1 == (bind(server_socket, (SOCKADDR*)&server_addr, sizeof(server_addr)))) {
		perror("Server Bind Failed:");
		exit(1);
	}

	srand(time(NULL)); // 产生随机数
	PackInfo serverPackInfo;

	SOCKADDR_IN client_addr;
	memset(&client_addr, 0, sizeof(client_addr));
	client_addr.sin_family = AF_INET;
	client_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
	client_addr.sin_port = htons(8001);
	int client_addr_length = sizeof(client_addr);

	// 接收建立连接的请求
	PackInfo clientPackInfo;
	if (recvfrom(server_socket, (char*)&clientPackInfo, sizeof(clientPackInfo), 0, (SOCKADDR*)&client_addr, &client_addr_length) == -1) {
		cout << "第1次握手，建立连接失败" << endl;
		exit(1);
	}
	serverPackInfo.syn = clientPackInfo.syn;
	serverPackInfo.seq = rand();
	serverPackInfo.ack = clientPackInfo.seq + 1;
	if (sendto(server_socket, (char*)&serverPackInfo, sizeof(serverPackInfo), 0, (SOCKADDR*)&client_addr, client_addr_length) < 0) {
		cout << "第2次握手，发送确认失败" << endl;
		exit(1);
	}
	if (recvfrom(server_socket, (char*)&clientPackInfo, sizeof(clientPackInfo), 0, (SOCKADDR*)&client_addr, &client_addr_length) == -1) {
		cout << "第3次握手，接受确认失败" << endl;
		exit(1);
	}
	if (clientPackInfo.syn == 0 && clientPackInfo.seq == serverPackInfo.ack && clientPackInfo.ack == (serverPackInfo.seq + 1))
		cout << "3次握手建立连接成功" << endl;

	return server_socket;
}

int main() {
	clock_t start, end;
	// 建立连接，获取套接字
	SOCKET server_socket = ShakeHands();

	// 定义一个地址，用于捕获客户端地址
	SOCKADDR_IN client_addr;
	memset(&client_addr, 0, sizeof(client_addr));
	client_addr.sin_family = AF_INET;
	client_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
	client_addr.sin_port = htons(8001);
	int client_addr_length = sizeof(client_addr);

	// 定义接收数据缓冲区
	char buffer[BUFFER_SIZE];
	memset(buffer, 0, BUFFER_SIZE); // 初始化缓冲区

	// 设置接收文件路径延时为30s
	int WaitTime = 30000;
	setsockopt(server_socket, SOL_SOCKET, SO_RCVTIMEO, (char*)&WaitTime, sizeof(int));
	// 接收文件路径到buffer
	if (recvfrom(server_socket, buffer, BUFFER_SIZE, 0, (SOCKADDR*)&client_addr, &client_addr_length) == -1) {
		cout << "等待超时" << endl;
		exit(1);
	}
	start = clock();
	// 从buffer中拷贝出file_path
	char file_path[FILE_NAME_MAX_SIZE + 1];
	memset(file_path, 0, FILE_NAME_MAX_SIZE + 1);
	strncpy(file_path, buffer, strlen(buffer) > FILE_NAME_MAX_SIZE ? FILE_NAME_MAX_SIZE : strlen(buffer));
	cout << file_path << endl;

	// 打开文件 
	FILE* fp = fopen(file_path, "rb+");
	fseek(fp, 0, SEEK_END);
	fileSize = ftell(fp);
	fclose(fp);
	fp = fopen(file_path, "rb+");
	if (NULL == fp) {
		cout << "文件：" << file_path << "没有找到" << endl;
		return 0;
	}
	int len = 0; // 用于接收读取一段内容的长度，字节数
	PackInfo packInfo; // 用于接收客户端的确认信息
	Packet* packet = new Packet(); // 定义一个大小为3个帧的窗口，用于发送
	PacketList packetList;
	// 设置recvfrom函数接收超时为1ms，用于取消阻塞，计算窗口发送的时间
	setsockopt(server_socket, SOL_SOCKET, SO_RCVTIMEO, (char*)&timeout, sizeof(int));

	if ((len = fread(packet->data, 1, BUFFER_SIZE, fp)) > 0) {
		packet->buf_size = len;
		packet->head.seq = 1;
		packet->Checksum = 0;
		packet->Checksum = checksum(*packet);
	}
	if (sendto(server_socket, (char*)packet, sizeof(*packet), 0, (SOCKADDR*)&client_addr, client_addr_length) < 0) {
		cout << "发送错误" << endl;
		return 0;
	}
	// 记录确认帧的发送时间
	packet->send_time = time(NULL);
	window_left = 0;
	window_right = 1;
	packetList.insert(packet);

	bool notFinished = true;
	unsigned short flag = 0;
	while (1) {
		// 结束
		if (packetList.first == NULL) {
			if (sendto(server_socket, NULL, 0, 0, (SOCKADDR*)&client_addr, client_addr_length) < 0) {
				cout << "发送错误" << endl;
				return 0;
			}
			break;
		}
		// 接受确认超时，进行重传
		if ((time(NULL) - packetList.first->send_time) >= 2) {
			cout << "超时重传" << endl;

			Packet* temp = packetList.first;
			int i = 0;
			while (temp && (i < cwnd)) {
				if (sendto(server_socket, (char*)temp, sizeof(*temp), 0, (sockaddr*)&client_addr, client_addr_length) < 0) {
					cout << "发送错误" << endl;
					return 0;
				}
				cout << "超时重传" << temp->head.seq << endl;
				temp->send_time = time(NULL);
				temp = temp->next;
			}
			ssthresh = cwnd / 2;
			cwnd = 1;
			window_right = window_left + 1;
			point = window_left;
		}

		//for (int i = 0; i < cwnd; i++) {
		while (1) {
			// 1ms recvfrom函数即返回，不断监听客户端回复的确认
			if (recvfrom(server_socket, (char*)&packInfo, sizeof(packInfo), 0, (SOCKADDR*)&client_addr, &client_addr_length) == -1)
				break;
		}
		// 快速重传
		if (packInfo.ack < packetList.first->head.seq) {
			cout << "！！！！！！！！！！！收到重复ack" << packInfo.ack << endl;
			if (packInfo.ack == flag)
				repeat_ack++;
			else {
				flag = packInfo.ack;
				repeat_ack++;
			}
			if (repeat_ack >= 3) {

				Packet* temp = packetList.first;
				int i = 0;
				while (temp && (i < cwnd)) {
					if (sendto(server_socket, (char*)temp, sizeof(*temp), 0, (SOCKADDR*)&client_addr, client_addr_length) < 0) {
						cout << "发送错误" << endl;
						return 0;
					}
					cout << "快速重传" << temp->head.seq << endl;
					temp->send_time = time(NULL);
					temp = temp->next;
				}
				ssthresh = cwnd / 2;
				cwnd = ssthresh + 3;
				window_right = window_left + 1;
				point = window_left;
				repeat_ack = 0;
			}
			continue;
		}
		// 接收确认，窗口左端后移
		while (packetList.first && (packInfo.ack >= packetList.first->head.seq)) {
			if (packetList.first->head.seq == packInfo.ack) {
				cout << "已确认第" << packInfo.ack << "条报文" << endl;
				packetList.first = packetList.first->next;
				break;
			}
			packetList.first = packetList.first->next;
		}
		window_left = packInfo.ack;

		if (!notFinished)
			continue;
		// 增加窗口大小
		if (window_left - point >= cwnd) {
			point = window_left;
			if (cwnd < ssthresh)
				cwnd *= 2;
			else
				cwnd++;
			cout << "窗口大小增加为" << cwnd << endl;
		}
		// 窗口右端后移，发送新进入窗口的报文
		for (window_right; window_right <= window_left + cwnd; window_right++) {
			cout << "发送第" << lastSeq + 1 << "条报文" << endl;
			packet = new Packet();
			if ((len = fread(packet->data, 1, BUFFER_SIZE, fp)) > 0) {
				lastSeq++;
				packet->buf_size = len;
				packet->head.seq = lastSeq;
				packet->Checksum = 0;
				packet->Checksum = checksum(*packet);
				if (sendto(server_socket, (char*)packet, sizeof(*packet), 0, (SOCKADDR*)&client_addr, client_addr_length) < 0) {
					cout << "发送错误" << endl;
					return 0;
				}
				packet->send_time = time(NULL);
				packetList.insert(packet);
			}
			else {// 数据已读完，将数据包置为空，递增序号用于客户端结束接受
				cout << "数据读取完成" << endl;
				notFinished = false;
				break;
			}
		}
	}
	end = clock();
	cout << "传输时间为" << (double)(end - start) / CLOCKS_PER_SEC << "秒" << endl;
	cout << "平均吞吐率为" << (double)((double)fileSize / ((double)(end - start) / CLOCKS_PER_SEC)) << endl;
	fclose(fp);
	closesocket(server_socket);
	WSACleanup();
	system("pause");
	return 0;
}