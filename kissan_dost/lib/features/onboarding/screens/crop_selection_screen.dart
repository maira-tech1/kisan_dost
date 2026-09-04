import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../farmer/extensions/crop_localization.dart';
import '../../farmer/models/crop_option.dart';
import '../../farmer/providers/farmer_provider.dart';

class CropSelectionScreen extends ConsumerWidget {
  const CropSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedIds = ref.watch(
      farmerProvider.select((farmer) => farmer.cropIds),
    );
    final hasSelection = selectedIds.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                l10n.cropSelectionTitle,
                style: AppTextStyles.headline,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.cropSelectionSubtitle,
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: availableCrops.length,
                  itemBuilder: (context, index) {
                    final crop = availableCrops[index];
                    final isSelected = selectedIds.contains(crop.id);
                    return _CropToggleCard(
                      crop: crop,
                      label: localizeCropName(context, crop.id),
                      isSelected: isSelected,
                      onTap: () =>
                          ref.read(farmerProvider.notifier).toggleCrop(crop.id),
                    );
                  },
                ),
              ),
              AppButton(
                label: l10n.finishButton,
                onPressed: hasSelection
                    ? () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRouter.home,
                          (route) => false,
                        )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CropToggleCard extends StatelessWidget {
  const _CropToggleCard({
    required this.crop,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final CropOption crop;
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  crop.icon,
                  size: 32,
                  color: isSelected
                      ? AppColors.textOnPrimary
                      : AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                label,
                style: AppTextStyles.title.copyWith(
                  color:
                      isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? AppColors.primary : AppColors.border,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
