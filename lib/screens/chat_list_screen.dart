import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'chat_page.dart'; // import ChatPage

class ChatListScreen extends StatelessWidget {
  final List<Map<String, String>> contacts = [
    {
      'name': 'Alice',
      'lastMessage': 'Hey, kya haal hai?',
      'time': '12:30 PM',
    },
    {
      'name': 'Bob',
      'lastMessage': 'Kal milte hain!',
      'time': '11:15 AM',
    },
    {
      'name': 'Charlie',
      'lastMessage': 'Flutter project ready hai',
      'time': 'Yesterday',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Chit',
                style: TextStyle(
                  color: AppColors.chit,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'Chat',
                style: TextStyle(
                  color: AppColors.chat,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.chat.withOpacity(0.3),
                child: Text(
                  contact['name']![0],
                  style: TextStyle(color: AppColors.chat),
                ),
              ),
              title: Text(
                contact['name']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                contact['lastMessage']!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                contact['time']!,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {
                // Navigate to ChatPage with userName
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatPage(userName: contact['name']!),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Start new chat')),
          );
        },
        backgroundColor: AppColors.chat,
        child: Icon(Icons.chat),
      ),
    );
  }
}
