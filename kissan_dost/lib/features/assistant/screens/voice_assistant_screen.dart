import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/widgets/app_bottom_navigation.dart';
import '../models/voice_state.dart';
import '../providers/assistant_provider.dart';
import '../widgets/mic_button.dart';
import '../widgets/transcript_view.dart';
import '../widgets/voice_status_label.dart';

class VoiceAssistantScreen extends ConsumerStatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  ConsumerState<VoiceAssistantScreen> createState() =>
      _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends ConsumerState<VoiceAssistantScreen> {
  void _onMicTap(String language) {
    final state = ref.read(assistantProvider);
    final notifier = ref.read(assistantProvider.notifier);

    if (state.isListening) {
      notifier.stopListening(language);
    } else if (state.isReady || state.hasError || state.hasTranscript) {
      notifier.startListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(assistantProvider);
    final locale = ref.watch(localeProvider);
    final language = locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.voiceAssistantTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const Spacer(),
              VoiceStatusLabel(state: state, l10n: l10n),
              const SizedBox(height: 12),
              _buildContent(context, state, l10n),
              const Spacer(),
              MicButton(
                isListening: state.isListening,
                isLoading: state.isTranscribing || state.isDownloadingModel,
                onTap: () => _onMicTap(language),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    l10n.cancelButton,
                    style: AppTextStyles.button,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentTab: HomeTab.assistant,
        onHome: () => Navigator.pushReplacementNamed(context, AppRouter.home),
        onWeather: () =>
            Navigator.pushReplacementNamed(context, AppRouter.weather),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    VoiceState state,
    AppLocalizations l10n,
  ) {
    if (state.isDownloadingModel) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: state.downloadProgress > 0 ? state.downloadProgress : null,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(state.downloadProgress * 100).toStringAsFixed(0)}%',
            style: AppTextStyles.bodySecondary,
          ),
        ],
      );
    }

    if (state.hasError) {
      return Text(
        _errorMessage(state.errorKey, l10n),
        style: AppTextStyles.bodySecondary.copyWith(color: AppColors.error),
        textAlign: TextAlign.center,
      );
    }

    if (state.hasTranscript && state.transcript != null) {
      return TranscriptView(text: state.transcript!);
    }

    return Text(
      l10n.tapToSpeak,
      style: AppTextStyles.bodySecondary,
      textAlign: TextAlign.center,
    );
  }

  String _errorMessage(String errorKey, AppLocalizations l10n) {
    switch (errorKey) {
      case 'micPermissionDenied':
        return l10n.micPermissionDenied;
      case 'modelDownloadFailed':
        return l10n.modelDownloadFailed;
      case 'noSpeechDetected':
        return l10n.noSpeechDetected;
      case 'sttServerUnreachable':
        return l10n.sttServerUnreachable;
      case 'sttTimeout':
        return l10n.sttTimeout;
      case 'transcriptionFailed':
      default:
        return l10n.transcriptionFailed;
    }
  }
}
