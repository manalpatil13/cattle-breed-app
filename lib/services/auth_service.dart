import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<void> loginFarmer(
      String name, String village, String phone) async {
    final prefs = await SharedPreferences.getInstance();

    /// ✅ LOCAL SAVE
    await prefs.setString('name', name);
    await prefs.setString('village', village);
    await prefs.setString('phone', phone);
    await prefs.setBool('loggedIn', true);

    /// 🔥 DEBUG PRINT
    print("Sending to Supabase:");
    print("Name: $name, Village: $village, Phone: $phone");

    /// 🔥 SUPABASE INSERT (WITH ERROR CHECK)
    try {
      final response = await supabase.from('farmers').upsert({
        'name': name,
        'village': village,
        'phone': phone,
      }).select();

      print("✅ Supabase Response: $response");

    } catch (e) {
      print("❌ Supabase Error: $e");
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? false;
  }

  Future<Map<String, String>> getFarmerData() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'name': prefs.getString('name') ?? '',
      'village': prefs.getString('village') ?? '',
      'phone': prefs.getString('phone') ?? '',
    };
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}