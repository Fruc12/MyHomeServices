// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'http_service.dart'; // Assurez-vous que ce fichier et sa méthode getBaseUrl() existent

class AuthService {
  final String apiUrl = HttpService.getBaseUrl(); // Utilise la méthode getBaseUrl() de HttpService

  // Clés pour SharedPreferences
  static const String _authTokenKey = 'token'; // Votre clé originale pour le token
  static const String _userIdKey = 'userId'; // Nouvelle clé pour l'ID utilisateur

  // Inscription
  Future<bool> register(String name, String email, String password, String role) async {
    final response = await http.post(
      Uri.parse('${apiUrl}register'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    return response.statusCode == 201;
  }

  // Connexion
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${apiUrl}login'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token']; // Extrait le token

      // --- CORRECTION ET AJOUT ICI : Extraire et stocker l'ID utilisateur ---
      final int? userId = data['data']['id']; // CORRECT : l'ID est sous 'data' -> 'id'

      if (token != null && userId != null) {
        await _saveToken(token); // Stocke le token avec la méthode existante
        await _saveUserId(userId); // Nouvelle méthode pour stocker l'ID
        return true;
      } else {
        // Gérer le cas où le token ou l'ID utilisateur sont manquants dans la réponse API
        print('Erreur: Token ou ID utilisateur manquant dans la réponse de login.');
        return false; // Retourne false si les données essentielles sont manquantes
      }
    } else {
      return false;
    }
  }

  // Déconnexion
  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_authTokenKey); // Utilise la clé constante

    // Si pas de token, l'utilisateur est déjà déconnecté localement
    if (token == null) {
      await prefs.remove(_authTokenKey);
      await prefs.remove(_userIdKey); // CORRECT : Nettoie aussi l'ID utilisateur
      return true;
    }

    final response = await http.post(
      Uri.parse('${apiUrl}logout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      await prefs.remove(_authTokenKey);
      await prefs.remove(_userIdKey); // CORRECT : Nettoie aussi l'ID utilisateur
      return true;
    } else {
      print('Échec de la déconnexion sur le serveur: ${response.statusCode} - ${response.body}');
      // Même en cas d'échec côté serveur, on nettoie localement pour éviter des états incohérents
      await prefs.remove(_authTokenKey);
      await prefs.remove(_userIdKey); // CORRECT : Nettoie aussi l'ID utilisateur
      return false;
    }
  }

  // Méthode existante pour sauvegarder le token
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
    print('DEBUG AUTH: Token SAUVEGARDE: $token');
  }

  // --- NOUVELLE MÉTHODE : Sauvegarder l'ID utilisateur ---
  Future<void> _saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }

  // Méthode existante pour obtenir le token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  // --- NOUVELLE MÉTHODE : Obtenir l'ID utilisateur ---
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  // Méthode pour vérifier le statut d'authentification
  Future<bool> checkAuthStatus() async {
    final url = Uri.parse('${apiUrl}auth'); // à adapter
    final token = await getToken();

    if (token == null) {
      return false;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur lors de la vérification du statut d\'authentification: $e');
      return false;
    }
  }
}