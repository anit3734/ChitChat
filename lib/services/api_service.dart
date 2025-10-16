import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/message.dart';

class ApiService {
  final String baseUrl = 'http://10.26.149.193:8000'; // replace with your backend

  // LOGIN
  Future<String?> login(String email, String password) async {
    final res = await http.post(Uri.parse('$baseUrl/login'),
        body: {'username': email, 'password': password});
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['access_token'];
    }
    return null;
  }

  // REGISTER
  Future<bool> register(String name, String email, String password) async {
    final res = await http.post(Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}));
    return res.statusCode == 200 || res.statusCode == 201;
  }

  // GET USERS
  Future<List<User>> getUsers(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {'Authorization': 'Bearer $token'},
    );
    final List data = jsonDecode(res.body);
    return data.map((e) => User.fromJson(e)).toList();
  }

  // GET MESSAGES
  Future<List<Message>> getMessages(String token, int otherUserId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/messages/$otherUserId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    final List data = jsonDecode(res.body);
    return data.map((e) => Message.fromJson(e)).toList();
  }
}
