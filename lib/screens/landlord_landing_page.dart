import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// LandlordLandingPage displays the property management dashboard for landlords.
/// This widget is modular and ready for integration into a role-based navigation system.
class LandlordLandingPage extends StatefulWidget {
  const LandlordLandingPage({Key? key}) : super(key: key);

  @override
  State<LandlordLandingPage> createState() => _LandlordLandingPageState();
}

class _LandlordLandingPageState extends State<LandlordLandingPage> {
  bool showNotifications = false;

  // Dummy data for properties and notifications
  final List<Map<String, String>> properties = [
    {
      'name': 'Green Apartments',
      'address': 'Kg 99 st, Kigali-Rwanda',
      'phone': '+250789999999',
      'email': 'someone@example.com',
      'size': '1234 sqm',
      'rooms': '4',
      'lastActivity': '12/03/24',
      'image': '', // Placeholder for image asset or network
    },
    {
      'name': 'Oasis Apartments',
      'address': 'Kg 420 st, Kigali-Rwanda',
      'phone': '+250789999999',
      'email': 'someone@example.com',
      'size': '1234 sqm',
      'rooms': '4',
      'lastActivity': '12/03/24',
      'image': '',
    },
  ];

  final List<Map<String, String>> notifications = [
    {
      'avatar': '', // Placeholder for avatar
      'message': 'Jane Doe added a review.',
      'time': '12:03 AM',
    },
    {
      'avatar': '',
      'message': 'Your listing with ID-1211 has been approved',
      'time': '12:03 AM',
    },
    {'avatar': '', 'message': 'Jane Doe added a review.', 'time': '12:03 AM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Property management',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          // Notification bell
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.textPrimary,
            ),
            onPressed:
                () => setState(() => showNotifications = !showNotifications),
          ),
          // Menu icon
          IconButton(
            icon: const Icon(Icons.menu, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
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
                    OutlinedButton(
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
                      child: const Text('Filter'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    final property = properties[index];
                    return _PropertyCard(property: property);
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
                child: Container(
                  color:
                      AppColors.backgroundOverlay, // semi-transparent overlay
                ),
              ),
            ),
            Positioned(
              top: kToolbarHeight + 16,
              right: 16,
              child: _NotificationPopover(
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

/// Widget for a single property card as per the design.
class _PropertyCard extends StatelessWidget {
  final Map<String, String> property;
  const _PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.inputBackground,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.inputBorder,
              radius: 24,
              // TODO: Replace with property image if available
              child: const Icon(Icons.home, color: AppColors.primaryPurple),
            ),
            title: Text(
              property['name'] ?? '',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              property['address'] ?? '',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz, color: AppColors.inputHint),
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: 'view',
                      child: Text('View More'),
                    ),
                  ],
              onSelected: (value) {
                // Handle actions here
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      size: 16,
                      color: AppColors.inputHint,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      property['phone'] ?? '',
                      style: const TextStyle(
                        color: AppColors.inputText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.email,
                      size: 16,
                      color: AppColors.inputHint,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      property['email'] ?? '',
                      style: const TextStyle(
                        color: AppColors.inputText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 20, thickness: 1, color: AppColors.inputBorder),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoColumn(label: 'Size', value: property['size'] ?? ''),
                _InfoColumn(
                  label: 'Number of rooms',
                  value: property['rooms'] ?? '',
                ),
                _InfoColumn(
                  label: 'Last activity',
                  value: property['lastActivity'] ?? '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper widget for info columns in the property card.
class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  const _InfoColumn({required this.label, required this.value});

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
          style: const TextStyle(
            color: AppColors.inputText,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

/// Notification popover widget as per the design.
class _NotificationPopover extends StatelessWidget {
  final List<Map<String, String>> notifications;
  final VoidCallback onMarkAllRead;
  const _NotificationPopover({
    required this.notifications,
    required this.onMarkAllRead,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your notifications',
                  style: TextStyle(
                    color: AppColors.inputText,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: onMarkAllRead,
                  child: const Text(
                    'Mark all as read',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...notifications.map(
              (notif) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryPurple,
                      radius: 18,
                      // TODO: Replace with avatar image if available
                      child: const Icon(
                        Icons.person,
                        color: AppColors.buttonText,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notif['message'] ?? '',
                            style: const TextStyle(
                              color: AppColors.inputText,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            notif['time'] ?? '',
                            style: const TextStyle(
                              color: AppColors.inputHint,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
