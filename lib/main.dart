import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChitChat',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
