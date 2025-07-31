import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habi_share/providers/property_provider.dart';
import '../models/property.dart';
import '../widgets/image_slider.dart';
import '../widgets/property_info_card.dart';
import '../widgets/property_details_card.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final String propertyId;

  const PropertyDetailsScreen({Key? key, required this.propertyId})
    : super(key: key);

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  Property? property;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProperty();
  }

  void _loadProperty() async {
    try {
      final propertyProvider = Provider.of<PropertyProvider>(
        context,
        listen: false,
      );

      // First, try to find the property in the already loaded properties
      Property? foundProperty = propertyProvider.findLoadedPropertyById(
        widget.propertyId,
      );

      // If not found in loaded properties, try to fetch from Firebase
      if (foundProperty == null) {
        print(
          'Property not found in loaded properties, fetching from Firebase...',
        );
        foundProperty = await propertyProvider.getPropertyById(
          widget.propertyId,
        );
      }

      if (mounted) {
        setState(() {
          property = foundProperty;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading property: $e');
      if (mounted) {
        setState(() {
          property = null;
          isLoading = false;
        });
      }
    }
  }

  void _toggleFavorite() {
    if (property != null) {
      final propertyProvider = Provider.of<PropertyProvider>(
        context,
        listen: false,
      );
      propertyProvider.toggleFavorite(property!.id);
      _loadProperty(); // Refresh the property data
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (property == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Property Not Found')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Property not found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'This property may not exist or you may not have permission to view it.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4ED),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageSlider(
              images: property!.images,
              isFavorite: property!.isFavorite,
              onFavoriteToggle: _toggleFavorite,
            ),
            PropertyInfoCard(property: property!),
            PropertyDetailsCard(property: property!),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
