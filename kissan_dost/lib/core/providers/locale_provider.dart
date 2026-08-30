import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en'));

  static const Locale english = Locale('en');
  static const Locale urdu = Locale('ur');

  void setEnglish() => state = english;

  void setUrdu() => state = urdu;

  void setLocale(Locale locale) => state = locale;
}
