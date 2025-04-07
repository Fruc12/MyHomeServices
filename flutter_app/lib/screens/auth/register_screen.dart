import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? selectedRole;

  final List<String> roles = ['Administrateur', 'Client', 'Prestataire'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dégradé de fond
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF3904F), Color(0xFF3B4371)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Carte transparente avec effet blur
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(0, 15, 0, 0),
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(
                      color: const Color.fromARGB(60, 255, 255, 255),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Créer un compte',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildTextField('Nom complet'),
                      const SizedBox(height: 20),
                      _buildTextField('Email', keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 20),
                      _buildTextField('Mot de passe', obscureText: true),
                      const SizedBox(height: 20),


                      DropdownButtonFormField<String>(

                        dropdownColor: const Color(0xFFFFFFFF).withAlpha((0.9 * 255).toInt()),

                        value: selectedRole,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Rôle',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: const Color.fromARGB(40, 255, 255, 255),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: roles.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                      ),

                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (selectedRole == 'Prestataire') {
                            Navigator.pushReplacementNamed(context, '/prestator');
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => MainScreen()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 10,
                        ),
                        child: const Text(
                          "S'inscrire",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),

                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          "Vous avez un compte  ? Se connecter",
                          style: TextStyle(color: Colors.lightBlueAccent),
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
    );
  }

  Widget _buildTextField(String label,
      {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: const Color.fromARGB(40, 255, 255, 255),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}


