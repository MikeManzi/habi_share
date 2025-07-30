import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback onClosePressed;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onClosePressed,
    this.onBackPressed,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF5F5F5),
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 120,
      title: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          children: [
            if (showBackButton)
              IconButton(
                onPressed: onBackPressed,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF8A2851),
                  size: 24,
                ),
              )
            else
              const SizedBox(width: 48),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF8A2851),
                          shape: BoxShape.rectangle,
                        ),
                        child: const Icon(
                          Icons.apartment,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'HabiShare',
                        style: TextStyle(
                          color: Color(0xFF8A2851),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onClosePressed,
              icon: const Icon(Icons.close, color: Color(0xFF8A2851), size: 24),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}
