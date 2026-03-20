import 'dart:convert';
import 'package:http/http.dart' as http;

class BreedInfoService {

  /// 🔥 STEP 1: Search Wikipedia
  Future<String?> searchBreed(String breed) async {
    final url = Uri.parse(
        "https://en.wikipedia.org/w/api.php?action=query&list=search&srsearch=$breed cattle&format=json");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final results = data['query']['search'];

      if (results != null && results.isNotEmpty) {
        return results[0]['title']; // best match
      }
    }

    return null;
  }

  /// 🔥 STEP 2: Get summary
  Future<Map<String, String>> getBreedInfo(String breed) async {
    try {
      final title = await searchBreed(breed);

      if (title == null) {
        return _fallback();
      }

      print("🔍 Found Wikipedia page: $title");

      final url = Uri.parse(
          "https://en.wikipedia.org/api/rest_v1/page/summary/${Uri.encodeComponent(title)}");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final extract = data['extract'];

        if (extract != null && extract.toString().isNotEmpty) {
          return {
            "feeding": extract,
            "breeding": extract,
            "care": extract,
          };
        }
      }

      return _fallback();

    } catch (e) {
      print("❌ ERROR: $e");
      return _fallback();
    }
  }

  Map<String, String> _fallback() {
    return {
      "feeding": "No information available for this breed.",
      "breeding": "No information available for this breed.",
      "care": "No information available for this breed.",
    };
  }
}