import 'package:flutter/material.dart';
import '../models/prediction_model.dart';

class HistoryDetailScreen extends StatelessWidget {
  final PredictionModel prediction;

  const HistoryDetailScreen({
    super.key,
    required this.prediction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        title: Text(prediction.breedName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// DATE CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "Detected Breed",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    prediction.breedName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Scanned on: ${prediction.dateTime}",
                    style: const TextStyle(
                        color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _infoCard(
              title: "Feeding / Diet",
              content: prediction.feeding,
              icon: Icons.grass,
              color: Colors.green.shade600,
            ),

            _infoCard(
              title: "Breeding Tips",
              content: prediction.breeding,
              icon: Icons.favorite,
              color: Colors.pink.shade400,
            ),

            _infoCard(
              title: "Care & Health",
              content: prediction.care,
              icon: Icons.health_and_safety,
              color: Colors.blue.shade500,
            ),

            _infoCard(
              title: "Milk Yield",
              content: prediction.milk,
              icon: Icons.water_drop,
              color: Colors.cyan.shade600,
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.all(16),
            child: content.isEmpty || content == 'No data'
                ? Text(
                    "Information not available.",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : Text(
                    content,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}