import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../farmer/providers/farmer_provider.dart';
import '../../home/widgets/app_bottom_navigation.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final location = ref.watch(
      farmerProvider.select((farmer) => farmer.location),
    );

    // TODO: Replace with real weather API response.
    const temperature = 24;
    const condition = 'Sunny';
    const humidity = 60;
    const windSpeed = 16;
    const rainChance = 30;

    final forecast = [
      _ForecastDay(l10n.weatherToday, 24, Icons.wb_sunny),
      _ForecastDay('Fri', 24, Icons.wb_cloudy),
      _ForecastDay('Sat', 24, Icons.wb_sunny),
      _ForecastDay('Sun', 23, Icons.water_drop),
      _ForecastDay('Mon', 24, Icons.wb_sunny),
      _ForecastDay('Tue', 24, Icons.wb_cloudy),
      _ForecastDay('Wed', 25, Icons.wb_sunny),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.weatherTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CurrentWeatherCard(
                temperature: temperature,
                condition: condition,
                humidity: humidity,
                windSpeed: windSpeed,
                rainChance: rainChance,
                location: location,
              ),
              const SizedBox(height: 28),
              Text(
                l10n.weather7DayForecast,
                style: AppTextStyles.title,
              ),
              const SizedBox(height: 16),
              _ForecastList(forecast: forecast),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentTab: HomeTab.weather,
        onHome: () => Navigator.pushReplacementNamed(context, AppRouter.home),
        onAssistant: () => Navigator.pushNamed(context, AppRouter.voiceAssistant),
      ),
    );
  }
}

class _CurrentWeatherCard extends StatelessWidget {
  const _CurrentWeatherCard({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.rainChance,
    required this.location,
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
    final displayLocation = location.trim().isEmpty
        ? AppLocalizations.of(context).farmerLocationHint
        : location;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.textOnPrimary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                displayLocation,
                style: AppTextStyles.title.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$temperature°C',
                    style: AppTextStyles.display.copyWith(
                      color: AppColors.textOnPrimary,
                      fontSize: 48,
                    ),
                  ),
                  Text(
                    condition,
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.wb_sunny,
                size: 80,
                color: AppColors.accent,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.textOnPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WeatherDetail(
                  icon: Icons.water_drop_outlined,
                  label: l10n.weatherHumidity,
                  value: '$humidity%',
                  color: AppColors.textOnPrimary,
                ),
                _WeatherDetail(
                  icon: Icons.air,
                  label: l10n.weatherWind,
                  value: '$windSpeed km/h',
                  color: AppColors.textOnPrimary,
                ),
                _WeatherDetail(
                  icon: Icons.umbrella_outlined,
                  label: l10n.weatherRain,
                  value: '$rainChance%',
                  color: AppColors.textOnPrimary,
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
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: color.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ForecastDay {
  const _ForecastDay(this.day, this.temp, this.icon);

  final String day;
  final int temp;
  final IconData icon;
}

class _ForecastList extends StatelessWidget {
  const _ForecastList({required this.forecast});

  final List<_ForecastDay> forecast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: forecast.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final day = forecast[index];
          final isToday = index == 0;
          return Container(
            width: 72,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isToday ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isToday ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  day.day,
                  style: AppTextStyles.body.copyWith(
                    color: isToday
                        ? AppColors.textOnPrimary
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  day.icon,
                  size: 28,
                  color: isToday ? AppColors.accent : AppColors.accent,
                ),
                Text(
                  '${day.temp}°',
                  style: AppTextStyles.title.copyWith(
                    color: isToday
                        ? AppColors.textOnPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
