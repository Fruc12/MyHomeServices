import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '/screens/auth/login_screen.dart';
import '/services/auth_service.dart';
import '/services/user_service.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  String name = '';
  String email = '';
  String role = '';
  String city = 'Cotonou, Bénin';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccountData();
  }

  Future<void> _loadAccountData() async {
    try {
      // final userId = await _authService.getToken(); // Récupère l'ID de l'utilisateur via le token
      final userData = await _userService.fetchUser();

      if (userData != null) {
        setState(() {
          name = userData['name'] ?? '';
          email = userData['email'] ?? '';
          role = userData['role'] ?? '';
        });
      }

      // final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // final placemarks = await Geolocator.placemarkFromCoordinates(position.latitude, position.longitude);
      // setState(() {
      //   city = placemarks.first.locality ?? 'Ville inconnue';
      // });
    } catch (e) {
      print('Erreur : $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon compte"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _logout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoTile(Icons.person, "Nom et Prénom", name),
            _buildInfoTile(Icons.email, "Email", email),
            _buildInfoTile(Icons.badge, "Rôle", role),
            _buildInfoTile(Icons.location_on, "Adresse", city),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.orange),
          title: Text(title),
          subtitle: Text(value),
        ),
        const Divider(),
      ],
    );
  }
}
