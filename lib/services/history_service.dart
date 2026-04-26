import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const String key = "prediction_history";

<<<<<<< HEAD
  Future<void> savePrediction({
    required String breed,
    required String feeding,
    required String breeding,
    required String care,
    required String milk,
  }) async {
    final prefs = await SharedPreferences.getInstance();
=======
  /// SAVE PREDICTION
  Future<void> savePrediction(String breed) async {
    final prefs = await SharedPreferences.getInstance();

>>>>>>> 21917f0651e5ead9e628e9b8bcf320b116806c9e
    final history = prefs.getStringList(key) ?? [];

    final newEntry = jsonEncode({
      'breed': breed,
<<<<<<< HEAD
      'feeding': feeding,
      'breeding': breeding,
      'care': care,
      'milk': milk,
=======
>>>>>>> 21917f0651e5ead9e628e9b8bcf320b116806c9e
      'date': DateTime.now().toString(),
    });

    history.insert(0, newEntry);
<<<<<<< HEAD
    await prefs.setStringList(key, history);
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(key) ?? [];
=======

    await prefs.setStringList(key, history);
  }

  /// GET HISTORY
  Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();

    final history = prefs.getStringList(key) ?? [];

>>>>>>> 21917f0651e5ead9e628e9b8bcf320b116806c9e
    return history
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }

<<<<<<< HEAD
=======
  /// CLEAR HISTORY (optional)
>>>>>>> 21917f0651e5ead9e628e9b8bcf320b116806c9e
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}