import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  const FilterChipWidget({
    Key? key,
    required this.label,
    required this.selected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.primaryPurple,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        selected: selected,
        selectedColor: AppColors.primaryPurple,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: selected ? AppColors.primaryPurple : Color(0xFFE0E0E0),
          ),
        ),
        onSelected: (_) => onTap?.call(),
        elevation: 0,
        pressElevation: 0,
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      ),
    );
  }
}
