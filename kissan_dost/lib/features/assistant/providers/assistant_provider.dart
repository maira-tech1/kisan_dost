import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/voice_state.dart';
import '../services/speech_to_text_service.dart';
import '../services/stt_api_service.dart';
import '../services/whisper_model_manager.dart';
import '../services/whisper_service.dart';

final sttApiServiceProvider = Provider.autoDispose<SpeechToTextService>(
  (ref) {
    final service = SttApiService();
    ref.onDispose(service.dispose);
    return service;
  },
);

// Kept as an on-device fallback while the backend integration is being tested.
final whisperServiceProvider = Provider.autoDispose<SpeechToTextService>(
  (ref) {
    final service = LocalWhisperService(
      WhisperModelManager(
        modelName: 'ggml-tiny-q5_1.bin',
        modelUrl:
            'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-tiny-q5_1.bin',
      ),
    );
    ref.onDispose(service.dispose);
    return service;
  },
);

final assistantProvider = StateNotifierProvider.autoDispose<AssistantNotifier, VoiceState>(
  (ref) => AssistantNotifier(ref.watch(sttApiServiceProvider)),
);

class AssistantNotifier extends StateNotifier<VoiceState> {
  AssistantNotifier(this._service) : super(const VoiceState());

  final SpeechToTextService _service;
  bool _isBusy = false;

  Future<void> startListening() async {
    if (_isBusy) return;
    _isBusy = true;

    try {
      state = state.copyWith(
        status: VoiceStatus.ready,
        transcript: null,
        errorKey: '',
      );

      final granted = await _service.requestMicrophonePermission();
      if (!granted) {
        state = state.copyWith(
          status: VoiceStatus.error,
          errorKey: 'micPermissionDenied',
        );
        return;
      }

      await _service.prepareModel((progress) {
        state = state.copyWith(
          status: VoiceStatus.downloadingModel,
          downloadProgress: progress,
        );
      });

      await _service.startRecording();
      state = state.copyWith(
        status: VoiceStatus.listening,
        downloadProgress: 0.0,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        status: VoiceStatus.error,
        errorKey: _mapErrorToKey(e),
      );
    } finally {
      _isBusy = false;
    }
  }

  Future<void> stopListening(String language) async {
    if (state.status != VoiceStatus.listening) return;

    state = state.copyWith(status: VoiceStatus.transcribing);
    _isBusy = true;

    try {
      final result = await _service.stopAndTranscribe(language: language);
      if (result.text.isEmpty) {
        state = state.copyWith(
          status: VoiceStatus.error,
          errorKey: 'noSpeechDetected',
        );
      } else {
        state = state.copyWith(
          status: VoiceStatus.transcriptReady,
          transcript: result.text,
        );
      }
    } on Exception catch (e) {
      state = state.copyWith(
        status: VoiceStatus.error,
        errorKey: _mapErrorToKey(e),
      );
    } finally {
      _isBusy = false;
    }
  }

  void reset() {
    state = const VoiceState();
  }

  String _mapErrorToKey(Exception e) {
    if (e is NoSpeechDetectedException) return 'noSpeechDetected';
    if (e is SttServerUnreachableException) return 'sttServerUnreachable';
    if (e is SttTimeoutException) return 'sttTimeout';
    if (e is SttServerErrorException) return 'transcriptionFailed';
    if (e is SttInvalidResponseException) return 'transcriptionFailed';
    final message = e.toString().toLowerCase();
    if (message.contains('permission')) return 'micPermissionDenied';
    if (message.contains('download') || message.contains('model')) {
      return 'modelDownloadFailed';
    }
    return 'transcriptionFailed';
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
