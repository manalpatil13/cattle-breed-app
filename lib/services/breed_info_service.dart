import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BreedInfoService {

  /// Map Flutter locale to Google Translate language code
  String _getTranslateLang(Locale locale) {
    switch (locale.languageCode) {
      case 'hi': return 'hi';
      case 'mr': return 'mr';
      case 'ta': return 'ta';
      case 'te': return 'te';
      case 'kn': return 'kn';
      case 'gu': return 'gu';
      case 'pa': return 'pa';
      default:   return 'en';
    }
  }

  /// Keywords to find relevant paragraphs — English only now
  static const Map<String, List<String>> _sectionKeywords = {
    'feeding': [
      'feed', 'fodder', 'grass', 'diet', 'graze', 'pasture',
      'nutrition', 'roughage', 'concentrate', 'silage', 'hay',
      'straw', 'eating', 'browse', 'forage',
    ],
    'breeding': [
      'breed', 'breeding', 'reproduction', 'calving', 'gestation',
      'fertility', 'bull', 'calf', 'conception', 'lactation',
      'estrus', 'mating', 'pregnancy', 'intercalving', 'insemination',
    ],
    'care': [
      'care', 'health', 'disease', 'vaccination', 'veterinary',
      'hygiene', 'shelter', 'housing', 'tick', 'parasite',
      'treatment', 'medicine', 'deworming', 'grooming', 'management',
    ],
    'milk': [
      'milk', 'dairy', 'litre', 'liter', 'yield', 'production',
      'fat content', 'lactation period', 'milking', 'daily yield',
      'per day', 'annual yield', 'kg per', 'butterfat',
    ],
  };

  /// Step 1: Search English Wikipedia for best article title
  Future<String?> _searchBreed(String breed) async {
    final url = Uri.parse(
      'https://en.wikipedia.org/w/api.php'
      '?action=query&list=search'
      '&srsearch=${Uri.encodeComponent(breed + " cattle breed")}'
      '&format=json&srlimit=3',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['query']['search'] as List?;
        if (results != null && results.isNotEmpty) {
          return results[0]['title'] as String;
        }
      }
    } catch (e) {
      print('❌ Search error: $e');
    }

    return null;
  }

  /// Step 2: Fetch full plain text of English Wikipedia article
  Future<String?> _fetchFullText(String title) async {
    final url = Uri.parse(
      'https://en.wikipedia.org/w/api.php'
      '?action=query&titles=${Uri.encodeComponent(title)}'
      '&prop=extracts&explaintext=true&exlimit=1&format=json',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final pages = data['query']['pages'] as Map;
        final page = pages.values.first;
        return page['extract'] as String?;
      }
    } catch (e) {
      print('❌ Fetch error: $e');
    }

    return null;
  }

  /// Step 3: Fetch named sections list
  Future<List<Map<String, dynamic>>> _fetchSections(String title) async {
    final url = Uri.parse(
      'https://en.wikipedia.org/w/api.php'
      '?action=parse&page=${Uri.encodeComponent(title)}'
      '&prop=sections&format=json',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final sections = data['parse']?['sections'] as List?;
        if (sections != null) {
          return sections
              .map((s) => {
                    'index': s['index'],
                    'title': (s['line'] as String? ?? '').toLowerCase(),
                  })
              .toList();
        }
      }
    } catch (e) {
      print('❌ Sections error: $e');
    }

    return [];
  }

  /// Step 4: Fetch text of a specific named section
  Future<String?> _fetchSectionText(
      String title, String sectionIndex) async {
    final url = Uri.parse(
      'https://en.wikipedia.org/w/api.php'
      '?action=query&titles=${Uri.encodeComponent(title)}'
      '&prop=extracts&exsectionformat=plain'
      '&section=$sectionIndex&explaintext=true&format=json',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final pages = data['query']['pages'] as Map;
        final page = pages.values.first;
        final extract = page['extract'] as String?;
        if (extract != null && extract.trim().length > 40) {
          return extract.trim();
        }
      }
    } catch (e) {
      print('❌ Section text error: $e');
    }

    return null;
  }

  /// Step 5: Score paragraphs by keyword match and return best one
  String _extractParagraph(String fullText, String sectionKey) {
    final keywords = _sectionKeywords[sectionKey] ?? [];

    final paragraphs = fullText
        .split('\n')
        .map((p) => p.trim())
        .where((p) => p.length > 80)
        .toList();

    String bestParagraph = '';
    int bestScore = 0;

    for (final para in paragraphs) {
      final lowerPara = para.toLowerCase();
      int score = 0;
      for (final keyword in keywords) {
        if (lowerPara.contains(keyword)) score++;
      }
      if (score > bestScore) {
        bestScore = score;
        bestParagraph = para;
      }
    }

    if (bestParagraph.isEmpty && paragraphs.isNotEmpty) {
      return paragraphs.first;
    }

    return bestParagraph;
  }

  /// Step 6: Try to find content via named Wikipedia section titles
  Future<String?> _findSectionByTitle(
      List<Map<String, dynamic>> sections,
      String title,
      String sectionKey) async {
    final keywords = _sectionKeywords[sectionKey] ?? [];

    for (final section in sections) {
      final sectionTitle = section['title'] as String;
      for (final keyword in keywords) {
        if (sectionTitle.contains(keyword)) {
          final text = await _fetchSectionText(
              title, section['index'].toString());
          if (text != null && text.length > 60) {
            return text;
          }
        }
      }
    }

    return null;
  }

  /// Step 7: Translate text using free Google Translate API
  /// Uses the unofficial endpoint — no API key required
  Future<String> _translate(String text, String targetLang) async {
    // No translation needed for English
    if (targetLang == 'en') return text;

    // Trim text to avoid request size issues
    final trimmed = text.length > 1000 ? text.substring(0, 1000) : text;

    try {
      final url = Uri.parse(
        'https://translate.googleapis.com/translate_a/single'
        '?client=gtx'
        '&sl=en'
        '&tl=$targetLang'
        '&dt=t'
        '&q=${Uri.encodeComponent(trimmed)}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Response is a nested array — extract all translated chunks
        final List<dynamic> chunks = data[0];
        final translated = chunks
            .where((chunk) => chunk[0] != null)
            .map((chunk) => chunk[0].toString())
            .join('');

        if (translated.trim().isNotEmpty) {
          return translated.trim();
        }
      }
    } catch (e) {
      print('❌ Translation error: $e');
    }

    // If translation fails, return original English text
    return text;
  }

  /// MAIN METHOD — always fetches English, then translates
  Future<Map<String, String>> getBreedInfo(
      String breed, Locale locale) async {
    final targetLang = _getTranslateLang(locale);

    try {
      // Search English Wikipedia
      final title = await _searchBreed(breed);
      if (title == null) return _fallback(targetLang);

      print('📖 Wikipedia: $title → translating to $targetLang');

      // Fetch sections list and full text in English
      final sections = await _fetchSections(title);
      final fullText = await _fetchFullText(title);

      if (fullText == null || fullText.isEmpty) {
        return _fallback(targetLang);
      }

      // Extract English text for each section
      Future<String> getEnglishSection(String key) async {
        if (sections.isNotEmpty) {
          final fromSection =
              await _findSectionByTitle(sections, title, key);
          if (fromSection != null && fromSection.length > 60) {
            return fromSection;
          }
        }
        final para = _extractParagraph(fullText, key);
        return para.isNotEmpty ? para : _fallbackText(key, 'en');
      }

      // Get all 4 sections in English first
      final feedingEn  = await getEnglishSection('feeding');
      final breedingEn = await getEnglishSection('breeding');
      final careEn     = await getEnglishSection('care');
      final milkEn     = await getEnglishSection('milk');

      print('✅ English sections extracted — translating...');

      // Translate all 4 sections to target language in parallel
      final results = await Future.wait([
        _translate(feedingEn,  targetLang),
        _translate(breedingEn, targetLang),
        _translate(careEn,     targetLang),
        _translate(milkEn,     targetLang),
      ]);

      return {
        'feeding':  results[0],
        'breeding': results[1],
        'care':     results[2],
        'milk':     results[3],
      };

    } catch (e) {
      print('❌ BreedInfoService error: $e');
      return _fallback(targetLang);
    }
  }

  /// Fallback when nothing found
  Map<String, String> _fallback(String lang) {
    return {
      'feeding':  _fallbackText('feeding',  lang),
      'breeding': _fallbackText('breeding', lang),
      'care':     _fallbackText('care',     lang),
      'milk':     _fallbackText('milk',     lang),
    };
  }

  String _fallbackText(String key, String lang) {
    const fallbacks = <String, Map<String, String>>{
      'feeding': {
        'en': 'Feeding information not available for this breed.',
        'hi': 'इस नस्ल के लिए चारे की जानकारी उपलब्ध नहीं है।',
        'mr': 'या जातीसाठी चाऱ्याची माहिती उपलब्ध नाही।',
        'ta': 'இந்த இனத்திற்கான தீவன தகவல் கிடைக்கவில்லை.',
        'te': 'ఈ జాతికి మేత సమాచారం అందుబాటులో లేదు.',
        'kn': 'ಈ ತಳಿಗೆ ಮೇವಿನ ಮಾಹಿತಿ ಲಭ್ಯವಿಲ್ಲ.',
        'gu': 'આ જાતિ માટે ઘાસચારાની માહિતી ઉપલબ્ધ નથી.',
        'pa': 'ਇਸ ਨਸਲ ਲਈ ਚਾਰੇ ਦੀ ਜਾਣਕਾਰੀ ਉਪਲਬਧ ਨਹੀਂ ਹੈ।',
      },
      'breeding': {
        'en': 'Breeding information not available for this breed.',
        'hi': 'इस नस्ल के लिए प्रजनन जानकारी उपलब्ध नहीं है।',
        'mr': 'या जातीसाठी प्रजननाची माहिती उपलब्ध नाही।',
        'ta': 'இந்த இனத்திற்கான இனப்பெருக்க தகவல் கிடைக்கவில்லை.',
        'te': 'ఈ జాతికి సంతానోత్పత్తి సమాచారం అందుబాటులో లేదు.',
        'kn': 'ಈ ತಳಿಗೆ ಸಂತಾನೋತ್ಪತ್ತಿ ಮಾಹಿತಿ ಲಭ್ಯವಿಲ್ಲ.',
        'gu': 'આ જાતિ માટે પ્રજનન માહિતી ઉપલબ્ધ નથી.',
        'pa': 'ਇਸ ਨਸਲ ਲਈ ਪ੍ਰਜਨਨ ਜਾਣਕਾਰੀ ਉਪਲਬਧ ਨਹੀਂ ਹੈ।',
      },
      'care': {
        'en': 'Care information not available for this breed.',
        'hi': 'इस नस्ल के लिए देखभाल की जानकारी उपलब्ध नहीं है।',
        'mr': 'या जातीसाठी काळजीची माहिती उपलब्ध नाही।',
        'ta': 'இந்த இனத்திற்கான பராமரிப்பு தகவல் கிடைக்கவில்லை.',
        'te': 'ఈ జాతికి సంరక్షణ సమాచారం అందుబాటులో లేదు.',
        'kn': 'ಈ ತಳಿಗೆ ಆರೈಕೆ ಮಾಹಿತಿ ಲಭ್ಯವಿಲ್ಲ.',
        'gu': 'આ જાતિ માટે સંભાળની માહિતી ઉપલબ્ધ નથી.',
        'pa': 'ਇਸ ਨਸਲ ਲਈ ਦੇਖਭਾਲ ਦੀ ਜਾਣਕਾਰੀ ਉਪਲਬਧ ਨਹੀਂ ਹੈ।',
      },
      'milk': {
        'en': 'Milk yield information not available for this breed.',
        'hi': 'इस नस्ल के लिए दूध उत्पादन की जानकारी उपलब्ध नहीं है।',
        'mr': 'या जातीसाठी दूध उत्पादनाची माहिती उपलब्ध नाही।',
        'ta': 'இந்த இனத்திற்கான பால் உற்பத்தி தகவல் கிடைக்கவில்லை.',
        'te': 'ఈ జాతికి పాల దిగుబడి సమాచారం అందుబాటులో లేదు.',
        'kn': 'ಈ ತಳಿಗೆ ಹಾಲಿನ ಉತ್ಪಾದನೆ ಮಾಹಿತಿ ಲಭ್ಯವಿಲ್ಲ.',
        'gu': 'આ જાતિ માટે દૂધ ઉત્પાદનની માહિતી ઉપલબ્ધ નથી.',
        'pa': 'ਇਸ ਨਸਲ ਲਈ ਦੁੱਧ ਉਤਪਾਦਨ ਦੀ ਜਾਣਕਾਰੀ ਉਪਲਬਧ ਨਹੀਂ ਹੈ।',
      },
    };

    return fallbacks[key]?[lang] ??
        fallbacks[key]?['en'] ??
        'Information not available.';
  }
}