import 'package:flutter/material.dart';
import '../models/property.dart';
import '../utils/app_colors.dart';
import 'info_column.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  const PropertyCard({required this.property, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        color: AppColors.inputBackground,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 0,
              ),
              leading:
                  property.image.isNotEmpty
                      ? CircleAvatar(
                        backgroundImage: NetworkImage(property.image),
                        radius: 24,
                      )
                      : CircleAvatar(
                        backgroundColor: AppColors.inputBorder,
                        radius: 24,
                        child: const Icon(
                          Icons.home,
                          color: AppColors.primaryPurple,
                        ),
                      ),
              title: Text(
                property.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                property.address,
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
                onSelected: (value) {},
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
                        property.phone,
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
                        property.email,
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
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.inputBorder,
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
              child: Container(
                color: const Color(0xFFD9D9D9),
                height: 52,
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: InfoColumn(
                          label: 'Size',
                          value: property.size,
                          bold: true,
                          large: true,
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: double.infinity,
                      color: AppColors.inputBorder,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: InfoColumn(
                          label: 'Number of rooms',
                          value: property.rooms,
                          bold: false,
                          large: true,
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: double.infinity,
                      color: AppColors.inputBorder,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: InfoColumn(
                          label: 'Last activity',
                          value: property.lastActivity,
                          bold: true,
                          large: false,
                        ),
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
