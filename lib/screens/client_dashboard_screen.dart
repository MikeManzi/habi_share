import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ClientDashboardScreen extends StatelessWidget {
  const ClientDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4ED),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // AppBar with logo and menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Logo icon (SVG or PNG, matching design color)
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
                    // Menu icon
                    Icon(Icons.menu, color: AppColors.primaryPurple, size: 28),
                  ],
                ),
                const SizedBox(height: 24),
                // Search bar
                Row(
                  children: [
                    // Search input
                    Expanded(
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Color(0xFFE0E0E0)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: Color(0xFF999999),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: 16,
                                  ),
                                  isCollapsed: true,
                                ),
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.tune, color: AppColors.primaryPurple, size: 28),
                  ],
                ),
                const SizedBox(height: 20),
                // Filter chips
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilterChip('Apartments', true),
                      _buildFilterChip('For sale', false),
                      _buildFilterChip('For sale', false),
                      _buildFilterChip('For sale', false),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Featured properties row
                Row(
                  children: [
                    Expanded(
                      child: _buildPropertyCard(
                        context,
                        'assets/apartment.png',
                        '320,000 Rwf',
                        'KK 62 st, Kabeza',
                        true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPropertyCard(
                        context,
                        'assets/apartment.png',
                        '230,000 Rwf',
                        'KK 62 st, Kabeza',
                        true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                // Shared housing section
                Padding(
                  padding: const EdgeInsets.only(left: 2.0, bottom: 8.0),
                  child: Text(
                    'Shared housing',
                    style: TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildPropertyGrid(context),
                const SizedBox(height: 28),
                // For sale section
                Padding(
                  padding: const EdgeInsets.only(left: 2.0, bottom: 8.0),
                  child: Text(
                    'For sale',
                    style: TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildPropertyGrid(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Filter chip builder
  Widget _buildFilterChip(String label, bool selected) {
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
        onSelected: (_) {},
        elevation: 0,
        pressElevation: 0,
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      ),
    );
  }

  // Property card builder
  Widget _buildPropertyCard(
    BuildContext context,
    String imagePath,
    String price,
    String address,
    bool isLarge,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: isLarge ? 100 : 68,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              12,
              isLarge ? 8 : 6,
              12,
              isLarge ? 8 : 6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w700,
                    fontSize: isLarge ? 18 : 15,
                  ),
                ),
                Text(
                  '/month',
                  style: TextStyle(
                    color: Color(0xFFB0B0B0),
                    fontSize: isLarge ? 13 : 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  address,
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: isLarge ? 13 : 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Property grid builder (2x2)
  Widget _buildPropertyGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        _buildPropertyCard(
          context,
          'assets/apartment.png',
          '320,000 Rwf',
          'KK 62 st, Kabeza',
          false,
        ),
        _buildPropertyCard(
          context,
          'assets/apartment.png',
          '320,000 Rwf',
          'KK 62 st, Kabeza',
          false,
        ),
        _buildPropertyCard(
          context,
          'assets/apartment.png',
          '320,000 Rwf',
          'KK 62 st, Kabeza',
          false,
        ),
        _buildPropertyCard(
          context,
          'assets/apartment.png',
          '320,000 Rwf',
          'KK 62 st, Kabeza',
          false,
        ),
      ],
    );
  }
}
