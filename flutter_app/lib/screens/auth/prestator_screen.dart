// lib/screens/auth/prestator_screen.dart
import 'dart:convert'; // Pour encoder les données du formulaire
import 'dart:io'; // Pour travailler avec les fichiers
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart'; // Import du sélecteur de fichiers
import 'package:http/http.dart' as http; // Import du package http
import 'package:path/path.dart' as p; // Pour basename()

import '/services/auth_service.dart';
import '/services/prestator_service.dart';
import 'login_screen.dart';

class PrestatorScreen extends StatefulWidget {
  const PrestatorScreen({super.key});

  @override
  State<PrestatorScreen> createState() => _PrestatorScreenState();
}

class _PrestatorScreenState extends State<PrestatorScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  // Plus besoin de _certificatePathController, nous allons stocker le fichier directement
  File? _selectedCertificate; // Pour stocker le fichier sélectionné
  String? _selectedFileName; // Pour afficher le nom du fichier sélectionné

  final PrestatorService _prestatorService = PrestatorService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Méthode pour sélectionner un fichier
  Future<void> _pickCertificateFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        // Vérifier la taille du fichier (2MB = 2 * 1024 * 1024 bytes)
        if (file.size > 2 * 1024 * 1024) {
          setState(() {
            _errorMessage = 'Le fichier est trop volumineux. La taille maximale est de 2Mo.';
            _selectedCertificate = null;
            _selectedFileName = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Le fichier est trop volumineux (max 2Mo).'), backgroundColor: Colors.red),
          );
          return;
        }

        setState(() {
          _selectedCertificate = File(file.path!);
          _selectedFileName = file.name;
          _errorMessage = null; // Réinitialiser le message d'erreur si un fichier est choisi
        });
      } else {
        // L'utilisateur a annulé la sélection
        setState(() {
          // Optionnel: réinitialiser si l'utilisateur annule
          // _selectedCertificate = null;
          // _selectedFileName = null;
        });
      }
    } catch (e) {
      // Gérer les erreurs de sélection de fichier
      print('Erreur lors de la sélection du fichier: $e');
      setState(() {
        _errorMessage = 'Erreur lors de la sélection du fichier.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la sélection du fichier.'), backgroundColor: Colors.red),
      );
    }
  }

  // Méthode pour soumettre le profil du prestataire (modifiée)
  Future<void> _submitPrestatorProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (_descriptionController.text.isEmpty || _addressController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez remplir tous les champs obligatoires (Description, Adresse).';
        _isLoading = false;
      });
      return;
    }

    // Le `PrestatorService` doit maintenant gérer l'upload du fichier
    // Il est préférable de passer le fichier lui-même au service.
    // Votre service devra utiliser `http.MultipartRequest` pour envoyer des données de formulaire ET le fichier.

    final bool success = await _prestatorService.createOrUpdatePrestatorProfile(
      description: _descriptionController.text.trim(),
      address: _addressController.text.trim(),
      certificateFile: _selectedCertificate, // Passer le fichier sélectionné
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil prestataire mis à jour avec succès !'), backgroundColor: Colors.green),
      );
      AuthService().logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      setState(() {
        // Le message d'erreur est généralement défini dans le service en cas d'échec de l'API
        _errorMessage = _prestatorService.latestError ?? 'Échec de la mise à jour du profil prestataire. Veuillez réessayer.';
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
      keyboardType: keyboardType,
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
          // ... (Votre code pour le fond et le filtre de flou reste inchangé)
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
                      'Certificat ou Diplôme (PDF, JPG, PNG - max 2Mo)',
                      style: TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    // Bouton pour sélectionner le fichier
                    ElevatedButton.icon(
                      icon: const Icon(Icons.attach_file),
                      label: Text(_selectedFileName ?? 'Choisir un fichier'),
                      onPressed: _pickCertificateFile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    // Optionnel: Afficher une miniature si c'est une image
                    if (_selectedCertificate != null &&
                        (p.extension(_selectedCertificate!.path).toLowerCase() == '.jpg' ||
                            p.extension(_selectedCertificate!.path).toLowerCase() == '.jpeg' ||
                            p.extension(_selectedCertificate!.path).toLowerCase() == '.png'))
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Image.file(
                          _selectedCertificate!,
                          height: 100,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text('Impossible d\'afficher l\'aperçu', style: TextStyle(color: Colors.red));
                          },
                        ),
                      ),
                    const SizedBox(height: 32),
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
                      onPressed: _isLoading ? null : _submitPrestatorProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
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