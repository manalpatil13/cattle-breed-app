import 'package:flutter/material.dart';
import '../models/prediction_model.dart';
import '../services/local_storage_service.dart';

class ResultScreen extends StatefulWidget {
  final String breedName;

  const ResultScreen({
    super.key,
    required this.breedName,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final LocalStorageService _storageService = LocalStorageService();

  late final String feeding;
  late final String breeding;
  late final String care;

  @override
  void initState() {
    super.initState();

    feeding = "Provide green fodder, dry fodder, and mineral supplements.";
    breeding = "Ensure proper heat detection and maintain breeding records.";
    care = "Maintain hygiene, regular vaccination, and clean water supply.";

    _savePrediction();
  }

  Future<void> _savePrediction() async {
    final prediction = PredictionModel(
      breedName: widget.breedName,
      feeding: feeding,
      breeding: breeding,
      care: care,
      dateTime: DateTime.now().toString(),
    );

    await _storageService.savePrediction(prediction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Breed Result"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [

              Text(
                widget.breedName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Feeding Pattern:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(feeding),

              const SizedBox(height: 15),

              const Text(
                "Breeding Tips:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(breeding),

              const SizedBox(height: 15),

              const Text(
                "Care Tips:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(care),
            ],
          ),
        ),
      ),
    );
  }
}