
import 'package:flutter/foundation.dart'; // Pour ValueNotifier

class RoleManager extends ChangeNotifier {

  static final ValueNotifier<String> _currentRole = ValueNotifier<String>('prestataire'); // 'client' ou 'prestataire'

  static String get currentRole => _currentRole.value;

  static void setRole(String role) {
    if (_currentRole.value != role) {
      _currentRole.value = role;
      // Pas besoin de notifyListeners() car ValueNotifier le fait automatiquement
      // mais on peut ajouter une logique si besoin pour des listeners externes.
    }
  }

  // Permet d'écouter les changements de rôle
  static ValueListenable<String> get roleListenable => _currentRole;
}