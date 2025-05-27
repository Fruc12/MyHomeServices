import 'dart:convert';
import 'package:http/http.dart' as http;
import 'http_service.dart'; // Adapte le chemin selon ta structure

class ServiceService {
  final String baseUrl = HttpService.getBaseUrl();

  Future<List<dynamic>> fetchServicesByCategory(int categoryId) async {
    final String url = '${baseUrl}categories/$categoryId/services';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data']['prestators'] ?? [];
      } else {
        throw Exception('Erreur ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion');
    }
  }
}
