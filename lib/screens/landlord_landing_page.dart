import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../models/property.dart';
import '../models/notification.dart';
import '../widgets/property_card.dart';
import '../widgets/notification_popover.dart';

class LandlordLandingPage extends StatefulWidget {
  const LandlordLandingPage({super.key});

  @override
  State<LandlordLandingPage> createState() => _LandlordLandingPageState();
}

class _LandlordLandingPageState extends State<LandlordLandingPage> {
  bool showNotifications = false;

  // Dummy data for properties and notifications
  final List<Property> properties = [
    Property(
      name: 'Green Apartments',
      address: 'Kg 99 st, Kigali-Rwanda',
      phone: '+250789999999',
      email: 'someone@example.com',
      size: '1234 sqm',
      rooms: '4',
      lastActivity: '12/03/24',
      image: '',
    ),
    Property(
      name: 'Oasis Apartments',
      address: 'Kg 420 st, Kigali-Rwanda',
      phone: '+250789999999',
      email: 'someone@example.com',
      size: '1234 sqm',
      rooms: '4',
      lastActivity: '12/03/24',
      image: '',
    ),
    Property(
      name: 'Oasis Apartments',
      address: 'Kg 420 st, Kigali-Rwanda',
      phone: '+250789999999',
      email: 'someone@example.com',
      size: '1234 sqm',
      rooms: '4',
      lastActivity: '12/03/24',
      image: '',
    ),
  ];

  final List<NotificationModel> notifications = [
    NotificationModel(
      avatar: '',
      message: 'Jane Doe added a review.',
      time: '12:03 AM',
    ),
    NotificationModel(
      avatar: '',
      message: 'Your listing with ID-1211 has been approved',
      time: '12:03 AM',
    ),
    NotificationModel(
      avatar: '',
      message: 'Jane Doe added a review.',
      time: '12:03 AM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4ED),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: AppColors.inputBackground,
          elevation: 0,
          title: const Text(
            'Property management',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed:
                  () => setState(() => showNotifications = !showNotifications),
            ),
            IconButton(
              icon: const Icon(Icons.menu, color: AppColors.primaryPurple),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: AppColors.inputBorder, height: 1),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    // Search bar
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: const TextStyle(
                            color: AppColors.inputHint,
                          ),
                          filled: true,
                          fillColor: AppColors.inputBackground,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.inputHint,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.inputBorder,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.inputBorder,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Filter button
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.inputBorder),
                        backgroundColor: AppColors.inputBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(
                        Icons.filter_list,
                        color: AppColors.primaryPurple,
                      ),
                      label: const Text(
                        'Filter',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    final property = properties[index];
                    return Column(
                      children: [
                        PropertyCard(property: property),
                        if (index < properties.length - 1)
                          const Divider(
                            height: 32,
                            thickness: 1,
                            color: AppColors.inputBorder,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          // Notification popover overlay
          if (showNotifications) ...[
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => showNotifications = false),
                child: Container(color: AppColors.backgroundOverlay),
              ),
            ),
            Positioned(
              top: kToolbarHeight + 16,
              right: 16,
              child: NotificationPopover(
                notifications: notifications,
                onMarkAllRead: () {},
              ),
            ),
          ],
        ],
      ),
    );
  }
}
