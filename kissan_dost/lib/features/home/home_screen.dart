import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/router.dart';
import '../../features/farmer/providers/farmer_provider.dart';
import 'widgets/app_bottom_navigation.dart';
import 'widgets/ask_kissan_dost_card.dart';
import 'widgets/crop_card.dart';
import 'widgets/farmer_header.dart';
import 'widgets/weather_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(
      farmerProvider.select((farmer) => farmer.location),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: FarmerHeader()),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                WeatherCard(
                  temperature: 24,
                  condition: 'Sunny',
                  humidity: 60,
                  windSpeed: 16,
                  rainChance: 30,
                  location: location,
                ),
                const SizedBox(height: 20),
                CropCard(
                  onEdit: () => Navigator.pushNamed(
                    context,
                    AppRouter.cropSelection,
                  ),
                ),
                const SizedBox(height: 20),
                AskKissanDostCard(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRouter.voiceAssistant,
                  ),
                ),
              ]),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentTab: HomeTab.home,
        onWeather: () => Navigator.pushNamed(context, AppRouter.weather),
        onAssistant: () => Navigator.pushNamed(context, AppRouter.voiceAssistant),
      ),
    );
  }
}
