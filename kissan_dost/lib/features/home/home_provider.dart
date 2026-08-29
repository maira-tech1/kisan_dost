import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeState {
  const HomeState({
    this.farmerName = 'محمد علی',
    this.location = 'فیصل آباد',
    this.temperature = 32,
    this.weatherCondition = 'صاف',
    this.crops = const ['گندم', 'کپاس'],
  });

  final String farmerName;
  final String location;
  final int temperature;
  final String weatherCondition;
  final List<String> crops;
}

final homeProvider = StateProvider<HomeState>((ref) => const HomeState());
