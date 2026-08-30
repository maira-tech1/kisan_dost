import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/router.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../farmer/providers/farmer_provider.dart';

class FarmerDetailsScreen extends ConsumerStatefulWidget {
  const FarmerDetailsScreen({super.key});

  @override
  ConsumerState<FarmerDetailsScreen> createState() =>
      _FarmerDetailsScreenState();
}

class _FarmerDetailsScreenState extends ConsumerState<FarmerDetailsScreen> {
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final farmer = ref.read(farmerProvider);
    _nameController.text = farmer.name;
    _locationController.text = farmer.location;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _continue() {
    final name = _nameController.text.trim();
    final location = _locationController.text.trim();

    if (name.isEmpty || location.isEmpty) return;

    ref.read(farmerProvider.notifier).updateFarmer(
          name: name,
          location: location,
        );

    Navigator.pushNamed(context, AppRouter.cropSelection);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.farmerDetailsTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.farmerDetailsTitle,
                style: AppTextStyles.headline,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.farmerNameLabel,
                  hintText: l10n.farmerNameHint,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _locationController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.farmerLocationLabel,
                  hintText: l10n.farmerLocationHint,
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
              ),
              const Spacer(),
              AppButton(
                label: l10n.continueButton,
                onPressed: _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
