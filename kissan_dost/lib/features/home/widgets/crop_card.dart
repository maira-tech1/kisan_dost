import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';

class CropCard extends StatelessWidget {
  const CropCard({required this.crops, super.key});

  final List<String> crops;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.grain, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Text('فصلیں', style: AppTextStyles.title),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: crops
                .map(
                  (crop) => Chip(
                    label: Text(crop),
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
