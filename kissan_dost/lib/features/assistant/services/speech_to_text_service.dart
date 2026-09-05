import '../models/transcription_result.dart';

abstract class SpeechToTextService {
  Future<bool> requestMicrophonePermission();

  Future<void> prepareModel(void Function(double progress)? onProgress);

  Future<void> startRecording();

  Future<TranscriptionResult> stopAndTranscribe({required String language});

  void dispose();
}
