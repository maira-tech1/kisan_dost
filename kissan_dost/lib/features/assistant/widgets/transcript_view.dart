import 'package:flutter/material.dart';

import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';

class TranscriptView extends StatelessWidget {
  const TranscriptView({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Text(
        text,
        style: AppTextStyles.body,
        textAlign: TextAlign.start,
      ),
    );
  }
}
