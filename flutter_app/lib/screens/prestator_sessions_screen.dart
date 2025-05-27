// lib/screens/prestator_sessions_screen.dart
import 'package:flutter/material.dart';

class PrestatorSessionsScreen extends StatelessWidget {
  const PrestatorSessionsScreen({Key? key}) : super(key: key);

  // Fonction factice pour simuler des réservations
  List<Map<String, String>> _getIncomingBookings() {
    return [
      {"client": "Alice Dupont", "service": "Ménage complet", "date": "15/06/2025", "time": "10:00"},
      {"client": "Bob Martin", "service": "Coiffure (coupe)", "date": "16/06/2025", "time": "14:30"},
      {"client": "Charlie Brown", "service": "Massage relaxant", "date": "17/06/2025", "time": "11:00"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final incomingBookings = _getIncomingBookings();

    return DefaultTabController(
      length: 2, // 'À venir' et 'Historique' (ou 'Réalisées')
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mes Réservations Reçues", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            labelColor: Colors.amber, // Une couleur qui contraste bien
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.amber,
            tabs: [
              Tab(text: "À venir"),
              Tab(text: "Historique"), // Pour les sessions passées/réalisées
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Onglet "À venir"
            incomingBookings.isEmpty
                ? _buildNoBookingMessage("Aucune réservation à venir pour le moment.")
                : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: incomingBookings.length,
              itemBuilder: (context, index) {
                final booking = incomingBookings[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Client: ${booking['client']}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                        ),
                        const SizedBox(height: 8),
                        Text('Service: ${booking['service']}', style: const TextStyle(fontSize: 16)),
                        Text('Date: ${booking['date']}', style: const TextStyle(fontSize: 16)),
                        Text('Heure: ${booking['time']}', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                // Logique pour marquer comme terminé ou modifier
                                print('Modifier la réservation de ${booking['client']}');
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.deepPurple,
                                side: const BorderSide(color: Colors.deepPurple),
                              ),
                              child: const Text('Modifier'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                // Logique pour annuler ou accepter
                                print('Accepter/Annuler la réservation de ${booking['client']}');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Accepter/Refuser'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Onglet "Historique"
            _buildNoBookingMessage("Aucune réservation passée."),
          ],
        ),
      ),
    );
  }

  Widget _buildNoBookingMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}