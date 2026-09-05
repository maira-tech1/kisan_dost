import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:whisper_cpp_flutter_plus/whisper_cpp_flutter_plus.dart' as whisper;

import '../../../core/config/backend_config.dart';
import '../models/transcription_result.dart';
import 'speech_to_text_service.dart';
import 'whisper_service.dart' show NoSpeechDetectedException;

class SttServerUnreachableException implements Exception {
  const SttServerUnreachableException();

  @override
  String toString() => 'Could not reach the transcription server.';
}

class SttTimeoutException implements Exception {
  const SttTimeoutException();

  @override
  String toString() => 'The transcription server timed out.';
}

class SttServerErrorException implements Exception {
  const SttServerErrorException(this.statusCode);

  final int statusCode;

  @override
  String toString() => 'The transcription server returned HTTP $statusCode.';
}

class SttInvalidResponseException implements Exception {
  const SttInvalidResponseException();

  @override
  String toString() => 'The transcription server returned an invalid response.';
}

/// Records with the device microphone and transcribes via the FastAPI backend.
class SttApiService implements SpeechToTextService {
  SttApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final whisper.WhisperRecorder _recorder = whisper.WhisperRecorder();
  final List<double> _samples = <double>[];

  StreamSubscription<whisper.RecordingChunk>? _subscription;
  int _sampleRate = 16000;
  bool _disposed = false;

  @override
  Future<bool> requestMicrophonePermission() {
    return _recorder.requestPermission();
  }

  @override
  Future<void> prepareModel(void Function(double progress)? onProgress) async {
    // The Whisper model lives on the server, so there is nothing to download.
  }

  @override
  Future<void> startRecording() async {
    _samples.clear();
    _subscription?.cancel();

    final stream = await _recorder.start();
    _subscription = stream.listen((chunk) {
      if (chunk.sampleRate > 0) {
        _sampleRate = chunk.sampleRate;
      }
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

    // [language] is deliberately unused: the app's UI language must not decide
    // what the farmer is allowed to speak. The server detects it from the audio.
    final wavBytes = _encodeWavPcm16(samples, _sampleRate);
    return _postForTranscription(wavBytes);
  }

  Future<TranscriptionResult> _postForTranscription(Uint8List wavBytes) async {
    final request = http.MultipartRequest('POST', BackendConfig.transcribeUri)
      ..files.add(
        http.MultipartFile.fromBytes(
          'audio',
          wavBytes,
          filename: 'recording.wav',
        ),
      );

    final http.Response response;
    try {
      response = await _send(request).timeout(BackendConfig.requestTimeout);
    } on TimeoutException {
      throw const SttTimeoutException();
    } on SocketException {
      throw const SttServerUnreachableException();
    } on http.ClientException {
      throw const SttServerUnreachableException();
    }

    if (response.statusCode != HttpStatus.ok) {
      throw SttServerErrorException(response.statusCode);
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw const SttInvalidResponseException();
    }

    if (decoded is! Map<String, dynamic>) {
      throw const SttInvalidResponseException();
    }

    final text = decoded['text'];
    if (text is! String) {
      throw const SttInvalidResponseException();
    }

    final responseLanguage = decoded['language'];
    if (responseLanguage is! String) {
      throw const SttInvalidResponseException();
    }

    final durationSeconds = decoded['duration_seconds'];
    final model = decoded['model'];

    return TranscriptionResult(
      text: text.trim(),
      language: responseLanguage,
      durationSeconds:
          durationSeconds is num ? durationSeconds.toDouble() : null,
      model: model is String ? model : null,
    );
  }

  Future<http.Response> _send(http.MultipartRequest request) async {
    final streamed = await _client.send(request);
    return http.Response.fromStream(streamed);
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;

    final sub = _subscription;
    _subscription = null;
    sub?.cancel();
    _recorder.stop().ignore();
    _client.close();
  }
}

Uint8List _encodeWavPcm16(List<double> samples, int sampleRate) {
  const int channels = 1;
  const int bitsPerSample = 16;
  final int bytesPerFrame = channels * bitsPerSample ~/ 8;
  final int dataSize = samples.length * bytesPerFrame;

  final out = ByteData(44 + dataSize);

  void writeAscii(int offset, String value) {
    for (var i = 0; i < value.length; i++) {
      out.setUint8(offset + i, value.codeUnitAt(i));
    }
  }

  writeAscii(0, 'RIFF');
  out.setUint32(4, 36 + dataSize, Endian.little);
  writeAscii(8, 'WAVE');
  writeAscii(12, 'fmt ');
  out.setUint32(16, 16, Endian.little);
  out.setUint16(20, 1, Endian.little);
  out.setUint16(22, channels, Endian.little);
  out.setUint32(24, sampleRate, Endian.little);
  out.setUint32(28, sampleRate * bytesPerFrame, Endian.little);
  out.setUint16(32, bytesPerFrame, Endian.little);
  out.setUint16(34, bitsPerSample, Endian.little);
  writeAscii(36, 'data');
  out.setUint32(40, dataSize, Endian.little);

  var offset = 44;
  for (final sample in samples) {
    final clamped = sample.clamp(-1.0, 1.0);
    out.setInt16(offset, (clamped * 32767).round(), Endian.little);
    offset += bytesPerFrame;
  }

  return out.buffer.asUint8List();
}
