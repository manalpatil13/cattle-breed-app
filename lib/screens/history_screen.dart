import 'package:flutter/material.dart';
import '../services/history_service.dart';
<<<<<<< HEAD
import '../models/prediction_model.dart';
import 'history_detail_screen.dart';
=======
import 'result_screen.dart';
>>>>>>> 21917f0651e5ead9e628e9b8bcf320b116806c9e

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final data = await HistoryService().getHistory();
    setState(() {
      history = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        title: const Text("History"),
        centerTitle: true,
      ),
=======
      appBar: AppBar(title: const Text("History")),
>>>>>>> 21917f0651e5ead9e628e9b8bcf320b116806c9e
      body: history.isEmpty
          ? const Center(child: Text("No history yet"))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
<<<<<<< HEAD
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: Icon(Icons.pets,
                          color: Colors.green.shade700),
                    ),
                    title: Text(
                      item['breed'] ?? 'Unknown',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item['date'] ?? ''),
                    trailing: const Icon(Icons.chevron_right),
=======

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(Icons.pets),
                    title: Text(item['breed']),
                    subtitle: Text(item['date']),
>>>>>>> 21917f0651e5ead9e628e9b8bcf320b116806c9e
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
<<<<<<< HEAD
                          builder: (_) => HistoryDetailScreen(
                            prediction: PredictionModel(
                              breedName: item['breed']    ?? 'Unknown',
                              feeding:   item['feeding']  ?? 'No data',
                              breeding:  item['breeding'] ?? 'No data',
                              care:      item['care']     ?? 'No data',
                              milk:      item['milk']     ?? 'No data',
                              dateTime:  item['date']     ?? '',
                            ),
                          ),
=======
                          builder: (_) =>
                              ResultScreen(breedName: item['breed']),
>>>>>>> 21917f0651e5ead9e628e9b8bcf320b116806c9e
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