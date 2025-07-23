import 'package:flutter/material.dart';
import '../models/property.dart';
import 'property_card.dart';

class PropertyGrid extends StatelessWidget {
  final List<Property> properties;
  const PropertyGrid({Key? key, required this.properties}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.1,
      children:
          properties
              .map((property) => PropertyCard(property: property))
              .toList(),
    );
  }
}
