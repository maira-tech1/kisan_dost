import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../farmer/providers/farmer_provider.dart';

class FarmerHeader extends ConsumerWidget {
  const FarmerHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(farmerProvider.select((farmer) => farmer.name));
    final location = ref.watch(
      farmerProvider.select((farmer) => farmer.location),
    );
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 32,
        bottom: 40,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.textOnPrimary,
                child: Icon(Icons.person, size: 28, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.trim().isEmpty
                          ? l10n.homeGreeting
                          : l10n.homeGreetingName(name),
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.textOnPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (location.trim().isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.primaryLight,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              location,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textOnPrimary
                                    .withValues(alpha: 0.85),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.textOnPrimary,
                ),
                tooltip: l10n.editProfile,
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRouter.farmerDetails,
                  arguments: const {'isEditing': true},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
