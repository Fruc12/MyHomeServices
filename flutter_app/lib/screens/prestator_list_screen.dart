import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'booking_form_screen.dart'; // Assurez-vous que le chemin est correct

class PrestatorListScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const PrestatorListScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  _PrestatorListScreenState createState() => _PrestatorListScreenState();
}

class _PrestatorListScreenState extends State<PrestatorListScreen> {
  List<dynamic> prestators = [];
  bool isLoading = true;
  String errorMessage = '';

  // Define category specific data (image paths and price ranges)
  final Map<String, Map<String, String>> _categoryData = {
    "Ménage": {
      "imagePath": 'icons/cleaning-woman.jpg',
      "priceRange": 'Dès 2500 - 3500 FCFA/h',
    },
    "Garde d'enfants": {
      "imagePath": 'icons/babysitter.jpg',
      "priceRange": 'Dès 1500 - 2500 FCFA/h',
    },
    "Coiffure": {
      "imagePath": 'icons/hair-stylist.jpg',
      "priceRange": 'Dès 5000 FCFA/service',
    },
    "Beauté": {
      "imagePath": 'icons/beauty-service.jpg',
      "priceRange": 'Dès 7000 FCFA/service',
    },
    "Massage": {
      "imagePath": 'icons/massage-therapist.jpg',
      "priceRange": 'Dès 10000 FCFA/heure',
    },
    "Coach sportif": {
      "imagePath": 'icons/sport-coach.jpg',
      "priceRange": 'Dès 8000 FCFA/séance',
    },
    // Ajoutez d'autres catégories ici si nécessaire
  };

  @override
  void initState() {
    super.initState();
    _fetchPrestators();
  }

  Future<void> _fetchPrestators() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final String apiUrl = 'http://localhost:8000/api/prestators/category/${widget.categoryId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('prestators')) {
          setState(() {
            prestators = data['prestators'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Réponse API invalide: manque la clé "prestators".';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Erreur ${response.statusCode} lors de la récupération.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de connexion.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Un fond doux pour la page
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red, fontSize: 16)))
          : ListView(
        children: [
          // En-tête avec image dynamique et dégradé
          _buildHeaderSection(),
          const SizedBox(height: 16), // Espace entre le header et la liste
          // Liste des prestataires
          ...prestators.map((prestator) => _buildPrestatorCard(prestator)).toList(),
          const SizedBox(height: 24),
          // Bouton "Devenir prestataire"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                side: const BorderSide(color: Colors.deepPurple),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Logique pour "Devenir prestataire MHS"
                print('Bouton "Devenir prestataire MHS" pressé');
              },
              child: const Text(
                "Devenir prestataire MHS",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Ancien _buildHeaderImage et _buildServiceInfo combinés et retravaillés en _buildHeaderSection
  Widget _buildHeaderSection() {
    final String imagePath = _categoryData[widget.categoryName]?['imagePath'] ?? 'assets/icons/default.jpg'; // Chemin par défaut
    final String priceRange = _categoryData[widget.categoryName]?['priceRange'] ?? 'Prix variables'; // Texte par défaut

    return Container(
      width: double.infinity,
      // Removed fixed height here
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)], // Dégradé de violet plus foncé à plus clair
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Image de fond pour la catégorie
          Positioned.fill(
            child: Image.asset(
              imagePath,
              fit: BoxFit.fitWidth, // Changed from BoxFit.cover to BoxFit.fitWidth
              // This will ensure the width is covered, and the height adjusts accordingly
              // without cropping, though it might leave empty space if aspect ratio is very different.
              // If you want to ensure the height is always filled, and allow some cropping on sides,
              // then BoxFit.cover is fine, but you might need to adjust the Container's height.
              // Consider a fixed aspect ratio for the image container if design allows.

              // Ajout d'un colorFilter pour assombrir l'image et améliorer la lisibilité du texte
              colorBlendMode: BlendMode.darken,
              color: Colors.black.withOpacity(0.3),
              errorBuilder: (context, error, stackTrace) {
                // Gère les erreurs de chargement d'image
                return Container(
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),
          // Contenu du texte et bouton retour
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 20), // Padding pour le contenu
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 10), // Espace après le bouton retour
                Text(
                  widget.categoryName,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  priceRange, // Prix dynamique
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                const Text(
                  '✔ Des professionnels sélectionnés\n'
                      '✔ Service simple, accessible, respectueux\n'
                      '✔ Annulation sans frais',
                  style: TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrestatorCard(Map<String, dynamic> prestator) {
    // Le tarif peut venir de l'API (prestator['tarif']) ou utiliser une valeur par défaut.
    final String tarifText = prestator['tarif'] != null ? '${prestator['tarif']} FCFA/h' : '1000 FCFA/h';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient( // Dégradé pour les cartes (rose/orange doux)
          // CHANGEMENT APPORTÉ ICI:
          colors: [Colors.pink.shade300, Colors.orange.shade200], // Nouvelles couleurs de dégradé
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  prestator['name'] ?? 'Nom inconnu',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
                const SizedBox(width: 8),
                // 5 étoiles vides
                Row(
                  children: List.generate(5, (index) {
                    return const Icon(
                      Icons.star_border, // Étoile vide
                      color: Colors.white54, // Couleur ambre pour les étoiles
                      size: 20,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              prestator['description'] ?? 'Aucune description.',
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            if (prestator['address'] != null)
              Text(
                '📍 ${prestator['address']}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            const SizedBox(height: 4),
            Text(
              'Tarif: $tarifText',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepPurple), // Tarif en violet
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Couleur du bouton "Réserver"
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // C'est ici que la navigation vers BookingFormScreen est ajoutée !
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingFormScreen(prestator: prestator),
                    ),
                  );
                },
                child: const Text('Réserver'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}