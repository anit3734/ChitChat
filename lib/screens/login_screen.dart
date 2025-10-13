import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordHidden = true; // toggle for password

  void handleLogin() async {
    setState(() => isLoading = true);
    final token = await AuthService.loginOrSignup(
      emailController.text,
      passwordController.text,
    );
    setState(() => isLoading = false);

    if (token != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login successful! Token: $token")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error logging in")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(height: 80), // Move app name higher
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Chit",
                      style: TextStyle(
                        color: AppColors.chit,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Chat",
                      style: TextStyle(
                        color: AppColors.chat,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email, color: AppColors.chit),
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: isPasswordHidden,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: AppColors.chat),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.chat,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordHidden = !isPasswordHidden;
                      });
                    },
                  ),
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: handleLogin,
                      child: Text("Login"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.chat,
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
              Spacer(),
              Text(
                "Best text / footer",
                style: TextStyle(
                  color: AppColors.chit,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
