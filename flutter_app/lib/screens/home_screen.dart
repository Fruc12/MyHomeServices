import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade300, Colors.orange.shade200],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Text(
                    "Bonjour Fructueux,",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Envie d'une session ?",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 20),

                  // Remplacé GridView par Wrap
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    children: [
                      _buildServiceButton("Ménage", Icons.cleaning_services),
                      _buildServiceButton("Garde d'enfants", Icons.child_care),
                      _buildServiceButton("Coiffure", Icons.cut),
                      _buildServiceButton("Beauté", Icons.brush),
                      _buildServiceButton("Massage", Icons.spa),
                      _buildServiceButton("Coach sportif", Icons.fitness_center),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("L'actu du moment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  _buildCard("Nouveaux services de ménage", "Grand nettoyage et ménage état des lieux maintenant disponibles", "Réserver mon ménage"),
                  SizedBox(height: 20),
                  Text("Nos clients adorent", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  _buildCard("Ménage régulier classique", "À partir de 3 000  FCFA/h", "En savoir plus"),
                  SizedBox(height: 20),
                  Text("Faites-nous confiance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  _buildTrustSection("Réservation simple et sécurisée", "Découvrez le mode d'emploi"),
                  _buildTrustSection("Des pros certifiés proches de chez vous", "Vous méritez le meilleur"),
                  _buildTrustSection("Annulation sans frais", "Jusqu'à 24h avant la session"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildServiceButton(String title, IconData icon) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(icon, size: 30, color: Colors.black),
          ),
          SizedBox(height: 5),
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String subtitle, String buttonText) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(subtitle, style: TextStyle(fontSize: 14)),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text(buttonText, style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustSection(String title, String subtitle) {
    return ListTile(
      leading: Icon(Icons.check_circle, color: Colors.orange),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }
}
