#pragma comment(lib,"ws2_32.lib")
#include <WinSock2.h>
#include <string.h>
#include <iostream>
#include <stdio.h>
#include <time.h>
using namespace std;

#define SERVER_PORT 8000 
#define BUFFER_SIZE 1024 
#define FILE_NAME_MAX_SIZE 512 
int timeout = 1;

/* 包头 */
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

/* 接收包 */
typedef struct Packet
{
	PackInfo head;
	unsigned short buf_size;
	unsigned short Checksum;
	time_t send_time;
	Packet* next;
	char data[BUFFER_SIZE];
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

unsigned short checksum(Packet packet) {
	unsigned long sum = 0;
	sum += packet.head.seq;
	sum += packet.head.ack;
	sum += packet.head.syn;
	sum += packet.buf_size;
	sum += packet.Checksum;

	if (packet.buf_size % 2 == 0) {
		for (int i = 0; i < packet.buf_size; i += 2) {
			sum += (((unsigned short)packet.data[i]) << 8) | (unsigned short)packet.data[i + 1];
			sum = (sum >> 16) + (sum & 0xffff);
		}
	}
	else {
		for (int i = 0; i < packet.buf_size - 1; i += 2) {
			sum += (((unsigned short)packet.data[i]) << 8) | (unsigned short)packet.data[i + 1];
			sum = (sum >> 16) + (sum & 0xffff);
		}
		sum += (((unsigned short)packet.data[packet.buf_size - 1]) << 8);
		sum = (sum >> 16) + (sum & 0xffff);
	}
	if (sum >> 16 != 0)
		sum = (sum >> 16) + (sum & 0xffff);
	return ~sum;
}

SOCKET ShakeHands() {
	WORD wVersionRequested;
	WSAData wsaData;
	wVersionRequested = MAKEWORD(2, 2);
	// 开启服务 
	if (WSAStartup(wVersionRequested, &wsaData) != 0) {
		cout << "开启服务失败" << endl;
		exit(1);
	}

	SOCKADDR_IN client_addr;
	memset(&client_addr, 0, sizeof(client_addr));
	client_addr.sin_family = AF_INET;
	client_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
	client_addr.sin_port = htons(8001);

	/* 服务端地址 */
	SOCKADDR_IN server_addr;
	memset(&server_addr, 0, sizeof(server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
	server_addr.sin_port = htons(8000);
	int server_addr_length = sizeof(server_addr);

	/* 创建socket */
	SOCKET client_socket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if (client_socket < 0) {
		perror("Create Socket Failed:");
		exit(1);
	}
	if (-1 == (bind(client_socket, (SOCKADDR*)&client_addr, sizeof(client_addr)))) {
		perror("Server Bind Failed:");
		exit(1);
	}

	srand(time(NULL)); // 产生随机数
	PackInfo serverPackInfo;

	/* 接收建立连接的请求 */
	PackInfo clientPackInfo;
	clientPackInfo.syn = 1;
	clientPackInfo.seq = rand();
	// 发送建立连接的请求
	if (sendto(client_socket, (char*)&clientPackInfo, sizeof(clientPackInfo), 0, (SOCKADDR*)&server_addr, server_addr_length) < 0) {
		cout << "第1次握手，发送建立连接请求失败" << endl;
		exit(1);
	}

	// 接受确认连接
	if (recvfrom(client_socket, (char*)&serverPackInfo, sizeof(serverPackInfo), 0, (SOCKADDR*)&server_addr, &server_addr_length) == -1) {
		cout << "第2次握手，接受确认失败" << endl;
		exit(1);
	}
	if (serverPackInfo.syn == 1 && serverPackInfo.ack == (clientPackInfo.seq + 1)) {
		clientPackInfo.syn = 0;
		clientPackInfo.seq = clientPackInfo.seq + 1;
		clientPackInfo.ack = serverPackInfo.seq + 1;
		if (sendto(client_socket, (char*)&clientPackInfo, sizeof(clientPackInfo), 0, (SOCKADDR*)&server_addr, server_addr_length) < 0) {
			cout << "第3次握手，确认建立连接发送失败" << endl;
			exit(1);
		}

	}
	cout << "3次握手建立连接成功" << endl;
	return client_socket;
}

int main() {
	// 三次握手建立连接，获取连接套接字
	SOCKET client_socket = ShakeHands();

	// 设置文件所在位置，此处设置在E:/目录下，更换目录需手动更改
	char* file_path = new char[FILE_NAME_MAX_SIZE + 1];
	memset(file_path, 0, FILE_NAME_MAX_SIZE + 1);
	//strcat(file_path, "E:/");
	// 输入文件名
	cout << "Please Input File Name On Server: ";
	char* file_name = new char[100];
	memset(file_name, 0, 100);
	cin >> file_name;
	// 将文件名加入路径之后
	strcat(file_path, file_name);
	// 将路径拷贝进buffer
	char buffer[BUFFER_SIZE];
	memset(buffer, 0, BUFFER_SIZE);
	strncpy(buffer, file_path, strlen(file_path) > BUFFER_SIZE ? BUFFER_SIZE : strlen(file_path));

	SOCKADDR_IN server_addr;
	memset(&server_addr, 0, sizeof(server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
	server_addr.sin_port = htons(8000);
	int server_addr_length = sizeof(server_addr);

	// 发送文件路径
	if (sendto(client_socket, buffer, BUFFER_SIZE, 0, (SOCKADDR*)&server_addr, server_addr_length) < 0) {
		perror("Send File Name Failed:");
		exit(1);
	}

	// 设置写入目录，打开文件，准备写入
	/*char* dest_file = new char[FILE_NAME_MAX_SIZE + 1];
	memset(dest_file, 0, FILE_NAME_MAX_SIZE + 1);
	strcat(dest_file, "E:/CNtest/lab3/");
	strcat(dest_file, file_name);*/
	FILE* fp = fopen(file_name, "wb+");
	if (NULL == fp) {
		cout << "File:" << file_path << "Can Not Open To Write" << endl;
		exit(1);
	}

	int len = 0;
	Packet packet; //累计确认数据报，大小为2，即收到两个帧之后再进行确认并写入文件
	// 从服务器接收数据，并写入文件
	PackInfo packInfo; // 用于发送确认信息，ack=确认帧的seq
	int lastSeq = 0;
	packInfo.seq = 1;
	while (1) {
		if ((len = recvfrom(client_socket, (char*)&packet, sizeof(packet), 0, (SOCKADDR*)&server_addr, &server_addr_length)) > 0) {
			if (checksum(packet) != 0) {
				cout << "校验和计算发现错误，请求重传" << endl;
				if (sendto(client_socket, (char*)&packInfo, sizeof(packInfo), 0, (SOCKADDR*)&server_addr, server_addr_length) < 0) {
					cout << "发送确认信息失败" << endl;
				}
				continue;
			}
			if (packet.head.seq == packInfo.seq) {
				cout << "数据报" << packet.head.seq << "传输完成" << endl;
				packInfo.ack = packet.head.seq;
				++packInfo.seq;
				// 发送数据包确认信息
				if (sendto(client_socket, (char*)&packInfo, sizeof(packInfo), 0, (SOCKADDR*)&server_addr, server_addr_length) < 0) {
					cout << "发送信息失败" << endl;
				}
				/* 写入文件 */
				if (fwrite(packet.data, sizeof(char), packet.buf_size, fp) < packet.buf_size) {
					cout << "写入文件失败" << endl;
					break;
				}
			}
			else if (packet.head.seq > packInfo.seq) {
				packInfo.ack = packInfo.seq - 1;
				cout << "收到" << packet.head.seq << "!!!!!!!!!!!重发" << packInfo.ack << endl;
				/* 重发数据包确认信息 */
				if (sendto(client_socket, (char*)&packInfo, sizeof(packInfo), 0, (SOCKADDR*)&server_addr, server_addr_length) < 0)
					cout << "发送确认信息失败" << endl;
			}
		}
		else {
			break;
		}
	}

	cout << "从服务器接受文件成功！！！" << endl;
	fclose(fp);
	// 关闭套接字，释放资源 
	closesocket(client_socket);
	WSACleanup();
	system("pause");
	return 0;
}