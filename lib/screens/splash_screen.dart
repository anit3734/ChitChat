import 'package:chitchat/screens/chat_list_screen.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ChatListScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Chit",
                style: TextStyle(
                  color: AppColors.chit,
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              TextSpan(
                text: "Chat",
                style: TextStyle(
                  color: AppColors.chat,
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
