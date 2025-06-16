// lib/screens/auth/prestator_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '/services/auth_service.dart'; // Pour obtenir l'ID de l'utilisateur authentifié si nécessaire
import '/services/prestator_service.dart'; // NOUVEAU: Import du service prestataire
import '/main.dart'; // Pour naviguer vers l'écran principal après l'inscription

class PrestatorScreen extends StatefulWidget {
  const PrestatorScreen({super.key});

  @override
  State<PrestatorScreen> createState() => _PrestatorScreenState();
}

class _PrestatorScreenState extends State<PrestatorScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _certificatePathController = TextEditingController(); // Pour le chemin du certificat
  final PrestatorService _prestatorService = PrestatorService(); // Instance du nouveau service
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
    _certificatePathController.dispose();
    super.dispose();
  }

  // Méthode pour soumettre le profil du prestataire
  Future<void> _submitPrestatorProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Réinitialiser le message d'erreur
    });

    // Ici, vous pourriez ajouter une validation des champs si nécessaire
    if (_descriptionController.text.isEmpty || _addressController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez remplir tous les champs obligatoires (Description, Adresse).';
        _isLoading = false;
      });
      return;
    }

    // Récupérer l'ID utilisateur (nécessaire si l'API Laravel l'attend explicitement)
    // Bien que Laravel puisse aussi utiliser Auth::id() directement
    final int? userId = await AuthService().getUserId();
    if (userId == null) {
      setState(() {
        _errorMessage = 'Erreur: ID utilisateur introuvable. Veuillez vous reconnecter.';
        _isLoading = false;
      });
      return;
    }

    final bool success = await _prestatorService.createOrUpdatePrestatorProfile(
      description: _descriptionController.text.trim(),
      address: _addressController.text.trim(),
      path: _certificatePathController.text.trim().isNotEmpty ? _certificatePathController.text.trim() : null, // Peut être nul si vide
    );

    if (success) {
      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil prestataire mis à jour avec succès !'), backgroundColor: Colors.green),
      );
      // Naviguer vers l'écran d'accueil/principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()), // Assurez-vous que MainScreen est la bonne destination
      );
    } else {
      // Le message d'erreur est déjà mis à jour par le service, mais on peut ajouter un fallback
      setState(() {
        _errorMessage = _errorMessage ?? 'Échec de la mise à jour du profil prestataire. Veuillez réessayer.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }


  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType, // Ajout du type de clavier
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        filled: true,
        fillColor: const Color.fromARGB(40, 255, 255, 255),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF3904F), Color(0xFF3B4371)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Container(color: Colors.transparent),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(60),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Informations Prestataire',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Complétez votre profil',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField('Description', _descriptionController, maxLines: 4),
                    const SizedBox(height: 16),
                    _buildTextField('Adresse', _addressController),
                    const SizedBox(height: 24),
                    const Text(
                      'Certificat ou Diplome (chemin du fichier)', // Texte clarifié
                      style: TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField('Chemin du certificat', _certificatePathController), // Champ pour le chemin
                    const SizedBox(height: 32),
                    // Afficher le message d'erreur si présent
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitPrestatorProfile, // Désactive le bouton si chargement
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white) // Affiche un indicateur de chargement
                          : const Text(
                        'TERMINER L\'INSCRIPTION',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
