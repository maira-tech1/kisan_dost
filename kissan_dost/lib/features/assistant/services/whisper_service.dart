import 'dart:async';
import 'dart:typed_data';

import 'package:whisper_cpp_flutter_plus/whisper_cpp_flutter_plus.dart' as whisper;

import '../models/transcription_result.dart';
import 'speech_to_text_service.dart';
import 'whisper_model_manager.dart';

class NoSpeechDetectedException implements Exception {
  const NoSpeechDetectedException();

  @override
  String toString() => 'No speech was detected in the recording.';
}

class LocalWhisperService implements SpeechToTextService {
  LocalWhisperService(this._modelManager);

  final WhisperModelManager _modelManager;

  final whisper.WhisperRecorder _recorder = whisper.WhisperRecorder();
  final List<double> _samples = <double>[];
  StreamSubscription<whisper.RecordingChunk>? _subscription;
  String? _modelPath;
  bool _disposed = false;

  @override
  Future<bool> requestMicrophonePermission() async {
    return _recorder.requestPermission();
  }

  @override
  Future<void> prepareModel(void Function(double progress)? onProgress) async {
    _modelPath = await _modelManager.ensureModelDownloaded(onProgress);
  }

  @override
  Future<void> startRecording() async {
    _samples.clear();
    _subscription?.cancel();

    final stream = await _recorder.start();
    _subscription = stream.listen((chunk) {
      _samples.addAll(chunk.samples);
    });
  }

  @override
  Future<TranscriptionResult> stopAndTranscribe({
    required String language,
  }) async {
    await _recorder.stop();
    await _subscription?.cancel();
    _subscription = null;

    final samples = List<double>.from(_samples);
    if (samples.isEmpty) {
      throw const NoSpeechDetectedException();
    }

    final modelPath = _modelPath;
    if (modelPath == null || modelPath.isEmpty) {
      throw Exception('Whisper model is not ready.');
    }

    final engine = await whisper.WhisperEngine.load(modelPath);
    try {
      final options = whisper.TranscribeOptions(
        language: language,
        tokenTimestamps: false,
        enableVad: false,
      ).withPerformanceMode(whisper.WhisperPerformanceMode.balanced);

      final task = engine.transcribe(
        Float32List.fromList(samples),
        options: options,
      );
      final result = await task.result;
      return TranscriptionResult(
        text: result.text.trim(),
        language: language,
      );
    } finally {
      engine.dispose();
    }
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;

    final sub = _subscription;
    _subscription = null;
    sub?.cancel();
    _recorder.stop().ignore();
    _modelManager.close();
  }
}
