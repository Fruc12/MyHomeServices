import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key); // Ajout du paramètre key

  @override
  RegisterScreenState createState() => RegisterScreenState(); // Retrait du _ pour la classe publique
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedRole;
  XFile? _certificateFile;
  final List<String> _roles = ['customer', 'prestator', 'admin'];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final file = await _picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          _certificateFile = file;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la sélection du fichier")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un compte")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nom complet"),
                validator: (value) => value?.isEmpty ?? true ? "Champ obligatoire" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value?.contains('@') ?? false ? null : "Email invalide",
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Mot de passe"),
                obscureText: true,
                validator: (value) => (value?.length ?? 0) >= 6 ? null : "6 caractères minimum",
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedRole,
                hint: const Text("Sélectionnez votre rôle"),
                items: _roles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(
                        role == 'prestator' ? 'Prestataire' :
                        role == 'customer' ? 'Client' : 'Administrateur'
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedRole = value),
                validator: (value) => value == null ? "Sélectionnez un rôle" : null,
              ),
              const SizedBox(height: 24),

              if (_selectedRole == 'prestator') ...[
                const Text("Informations prestataire",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 3,
                  validator: (value) => value?.isEmpty ?? true ? "Champ obligatoire" : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: "Adresse"),
                  validator: (value) => value?.isEmpty ?? true ? "Champ obligatoire" : null,
                ),
                const SizedBox(height: 16),

                const Text("Certificat/Diplôme"),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _pickImage,
                  child: Text(_certificateFile == null
                      ? "Choisir un fichier"
                      : "Fichier sélectionné"),
                ),
                if (_certificateFile != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _certificateFile!.name,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 16),
              ],

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("S'inscrire"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final userData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'role': _selectedRole,
        if (_selectedRole == 'prestator') ...{
          'description': _descriptionController.text,
          'address': _addressController.text,
          'certificate': _certificateFile?.path,
        }
      };

      // TODO: Implémenter la logique d'enregistrement
      debugPrint(userData.toString());

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => HomeScreen()),
      // );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}