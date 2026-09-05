import 'package:flutter/material.dart';

import '../../../app/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../models/voice_state.dart';

class VoiceStatusLabel extends StatelessWidget {
  const VoiceStatusLabel({
    super.key,
    required this.state,
    required this.l10n,
  });

  final VoiceState state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Text(
      _labelText,
      style: AppTextStyles.headline,
      textAlign: TextAlign.center,
    );
  }

  String get _labelText {
    if (state.isDownloadingModel) return l10n.modelDownloading;
    if (state.isListening) return l10n.listening;
    if (state.isTranscribing) return l10n.transcribing;
    if (state.hasError) return l10n.transcriptionFailed;
    if (state.hasTranscript) return l10n.transcriptReadyTitle;
    return l10n.voiceAssistantReady;
  }
}
