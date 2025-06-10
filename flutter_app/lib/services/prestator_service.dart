// lib/services/prestator_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'http_service.dart'; // Assurez-vous que ce chemin est correct
import 'auth_service.dart'; // Pour récupérer le token et l'ID utilisateur

class PrestatorService {
  final String apiUrl = HttpService.getBaseUrl(); // Utilise la méthode getBaseUrl() de HttpService
  final AuthService _authService = AuthService(); // Instance d'AuthService

  // Méthode pour créer ou mettre à jour le profil du prestataire
  Future<bool> createOrUpdatePrestatorProfile({
    required String description,
    required String address,
    String? path, // Le chemin du certificat/diplôme, peut être nul
  }) async {
    final String? authToken = await _authService.getToken();
    final int? userId = await _authService.getUserId();

    if (authToken == null || userId == null) {
      print('Erreur PrestatorService: Utilisateur non authentifié ou ID utilisateur manquant.');
      return false;
    }

    final String endpoint = '${apiUrl}prestators'; // Nouvel endpoint API pour les prestataires

    try {
      final response = await http.post( // Utiliser POST pour créer ou PUT pour mettre à jour si l'ID est connu
        Uri.parse(endpoint),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken', // Envoi du Bearer Token
        },
        body: jsonEncode({
          'user_id': userId, // L'ID de l'utilisateur est envoyé (bien que Laravel puisse le récupérer via Auth::id())
          'description': description,
          'address': address,
          'path': path, // Chemin du certificat/diplôme
          // 'validate' et 'id' sont gérés côté Laravel
        }),
      );

      if (response.statusCode == 201) { // 201 Created pour une nouvelle ressource
        print('Profil prestataire créé avec succès: ${response.body}');
        return true;
      } else if (response.statusCode == 200) { // 200 OK pour une mise à jour
        print('Profil prestataire mis à jour avec succès: ${response.body}');
        return true;
      } else {
        final errorData = json.decode(response.body);
        print('Échec de la création/mise à jour du profil prestataire: ${response.statusCode} - ${errorData['message']}');
        return false;
      }
    } catch (e) {
      print('Erreur de connexion lors de la création/mise à jour du profil prestataire: $e');
      return false;
    }
  }
}
