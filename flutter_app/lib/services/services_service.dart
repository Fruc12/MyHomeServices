import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'http_service.dart'; // Adapte le chemin selon ta structure

class ServiceService {
  final String baseUrl = HttpService.getBaseUrl();

  Future<List<dynamic>> fetchServicesByCategory(int categoryId) async {
    final String url = '${baseUrl}categories/$categoryId/services';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(Uri.parse(url),
        headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'] ?? [];
      } else {
        throw Exception('Erreur ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
