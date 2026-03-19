import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import '../models/prediction_model.dart';
import 'history_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final LocalStorageService _storageService = LocalStorageService();
  List<PredictionModel> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await _storageService.getPredictions();
    setState(() {
      _history = data.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prediction History"),
        centerTitle: true,
      ),
      body: _history.isEmpty
          ? const Center(child: Text("No History Yet"))
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];

                return Card(
                  child: ListTile(
                    title: Text(item.breedName),
                    subtitle: Text(item.dateTime),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              HistoryDetailScreen(prediction: item),
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