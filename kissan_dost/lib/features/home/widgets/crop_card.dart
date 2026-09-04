import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../farmer/extensions/crop_localization.dart';
import '../../farmer/models/crop_option.dart';
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.grain,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(l10n.cropsTitle, style: AppTextStyles.title),
              ),
              if (onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  child: Text(
                    l10n.editCrops,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (cropIds.isEmpty)
            Text(
              l10n.addCrop,
              style: AppTextStyles.bodySecondary,
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: cropIds
                  .map((cropId) => _CropChip(cropId: cropId))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _CropChip extends StatelessWidget {
  const _CropChip({required this.cropId});

  final String cropId;

  @override
  Widget build(BuildContext context) {
    final crop = availableCrops.firstWhere(
      (c) => c.id == cropId,
      orElse: () => const CropOption(id: '', icon: Icons.spa),
    );

    return Chip(
      avatar: Icon(
        crop.icon,
        size: 18,
        color: AppColors.primary,
      ),
      label: Text(localizeCropName(context, cropId)),
      backgroundColor: AppColors.primarySoft,
      side: BorderSide.none,
    );
  }
}
