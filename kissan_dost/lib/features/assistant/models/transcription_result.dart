import 'package:flutter/foundation.dart';

@immutable
class TranscriptionResult {
  const TranscriptionResult({
    required this.text,
    required this.language,
    this.durationSeconds,
    this.model,
  });

  final String text;
  final String language;
  final double? durationSeconds;
  final String? model;
}
