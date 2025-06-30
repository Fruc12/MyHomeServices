// lib/screens/session_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_app/services/auth_service.dart'; // Assurez-vous que ce chemin est correct
import '../main.dart'; // Pour naviguer vers l'écran principal si nécessaire

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({Key? key}) : super(key: key);

  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  List<dynamic> _allReservations = []; // Pour stocker toutes les réservations
  List<dynamic> _upcomingReservations = []; // pending, reported, accepted
  List<dynamic> _completedReservations = []; // completed
  List<dynamic> _canceledReservations = []; // canceled

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchReservations(); // Appel initial pour charger les données
  }

  // --- Méthode pour récupérer les réservations ---
  Future<void> _fetchReservations() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      // Réinitialiser les listes pour un rafraîchissement propre
      _allReservations = [];
      _upcomingReservations = [];
      _completedReservations = [];
      _canceledReservations = [];
    });

    try {
      final String? authToken = await AuthService().getToken();
      final int? userId = await AuthService().getUserId();

      if (authToken == null || userId == null) {
        setState(() {
          errorMessage = 'Erreur: Utilisateur non authentifié. Veuillez vous connecter.';
          isLoading = false;
        });
        // Naviguer vers l'écran de connexion si non authentifié
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainScreen()), // Ou votre écran de connexion
              (Route<dynamic> route) => false,
        );
        return;
      }

      final String baseUrl = 'http://localhost:8000';
      final String apiUrl = '$baseUrl/api/reservations/customer';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] is List) {
          setState(() {
            _allReservations = responseData['data'];
            _filterReservations(); // Filtrer après avoir reçu toutes les données
          });
        } else {
          setState(() {
            errorMessage = responseData['message'] ?? 'Erreur inconnue lors de la récupération des réservations.';
          });
        }
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          errorMessage = errorData['message'] ?? 'Erreur serveur lors de la récupération des réservations.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de connexion: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // --- Méthode pour filtrer les réservations par statut ---
  void _filterReservations() {
    _upcomingReservations.clear();
    _completedReservations.clear();
    _canceledReservations.clear();

    for (var reservation in _allReservations) {
      final status = reservation['status'];
      switch (status) {
        case 'pending':
        case 'reported':
        case 'accepted':
          _upcomingReservations.add(reservation);
          break;
        case 'completed':
          _completedReservations.add(reservation);
          break;
        case 'canceled':
          _canceledReservations.add(reservation);
          break;
        default:
          _upcomingReservations.add(reservation);
          break;
      }
    }
  }

  // --- Méthode pour mettre à jour le statut d'une réservation via l'API ---
  Future<void> _updateReservationStatus(int reservationId, String newStatus) async {
    setState(() {
      isLoading = true; // Affiche un indicateur de chargement global
    });

    try {
      final String? authToken = await AuthService().getToken();
      if (authToken == null) {
        _showSnackBar('Erreur d\'authentification. Veuillez vous reconnecter.', Colors.red);
        return;
      }

      final String baseUrl = 'http://localhost:8000';
      final String apiUrl = '$baseUrl/api/reservations/$reservationId';

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({'status': newStatus}),
      );

      if (response.statusCode == 200) {
        _showSnackBar('Statut de la réservation mis à jour: $newStatus', Colors.green);
        _fetchReservations(); // Re-charger les réservations pour mettre à jour l'UI et les onglets
      } else {
        final errorData = json.decode(response.body);
        _showSnackBar('Erreur lors de la mise à jour: ${errorData['message'] ?? 'Erreur inconnue'}', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Erreur de connexion: $e', Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // --- Méthode pour supprimer une réservation via l'API ---
  Future<void> _deleteReservation(int reservationId) async {
    setState(() {
      isLoading = true; // Affiche un indicateur de chargement global
    });

    try {
      final String? authToken = await AuthService().getToken();
      if (authToken == null) {
        _showSnackBar('Erreur d\'authentification. Veuillez vous reconnecter.', Colors.red);
        return;
      }

      final String baseUrl = 'http://localhost:8000';
      final String apiUrl = '$baseUrl/api/reservations/$reservationId';

      final response = await http.delete( // Utilisation de la méthode HTTP DELETE
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) { // 200 OK ou 204 No Content pour suppression réussie
        _showSnackBar('Réservation supprimée avec succès !', Colors.green);
        _fetchReservations(); // Re-charger les réservations pour mettre à jour l'UI et les onglets
      } else {
        final errorData = json.decode(response.body);
        _showSnackBar('Erreur lors de la suppression: ${errorData['message'] ?? 'Erreur inconnue'}', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Erreur de connexion: $e', Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // --- Helper pour afficher des SnackBar ---
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // --- Helper pour obtenir la couleur du statut ---
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
      case 'accepted':
        return Colors.lightGreen;
      default:
        return Colors.grey;
    }
  }

  // --- Widget pour construire le contenu de chaque onglet de session ---
  Widget _buildSessionTabContent(List<dynamic> reservations, String emptyMessage) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)));
    }
    if (reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emptyMessage, style: const TextStyle(fontSize: 16, color: Colors.grey)),
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

    // Affiche la liste des réservations
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        final service = reservation['service'];
        final prestator = service?['prestator'];
        final prestatorUser = prestator?['user'];
        final category = service?['category'];

        // Accès sécurisé aux données
        final String prestatorName = prestatorUser?['name'] ?? 'Nom inconnu';
        final String serviceName = service?['name'] ?? 'Service inconnu';
        final String reservationDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(reservation['date']));
        final String reservationTime = reservation['time']?.substring(0, 5) ?? 'N/A'; // Pour "HH:MM"
        final String location = reservation['location'] ?? 'Lieu inconnu';
        final String reservationStatus = reservation['status'] ?? 'pending';
        final String reservationPrice = reservation['price']?.toString() ?? 'N/A';


        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        prestatorName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Logique conditionnelle pour afficher le bon bouton/menu
                    if (reservationStatus == 'canceled' || reservationStatus == 'completed')
                    // Pour les statuts 'Annulées' et 'Réalisées', un seul bouton "Supprimer"
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            _showConfirmDeleteDialog(reservation['id']);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
                        ),
                      )
                    else if (reservationStatus == 'pending' || reservationStatus == 'in_progress' || reservationStatus == 'accepted' || reservationStatus == 'reported')
                    // Pour les statuts 'À venir' et 'Reported', le menu à trois points
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (String action) {
                          if (action == 'annuler') {
                            _showConfirmCancelDialog(reservation['id']);
                          } else if (action == 'reporter') {
                            _updateReservationStatus(reservation['id'], 'reported'); // Change status to reported
                          } else if (action == 'achever') {
                            _showConfirmCompleteDialog(reservation['id']);
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          // Option "Annuler"
                          PopupMenuItem<String>(
                            value: 'annuler',
                            enabled: reservationStatus == 'pending' || reservationStatus == 'in_progress' || reservationStatus == 'accepted' || reservationStatus == 'reported',
                            child: Text(
                              'Annuler',
                              style: TextStyle(
                                color: (reservationStatus == 'pending' || reservationStatus == 'in_progress' || reservationStatus == 'accepted' || reservationStatus == 'reported') ? Colors.red : Colors.grey,
                              ),
                            ),
                          ),
                          // Option "Reporter"
                          PopupMenuItem<String>(
                            value: 'reporter',
                            // Activé si pending, in_progress ou accepted (pas si déjà reported)
                            enabled: reservationStatus == 'pending' || reservationStatus == 'in_progress' || reservationStatus == 'accepted',
                            child: Text(
                              'Reporter',
                              style: TextStyle(
                                color: (reservationStatus == 'pending' || reservationStatus == 'in_progress' || reservationStatus == 'accepted') ? Colors.blue : Colors.grey,
                              ),
                            ),
                          ),
                          // Option "Achever"
                          PopupMenuItem<String>(
                            value: 'achever',
                            // Activé si pending, in_progress ou accepted (pour permettre de terminer un service)
                            enabled: reservationStatus == 'pending' || reservationStatus == 'in_progress' || reservationStatus == 'accepted',
                            child: Text(
                              'Achever',
                              style: TextStyle(
                                color: (reservationStatus == 'pending' || reservationStatus == 'in_progress' || reservationStatus == 'accepted') ? Colors.green : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.grey, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Date: $reservationDate',
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.grey, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Heure: $reservationTime',
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Lieu: $location',
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.category, color: Colors.grey, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Catégorie: ${category?['name'] ?? 'Inconnue'}',
                        style: const TextStyle(fontSize: 15, color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Prix: $reservationPrice FCFA',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                        overflow: TextOverflow.ellipsis,
                      ),
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
                        overflow: TextOverflow.ellipsis,
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

  // --- Boîte de dialogue de confirmation pour annuler ---
  void _showConfirmCancelDialog(int reservationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Annuler la réservation ?'),
          content: const Text('Êtes-vous sûr de vouloir annuler cette réservation ? Cette action est irréversible.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Non'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateReservationStatus(reservationId, 'canceled');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Oui, annuler', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // --- Boîte de dialogue de confirmation pour achever ---
  void _showConfirmCompleteDialog(int reservationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Achever la réservation ?'),
          content: const Text('Confirmez-vous que cette réservation est terminée ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Non'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateReservationStatus(reservationId, 'completed');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Oui, achever', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // --- Boîte de dialogue de confirmation pour supprimer/archiver ---
  void _showConfirmDeleteDialog(int reservationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer la réservation ?'),
          content: const Text('Cette action supprimera définitivement la réservation. Êtes-vous sûr ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteReservation(reservationId);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // --- Widget principal de l'écran des sessions ---
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
            _buildSessionTabContent(_upcomingReservations, "Aucune réservation à venir !"),
            _buildSessionTabContent(_completedReservations, "Aucune session réalisée."),
            _buildSessionTabContent(_canceledReservations, "Aucune session annulée."),
          ],
        ),
      ),
    );
  }
}
