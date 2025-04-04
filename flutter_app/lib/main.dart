import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SessionsScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Réserver'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Sessions'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Compte'),
        ],
      ),
    );
  }
}

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
                  Text("Bonjour Fructueux,", style: TextStyle(fontSize: 18, color: Colors.white)),
                  SizedBox(height: 5),
                  Text("Envie d'une session ?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 20),
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
                  _buildCard("Ménage régulier classique", "À partir de 26,90 €/h", "En savoir plus"),
                  SizedBox(height: 20),
                  Text("Faites-nous confiance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  _buildTrustSection("Réservation simple et sécurisée", "Découvrez le mode d'emploi"),
                  _buildTrustSection("Des pros certifiés proches de chez vous", "Vous méritez le meilleur"),
                  _buildTrustSection("Annulation sans frais", "Jusqu'à 24h avant la session"),
                  _buildTrustSection("Assurance Wecasa incluse", "Vous êtes couvert en cas de pépin"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildServiceButton(String title, IconData icon) {
    return Column(
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

class SessionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Mes sessions", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          bottom: TabBar(
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
            _buildSessionTab("Aucune réservation enregistrée !"),
            _buildSessionTab("Aucune session réalisée."),
            _buildSessionTab("Aucune session annulée."),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionTab(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: TextStyle(fontSize: 16, color: Colors.grey)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text("Réserver", style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

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

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Connexion", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            SizedBox(height: 20),
            TextField(decoration: InputDecoration(labelText: "Email")),
            SizedBox(height: 10),
            TextField(decoration: InputDecoration(labelText: "Mot de passe"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text("Se connecter", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}