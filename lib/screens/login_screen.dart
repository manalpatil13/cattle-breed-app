import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../core/localization/app_localizations.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;

  Future<void> _continue() async {
    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    final village = _villageController.text.trim();
    final phone = _phoneController.text.trim();

    try {
      final farmer = await _authService.findFarmer(
        name: name,
        village: village,
        phone: phone,
      );

      if (farmer == null) {
        await _authService.createFarmer(
          name: name,
          village: village,
          phone: phone,
        );
      }

      await _authService.saveFarmerLocally(
        name: name,
        village: village,
        phone: phone,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.login),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: loc.get('name'),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _villageController,
              decoration: InputDecoration(
                labelText: loc.get('village'),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: loc.get('phone'),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _continue,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(loc.get('continue')),
                  ),
          ],
        ),
      ),
    );
  }
}