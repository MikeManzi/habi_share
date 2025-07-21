import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final bool large;
  const InfoColumn({
    required this.label,
    required this.value,
    this.bold = false,
    this.large = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.inputHint, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: AppColors.inputText,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            fontSize: large ? 15 : 13,
          ),
        ),
      ],
    );
  }
}
