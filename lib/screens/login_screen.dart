import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/app_strings.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();

  final _nameController = TextEditingController();
  final _villageController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _loading = false;

  Future<void> _login() async {
    if (_nameController.text.isEmpty ||
        _villageController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      return;
    }

    setState(() => _loading = true);

    await _authService.loginFarmer(
      _nameController.text,
      _villageController.text,
      _phoneController.text,
    );

    setState(() => _loading = false);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade200,
              Colors.green.shade50,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 20),

                /// TITLE
                Text(
                  AppStrings.login(context),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Enter your details to continue",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                /// INPUT CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [

                      _buildField(
                        controller: _nameController,
                        label: "Name",
                        icon: Icons.person,
                      ),

                      const SizedBox(height: 15),

                      _buildField(
                        controller: _villageController,
                        label: "Village",
                        icon: Icons.location_on,
                      ),

                      const SizedBox(height: 15),

                      _buildField(
                        controller: _phoneController,
                        label: "Phone",
                        icon: Icons.phone,
                        keyboard: TextInputType.phone,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// BUTTON
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          AppStrings.login(context),
                          style: const TextStyle(fontSize: 18),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}