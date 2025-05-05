import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String _baseUrl = 'http://localhost:8000/api/'; // à adapter
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> fetchUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.post(
      Uri.parse('${_baseUrl}auth'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    }
    else {
      return null;
    }
  }
}
