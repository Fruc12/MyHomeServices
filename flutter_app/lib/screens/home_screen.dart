import 'package:flutter/material.dart';
import 'package:flutter_app/screens/prestator_list_screen.dart';
import '/services/auth_service.dart'; // Assurez-vous que le chemin est correct
import '/services/user_service.dart'; // Assurez-vous que le chemin est correct

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = ''; // Variable pour stocker le nom de l'utilisateur
  bool _isLoading = true; // Pour gérer l'état de chargement

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final UserService _userService = UserService();
      final userData = await _userService.fetchUser();
      if (userData != null) {
        setState(() {
          _userName = userData['name'] ?? 'Utilisateur'; // Récupère le nom, ou 'Utilisateur' par défaut
        });
      }
    } catch (e) {
      print('Erreur lors du chargement du nom de l\'utilisateur : $e');
      setState(() {
        _userName = 'Utilisateur'; // Nom par défaut en cas d'erreur
      });
    } finally {
      setState(() {
        _isLoading = false; // Le chargement est terminé
      });
    }
  }

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
                  _isLoading
                      ? CircularProgressIndicator(color: Colors.white) // Affiche un indicateur de chargement
                      : Text(
                    "Salut, $_userName,", // Utilise le nom de l'utilisateur
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
                  _buildCard("Ménage régulier classique", "À partir de 3 000 FCFA/h", "En savoir plus"),
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
    return InkWell(
      onTap: () {
        int? categoryId; // Variable pour stocker l'ID de la catégorie (peut être null initialement)

        // IMPORTANT: Assurez-vous que ces IDs correspondent aux IDs réels de vos catégories dans la base de données Laravel.
        // Si vos IDs sont différents, vous devrez les ajuster ici.
        if (title == "Ménage") {
          categoryId = 1;
        } else if (title == "Garde d'enfants") {
          categoryId = 2; // Exemple d'ID, à vérifier dans votre DB
        } else if (title == "Coiffure") {
          categoryId = 3; // Exemple d'ID, à vérifier dans votre DB
        } else if (title == "Beauté") {
          categoryId = 4; // Exemple d'ID, à vérifier dans votre DB
        } else if (title == "Massage") {
          categoryId = 5; // Exemple d'ID, à vérifier dans votre DB
        } else if (title == "Coach sportif") {
          categoryId = 6; // Exemple d'ID, à vérifier dans votre DB
        }

        if (categoryId != null) {
          // Si categoryId n'est PAS null, nous pouvons naviguer
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrestatorListScreen(
                categoryId: categoryId!, // Utilisation de l'opérateur ! pour affirmer que categoryId n'est pas null
                categoryName: title,
              ),
            ),
          );
        } else {
          // Gérer le cas où la catégorie n'est pas reconnue ou l'ID n'est pas défini
          print('Catégorie non reconnue ou ID non défini: $title');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Catégorie "$title" non disponible pour l\'instant ou ID inconnu.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
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
