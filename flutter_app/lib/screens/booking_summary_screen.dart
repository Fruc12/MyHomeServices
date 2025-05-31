// lib/screens/booking_summary_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class BookingSummaryScreen extends StatefulWidget {
  final Map<String, dynamic> prestator;
  final String address;
  final String phoneNumber; // Nous ne l'enverrons pas dans la réservation, mais laissons-le ici pour l'affichage
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  const BookingSummaryScreen({
    Key? key,
    required this.prestator,
    required this.address,
    required this.phoneNumber,
    required this.selectedDate,
    required this.selectedTime,
  }) : super(key: key);

  @override
  _BookingSummaryScreenState createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  bool _isLoading = false;
  String _message = '';

  Future<void> _submitBooking() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    final DateTime bookingDateTime = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      widget.selectedTime.hour,
      widget.selectedTime.minute,
    );

    final String baseUrl = 'http://localhost:8000';
    final String apiUrl = '$baseUrl/api/reservations/customer'; // Endpoint pour créer une réservation
    Map<String, dynamic> requestBody = {
      'service_id': widget.prestator['id'], // Assurez-vous que c'est bien l'ID du service
      'customer_id': 1, // Temporaire: Remplacez par l'ID de l'utilisateur connecté
      'location': widget.address,
      'date': DateFormat('yyyy-MM-dd').format(bookingDateTime),
      'time': DateFormat('HH:mm:ss').format(bookingDateTime),
      'status': 'pending',

    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) {
        setState(() {
          _message = 'Réservation confirmée avec succès !';
        });
        _showSuccessDialog();
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          _message = 'Échec de la réservation : ${errorData['message'] ?? 'Erreur inconnue'}';
        });
        print('Erreur API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _message = 'Erreur de connexion : $e';
      });
      print('Erreur de connexion: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Réservation Confirmée !',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        content: const Text(
          'Votre réservation a été envoyée avec succès au prestataire. Vous pouvez suivre son statut dans votre profil.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop(); // Go back to BookingFormScreen
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent.shade100,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8E2DE2), Color(0xFFFF6A00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RÉCAPITULATIF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.check_circle_outline, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Veuillez vérifier les informations ci-dessous avant de confirmer.',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      _buildSummaryRow('Prestataire', widget.prestator['name'] ?? 'Nom inconnu', Icons.person),
                      const Divider(),
                      _buildSummaryRow('Adresse', widget.address, Icons.location_on),
                      const Divider(),
                      _buildSummaryRow('Téléphone', widget.phoneNumber, Icons.phone), // Le téléphone reste affiché pour l'utilisateur
                      const Divider(),
                      _buildSummaryRow('Date', DateFormat('dd/MM/yyyy').format(widget.selectedDate), Icons.calendar_today),
                      const Divider(),
                      _buildSummaryRow('Heure', widget.selectedTime.format(context), Icons.access_time),
                      if (_message.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            _message,
                            style: TextStyle(
                              color: _message.contains('Échec') ? Colors.red : Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _submitBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                            : const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Confirmer la Réservation',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.check, color: Colors.white),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: const BorderSide(color: Colors.orange),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back, color: Colors.orange),
                            SizedBox(width: 8),
                            Text(
                              'Retour',
                              style: TextStyle(fontSize: 16, color: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orange, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 17, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}