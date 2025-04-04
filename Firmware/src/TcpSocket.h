#ifndef TCPSOCKET_H_
#define TCPSOCKET_H_

extern bool SocketConnected;

void startTcpSocket();
void stopTcpSocket();
void LoopSocketServer();
void SendToSocket(String txt);
void SendToSocket(char cc);
String ReadFromSocket(void);
bool DataAvailableInSocket(void);


#endif /* TCPSOCKET_H_ */
