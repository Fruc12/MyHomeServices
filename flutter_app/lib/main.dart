// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/account_screen.dart';
import 'package:flutter_app/screens/auth/login_screen.dart';
import 'package:flutter_app/screens/auth/prestator_screen.dart'; // Si PrestatorScreen est toujours nécessaire
import 'package:flutter_app/screens/auth/register_screen.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/session_screen.dart'; // Vue sessions client
import 'package:flutter_app/services/auth_service.dart';
import 'package:flutter_app/services/role_manager.dart'; // <-- Importez le RoleManager
import 'package:flutter_app/screens/prestator_service_form_screen.dart'; // <-- Importez la nouvelle page
import 'package:flutter_app/screens/prestator_sessions_screen.dart'; // <-- Importez la nouvelle page

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthChecker(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        // '/home' et '/prestator' seront gérés par MainScreen maintenant
      },
    );
  }
}

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isAuth = await AuthService().checkAuthStatus();
      setState(() {
        _isAuthenticated = isAuth;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isAuthenticated = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _isAuthenticated ? const MainScreen() : const LoginScreen();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Définir les écrans pour le rôle Client
  final List<Widget> _clientScreens = [
    HomeScreen(),         // Écran de réservation principal (client)
    SessionsScreen(),     // Mes sessions (client)
    AccountScreen(),      // Compte (commun aux deux rôles)
  ];

  // Définir les écrans pour le rôle Prestataire
  final List<Widget> _prestatorScreens = [
    HomeScreen(),                     // Le prestataire peut aussi "réserver" en tant que client
    const PrestatorSessionsScreen(),  // Mes réservations reçues (prestataire)
    const PrestatorServiceFormScreen(), // Gérer mes services (prestataire)
    AccountScreen(),                  // Compte (commun aux deux rôles)
  ];

  // Définir les éléments de la BottomNavigationBar pour le rôle Client
  final List<BottomNavigationBarItem> _clientNavBarItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Réserver'),
    BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Mes Sessions'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Compte'),
  ];

  // Définir les éléments de la BottomNavigationBar pour le rôle Prestataire
  final List<BottomNavigationBarItem> _prestatorNavBarItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Réserver'), // Peut-être "Client View" ou "Accueil"
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Réservations'), // Réservations reçues

    BottomNavigationBarItem(icon: Icon(Icons.add_business), label: 'Mes Services'), // Gérer les services
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Compte'),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: RoleManager.roleListenable,
      builder: (context, currentRole, child) {
        final List<Widget> screens = currentRole == 'client' ? _clientScreens : _prestatorScreens;
        final List<BottomNavigationBarItem> navBarItems = currentRole == 'client' ? _clientNavBarItems : _prestatorNavBarItems;

        if (_selectedIndex >= screens.length) {
          _selectedIndex = 0;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Bienvenue sur MHS', // Texte fixe pour les deux rôles
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            // Condition pour afficher le Drawer icon
            automaticallyImplyLeading: currentRole == 'prestataire', // N'affiche le bouton retour que si Prestataire
          ),
          // Le Drawer pour changer de vue, n'est présent que si le rôle est 'prestataire'
          drawer: currentRole == 'prestataire'
              ? Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Menu Principal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rôle actuel: ${currentRole.toUpperCase()}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Vue Client'),
                  onTap: () {
                    RoleManager.setRole('client');
                    Navigator.pop(context);
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.work),
                  title: const Text('Vue Prestataire'),
                  onTap: () {
                    RoleManager.setRole('prestataire');
                    Navigator.pop(context);
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Déconnexion'),
                  onTap: () {
                    AuthService().logout();
                    RoleManager.setRole('client');
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            ),
          )
              : null, // Si le rôle est client, le drawer est null
          body: screens[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: navBarItems,
            type: BottomNavigationBarType.fixed,
            // Couleurs de la BottomNavigationBar (blanc)
            backgroundColor: Colors.white, // Fond blanc
            selectedItemColor: Colors.deepPurple, // Couleur des icônes/labels sélectionnés (violet)
            unselectedItemColor: Colors.grey, // Couleur des icônes/labels non sélectionnés (gris)
          ),
        );
      },
    );
  }
}