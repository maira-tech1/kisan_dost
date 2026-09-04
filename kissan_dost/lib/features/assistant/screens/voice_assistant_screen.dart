import 'package:flutter/material.dart';
import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/widgets/app_bottom_navigation.dart';

class VoiceAssistantScreen extends StatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  State<VoiceAssistantScreen> createState() => _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() => _isListening = !_isListening);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
              Text(
                _isListening ? l10n.listening : l10n.voiceAssistantReady,
                style: AppTextStyles.headline,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.tapToSpeak,
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              _MicButton(
                isListening: _isListening,
                onTap: _toggleListening,
                pulseController: _pulseController,
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
}

class _MicButton extends StatelessWidget {
  const _MicButton({
    required this.isListening,
    required this.onTap,
    required this.pulseController,
  });

  final bool isListening;
  final VoidCallback onTap;
  final AnimationController pulseController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: pulseController,
        builder: (context, child) {
          final scale = isListening ? 1 + pulseController.value * 0.08 : 1.0;
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(
                      alpha: isListening ? 0.5 : 0.3,
                    ),
                    blurRadius: isListening ? 40 : 24,
                    spreadRadius: isListening ? 8 : 4,
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: const Icon(
          Icons.mic,
          size: 64,
          color: AppColors.textOnPrimary,
        ),
      ),
    );
  }
}
