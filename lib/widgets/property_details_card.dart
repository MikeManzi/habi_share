import 'package:flutter/material.dart';
import 'package:habi_share/utils/app_colors.dart';
import '../models/property.dart';

class PropertyDetailsCard extends StatelessWidget {
  final Property property;

  const PropertyDetailsCard({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Number of rooms', '${property.normalRooms} normal rooms and ${property.masterBedrooms} master bedroom'),
            const SizedBox(height: 16),
            _buildDetailRow('Size', '${property.size.toStringAsFixed(0)} sqm'),
            const SizedBox(height: 16),
            _buildDetailRow('Type', property.type),
            const SizedBox(height: 16),
            _buildDetailRow('Size', '${property.size.toStringAsFixed(0)} sqm'),
            const SizedBox(height: 16),

            if (property.tags.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: property.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryMagenta,
                      borderRadius: BorderRadius.circular(10),
    
                    ),
                    child: Text(
                      tag.replaceAll('-', ' '),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryPurple,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

