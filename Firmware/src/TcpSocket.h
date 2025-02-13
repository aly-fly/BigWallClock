#ifndef TCPSOCKET_H_
#define TCPSOCKET_H_

extern String SocketTxData;
extern bool SocketConnected;

void startTcpSocket();
void LoopSocketServer();
void SendToSocket(String txt);
String ReadFromSocket(void);
bool DataAvailableInSocket(void);


#endif /* TCPSOCKET_H_ */
