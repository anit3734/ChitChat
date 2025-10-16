import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  late IOWebSocketChannel channel;

  void connect(String token) {
    channel = IOWebSocketChannel.connect(
      Uri.parse('ws://10.26.149.193:8000/ws/chat?token=$token'),
    );
  }

  void sendMessage(int receiverId, String content) {
    channel.sink.add(jsonEncode({
      'type': 'message',
      'receiver_id': receiverId,
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
    }));
  }

  void sendTyping(int receiverId, bool status) {
    channel.sink.add(jsonEncode({
      'type': 'typing',
      'receiver_id': receiverId,
      'status': status,
    }));
  }

  Stream<dynamic> receive() {
    return channel.stream.map((event) => jsonDecode(event));
  }

  void disconnect() {
    channel.sink.close();
  }
}
