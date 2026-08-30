import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

extension CropLocalization on AppLocalizations {
  String cropName(String cropId) {
    switch (cropId) {
      case 'wheat':
        return cropWheat;
      case 'cotton':
        return cropCotton;
      case 'rice':
        return cropRice;
      case 'sugarcane':
        return cropSugarcane;
      case 'maize':
        return cropMaize;
      case 'tomato':
        return cropTomato;
      case 'potato':
        return cropPotato;
      case 'onion':
        return cropOnion;
      case 'sunflower':
        return cropSunflower;
      default:
        return cropId;
    }
  }
}

String localizeCropName(BuildContext context, String cropId) {
  return AppLocalizations.of(context).cropName(cropId);
}
