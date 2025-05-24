import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrestatorListScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const PrestatorListScreen({Key? key, required this.categoryId, required this.categoryName}) : super(key: key);

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
        if (data.containsKey('prestators')) {
          setState(() {
            prestators = data['prestators'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Réponse API invalide.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Erreur lors de la récupération des prestataires: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Impossible de contacter le serveur.';
        isLoading = false;
      });
      print('Erreur de connexion: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prestataires pour ${widget.categoryName}'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
          : prestators.isEmpty
          ? Center(child: Text('Aucun prestataire trouvé pour cette catégorie.'))
          : ListView.builder(
        itemCount: prestators.length,
        itemBuilder: (context, index) {
          final prestator = prestators[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(prestator['name'] ?? 'Nom inconnu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(prestator['description'] ?? 'Description non disponible'),
                  SizedBox(height: 8),
                  Text('Adresse: ${prestator['address'] ?? 'Adresse non disponible'}'),
                  // Vous pouvez ajouter d'autres informations ici
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}