import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'booking_summary_screen.dart';

class BookingFormScreen extends StatefulWidget {
  final Map<String, dynamic> prestator;

  const BookingFormScreen({Key? key, required this.prestator}) : super(key: key);

  @override
  _BookingFormScreenState createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _message = '';

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2028),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _message = '';
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _message = '';
      });
    }
  }

  void _goToSummary() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        setState(() {
          _message = 'Veuillez sélectionner la date et l\'heure.';
        });
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingSummaryScreen(
            prestator: widget.prestator,
            address: _addressController.text,
            phoneNumber: _phoneController.text,
            selectedDate: _selectedDate!,
            selectedTime: _selectedTime!,
          ),
        ),
      );
    }
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'RÉSERVATION',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Form Container
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: _addressController,
                          hintText: "Adresse de la prestation",
                          icon: Icons.location_on,
                          validatorMsg: 'Veuillez entrer l\'adresse.',
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _phoneController,
                          hintText: "Numéro de téléphone",
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validatorMsg: 'Veuillez entrer un numéro de téléphone valide.',
                          validatorRegex: r'^\+?[0-9]{8,15}$',
                        ),
                        const SizedBox(height: 16),
                        _buildSelectionTile(
                          title: _selectedDate == null
                              ? 'Sélectionner une date'
                              : 'Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                          icon: Icons.calendar_today,
                          onTap: () => _selectDate(context),
                        ),
                        const SizedBox(height: 16),
                        _buildSelectionTile(
                          title: _selectedTime == null
                              ? 'Sélectionner une heure'
                              : 'Heure: ${_selectedTime!.format(context)}',
                          icon: Icons.access_time,
                          onTap: () => _selectTime(context),
                        ),
                        if (_message.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              _message,
                              style: const TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _goToSummary,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Suivant',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String validatorMsg,
    String? validatorRegex,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return validatorMsg;
        if (validatorRegex != null && !RegExp(validatorRegex).hasMatch(value)) {
          return validatorMsg;
        }
        return null;
      },
    );
  }

  Widget _buildSelectionTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      title: Text(title),
      trailing: Icon(icon),
      onTap: onTap,
      tileColor: Colors.grey[100],
    );
  }
}
