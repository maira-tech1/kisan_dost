import 'package:flutter/material.dart';
import '../features/assistant/screens/voice_assistant_screen.dart';
import '../features/home/home_screen.dart';
import '../features/onboarding/screens/crop_selection_screen.dart';
import '../features/onboarding/screens/farmer_details_screen.dart';
import '../features/onboarding/screens/language_selection_screen.dart';
import '../features/onboarding/screens/splash_screen.dart';
import '../features/onboarding/screens/welcome_screen.dart';
import '../features/weather/screens/weather_screen.dart';

abstract class AppRouter {
  static const String home = '/';
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String language = '/language';
  static const String farmerDetails = '/farmer-details';
  static const String cropSelection = '/crop-selection';
  static const String voiceAssistant = '/voice-assistant';
  static const String weather = '/weather';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomeScreen(),
        splash: (context) => const SplashScreen(),
        welcome: (context) => const WelcomeScreen(),
        language: (context) => const LanguageSelectionScreen(),
        farmerDetails: (context) => const FarmerDetailsScreen(),
        cropSelection: (context) => const CropSelectionScreen(),
        voiceAssistant: (context) => const VoiceAssistantScreen(),
        weather: (context) => const WeatherScreen(),
      };
}
