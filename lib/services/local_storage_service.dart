import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prediction_model.dart';

class LocalStorageService {
  Future<void> savePrediction(PredictionModel prediction) async {
    final prefs = await SharedPreferences.getInstance();

    final existing = prefs.getStringList('history') ?? [];

    existing.add(jsonEncode(prediction.toJson()));

    await prefs.setStringList('history', existing);
  }

  Future<List<PredictionModel>> getPredictions() async {
    final prefs = await SharedPreferences.getInstance();

    final existing = prefs.getStringList('history') ?? [];

    return existing
        .map((e) => PredictionModel.fromJson(jsonDecode(e)))
        .toList();
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('history');
  }
}