import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const String key = "prediction_history";

  /// SAVE PREDICTION
  Future<void> savePrediction(String breed) async {
    final prefs = await SharedPreferences.getInstance();

    final history = prefs.getStringList(key) ?? [];

    final newEntry = jsonEncode({
      'breed': breed,
      'date': DateTime.now().toString(),
    });

    history.insert(0, newEntry);

    await prefs.setStringList(key, history);
  }

  /// GET HISTORY
  Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();

    final history = prefs.getStringList(key) ?? [];

    return history
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }

  /// CLEAR HISTORY (optional)
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}