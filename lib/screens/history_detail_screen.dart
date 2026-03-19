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
      appBar: AppBar(
        title: Text(prediction.breedName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [

              Text(
                "Date: ${prediction.dateTime}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              const Text(
                "Feeding Pattern:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(prediction.feeding),

              const SizedBox(height: 15),

              const Text(
                "Breeding Tips:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(prediction.breeding),

              const SizedBox(height: 15),

              const Text(
                "Care Tips:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(prediction.care),
            ],
          ),
        ),
      ),
    );
  }
}