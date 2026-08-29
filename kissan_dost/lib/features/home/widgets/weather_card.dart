import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({
    required this.temperature,
    required this.condition,
    required this.location,
    super.key,
  });

  final int temperature;
  final String condition;
  final String location;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wb_sunny,
              color: AppColors.accent,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$temperature°C', style: AppTextStyles.headline),
                Text(condition, style: AppTextStyles.body),
                const SizedBox(height: 2),
                Text(location, style: AppTextStyles.caption),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
