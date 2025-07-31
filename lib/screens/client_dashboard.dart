import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/property_card.dart';
import '../widgets/filter_chip.dart';
import '../models/property.dart';
import '../providers/auth_provider.dart';
import '../providers/property_provider.dart';
import 'package:provider/provider.dart';

class ClientDashboardScreen extends StatefulWidget {
  const ClientDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ClientDashboardScreen> createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load properties when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertyProvider>().loadClientProperties();
    });

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user scrolls near the bottom
      context.read<PropertyProvider>().loadMoreClientProperties();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4ED),
      body: SafeArea(
        child: Consumer<PropertyProvider>(
          builder: (context, propertyProvider, child) {
            final filters = [
              {'label': 'All', 'selected': propertyProvider.currentFilter == 'All'},
              {'label': 'Apartments', 'selected': propertyProvider.currentFilter == 'Apartments'},
              {'label': 'For sale', 'selected': propertyProvider.currentFilter == 'For sale'},
              {'label': 'Shared', 'selected': propertyProvider.currentFilter == 'Shared'},
            ];

            return RefreshIndicator(
              onRefresh: () => propertyProvider.refreshClientProperties(),
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // AppBar with logo and menu
                      _buildAppBar(context),
                      const SizedBox(height: 24),
                      // Search bar
                      _buildSearchBar(propertyProvider),
                      const SizedBox(height: 20),
                      // Filter chips
                      _buildFilterChips(filters, propertyProvider),
                      const SizedBox(height: 20),
                      // Content
                      _buildContent(propertyProvider),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(PropertyProvider propertyProvider) {
    if (propertyProvider.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (propertyProvider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading properties',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                propertyProvider.error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => propertyProvider.loadClientProperties(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (propertyProvider.filteredProperties.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(
                Icons.home_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No properties found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search or filters',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Featured properties
        if (propertyProvider.featuredProperties.isNotEmpty) ...[
          _buildFeaturedProperties(propertyProvider.featuredProperties),
          const SizedBox(height: 28),
        ],
        
        // All properties
        _buildPropertiesSection('All Properties', propertyProvider.filteredProperties),
        
        // Loading more indicator
        if (propertyProvider.isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          ),
        
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.apartment,
              color: AppColors.primaryPurple,
              size: 32,
            ),
            const SizedBox(width: 8),
            Text(
              'HabiShare',
              style: TextStyle(
                color: AppColors.primaryPurple,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.menu,
            color: AppColors.primaryPurple,
            size: 28,
          ),
          onSelected: (value) {
            if (value == 'logout') {
              _showLogoutDialog(context);
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar(PropertyProvider propertyProvider) {
    return TextField(
      onChanged: (value) => propertyProvider.setSearchQuery(value),
      decoration: InputDecoration(
        hintText: 'Search properties...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildFilterChips(List<Map<String, dynamic>> filters, PropertyProvider propertyProvider) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: filters
            .map(
              (filter) => FilterChipWidget(
                label: filter['label'] as String,
                selected: filter['selected'] as bool,
                onTap: () {
                  propertyProvider.setFilter(filter['label'] as String);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildFeaturedProperties(List<Property> featuredProperties) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2.0, bottom: 8.0),
          child: Text(
            'Featured Properties',
            style: TextStyle(
              color: Color(0xFFB0B0B0),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // List layout for featured properties (one per row)
        Column(
          children: featuredProperties
              .take(2)
              .map(
                (property) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: PropertyCard(property: property),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPropertiesSection(String title, List<Property> properties) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2.0, bottom: 12.0),
          child: Text(
            title,
            style: TextStyle(
              color: Color(0xFFB0B0B0),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // List layout for properties (one per row)
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: properties.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: PropertyCard(property: properties[index]),
            );
          },
        ),
      ],
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
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
