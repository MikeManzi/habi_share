import 'package:flutter/material.dart';
import 'package:habi_share/providers/auth_provider.dart';
import 'package:habi_share/screens/profile_settings.dart';
import 'package:provider/provider.dart';

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
                      color:   Color(0xFF8A2851),
                      size: 24,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              
              Center(
                child: Column(
                  children: [
                    
                    Container(
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                        color:  const Color(0xFF8A2851),
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

              
              _buildMenuItem(
                icon: Icons.dashboard_outlined,
                title: 'Dashboard',
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 30),

              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Profile Settings',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileSettingsPage(),
                    ),
                  );
                },
              ),

              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(Icons.logout, color: const Color(0xFF8A2851)),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.black),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
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
            Icon(icon, color:   const Color(0xFF8A2851), size: 24),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<AuthProvider>(context, listen: false).signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },

              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
