import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  ChatPage({required this.userName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> messages = [
    {'text': 'Hey, kya haal hai?', 'sent': false},
    {'text': 'Sab badhiya, tu bata!', 'sent': true},
    {'text': 'Project ready hai kya?', 'sent': false},
  ];

  void sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add({'text': text, 'sent': true});
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: BackButton(color: AppColors.chit),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.chat.withOpacity(0.3),
              child: Text(
                widget.userName[0],
                style: TextStyle(color: AppColors.chat),
              ),
            ),
            SizedBox(width: 8),
            Text(
              widget.userName,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isSent = msg['sent'] as bool;
                return Align(
                  alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isSent ? AppColors.chat : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(isSent ? 12 : 0),
                        bottomRight: Radius.circular(isSent ? 0 : 12),
                      ),
                    ),
                    child: Text(
                      msg['text'],
                      style: TextStyle(
                        color: isSent ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.chat,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
