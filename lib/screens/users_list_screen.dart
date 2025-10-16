import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'chat_screen.dart';

class UsersListScreen extends StatefulWidget {
  final String token;
  UsersListScreen({required this.token});

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  List<User> users = [];
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    final data = await apiService.getUsers(widget.token);
    setState(() {
      users = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (_, index) {
          final user = users[index];
          return ListTile(
            leading: Icon(Icons.circle, color: user.online ? Colors.green : Colors.red),
            title: Text(user.name),
            subtitle: Text(user.online ? "Online" : "Last seen: ${user.lastSeen}"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChatScreen(token: widget.token, user: user, currentUserId: 1)),
            ),
          );
        },
      ),
    );
  }
}
