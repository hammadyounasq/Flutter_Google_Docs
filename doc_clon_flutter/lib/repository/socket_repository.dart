import 'package:doc_clon_flutter/clients/socket_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository{
  final _socketClient=SocketClient.instance.socket!;

Socket get socketClient=>_socketClient;

void joinRoom(String documentId){
  _socketClient.emit('join',documentId);
}

void typing(Map<String,dynamic> data){
  _socketClient.emit('typing',data);

}


void autoSave(Map<String,dynamic>data){
  _socketClient.emit('save',data);
}

void changeListener(Function(Map<String,dynamic>)fun){
  _socketClient.on('changes', (data) => fun(data));
}
}