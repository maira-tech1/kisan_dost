import 'package:flutter/foundation.dart';

enum VoiceStatus {
  ready,
  downloadingModel,
  listening,
  transcribing,
  transcriptReady,
  error,
}

@immutable
class VoiceState {
  const VoiceState({
    this.status = VoiceStatus.ready,
    this.transcript,
    this.errorKey = '',
    this.downloadProgress = 0.0,
  });

  final VoiceStatus status;
  final String? transcript;
  final String errorKey;
  final double downloadProgress;

  bool get isReady => status == VoiceStatus.ready;
  bool get isDownloadingModel => status == VoiceStatus.downloadingModel;
  bool get isListening => status == VoiceStatus.listening;
  bool get isTranscribing => status == VoiceStatus.transcribing;
  bool get hasTranscript => status == VoiceStatus.transcriptReady && transcript != null;
  bool get hasError => status == VoiceStatus.error;

  VoiceState copyWith({
    VoiceStatus? status,
    String? transcript,
    String? errorKey,
    double? downloadProgress,
  }) {
    return VoiceState(
      status: status ?? this.status,
      transcript: transcript ?? this.transcript,
      errorKey: errorKey ?? this.errorKey,
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }
}
