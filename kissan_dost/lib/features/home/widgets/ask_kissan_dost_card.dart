import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

class AskKissanDostCard extends StatelessWidget {
  const AskKissanDostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mic,
                  color: AppColors.textOnPrimary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'کسان دوست سے پوچھیں',
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'بول کر یا لکھ کر سوال کریں',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textOnPrimary.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward, color: AppColors.textOnPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
