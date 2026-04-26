import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import 'login_screen.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

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
          child: Column(
            children: [

              const SizedBox(height: 30),

              const Text(
                "Select Language",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Choose your preferred language",
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [

                    _tile(context, "English", const Locale('en')),
                    _tile(context, "हिंदी", const Locale('hi')),
                    _tile(context, "मराठी", const Locale('mr')),
                    _tile(context, "தமிழ்", const Locale('ta')),
                    _tile(context, "తెలుగు", const Locale('te')),
                    _tile(context, "ಕನ್ನಡ", const Locale('kn')),
                    _tile(context, "ગુજરાતી", const Locale('gu')),
                    _tile(context, "ਪੰਜਾਬੀ", const Locale('pa')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, String text, Locale locale) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Provider.of<LanguageProvider>(context, listen: false)
              .setLocale(locale);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
              )
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.language, color: Colors.green),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}