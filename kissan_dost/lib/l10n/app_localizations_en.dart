// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Kisan Dost';

  @override
  String get welcomeTitle => 'Welcome to Kisan Dost';

  @override
  String get welcomeSubtitle => 'Your trusted farming companion';

  @override
  String get continueButton => 'Continue';

  @override
  String get getStartedButton => 'Get Started';

  @override
  String get nextButton => 'Next';

  @override
  String get backButton => 'Back';

  @override
  String get saveButton => 'Save';

  @override
  String get finishButton => 'Finish';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get selectLanguage => 'Choose your preferred language';

  @override
  String get selectLanguageSubtitle =>
      'Select your language / اپنی زبان منتخب کریں';

  @override
  String get english => 'English';

  @override
  String get urdu => 'اردو';

  @override
  String get farmerDetailsTitle => 'Farmer Information';

  @override
  String get farmerNameLabel => 'Your name';

  @override
  String get farmerLocationLabel => 'Your city';

  @override
  String get farmerNameHint => 'Enter your name';

  @override
  String get farmerLocationHint => 'Enter your village or city';

  @override
  String get cropSelectionTitle => 'Choose Your Crops';

  @override
  String get cropSelectionSubtitle => 'Select the crops you grow';

  @override
  String get homeGreeting => 'Good morning!';

  @override
  String homeGreetingName(String name) {
    return 'Good morning, $name';
  }

  @override
  String get homePrompt => 'How can we help you today?';

  @override
  String get weatherTitle => 'Weather';

  @override
  String get weatherHumidity => 'Humidity';

  @override
  String get weatherWind => 'Wind';

  @override
  String get weatherRain => 'Rain';

  @override
  String get weather7DayForecast => '7-day forecast';

  @override
  String get weatherToday => 'Today';

  @override
  String get cropsTitle => 'My Crops';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get editCrops => 'Edit crops';

  @override
  String get addCrop => 'Add crop';

  @override
  String get askKisanDost => 'Ask Kisan Dost';

  @override
  String get askKisanDostSubtitle => 'Tap to speak';

  @override
  String get voiceAssistantTitle => 'Ask Kisan Dost';

  @override
  String get voiceAssistantReady => 'Tap the microphone and speak';

  @override
  String get tapToSpeak => 'What would you like to ask?';

  @override
  String get listening => 'Listening...';

  @override
  String get transcribing => 'Transcribing...';

  @override
  String get modelDownloading => 'Downloading speech model...';

  @override
  String get modelDownloadFailed =>
      'Failed to download the speech model. Please check your internet and try again.';

  @override
  String get micPermissionDenied =>
      'Microphone permission is required to record your voice.';

  @override
  String get transcriptionFailed =>
      'Could not transcribe your speech. Please try again.';

  @override
  String get noSpeechDetected => 'No speech was detected. Please try again.';

  @override
  String get sttServerUnreachable =>
      'Cannot reach the Kisan Dost server. Check that it is running and on the same network.';

  @override
  String get sttTimeout =>
      'The server took too long to respond. Please try again.';

  @override
  String get retry => 'Retry';

  @override
  String get transcriptReadyTitle => 'Here is what we heard';

  @override
  String get bottomNavHome => 'Home';

  @override
  String get bottomNavWeather => 'Weather';

  @override
  String get bottomNavAssistant => 'Assistant';

  @override
  String get cropWheat => 'Wheat';

  @override
  String get cropCotton => 'Cotton';

  @override
  String get cropRice => 'Rice';

  @override
  String get cropSugarcane => 'Sugarcane';

  @override
  String get cropMaize => 'Maize';

  @override
  String get cropTomato => 'Tomato';

  @override
  String get cropPotato => 'Potato';

  @override
  String get cropOnion => 'Onion';

  @override
  String get cropSunflower => 'Sunflower';
}
