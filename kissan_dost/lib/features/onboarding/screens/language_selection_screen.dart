import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/widgets/app_button.dart';
import '../../../l10n/app_localizations.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
  String _selected = 'en';

  void _selectLanguage(String code) {
    setState(() => _selected = code);
    if (code == 'en') {
      ref.read(localeProvider.notifier).setEnglish();
    } else {
      ref.read(localeProvider.notifier).setUrdu();
    }
  }

  void _continue() {
    Navigator.pushNamed(context, AppRouter.farmerDetails);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectLanguage)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.selectLanguage,
                style: AppTextStyles.headline,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _LanguageCard(
                key: const Key('language-card-en'),
                code: 'en',
                label: l10n.english,
                nativeLabel: 'English',
                isSelected: _selected == 'en',
                onTap: () => _selectLanguage('en'),
              ),
              const SizedBox(height: 16),
              _LanguageCard(
                key: const Key('language-card-ur'),
                code: 'ur',
                label: l10n.urdu,
                nativeLabel: 'اردو',
                isSelected: _selected == 'ur',
                onTap: () => _selectLanguage('ur'),
              ),
              const Spacer(),
              AppButton(
                label: l10n.continueButton,
                onPressed: _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    super.key,
    required this.code,
    required this.label,
    required this.nativeLabel,
    required this.isSelected,
    required this.onTap,
  });

  final String code;
  final String label;
  final String nativeLabel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppColors.primary.withValues(alpha: 0.1)
          : AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.divider,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primaryLight.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    code.toUpperCase(),
                    style: AppTextStyles.button.copyWith(
                      color: isSelected
                          ? AppColors.textOnPrimary
                          : AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTextStyles.title),
                    const SizedBox(height: 4),
                    Text(
                      nativeLabel,
                      style: AppTextStyles.bodySecondary,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
