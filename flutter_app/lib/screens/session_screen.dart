// lib/screens/session_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart'; // N'importez plus dotenv
import 'package:flutter_app/services/auth_service.dart'; // Importez AuthService

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  List<dynamic> upcomingReservations = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUpcomingReservations();
  }

  Future<void> _fetchUpcomingReservations() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final String? authToken = await AuthService().getToken();
      final int? userId = await AuthService().getUserId(); // Utilise la nouvelle méthode getUserId()

      if (authToken == null || userId == null) {
        setState(() {
          errorMessage = 'Erreur: Utilisateur non authentifié. Veuillez vous connecter.';
          isLoading = false;
        });
        return;
      }

      // Remplacement de dotenv par l'URL localhost directe
      final String baseUrl = 'http://localhost:8000';
      final String apiUrl = '$baseUrl/api/reservations/customer';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('reservations')) {
          List<dynamic> allReservations = responseData['reservations'];

          // Filtrer les réservations pour "À venir" (pending, in_progress)
          upcomingReservations = allReservations.where((reservation) {
            final String status = reservation['status'];
            return status == 'pending' || status == 'in_progress';
          }).toList();

          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Réponse API invalide : Clé "reservations" manquante.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Échec du chargement des sessions : ${response.statusCode} - ${response.body}';
          isLoading = false;
        });
        print('Erreur API Sessions: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de connexion : $e';
        isLoading = false;
      });
      print('Erreur de connexion Sessions: $e');
    }
  }

  String _formatDateTime(String date, String time) {
    try {
      final dateTime = DateTime.parse('$date $time');
      return DateFormat('dd/MM/yyyy à HH:mm').format(dateTime);
    } catch (e) {
      return '$date à $time';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      case 'reported':
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
        body: TabBarView(
          children: [
            _buildUpcomingSessionsTab(),
            _buildSessionTab("Aucune session réalisée."),
            _buildSessionTab("Aucune session annulée."),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingSessionsTab() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage, style: const TextStyle(color: Colors.red, fontSize: 16), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchUpcomingReservations,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    } else if (upcomingReservations.isEmpty) {
      return _buildSessionTab("Aucune réservation à venir enregistrée !");
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: upcomingReservations.length,
        itemBuilder: (context, index) {
          final reservation = upcomingReservations[index];
          final serviceName = reservation['service']['name'] ?? 'Service Inconnu';
          final prestatorName = reservation['service']['prestator']['name'] ?? 'Prestataire Inconnu';
          final servicePrice = reservation['service']['price'] ?? 'N/A';
          final reservationLocation = reservation['location'] ?? 'Non spécifiée';
          final reservationDateTime = _formatDateTime(reservation['date'], reservation['time']);
          final reservationStatus = reservation['status'] ?? 'pending';

          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Prestataire: $prestatorName',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lieu: $reservationLocation',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date & Heure: $reservationDateTime',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tarif: $servicePrice XOF',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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

  Widget _buildSessionTab(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
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
  }
}