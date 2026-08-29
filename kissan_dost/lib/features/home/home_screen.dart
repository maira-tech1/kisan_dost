import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_provider.dart';
import 'widgets/farmer_header.dart';
import 'widgets/weather_card.dart';
import 'widgets/crop_card.dart';
import 'widgets/ask_kissan_dost_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: FarmerHeader(name: state.farmerName)),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                WeatherCard(
                  temperature: state.temperature,
                  condition: state.weatherCondition,
                  location: state.location,
                ),
                const SizedBox(height: 16),
                CropCard(crops: state.crops),
                const SizedBox(height: 16),
                const AskKissanDostCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
