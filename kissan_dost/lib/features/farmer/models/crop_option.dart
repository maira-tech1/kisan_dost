import 'package:flutter/material.dart';

class CropOption {
  const CropOption({
    required this.id,
    required this.icon,
  });

  final String id;
  final IconData icon;
}

const List<CropOption> availableCrops = [
  CropOption(id: 'wheat', icon: Icons.grain),
  CropOption(id: 'cotton', icon: Icons.eco),
  CropOption(id: 'rice', icon: Icons.grass),
  CropOption(id: 'sugarcane', icon: Icons.nature),
  CropOption(id: 'maize', icon: Icons.nature_outlined),
  CropOption(id: 'tomato', icon: Icons.local_florist),
  CropOption(id: 'potato', icon: Icons.local_dining),
  CropOption(id: 'onion', icon: Icons.layers),
  CropOption(id: 'sunflower', icon: Icons.wb_sunny_outlined),
];
