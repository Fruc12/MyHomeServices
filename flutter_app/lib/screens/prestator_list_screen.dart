import 'package:flutter/material.dart';
import 'booking_form_screen.dart'; // Chemin à adapter
import '/services/services_service.dart'; // Chemin à adapter selon ton projet

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
  List<dynamic> services = [];
  bool isLoading = true;
  String errorMessage = '';

  final _serviceService = ServiceService();

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

    try {
      final data = await _serviceService.fetchServicesByCategory(widget.categoryId);
      setState(() {
        services = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red, fontSize: 16)))
          : ListView(
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 16),
          ...services.map((prestator) => _buildServiceCard(prestator)).toList(),
          const SizedBox(height: 24),
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

  Widget _buildHeaderSection() {
    final String imagePath = _categoryData[widget.categoryName]?['imagePath'] ?? 'assets/icons/default.jpg';
    final String priceRange = _categoryData[widget.categoryName]?['priceRange'] ?? 'Prix variables';

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              imagePath,
              fit: BoxFit.fitWidth,
              colorBlendMode: BlendMode.darken,
              color: Colors.black.withOpacity(0.3),
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.categoryName,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  priceRange,
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

  Widget _buildServiceCard(Map<String, dynamic> service) {
    final String tarifText = service['tarif'] != null ? '${service['tarif']} FCFA/h' : '1000 FCFA/h';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink.shade300, Colors.orange.shade200],
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
                  service['name'] ?? 'Nom inconnu',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
                const SizedBox(width: 8),
                Row(
                  children: List.generate(5, (_) => const Icon(Icons.star_border, color: Colors.white54, size: 20)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              service['description'] ?? 'Aucune description.',
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            // if (service['prestator']['address'] != null)
              Text(
                "📍 ${service['prestator']['address']}",
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            const SizedBox(height: 4),
            Text(
              'Tarif: $tarifText',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingFormScreen(prestator: service),
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
