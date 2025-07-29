import 'package:flutter/material.dart';
import 'package:habi_share/screens/profile_settings.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4ED),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF8B4B8C),
                      size: 24,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // HabiShare Logo and Title
              Center(
                child: Column(
                  children: [
                    // Logo placeholder (building icon)
                    Container(
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B4B8C),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.business,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'HabiShare',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8B4B8C),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 80),
              
              // Menu Items
              _buildMenuItem(
                icon: Icons.dashboard_outlined,
                title: 'Dashboard',
                onTap: () {
                  // Handle dashboard navigation
                  Navigator.pop(context);
                },
              ),
              
              const SizedBox(height: 30),
              
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Profile Settings',
                onTap: () {
                  // Handle profile settings navigation
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileSettingsPage()));
                },
              ),
              
              const Spacer(),
              
              // Log Out Button
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Log Out',
                onTap: () {
                  // Handle log out
                },
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF8B4B8C),
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
