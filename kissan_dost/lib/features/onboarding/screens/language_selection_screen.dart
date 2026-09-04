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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                l10n.selectLanguage,
                style: AppTextStyles.headline,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.selectLanguageSubtitle,
                style: AppTextStyles.bodySecondary.copyWith(
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _LanguageCard(
                key: const Key('language-card-en'),
                code: 'EN',
                label: l10n.english,
                isSelected: _selected == 'en',
                onTap: () => _selectLanguage('en'),
              ),
              const SizedBox(height: 16),
              _LanguageCard(
                key: const Key('language-card-ur'),
                code: 'UR',
                label: l10n.urdu,
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
    required this.isSelected,
    required this.onTap,
  });

  final String code;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primarySoft : AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    code,
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
                child: Text(
                  label,
                  style: AppTextStyles.title.copyWith(
                    color: isSelected
                        ? AppColors.primaryDark
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 28,
                )
              else
                Icon(
                  Icons.circle_outlined,
                  color: AppColors.textSecondary.withValues(alpha: 0.35),
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
