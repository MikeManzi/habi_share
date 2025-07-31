import 'package:flutter/material.dart';
import 'package:habi_share/screens/menu.dart';
import '../utils/app_colors.dart';
import '../models/property.dart';
import '../models/notification.dart';
import '../widgets/property_card.dart';
import '../widgets/notification_popover.dart';
import 'property_upload_flow.dart';
import 'package:habi_share/providers/property_provider.dart';
import 'package:provider/provider.dart';

class LandlordDashboard extends StatefulWidget {
  const LandlordDashboard({super.key});

  @override
  State<LandlordDashboard> createState() => _LandlordDashboardState();
}

class _LandlordDashboardState extends State<LandlordDashboard> {
  bool showNotifications = false;
  List<Property> userProperties = [];
  bool isLoadingProperties = true;
  String? errorMessage;

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
  void initState() {
    super.initState();
    // Load properties after the widget is built to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProperties();
    });
  }

  Future<void> _loadUserProperties() async {
    try {
      setState(() {
        isLoadingProperties = true;
        errorMessage = null;
      });

      final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
      final properties = await propertyProvider.getUserProperties();
      
      setState(() {
        userProperties = properties;
        isLoadingProperties = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load properties: ${e.toString()}';
        isLoadingProperties = false;
      });
    }
  }

  Future<void> _refreshProperties() async {
    await _loadUserProperties();
  }

  Widget _buildPropertiesContent() {
    if (isLoadingProperties) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshProperties,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (userProperties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.home_outlined,
              size: 64,
              color: AppColors.inputHint,
            ),
            const SizedBox(height: 16),
            const Text(
              "You don't have any properties on HabiShare",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Add your first property to start managing your rentals",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.inputHint,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PropertyUploadFlow(),
                  ),
                );
                if (result == true) {
                  _refreshProperties();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Property'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      itemCount: userProperties.length,
      itemBuilder: (context, index) {
        final property = userProperties[index];
        return Column(
          children: [
            PropertyCard(property: property),
            if (index < userProperties.length - 1)
              const Divider(
                height: 32,
                thickness: 1,
                color: AppColors.inputBorder,
              ),
          ],
        );
      },
    );
  }

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
              onPressed: (){
                //open the menupage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MenuPage()),
                );
              },
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
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PropertyUploadFlow(),
                          ),
                        );
                        // Refresh properties when returning from upload
                        if (result == true) {
                          _refreshProperties();
                        }
                      },
                      label: const Text(
                        'Add property',
                        style: TextStyle(color: AppColors.primaryPurple),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshProperties,
                  child: _buildPropertiesContent(),
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
