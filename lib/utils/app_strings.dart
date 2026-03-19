import 'package:flutter/material.dart';

class AppStrings {
  static String welcome(BuildContext context) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'hi':
        return "स्वागत किसान";
      case 'mr':
        return "स्वागत शेतकरी";
      default:
        return "Welcome Farmer";
    }
  }

  static String login(BuildContext context) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'hi':
        return "लॉगिन करें";
      case 'mr':
        return "लॉगिन करा";
      default:
        return "Login";
    }
  }

  static String predict(BuildContext context) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'hi':
        return "भविष्यवाणी करें";
      case 'mr':
        return "भाकीत करा";
      default:
        return "Predict Breed";
    }
  }

  static String camera(BuildContext context) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'hi':
        return "कैमरा";
      case 'mr':
        return "कॅमेरा";
      default:
        return "Camera";
    }
  }

  static String gallery(BuildContext context) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'hi':
        return "गैलरी";
      case 'mr':
        return "गॅलरी";
      default:
        return "Gallery";
    }
  }
}