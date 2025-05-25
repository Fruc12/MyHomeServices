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
  final TextEditingController passwordController = TextEditingController();
  String? selectedRole;
  bool isLoading = false;
  final List<String> roles = ['Client', 'Prestataire'];
  final AuthService _authService = AuthService();

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
                    'assets/icons/logo1.png',
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
                  // const Text(
                  //   'Incrivez-vous pour rejoindre notre communauté et profiter'
                  //       'de nos services à domicile.',
                  //   textAlign: TextAlign.center, // Centre le texte
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 16,
                  //   ),
                  // ),
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
                              _buildTextField(
                                controller: passwordController,
                                label: 'Mot de passe',
                                icon: Icons.lock_outline,
                                obscureText: true,
                                validator: (value) =>
                                value!.length < 8 ? '8 caractères minimum' : null,
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
                                dropdownColor: Colors.grey[850],
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : _register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: isLoading
                                      ? const CircularProgressIndicator()
                                      : const Text(
                                    "S'inscrire",
                                    style: TextStyle(
                                      color: Colors.white,
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

  InputDecoration _buildInputDecoration({required String label, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: icon != null
          ? Icon(icon, color: Colors.white70)
          : null,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    IconData? icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: _buildInputDecoration(label: label, icon: icon),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => isLoading = true);
      try {
        final success = await _authService.register(
          nameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
          selectedRole == 'Client' ? 'customer' : 'prestator',
        );

        if (success) {
          if (selectedRole == 'Prestataire') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PrestatorScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        }
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    }
  }
}