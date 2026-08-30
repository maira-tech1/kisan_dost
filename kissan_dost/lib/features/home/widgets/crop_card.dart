import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../farmer/extensions/crop_localization.dart';
import '../../farmer/providers/farmer_provider.dart';

class CropCard extends ConsumerWidget {
  const CropCard({super.key, this.onEdit});

  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cropIds = ref.watch(
      farmerProvider.select((farmer) => farmer.cropIds),
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.grain, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(l10n.cropsTitle, style: AppTextStyles.title)),
              if (onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.primary),
                  tooltip: l10n.editCrops,
                  onPressed: onEdit,
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (cropIds.isEmpty)
            Text(
              l10n.addCrop,
              style: AppTextStyles.bodySecondary,
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: cropIds
                  .map(
                    (cropId) => Chip(
                      avatar: Icon(
                        Icons.spa,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      label: Text(localizeCropName(context, cropId)),
                      backgroundColor: AppColors.primaryLight.withValues(
                        alpha: 0.15,
                      ),
                      side: BorderSide.none,
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}
