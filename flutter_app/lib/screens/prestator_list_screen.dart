import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        setState(() {
          prestators = data['prestators'];
          isLoading = false;
        });
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

  Widget _buildHeaderImage() {
    return Stack(
      children: [
        // Using an AspectRatio widget to control the image's height proportionally
        // This helps prevent excessive cropping while maintaining aspect ratio.
        AspectRatio(
          aspectRatio: 16 / 9, // Common aspect ratio for images/videos
          child: Image.asset(
            'icons/cleaning-woman.jpg',
            width: double.infinity,
            fit: BoxFit.cover, // Still use cover to fill the AspectRatio box
          ),
        ),
        Positioned(
          top: 40,
          left: 16,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceInfo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.categoryName, // Dynamically use the category name here
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('• ', style: TextStyle(fontSize: 16, color: Colors.black54)), // Bullet point
              Expanded(
                child: Text(
                  'À partir de 500 FCFA/h - 1500 FCFA/h',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('• ', style: TextStyle(fontSize: 14, color: Colors.black54)), // Bullet point
              Expanded(
                child: Text(
                  'Simple, accessible, respectueux des personnes',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrestatorCard(Map<String, dynamic> prestator) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  prestator['name'] ?? 'Nom inconnu',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                // 5 empty stars
                Row(
                  children: List.generate(5, (index) => const Icon(Icons.star_border, size: 18, color: Colors.amber)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              prestator['description'] ?? 'Aucune description.',
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 6),
            if (prestator['address'] != null)
              Text('📍 ${prestator['address']}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 6),
            Text('Tarif : ${prestator['tarif'] ?? '1000 FCFA/h'}'),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () {
                  // Handle reservation logic here
                },
                child: const Text('Réserver'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
          : ListView(
        children: [
          _buildHeaderImage(),
          _buildServiceInfo(),
          const SizedBox(height: 8),
          ...prestators.map((prestator) => _buildPrestatorCard(prestator)).toList(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              onPressed: () {

              },
              child: const Text("Devenir prestataire MHS"),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}