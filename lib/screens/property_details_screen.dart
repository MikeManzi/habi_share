import 'package:flutter/material.dart';
import 'package:habi_share/providers/property_provider.dart';
import '../models/property.dart';
import '../utils/property_data.dart';
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

  @override
  void initState() {
    super.initState();
    _loadProperty();
  }

void _loadProperty() async {
  Property? propertyById = await PropertyProvider().getPropertyById(
    widget.propertyId,
  );
  if (propertyById != null) {
    setState(() {
      property = propertyById;
    });
  } else {
    setState(() {
      property = null; // Ensure it stays null if not found
    });
  }
}

  void _toggleFavorite() {
    if (property != null) {
      PropertyProvider().updateProperty(property!.copyWith(isFavorite: !property!.isFavorite));
      _loadProperty(); // Refresh the property data
    }
  }

  @override
  Widget build(BuildContext context) {
    if (property == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Property Not Found')),
        body: const Center(
          child: Text('Property not found', style: TextStyle(fontSize: 18)),
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
