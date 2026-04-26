import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

<<<<<<< HEAD
import 'core/localization/app_localizations.dart';
=======
>>>>>>> 21917f0651e5ead9e628e9b8bcf320b116806c9e
import 'providers/language_provider.dart';
import 'screens/language_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

<<<<<<< HEAD
=======
  /// 🔥 SUPABASE INIT (REQUIRED)
>>>>>>> 21917f0651e5ead9e628e9b8bcf320b116806c9e
  await Supabase.initialize(
    url: 'https://thcgtuskzvlzmefduxva.supabase.co',
    anonKey: 'sb_publishable_z4hyvIDZHWBcMiGS5XYkVg_BrjYTNbQ',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getStartScreen() async {
    final authService = AuthService();
    final isLoggedIn = await authService.isLoggedIn();
<<<<<<< HEAD
=======

>>>>>>> 21917f0651e5ead9e628e9b8bcf320b116806c9e
    if (isLoggedIn) {
      return const HomeScreen();
    } else {
      return const LanguageScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: languageProvider.locale,

      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
        Locale('ta'),
        Locale('te'),
        Locale('kn'),
        Locale('gu'),
        Locale('pa'),
      ],

      localizationsDelegates: const [
<<<<<<< HEAD
        AppLocalizationsDelegate(), // ✅ now registered
=======
>>>>>>> 21917f0651e5ead9e628e9b8bcf320b116806c9e
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

<<<<<<< HEAD
=======
      /// 🔥 AUTO LOGIN
>>>>>>> 21917f0651e5ead9e628e9b8bcf320b116806c9e
      home: FutureBuilder<Widget>(
        future: _getStartScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            return snapshot.data!;
          }
        },
      ),
    );
  }
}