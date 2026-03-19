import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String breedName;

  const ResultScreen({super.key, required this.breedName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prediction Result"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade100,
              Colors.green.shade50,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              const SizedBox(height: 10),

              /// BREED NAME
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade700,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Detected Breed",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      breedName,
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// FEEDING
              _sectionCard(
                title: "Feeding Tips",
                content:
                    "Provide balanced diet with green fodder, dry fodder, and mineral mix. Ensure clean drinking water always.",
              ),

              const SizedBox(height: 15),

              /// BREEDING
              _sectionCard(
                title: "Breeding Tips",
                content:
                    "Maintain proper breeding intervals and consult a veterinarian for artificial insemination.",
              ),

              const SizedBox(height: 15),

              /// CARE
              _sectionCard(
                title: "Care Tips",
                content:
                    "Keep cattle in clean shelters, vaccinate regularly, and monitor health daily.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            content,
            style: const TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }
}