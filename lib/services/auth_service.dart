import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Map<String, dynamic>?> findFarmer({
    required String name,
    required String village,
    required String phone,
  }) async {
    final response = await _client
        .from('farmers')
        .select()
        .eq('name', name)
        .eq('village', village)
        .eq('phone', phone)
        .maybeSingle();

    return response;
  }

  Future<void> createFarmer({
    required String name,
    required String village,
    required String phone,
  }) async {
    await _client.from('farmers').insert({
      'name': name,
      'village': village,
      'phone': phone,
    });
  }

  Future<void> saveFarmerLocally({
    required String name,
    required String village,
    required String phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('village', village);
    await prefs.setString('phone', phone);
  }

  Future<bool> isFarmerLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('name');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}