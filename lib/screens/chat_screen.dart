import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/message.dart';
import '../services/api_service.dart';
import '../services/websocket_service.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String token;
  final User user;
  final int currentUserId;

  ChatScreen({required this.token, required this.user, required this.currentUserId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> messages = [];
  ApiService apiService = ApiService();
  WebSocketService wsService = WebSocketService();
  TextEditingController controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    fetchMessages();
    wsService.connect(widget.token);
    wsService.receive().listen(handleIncoming);
  }

  void fetchMessages() async {
    final data = await apiService.getMessages(widget.token, widget.user.id);
    setState(() {
      messages = data;
    });
    scrollToBottom();
  }

  void handleIncoming(dynamic data) {
    if (data['type'] == 'typing' && data['sender_id'] == widget.user.id) {
      setState(() {
        isTyping = data['status'];
      });
      return;
    }

    if (data['type'] == 'message') {
      final msg = Message(
        id: data['id'] ?? 0,
        senderId: data['sender_id'],
        receiverId: data['receiver_id'],
        content: data['content'],
        timestamp: DateTime.parse(data['timestamp']),
      );
      setState(() {
        messages.add(msg);
      });
      scrollToBottom();
    }
  }

  void sendMessage() {
    if (controller.text.isEmpty) return;
    wsService.sendMessage(widget.user.id, controller.text);

    setState(() {
      messages.add(Message(
        id: 0,
        senderId: widget.currentUserId,
        receiverId: widget.user.id,
        content: controller.text,
        timestamp: DateTime.now(),
      ));
    });
    controller.clear();
    sendTyping(false);
    scrollToBottom();
  }

  void sendTyping(bool status) {
    wsService.sendTyping(widget.user.id, status);
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    wsService.disconnect();
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.name)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (_, index) {
                final msg = messages[index];
                return MessageBubble(
                  content: msg.content,
                  isMe: msg.senderId == widget.currentUserId,
                  timestamp: msg.timestamp,
                );
              },
            ),
          ),
          if (isTyping)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("${widget.user.name} is typing...",
                  style: TextStyle(fontStyle: FontStyle.italic)),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: (text) => sendTyping(text.isNotEmpty),
                  decoration: InputDecoration(hintText: "Type a message"),
                ),
              ),
              IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
            ],
          )
        ],
      ),
    );
  }
}
