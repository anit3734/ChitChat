import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const baseUrl = 'http://127.0.0.1:8000'; // FastAPI backend

  static Future<String?> loginOrSignup(String email, String password) async {
    final loginResponse = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    if (loginResponse.statusCode == 200) {
      return jsonDecode(loginResponse.body)['token'];
    } else {
      // If user doesn't exist, auto signup
      final signupResponse = await http.post(
        Uri.parse('$baseUrl/register'),
        body: {'email': email, 'password': password},
      );
      if (signupResponse.statusCode == 201) {
        return jsonDecode(signupResponse.body)['token'];
      }
    }
    return null;
  }
}
