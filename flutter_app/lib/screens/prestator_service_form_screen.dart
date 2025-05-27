// lib/screens/prestator_service_form_screen.dart
import 'package:flutter/material.dart';

class PrestatorServiceFormScreen extends StatefulWidget {
  const PrestatorServiceFormScreen({Key? key}) : super(key: key);

  @override
  State<PrestatorServiceFormScreen> createState() => _PrestatorServiceFormScreenState();
}

class _PrestatorServiceFormScreenState extends State<PrestatorServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _serviceName;
  String? _serviceDescription;
  String? _tarif; // Ajout du champ tarif
  String? _prestatorId; // ID du prestataire (peut être pré-rempli ou récupéré)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gérer mes services', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ajouter ou modifier un service',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nom du service',
                  hintText: 'Ex: Ménage standard, Coiffure mariage',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.cleaning_services),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom du service';
                  }
                  return null;
                },
                onSaved: (value) {
                  _serviceName = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description du service',
                  hintText: 'Ex: Nettoyage complet de la cuisine, salon, chambres...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _serviceDescription = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Tarif (FCFA/heure ou service)',
                  hintText: 'Ex: 2500',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un tarif';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
                onSaved: (value) {
                  _tarif = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                enabled: false, // L'ID du prestataire sera normalement géré automatiquement
                decoration: InputDecoration(
                  labelText: 'ID Prestataire',
                  hintText: 'Votre ID unique (généré automatiquement)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.perm_identity),
                ),
                initialValue: 'PRESTA_12345', // Exemple d'ID, à remplacer par le réel
                onSaved: (value) {
                  _prestatorId = value;
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Ici, vous enverrez les données à votre API
                      print('Service Name: $_serviceName');
                      print('Service Description: $_serviceDescription');
                      print('Tarif: $_tarif');
                      print('Prestator ID: $_prestatorId');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Service ajouté avec succès !')),
                      );
                      // Réinitialiser le formulaire
                      _formKey.currentState!.reset();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text(
                    'Ajouter ce service',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}