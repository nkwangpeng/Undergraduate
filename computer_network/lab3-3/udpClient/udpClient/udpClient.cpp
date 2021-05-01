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

/* ��ͷ */
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

/* ���հ� */
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
	// �������� 
	if (WSAStartup(wVersionRequested, &wsaData) != 0) {
		cout << "��������ʧ��" << endl;
		exit(1);
	}

	SOCKADDR_IN client_addr;
	memset(&client_addr, 0, sizeof(client_addr));
	client_addr.sin_family = AF_INET;
	client_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
	client_addr.sin_port = htons(8001);

	/* ����˵�ַ */
	SOCKADDR_IN server_addr;
	memset(&server_addr, 0, sizeof(server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
	server_addr.sin_port = htons(8000);
	int server_addr_length = sizeof(server_addr);

	/* ����socket */
	SOCKET client_socket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if (client_socket < 0) {
		perror("Create Socket Failed:");
		exit(1);
	}
	if (-1 == (bind(client_socket, (SOCKADDR*)&client_addr, sizeof(client_addr)))) {
		perror("Server Bind Failed:");
		exit(1);
	}

	srand(time(NULL)); // ���������
	PackInfo serverPackInfo;

	/* ���ս������ӵ����� */
	PackInfo clientPackInfo;
	clientPackInfo.syn = 1;
	clientPackInfo.seq = rand();
	// ���ͽ������ӵ�����
	if (sendto(client_socket, (char*)&clientPackInfo, sizeof(clientPackInfo), 0, (SOCKADDR*)&server_addr, server_addr_length) < 0) {
		cout << "��1�����֣����ͽ�����������ʧ��" << endl;
		exit(1);
	}

	// ����ȷ������
	if (recvfrom(client_socket, (char*)&serverPackInfo, sizeof(serverPackInfo), 0, (SOCKADDR*)&server_addr, &server_addr_length) == -1) {
		cout << "��2�����֣�����ȷ��ʧ��" << endl;
		exit(1);
	}
	if (serverPackInfo.syn == 1 && serverPackInfo.ack == (clientPackInfo.seq + 1)) {
		clientPackInfo.syn = 0;
		clientPackInfo.seq = clientPackInfo.seq + 1;
		clientPackInfo.ack = serverPackInfo.seq + 1;
		if (sendto(client_socket, (char*)&clientPackInfo, sizeof(clientPackInfo), 0, (SOCKADDR*)&server_addr, server_addr_length) < 0) {
			cout << "��3�����֣�ȷ�Ͻ������ӷ���ʧ��" << endl;
			exit(1);
		}

	}
	cout << "3�����ֽ������ӳɹ�" << endl;
	return client_socket;
}

int main() {
	// �������ֽ������ӣ���ȡ�����׽���
	SOCKET client_socket = ShakeHands();

	// �����ļ�����λ�ã��˴�������E:/Ŀ¼�£�����Ŀ¼���ֶ�����
	char* file_path = new char[FILE_NAME_MAX_SIZE + 1];
	memset(file_path, 0, FILE_NAME_MAX_SIZE + 1);
	//strcat(file_path, "E:/");
	// �����ļ���
	cout << "Please Input File Name On Server: ";
	char* file_name = new char[100];
	memset(file_name, 0, 100);
	cin >> file_name;
	// ���ļ�������·��֮��
	strcat(file_path, file_name);
	// ��·��������buffer
	char buffer[BUFFER_SIZE];
	memset(buffer, 0, BUFFER_SIZE);
	strncpy(buffer, file_path, strlen(file_path) > BUFFER_SIZE ? BUFFER_SIZE : strlen(file_path));

	SOCKADDR_IN server_addr;
	memset(&server_addr, 0, sizeof(server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
	server_addr.sin_port = htons(8000);
	int server_addr_length = sizeof(server_addr);

	// �����ļ�·��
	if (sendto(client_socket, buffer, BUFFER_SIZE, 0, (SOCKADDR*)&server_addr, server_addr_length) < 0) {
		perror("Send File Name Failed:");
		exit(1);
	}

	// ����д��Ŀ¼�����ļ���׼��д��
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
	Packet packet; //�ۼ�ȷ�����ݱ�����СΪ2�����յ�����֮֡���ٽ���ȷ�ϲ�д���ļ�
	// �ӷ������������ݣ���д���ļ�
	PackInfo packInfo; // ���ڷ���ȷ����Ϣ��ack=ȷ��֡��seq
	int lastSeq = 0;
	packInfo.seq = 1;
	while (1) {
		if ((len = recvfrom(client_socket, (char*)&packet, sizeof(packet), 0, (SOCKADDR*)&server_addr, &server_addr_length)) > 0) {
			if (checksum(packet) != 0) {
				cout << "У��ͼ��㷢�ִ��������ش�" << endl;
				if (sendto(client_socket, (char*)&packInfo, sizeof(packInfo), 0, (SOCKADDR*)&server_addr, server_addr_length) < 0) {
					cout << "����ȷ����Ϣʧ��" << endl;
				}
				continue;
			}
			if (packet.head.seq == packInfo.seq) {
				cout << "���ݱ�" << packet.head.seq << "�������" << endl;
				packInfo.ack = packet.head.seq;
				++packInfo.seq;
				// �������ݰ�ȷ����Ϣ
				if (sendto(client_socket, (char*)&packInfo, sizeof(packInfo), 0, (SOCKADDR*)&server_addr, server_addr_length) < 0) {
					cout << "������Ϣʧ��" << endl;
				}
				/* д���ļ� */
				if (fwrite(packet.data, sizeof(char), packet.buf_size, fp) < packet.buf_size) {
					cout << "д���ļ�ʧ��" << endl;
					break;
				}
			}
			else if (packet.head.seq > packInfo.seq) {
				packInfo.ack = packInfo.seq - 1;
				cout << "�յ�" << packet.head.seq << "!!!!!!!!!!!�ط�" << packInfo.ack << endl;
				/* �ط����ݰ�ȷ����Ϣ */
				if (sendto(client_socket, (char*)&packInfo, sizeof(packInfo), 0, (SOCKADDR*)&server_addr, server_addr_length) < 0)
					cout << "����ȷ����Ϣʧ��" << endl;
			}
		}
		else {
			break;
		}
	}

	cout << "�ӷ����������ļ��ɹ�������" << endl;
	fclose(fp);
	// �ر��׽��֣��ͷ���Դ 
	closesocket(client_socket);
	WSACleanup();
	system("pause");
	return 0;
}