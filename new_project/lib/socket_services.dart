import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect(String userId) {
    try {
      socket = IO.io('http://192.168.29.136:1001', <String, dynamic>{
        'transports': ['websocket'],
        'extraHeaders': {'userId': userId}
      });

      socket.on('connect',
          (_) => log('socket connection successful ${socket.id ?? ''}'));

      socket.on(
          'disconnect', (data) => log('socket disconnect ${socket.id ?? ''}'));
    } catch (e) {
      log('socket error: $e');
    }
  }

  void joinConversation(String conversationId) {
    socket.emit('joinConversation', conversationId);
  }

  void sendMessage(String conversationId, String senderId, String content) {
    socket.emit('sendMessage', {
      'conversationId': conversationId,
      'senderId': senderId,
      'content': content,
    });
  }

  void onReceiveMessage(Function(Map<String, dynamic>) callback) {
    socket.on('receiveMessage', (data) {
      callback(data);
    });
  }

  void dispose() {
    socket.disconnect();
  }
}
