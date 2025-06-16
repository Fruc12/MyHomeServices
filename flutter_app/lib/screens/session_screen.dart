// lib/screens/session_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_app/services/auth_service.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  List<dynamic> _allReservations = []; // Pour stocker toutes les réservations
  List<dynamic> _upcomingReservations = [];
  List<dynamic> _completedReservations = [];
  List<dynamic> _canceledReservations = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchReservations(); // Appel initial pour charger les données
  }

  Future<void> _fetchReservations() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final String? authToken = await AuthService().getToken();
      final int? userId = await AuthService().getUserId();

      if (authToken == null || userId == null) {
        setState(() {
          errorMessage = 'Erreur: Utilisateur non authentifié. Veuillez vous connecter.';
          isLoading = false;
        });
        return;
      }

      final String baseUrl = 'http://localhost:8000';
      // L'API renvoie des réservations pour 'customer' ou 'prestator'.
      // Ici, nous supposons que l'utilisateur est un 'customer'.
      // Vous devrez ajuster si l'utilisateur peut être un prestataire.
      final String apiUrl = '$baseUrl/api/reservations/customer';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // *** CORRECTION ICI : Utilisation de la clé "data" ***
        if (responseData.containsKey('data') && responseData['data'] is List) {
          _allReservations = responseData['data'];
          _filterReservations(); // Filtrer les réservations après les avoir chargées
        } else {
          errorMessage = 'Réponse API invalide : la clé "data" est manquante ou n\'est pas une liste.';
        }
      } else {
        errorMessage = 'Échec du chargement des sessions: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Erreur de connexion : $e';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterReservations() {
    final now = DateTime.now();
    _upcomingReservations.clear();
    _completedReservations.clear();
    _canceledReservations.clear();

    for (var reservation in _allReservations) {
      // Parse la date et l'heure de la réservation
      final reservationDate = DateTime.parse(reservation['date']);
      final reservationTimeParts = reservation['time'].split(':');
      final reservationTime = TimeOfDay(
        hour: int.parse(reservationTimeParts[0]),
        minute: int.parse(reservationTimeParts[1]),
      );

      final reservationDateTime = DateTime(
        reservationDate.year,
        reservationDate.month,
        reservationDate.day,
        reservationTime.hour,
        reservationTime.minute,
      );

      final status = reservation['status'];

      if (status == 'canceled') {
        _canceledReservations.add(reservation);
      } else if (reservationDateTime.isAfter(now)) {
        _upcomingReservations.add(reservation);
      } else {
        _completedReservations.add(reservation);
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange; // Orange pour "en attente" ou "à venir"
      case 'in_progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      case 'reported': // Si vous avez un statut "signalé"
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mes sessions", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.orange,
            tabs: [
              Tab(text: "À venir"),
              Tab(text: "Réalisées"),
              Tab(text: "Annulées"),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
            : TabBarView(
          children: [
            _buildSessionList(_upcomingReservations, "Aucune réservation à venir."),
            _buildSessionList(_completedReservations, "Aucune session réalisée."),
            _buildSessionList(_canceledReservations, "Aucune session annulée."),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionList(List<dynamic> reservations, String emptyMessage) {
    if (reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emptyMessage, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Vous pouvez naviguer vers l'écran de réservation ici.
                // Par exemple, revenir à l'écran d'accueil ou une page de recherche de services.
                Navigator.of(context).popUntil((route) => route.isFirst); // Revient à la première route (Home)
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text("Réserver", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index];
          final service = reservation['service'];
          final prestator = service['prestator'];
          final category = service['category'];

          // Formatage de la date et l'heure
          final String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(reservation['date']));
          final String formattedTime = DateFormat('HH:mm').format(DateFormat('HH:mm:ss').parse(reservation['time']));

          // Utilise le statut directement de l'API
          final String reservationStatus = reservation['status'];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prestator['user']['name'] ?? 'Service Inconnu',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey[600], size: 18),
                      const SizedBox(width: 8),
                      Text('Date: $formattedDate', style: const TextStyle(fontSize: 15)),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time, color: Colors.grey[600], size: 18),
                      const SizedBox(width: 8),
                      Text('Heure: $formattedTime', style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey[600], size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(reservation['location'] ?? 'Adresse inconnue', style: const TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.grey[600], size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Prestataire: ${prestator['description'] ?? 'Inconnu'}', // Exemple, affiche la description du prestataire
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.category, color: Colors.grey[600], size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Catégorie: ${category['name'] ?? 'Inconnue'}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Prix: ${reservation['price'] ?? 'N/A'} FCFA',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _getStatusColor(reservationStatus).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          reservationStatus.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(reservationStatus),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}