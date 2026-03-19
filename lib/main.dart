import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/localization/app_localizations.dart';
import 'screens/language_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://thcgtuskzvlzmefduxva.supabase.co',
    anonKey: 'sb_publishable_z4hyvIDZHWBcMiGS5XYkVg_BrjYTNbQ',
  );

  runApp(const CattleApp());
}

class CattleApp extends StatefulWidget {
  const CattleApp({super.key});

  @override
  State<CattleApp> createState() => _CattleAppState();
}

class _CattleAppState extends State<CattleApp> {
  Locale _locale = const Locale('en');
  final AuthService _authService = AuthService();
  bool _checkedLogin = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final loggedIn = await _authService.isFarmerLoggedIn();
    setState(() {
      _isLoggedIn = loggedIn;
      _checkedLogin = true;
    });
  }

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_checkedLogin) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('gu'),
        Locale('mr'),
        Locale('kn'),
        Locale('ta'),
        Locale('te'),
        Locale('bn'),
        Locale('pa'),
        Locale('or'),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: _isLoggedIn
          ? const HomeScreen()
          : LanguageScreen(onLanguageSelected: changeLanguage),
    );
  }
}