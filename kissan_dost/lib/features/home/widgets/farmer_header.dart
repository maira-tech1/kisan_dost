import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

class FarmerHeader extends StatelessWidget {
  const FarmerHeader({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 24,
        left: 16,
        right: 16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.textOnPrimary,
                child: Icon(Icons.person, size: 32, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: AppTextStyles.title.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'السلام علیکم!',
            style: AppTextStyles.headline.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'آج آپ کو کیا مدد چاہیے؟',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textOnPrimary.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
