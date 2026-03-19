import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(
        context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {

    'en': {
      'selectLanguage': 'Select Language',
      'login': 'Farmer Login',
      'name': 'Name',
      'village': 'Village',
      'phone': 'Phone Number',
      'continue': 'Continue',
    },

    'hi': {
      'selectLanguage': 'भाषा चुनें',
      'login': 'किसान लॉगिन',
      'name': 'नाम',
      'village': 'गांव',
      'phone': 'फोन नंबर',
      'continue': 'आगे बढ़ें',
    },

    'gu': {
      'selectLanguage': 'ભાષા પસંદ કરો',
      'login': 'ખેડૂત લૉગિન',
      'name': 'નામ',
      'village': 'ગામ',
      'phone': 'ફોન નંબર',
      'continue': 'આગળ વધો',
    },

    'mr': {
      'selectLanguage': 'भाषा निवडा',
      'login': 'शेतकरी लॉगिन',
      'name': 'नाव',
      'village': 'गाव',
      'phone': 'फोन नंबर',
      'continue': 'पुढे जा',
    },

    'kn': {
      'selectLanguage': 'ಭಾಷೆ ಆಯ್ಕೆಮಾಡಿ',
      'login': 'ರೈತ ಲಾಗಿನ್',
      'name': 'ಹೆಸರು',
      'village': 'ಗ್ರಾಮ',
      'phone': 'ಫೋನ್ ಸಂಖ್ಯೆ',
      'continue': 'ಮುಂದುವರಿಸಿ',
    },

    'ta': {
      'selectLanguage': 'மொழியை தேர்வு செய்யவும்',
      'login': 'விவசாயி உள்நுழைவு',
      'name': 'பெயர்',
      'village': 'கிராமம்',
      'phone': 'தொலைபேசி எண்',
      'continue': 'தொடரவும்',
    },

    'te': {
      'selectLanguage': 'భాషను ఎంచుకోండి',
      'login': 'రైతు లాగిన్',
      'name': 'పేరు',
      'village': 'గ్రామం',
      'phone': 'ఫోన్ నంబర్',
      'continue': 'కొనసాగించు',
    },

    'bn': {
      'selectLanguage': 'ভাষা নির্বাচন করুন',
      'login': 'কৃষক লগইন',
      'name': 'নাম',
      'village': 'গ্রাম',
      'phone': 'ফোন নম্বর',
      'continue': 'চালিয়ে যান',
    },

    'pa': {
      'selectLanguage': 'ਭਾਸ਼ਾ ਚੁਣੋ',
      'login': 'ਕਿਸਾਨ ਲਾਗਇਨ',
      'name': 'ਨਾਮ',
      'village': 'ਪਿੰਡ',
      'phone': 'ਫੋਨ ਨੰਬਰ',
      'continue': 'ਅੱਗੇ ਵਧੋ',
    },

    'or': {
      'selectLanguage': 'ଭାଷା ବାଛନ୍ତୁ',
      'login': 'ଚାଷୀ ଲଗଇନ',
      'name': 'ନାମ',
      'village': 'ଗାଁ',
      'phone': 'ଫୋନ ନମ୍ବର',
      'continue': 'ଆଗକୁ ବଢ଼ନ୍ତୁ',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]![key]!;
  }

  String get selectLanguage => get('selectLanguage');
  String get login => get('login');
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      [
        'en','hi','gu','mr','kn',
        'ta','te','bn','pa','or'
      ].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}