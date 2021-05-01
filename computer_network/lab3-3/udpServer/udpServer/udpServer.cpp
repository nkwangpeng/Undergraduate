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
int point = 0;// �ı䴰��ʱ��ȷ�ϵ�����seq
int repeat_ack = 0;
int lastSeq = 1;
size_t fileSize;

// ���ݱ�ͷ�� 
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
// ���ݱ�
typedef struct Packet
{
	PackInfo head; //α�ײ�
	unsigned short buf_size;
	unsigned short Checksum; // У���
	time_t send_time; // ����ʱ��
	Packet* next;
	char data[BUFFER_SIZE]; // ���ݻ�����
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

unsigned short checksum(Packet packet) { // У��ͼ���
	// ���ݱ����ֶ����
	unsigned long sum = 0;
	sum += packet.head.seq;
	sum += packet.head.ack;
	sum += packet.head.syn;
	sum += packet.buf_size;
	sum += packet.Checksum;

	if (packet.buf_size % 2 == 0) { // �����ۼ�
		for (int i = 0; i < packet.buf_size; i += 2) {
			// char����������8λ����һ��char���
			sum += (((unsigned short)packet.data[i]) << 8) | (unsigned short)packet.data[i + 1];
			sum = (sum >> 16) + (sum & 0xffff);
		}
	}
	else {// ����ȱʧ��0λ
		for (int i = 0; i < packet.buf_size - 1; i += 2) {
			sum += (((unsigned short)packet.data[i]) << 8) | (unsigned short)packet.data[i + 1];
			sum = (sum >> 16) + (sum & 0xffff);
		}
		sum += (((unsigned short)packet.data[packet.buf_size - 1]) << 8);
		sum = (sum >> 16) + (sum & 0xffff);
	}
	// ��λ�ӻ�ĩβ
	if (sum >> 16 != 0)
		sum = (sum >> 16) + (sum & 0xffff);

	return ~sum;
}

SOCKET ShakeHands() {
	WORD wVersionRequested;
	WSAData wsaData;
	wVersionRequested = MAKEWORD(2, 2);
	// ��������
	WSAStartup(wVersionRequested, &wsaData);

	// ����UDP�׽���
	SOCKADDR_IN server_addr;
	memset(&server_addr, 0, sizeof(server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
	server_addr.sin_port = htons(SERVER_PORT);

	// ����socket
	SOCKET server_socket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if (server_socket == -1) {
		perror("Create Socket Failed:");
		exit(1);
	}

	// ���׽���
	if (-1 == (bind(server_socket, (SOCKADDR*)&server_addr, sizeof(server_addr)))) {
		perror("Server Bind Failed:");
		exit(1);
	}

	srand(time(NULL)); // ���������
	PackInfo serverPackInfo;

	SOCKADDR_IN client_addr;
	memset(&client_addr, 0, sizeof(client_addr));
	client_addr.sin_family = AF_INET;
	client_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
	client_addr.sin_port = htons(8001);
	int client_addr_length = sizeof(client_addr);

	// ���ս������ӵ�����
	PackInfo clientPackInfo;
	if (recvfrom(server_socket, (char*)&clientPackInfo, sizeof(clientPackInfo), 0, (SOCKADDR*)&client_addr, &client_addr_length) == -1) {
		cout << "��1�����֣���������ʧ��" << endl;
		exit(1);
	}
	serverPackInfo.syn = clientPackInfo.syn;
	serverPackInfo.seq = rand();
	serverPackInfo.ack = clientPackInfo.seq + 1;
	if (sendto(server_socket, (char*)&serverPackInfo, sizeof(serverPackInfo), 0, (SOCKADDR*)&client_addr, client_addr_length) < 0) {
		cout << "��2�����֣�����ȷ��ʧ��" << endl;
		exit(1);
	}
	if (recvfrom(server_socket, (char*)&clientPackInfo, sizeof(clientPackInfo), 0, (SOCKADDR*)&client_addr, &client_addr_length) == -1) {
		cout << "��3�����֣�����ȷ��ʧ��" << endl;
		exit(1);
	}
	if (clientPackInfo.syn == 0 && clientPackInfo.seq == serverPackInfo.ack && clientPackInfo.ack == (serverPackInfo.seq + 1))
		cout << "3�����ֽ������ӳɹ�" << endl;

	return server_socket;
}

int main() {
	clock_t start, end;
	// �������ӣ���ȡ�׽���
	SOCKET server_socket = ShakeHands();

	// ����һ����ַ�����ڲ���ͻ��˵�ַ
	SOCKADDR_IN client_addr;
	memset(&client_addr, 0, sizeof(client_addr));
	client_addr.sin_family = AF_INET;
	client_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
	client_addr.sin_port = htons(8001);
	int client_addr_length = sizeof(client_addr);

	// ����������ݻ�����
	char buffer[BUFFER_SIZE];
	memset(buffer, 0, BUFFER_SIZE); // ��ʼ��������

	// ���ý����ļ�·����ʱΪ30s
	int WaitTime = 30000;
	setsockopt(server_socket, SOL_SOCKET, SO_RCVTIMEO, (char*)&WaitTime, sizeof(int));
	// �����ļ�·����buffer
	if (recvfrom(server_socket, buffer, BUFFER_SIZE, 0, (SOCKADDR*)&client_addr, &client_addr_length) == -1) {
		cout << "�ȴ���ʱ" << endl;
		exit(1);
	}
	start = clock();
	// ��buffer�п�����file_path
	char file_path[FILE_NAME_MAX_SIZE + 1];
	memset(file_path, 0, FILE_NAME_MAX_SIZE + 1);
	strncpy(file_path, buffer, strlen(buffer) > FILE_NAME_MAX_SIZE ? FILE_NAME_MAX_SIZE : strlen(buffer));
	cout << file_path << endl;

	// ���ļ� 
	FILE* fp = fopen(file_path, "rb+");
	fseek(fp, 0, SEEK_END);
	fileSize = ftell(fp);
	fclose(fp);
	fp = fopen(file_path, "rb+");
	if (NULL == fp) {
		cout << "�ļ���" << file_path << "û���ҵ�" << endl;
		return 0;
	}
	int len = 0; // ���ڽ��ն�ȡһ�����ݵĳ��ȣ��ֽ���
	PackInfo packInfo; // ���ڽ��տͻ��˵�ȷ����Ϣ
	Packet* packet = new Packet(); // ����һ����СΪ3��֡�Ĵ��ڣ����ڷ���
	PacketList packetList;
	// ����recvfrom�������ճ�ʱΪ1ms������ȡ�����������㴰�ڷ��͵�ʱ��
	setsockopt(server_socket, SOL_SOCKET, SO_RCVTIMEO, (char*)&timeout, sizeof(int));

	if ((len = fread(packet->data, 1, BUFFER_SIZE, fp)) > 0) {
		packet->buf_size = len;
		packet->head.seq = 1;
		packet->Checksum = 0;
		packet->Checksum = checksum(*packet);
	}
	if (sendto(server_socket, (char*)packet, sizeof(*packet), 0, (SOCKADDR*)&client_addr, client_addr_length) < 0) {
		cout << "���ʹ���" << endl;
		return 0;
	}
	// ��¼ȷ��֡�ķ���ʱ��
	packet->send_time = time(NULL);
	window_left = 0;
	window_right = 1;
	packetList.insert(packet);

	bool notFinished = true;
	unsigned short flag = 0;
	while (1) {
		// ����
		if (packetList.first == NULL) {
			if (sendto(server_socket, NULL, 0, 0, (SOCKADDR*)&client_addr, client_addr_length) < 0) {
				cout << "���ʹ���" << endl;
				return 0;
			}
			break;
		}
		// ����ȷ�ϳ�ʱ�������ش�
		if ((time(NULL) - packetList.first->send_time) >= 2) {
			cout << "��ʱ�ش�" << endl;

			Packet* temp = packetList.first;
			int i = 0;
			while (temp && (i < cwnd)) {
				if (sendto(server_socket, (char*)temp, sizeof(*temp), 0, (sockaddr*)&client_addr, client_addr_length) < 0) {
					cout << "���ʹ���" << endl;
					return 0;
				}
				cout << "��ʱ�ش�" << temp->head.seq << endl;
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
			// 1ms recvfrom���������أ����ϼ����ͻ��˻ظ���ȷ��
			if (recvfrom(server_socket, (char*)&packInfo, sizeof(packInfo), 0, (SOCKADDR*)&client_addr, &client_addr_length) == -1)
				break;
		}
		// �����ش�
		if (packInfo.ack < packetList.first->head.seq) {
			cout << "�����������������������յ��ظ�ack" << packInfo.ack << endl;
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
						cout << "���ʹ���" << endl;
						return 0;
					}
					cout << "�����ش�" << temp->head.seq << endl;
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
		// ����ȷ�ϣ�������˺���
		while (packetList.first && (packInfo.ack >= packetList.first->head.seq)) {
			if (packetList.first->head.seq == packInfo.ack) {
				cout << "��ȷ�ϵ�" << packInfo.ack << "������" << endl;
				packetList.first = packetList.first->next;
				break;
			}
			packetList.first = packetList.first->next;
		}
		window_left = packInfo.ack;

		if (!notFinished)
			continue;
		// ���Ӵ��ڴ�С
		if (window_left - point >= cwnd) {
			point = window_left;
			if (cwnd < ssthresh)
				cwnd *= 2;
			else
				cwnd++;
			cout << "���ڴ�С����Ϊ" << cwnd << endl;
		}
		// �����Ҷ˺��ƣ������½��봰�ڵı���
		for (window_right; window_right <= window_left + cwnd; window_right++) {
			cout << "���͵�" << lastSeq + 1 << "������" << endl;
			packet = new Packet();
			if ((len = fread(packet->data, 1, BUFFER_SIZE, fp)) > 0) {
				lastSeq++;
				packet->buf_size = len;
				packet->head.seq = lastSeq;
				packet->Checksum = 0;
				packet->Checksum = checksum(*packet);
				if (sendto(server_socket, (char*)packet, sizeof(*packet), 0, (SOCKADDR*)&client_addr, client_addr_length) < 0) {
					cout << "���ʹ���" << endl;
					return 0;
				}
				packet->send_time = time(NULL);
				packetList.insert(packet);
			}
			else {// �����Ѷ��꣬�����ݰ���Ϊ�գ�����������ڿͻ��˽�������
				cout << "���ݶ�ȡ���" << endl;
				notFinished = false;
				break;
			}
		}
	}
	end = clock();
	cout << "����ʱ��Ϊ" << (double)(end - start) / CLOCKS_PER_SEC << "��" << endl;
	cout << "ƽ��������Ϊ" << (double)((double)fileSize / ((double)(end - start) / CLOCKS_PER_SEC)) << endl;
	fclose(fp);
	closesocket(server_socket);
	WSACleanup();
	system("pause");
	return 0;
}