import 'package:flutter/material.dart';
import 'auth/login_screen.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mon compte"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.person, color: Colors.orange),
              title: Text("Nom et Prénom"),
              subtitle: Text("Fructueux Doe"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.email, color: Colors.orange),
              title: Text("Email"),
              subtitle: Text("fructueux.doe@example.com"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.orange),
              title: Text("Téléphone"),
              subtitle: Text("+229 12345678"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.location_on, color: Colors.orange),
              title: Text("Adresse"),
              subtitle: Text("Cotonou, Bénin"),
            ),
          ],
        ),
      ),
    );
  }
}