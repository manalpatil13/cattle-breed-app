import 'package:flutter/material.dart';
import 'login_screen.dart';

class LanguageScreen extends StatelessWidget {
  final Function(Locale) onLanguageSelected;

  const LanguageScreen({
    super.key,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final languages = [
      {'name': 'English', 'code': 'en'},
      {'name': 'हिंदी', 'code': 'hi'},
      {'name': 'ગુજરાતી', 'code': 'gu'},
      {'name': 'मराठी', 'code': 'mr'},
      {'name': 'ಕನ್ನಡ', 'code': 'kn'},
      {'name': 'தமிழ்', 'code': 'ta'},
      {'name': 'తెలుగు', 'code': 'te'},
      {'name': 'বাংলা', 'code': 'bn'},
      {'name': 'ਪੰਜਾਬੀ', 'code': 'pa'},
      {'name': 'ଓଡ଼ିଆ', 'code': 'or'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Language"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(
                languages[index]['name']!,
                style: const TextStyle(fontSize: 18),
              ),
              onTap: () {
                onLanguageSelected(
                  Locale(languages[index]['code']!),
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}