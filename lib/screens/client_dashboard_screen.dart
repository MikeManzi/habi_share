import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/property_card.dart';
import '../widgets/property_grid.dart';
import '../widgets/filter_chip.dart';
import '../widgets/search_bar.dart' as custom_widgets;
import '../models/property.dart';

class ClientDashboardScreen extends StatelessWidget {
  const ClientDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample property data
    final featuredProperties = [
      Property(
        imagePath: 'assets/apartment.png',
        price: '320,000 Rwf',
        address: 'KK 62 st, Kabeza',
        isLarge: true,
      ),
      Property(
        imagePath: 'assets/apartment.png',
        price: '230,000 Rwf',
        address: 'KK 62 st, Kabeza',
        isLarge: true,
      ),
    ];
    final sharedHousing = List.generate(
      4,
      (_) => Property(
        imagePath: 'assets/apartment.png',
        price: '320,000 Rwf',
        address: 'KK 62 st, Kabeza',
      ),
    );
    final forSale = List.generate(
      4,
      (_) => Property(
        imagePath: 'assets/apartment.png',
        price: '320,000 Rwf',
        address: 'KK 62 st, Kabeza',
      ),
    );
    final filters = [
      {'label': 'Apartments', 'selected': true},
      {'label': 'For sale', 'selected': false},
      {'label': 'Shared', 'selected': false},
      {'label': 'All', 'selected': false},
    ];

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
                    Icon(Icons.menu, color: AppColors.primaryPurple, size: 28),
                  ],
                ),
                const SizedBox(height: 24),
                // Search bar
                const custom_widgets.SearchBar(),
                const SizedBox(height: 20),
                // Filter chips
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        filters
                            .map(
                              (filter) => FilterChipWidget(
                                label: filter['label'] as String,
                                selected: filter['selected'] as bool,
                                onTap: () {},
                              ),
                            )
                            .toList(),
                  ),
                ),
                const SizedBox(height: 20),
                // Featured properties row
                Row(
                  children:
                      featuredProperties
                          .map(
                            (property) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: PropertyCard(property: property),
                              ),
                            ),
                          )
                          .toList(),
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
                PropertyGrid(properties: sharedHousing),
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
                PropertyGrid(properties: forSale),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
