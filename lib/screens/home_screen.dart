import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../services/auth_service.dart';
import '../services/ai_service.dart';
import '../services/history_service.dart';
import '../services/breed_info_service.dart';
import '../utils/app_strings.dart';

import 'language_screen.dart';
import 'result_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final AIService _aiService = AIService();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  bool _loading = false;
  bool _modelLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    await _aiService.loadModel();
    setState(() {
      _modelLoaded = true;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  /// Show a friendly dialog when image is not a cattle
  void _showNotCattleDialog(BuildContext context) {
    final locale =
        Provider.of<LanguageProvider>(context, listen: false).locale;

    // Message in the app's current language
    final Map<String, Map<String, String>> messages = {
      'en': {
        'title': 'Not a Cattle Image',
        'body':
            'The image you selected does not appear to be a cattle. Please take or select a clear photo of a cow to get breed information.',
        'button': 'Try Again',
      },
      'hi': {
        'title': 'यह गाय की तस्वीर नहीं है',
        'body':
            'आपने जो तस्वीर चुनी वह गाय की नहीं लगती। कृपया गाय की स्पष्ट तस्वीर लें या चुनें।',
        'button': 'फिर से कोशिश करें',
      },
      'mr': {
        'title': 'हे गाईचे चित्र नाही',
        'body':
            'आपण निवडलेले चित्र गाईचे दिसत नाही। कृपया गाईचे स्पष्ट छायाचित्र घ्या किंवा निवडा।',
        'button': 'पुन्हा प्रयत्न करा',
      },
      'ta': {
        'title': 'இது மாட்டின் படம் இல்லை',
        'body':
            'நீங்கள் தேர்ந்தெடுத்த படம் மாடு அல்ல. தயவுசெய்து மாட்டின் தெளிவான படத்தை எடுக்கவும்.',
        'button': 'மீண்டும் முயற்சிக்கவும்',
      },
      'te': {
        'title': 'ఇది పశువు చిత్రం కాదు',
        'body':
            'మీరు ఎంచుకున్న చిత్రం పశువు కాదు. దయచేసి ఆవు యొక్క స్పష్టమైన ఫోటో తీయండి.',
        'button': 'మళ్ళీ ప్రయత్నించండి',
      },
      'kn': {
        'title': 'ಇದು ಜಾನುವಾರಿನ ಚಿತ್ರ ಅಲ್ಲ',
        'body':
            'ನೀವು ಆಯ್ಕೆ ಮಾಡಿದ ಚಿತ್ರ ಹಸು ಅಲ್ಲ. ದಯವಿಟ್ಟು ಹಸುವಿನ ಸ್ಪಷ್ಟ ಫೋಟೋ ತೆಗೆಯಿರಿ.',
        'button': 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ',
      },
      'gu': {
        'title': 'આ ઢોરની તસ્વીર નથી',
        'body':
            'તમે પસંદ કરેલ તસ્વીર ગાયની નથી. કૃપા કરીને ગાયનો સ્પષ્ટ ફોટો લો અથવા પસંદ કરો.',
        'button': 'ફરી પ્રયાસ કરો',
      },
      'pa': {
        'title': 'ਇਹ ਪਸ਼ੂ ਦੀ ਤਸਵੀਰ ਨਹੀਂ ਹੈ',
        'body':
            'ਤੁਸੀਂ ਜੋ ਤਸਵੀਰ ਚੁਣੀ ਉਹ ਗਾਂ ਨਹੀਂ ਲੱਗਦੀ। ਕਿਰਪਾ ਕਰਕੇ ਗਾਂ ਦੀ ਸਾਫ਼ ਤਸਵੀਰ ਲਓ।',
        'button': 'ਦੁਬਾਰਾ ਕੋਸ਼ਿਸ਼ ਕਰੋ',
      },
    };

    final lang = locale.languageCode;
    final msg = messages[lang] ?? messages['en']!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        // Red warning icon at top
        title: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.red.shade50,
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.red.shade400,
                size: 36,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              msg['title']!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          msg['body']!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 32, vertical: 12),
            ),
            onPressed: () {
              Navigator.pop(context);
              // Clear the selected image so user picks a new one
              setState(() => _selectedImage = null);
            },
            child: Text(
              msg['button']!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _predict() async {
    if (!_modelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Model is still loading...")),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
      return;
    }

    try {
      setState(() => _loading = true);

      // Step 1: get breed name from AI model
      final breedName = await _aiService.predict(_selectedImage!);

      setState(() => _loading = false);

      // 🔥 Step 2: intercept not_cattle BEFORE doing anything else
      if (breedName == 'not_cattle') {
        if (!mounted) return;
        _showNotCattleDialog(context);
        return;
      }

      setState(() => _loading = true);

      // Step 3: get current locale
      final locale =
          Provider.of<LanguageProvider>(context, listen: false).locale;

      // Step 4: fetch breed info in correct language
      final breedInfo =
          await BreedInfoService().getBreedInfo(breedName, locale);

      // Step 5: save everything to history
      await HistoryService().savePrediction(
        breed: breedName,
        feeding: breedInfo['feeding'] ?? '',
        breeding: breedInfo['breeding'] ?? '',
        care: breedInfo['care'] ?? '',
        milk: breedInfo['milk'] ?? '',
      );

      setState(() => _loading = false);

      if (!mounted) return;

      // Step 6: navigate to ResultScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            breedName: breedName,
            breedInfo: breedInfo,
          ),
        ),
      );

      setState(() => _selectedImage = null);

    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade200,
              Colors.green.shade50,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              /// TOP BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    IconButton(
                      icon: const Icon(Icons.history, size: 28),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HistoryScreen(),
                          ),
                        );
                      },
                    ),

                    const Text(
                      "Cattle Recognition",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.logout, size: 28),
                      onPressed: () async {
                        await _authService.logout();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LanguageScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              if (!_modelLoaded)
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Loading AI Model...",
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              const SizedBox(height: 10),

              Text(
                AppStrings.welcome(context),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: _selectedImage == null
                          ? Icon(Icons.camera_alt,
                              size: 80, color: Colors.grey.shade400)
                          : Image.file(_selectedImage!, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera),
                        label: Text(AppStrings.camera(context)),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo),
                        label: Text(AppStrings.gallery(context)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: _predict,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(AppStrings.predict(context)),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}