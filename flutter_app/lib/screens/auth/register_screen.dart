import 'dart:ui';

import 'package:flutter/material.dart';
import '/screens/auth/prestator_screen.dart';
import '/services/auth_service.dart';
import '/screens/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedRole;
  bool isLoading = false;
  final List<String> roles = ['Client', 'Prestataire'];
  final AuthService _authService = AuthService();

  // NOUVEAU : État pour basculer la visibilité du mot de passe
  bool _obscurePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // MODIFIÉ : Ajout du paramètre suffixIcon
  InputDecoration _buildInputDecoration({
    required String label,
    IconData? icon,
    Widget? suffixIcon, // NOUVEAU : Paramètre pour l'icône de suffixe
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: icon != null
          ? Icon(icon, color: Colors.white70)
          : null,
      suffixIcon: suffixIcon, // NOUVEAU : Utilise l'icône de suffixe
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
          vertical: 16, horizontal: 20),
    );
  }

  // MODIFIÉ : Ajout du paramètre suffixIcon et utilisation de _obscurePassword
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    IconData? icon,
    bool obscureText = false, // MODIFIÉ : Défini sur false par défaut car c'est l'appelant qui le contrôle
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon, // NOUVEAU : Paramètre pour l'icône de suffixe
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: _buildInputDecoration(label: label, icon: icon, suffixIcon: suffixIcon), // NOUVEAU : Passe le suffixIcon
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => isLoading = true);
      try {
        final success = await _authService.register(
          nameController.text.trim(),
          emailController.text.trim(),
          phoneController.text.trim(),
          passwordController.text.trim(),
          selectedRole == 'Client' ? 'customer' : 'prestator',
        );

        if (success) {
          if (selectedRole == 'Prestataire') {
            // Logique pour les prestataires : tentative de connexion automatique
            final loginSuccess = await _authService.login(
              emailController.text.trim(),
              passwordController.text.trim(),
            );

            if (loginSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const PrestatorScreen()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Inscription réussie, mais connexion automatique échouée. Veuillez vous connecter manuellement.'),
                  backgroundColor: Colors.orange,
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          } else {
            // Logique pour les clients
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Inscription réussie. Veuillez vous connecter.'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Échec de l\'inscription. Vérifiez vos informations ou l\'email est déjà utilisé.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Une erreur est survenue: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dégradé de fond original (orange/gris)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF3904F), Color(0xFF3B4371)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centre les éléments verticalement
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100), // Espacement au-dessus du logo

                  Image.asset(
                    'icons/mhs.png',
                    height: 120, // Ajustez la hauteur selon vos besoins
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Bienvenue !!!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: nameController,
                                label: 'Nom complet',
                                icon: Icons.person_outline,
                                validator: (value) =>
                                value!.isEmpty ? 'Le nom est requis' : null,
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: emailController,
                                label: 'Email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) return 'Email requis';
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                    return 'Email invalide';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              // Champ Numéro de téléphone - AUCUN CHANGEMENT DE STYLE
                              _buildTextField(
                                controller: phoneController,
                                label: 'Numéro de téléphone',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return 'Numéro requis';
                                  if (!RegExp(r'^\d{8,15}$').hasMatch(value)) {
                                    return 'Numéro invalide';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              // Champ Mot de passe avec icône d'œil - AUCUN CHANGEMENT DE STYLE EN DEHORS DE L'ICÔNE
                              _buildTextField(
                                controller: passwordController,
                                label: 'Mot de passe',
                                icon: Icons.lock_outline,
                                obscureText: _obscurePassword, // Utilise la variable d'état
                                validator: (value) =>
                                value!.length < 8 ? '8 caractères minimum' : null,
                                // NOUVEAU : Ajout de l'icône d'œil pour basculer la visibilité
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.white70, // Conserve la couleur existante
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: selectedRole,
                                decoration: _buildInputDecoration(
                                    label: 'Rôle', icon: Icons.work_outline),
                                items: roles.map((role) {
                                  return DropdownMenuItem(
                                    value: role,
                                    child: Text(role),
                                  );
                                }).toList(),
                                onChanged: (value) =>
                                    setState(() => selectedRole = value),
                                validator: (value) =>
                                value == null ? 'Sélectionnez un rôle' : null,
                                dropdownColor: Colors.grey[850], // Conserve la couleur existante
                                style: const TextStyle(color: Colors.white), // Conserve la couleur existante
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black, // Conserve la couleur existante
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: isLoading
                                      ? const CircularProgressIndicator(color: Colors.white) // Spécifiez la couleur pour correspondre au design
                                      : const Text(
                                    "S'inscrire",
                                    style: TextStyle(
                                      color: Colors.white, // Conserve la couleur existante
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text(
                      "Déjà un compte ? Connectez-vous",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40), // Espacement en bas
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
