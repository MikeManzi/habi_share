
/* This is just a temporary file to base on calling the details page,
it will have to be replaced when the actual page is done*/
import 'package:flutter/material.dart';
import '../utils/property_data.dart';
import 'property_details_screen.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({Key? key}) : super(key: key);

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Properties'),
        backgroundColor: const Color(0xFF8B4F7A),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: PropertyData.properties.length,
        itemBuilder: (context, index) {
          final property = PropertyData.properties[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(property.images.first),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(property.title),
              subtitle: Text(property.location),
              trailing: Icon(
                property.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: property.isFavorite ? Colors.red : Colors.grey,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            PropertyDetailsScreen(propertyId: property.id),
                  ),
                ).then((_) => setState(() {})); // Refresh list when returning
              },
            ),
          );
        },
      ),
    );
  }
}
