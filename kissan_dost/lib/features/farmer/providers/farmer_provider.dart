import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/farmer.dart';

final farmerProvider = StateNotifierProvider<FarmerNotifier, Farmer>(
  (ref) => FarmerNotifier(),
);

class FarmerNotifier extends StateNotifier<Farmer> {
  FarmerNotifier() : super(const Farmer());

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setLocation(String location) {
    state = state.copyWith(location: location);
  }

  void setCrops(List<String> cropIds) {
    state = state.copyWith(cropIds: cropIds);
  }

  void toggleCrop(String cropId) {
    final current = List<String>.from(state.cropIds);
    if (current.contains(cropId)) {
      current.remove(cropId);
    } else {
      current.add(cropId);
    }
    state = state.copyWith(cropIds: current);
  }

  void updateFarmer({
    String? name,
    String? location,
    List<String>? cropIds,
  }) {
    state = state.copyWith(
      name: name,
      location: location,
      cropIds: cropIds,
    );
  }
}

final onboardingCompleteProvider = Provider<bool>(
  (ref) =>
      ref.watch(farmerProvider.select((farmer) => farmer.isOnboardingComplete)),
);
