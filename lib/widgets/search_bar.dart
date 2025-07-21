import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onFilterTap;
  const SearchBar({Key? key, this.controller, this.onFilterTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Color(0xFFE0E0E0)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color(0xFF999999), size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 16,
                      ),
                      isCollapsed: true,
                    ),
                    style: TextStyle(color: Color(0xFF333333), fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onFilterTap,
          child: Icon(Icons.tune, color: AppColors.primaryPurple, size: 28),
        ),
      ],
    );
  }
}
