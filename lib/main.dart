import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/users_list_screen.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Multi-User Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (_) => LoginScreen(),
        '/register': (_) => RegisterScreen(),
        '/users': (_) => UsersListScreen(token: ''), // token will be passed dynamically
      },
    );
  }
}
