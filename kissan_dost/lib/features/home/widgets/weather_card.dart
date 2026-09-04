import 'package:flutter/material.dart';
import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../l10n/app_localizations.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.location,
    this.rainChance = 30,
    super.key,
  });

  final int temperature;
  final String condition;
  final int humidity;
  final int windSpeed;
  final int rainChance;
  final String location;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppCard(
      onTap: () => Navigator.pushNamed(context, AppRouter.weather),
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
                  Icons.wb_sunny,
                  color: AppColors.accent,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(l10n.weatherTitle, style: AppTextStyles.title),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.weatherToday,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wb_sunny,
                  color: AppColors.accent,
                  size: 36,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$temperature°C',
                      style: AppTextStyles.display.copyWith(fontSize: 28),
                    ),
                    Text(
                      condition,
                      style: AppTextStyles.body,
                    ),
                    if (location.trim().isNotEmpty)
                      Text(
                        location,
                        style: AppTextStyles.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WeatherDetail(
                  icon: Icons.water_drop_outlined,
                  label: l10n.weatherHumidity,
                  value: '$humidity%',
                ),
                _WeatherDetail(
                  icon: Icons.air,
                  label: l10n.weatherWind,
                  value: '$windSpeed km/h',
                ),
                _WeatherDetail(
                  icon: Icons.umbrella_outlined,
                  label: l10n.weatherRain,
                  value: '$rainChance%',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherDetail extends StatelessWidget {
  const _WeatherDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            Text(
              value,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
