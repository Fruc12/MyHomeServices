// lib/services/prestator_service.dart
import 'dart:convert';
import 'dart:io'; // Import pour la classe File
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p; // Import pour basename()
import 'http_service.dart';
import 'auth_service.dart';

class PrestatorService {
  final String apiUrl = HttpService.getBaseUrl();
  final AuthService _authService = AuthService();
  String? latestError; // Pour stocker le dernier message d'erreur pour l'UI

  // Méthode mise à jour pour créer ou mettre à jour le profil du prestataire avec un fichier
  Future<bool> createOrUpdatePrestatorProfile({
    required String description,
    required String address,
    File? certificateFile, // Accepte un File optionnel pour le certificat
  }) async {
    latestError = null; // Réinitialiser le message d'erreur à chaque appel
    final String? authToken = await _authService.getToken();
    final int? userId = await _authService.getUserId();

    if (authToken == null || userId == null) {
      print('Erreur PrestatorService: Utilisateur non authentifié ou ID utilisateur manquant.');
      latestError = 'Utilisateur non authentifié ou ID utilisateur manquant.';
      return false;
    }

    // L'endpoint reste le même si votre API gère la création/mise à jour
    // sur la même route en fonction de la présence d'un ID ou de la méthode HTTP.
    // Si vous avez des routes distinctes pour POST (créer) et PUT/PATCH (mettre à jour),
    // vous devrez ajuster cela. Pour cet exemple, nous supposons une route unique pour POST.
    final String endpoint = '${apiUrl}prestators';

    try {
      // Créer une requête multipart
      var request = http.MultipartRequest('POST', Uri.parse(endpoint));

      // Ajouter les headers
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $authToken';
      // 'Content-Type' sera automatiquement défini sur 'multipart/form-data' par http.MultipartRequest

      // Ajouter les champs de texte
      // L'ID utilisateur est souvent récupéré côté serveur via le token (Auth::id() dans Laravel)
      // mais si votre API l'exige explicitement dans le corps, vous pouvez l'ajouter.
      // Pour cet exemple, nous supposons que Laravel peut déterminer l'utilisateur via le token.
      // Si ce n'est pas le cas, décommentez et ajustez :
      // request.fields['user_id'] = userId.toString();

      request.fields['description'] = description;
      request.fields['address'] = address;

      // Ajouter le fichier s'il est fourni
      if (certificateFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'path', // Ce nom de champ doit correspondre à ce que votre API Laravel attend (ex: $request->file('certificate'))
            certificateFile.path,
            filename: p.basename(certificateFile.path), // Envoyer le nom de base du fichier
          ),
        );
        print('Fichier de certificat ajouté à la requête: ${p.basename(certificateFile.path)}');
      } else {
        // Si aucun fichier n'est fourni, vous pouvez choisir de ne rien envoyer pour ce champ
        // ou d'envoyer une valeur nulle/vide si votre API le gère.
        // Ici, nous n'ajoutons simplement pas le champ de fichier.
        // Si votre API ATTEND le champ 'path' même s'il est vide, vous devrez ajouter:
        // request.fields['path'] = ''; // ou null, selon ce que l'API attend
        print('Aucun fichier de certificat fourni.');
      }

      // Envoyer la requête
      final streamedResponse = await request.send();

      // Lire la réponse
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) { // 201 Created pour une nouvelle ressource
        print('Profil prestataire créé avec succès: ${response.body}');
        return true;
      } else if (response.statusCode == 200) { // 200 OK pour une mise à jour
        // Note: Si vous utilisez POST pour la création, une réponse 200 peut indiquer
        // que la ressource existait déjà et a été mise à jour, ou c'est la réponse de succès pour la création
        // selon la configuration de votre API.
        print('Profil prestataire mis à jour/créé avec succès: ${response.body}');
        return true;
      } else {
        // Gérer les erreurs de l'API
        try {
          final errorData = json.decode(response.body);
          latestError = errorData['message'] as String? ?? 'Erreur inconnue du serveur.';
          // Si votre API renvoie des erreurs de validation plus spécifiques:
          if (errorData['errors'] != null && errorData['errors'] is Map) {
            // Tentative d'extraire le premier message d'erreur de validation
            final errorsMap = errorData['errors'] as Map;
            if (errorsMap.isNotEmpty) {
              final firstErrorField = errorsMap.keys.first;
              if (errorsMap[firstErrorField] is List && (errorsMap[firstErrorField] as List).isNotEmpty) {
                latestError = (errorsMap[firstErrorField] as List).first as String?;
              }
            }
          }
          print('Échec de la création/mise à jour du profil prestataire: ${response.statusCode} - $latestError');
        } catch (e) {
          latestError = 'Réponse inattendue ou malformée du serveur.';
          print('Échec de la création/mise à jour du profil prestataire: ${response.statusCode} - ${response.body}');
        }
        return false;
      }
    } catch (e) {
      print('Erreur de connexion ou lors de la préparation de la requête: $e');
      latestError = 'Erreur de connexion. Veuillez vérifier votre réseau et réessayer.';
      return false;
    }
  }
}