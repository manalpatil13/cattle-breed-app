import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const String key = "prediction_history";

  Future<void> savePrediction({
    required String breed,
    required String feeding,
    required String breeding,
    required String care,
    required String milk,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(key) ?? [];

    final newEntry = jsonEncode({
      'breed': breed,
      'feeding': feeding,
      'breeding': breeding,
      'care': care,
      'milk': milk,
      'date': DateTime.now().toString(),
    });

    history.insert(0, newEntry);
    await prefs.setStringList(key, history);
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(key) ?? [];
    return history
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}