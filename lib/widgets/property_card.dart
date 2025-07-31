import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habi_share/screens/property_details_screen.dart';
import 'package:habi_share/providers/property_provider.dart';
import '../models/property.dart';
import '../utils/app_colors.dart';
import '../utils/date_utils.dart';
import 'info_column.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final bool showDeleteOption;
  final VoidCallback? onDeleted;
  
  const PropertyCard({
    required this.property, 
    Key? key, 
    this.showDeleteOption = false,
    this.onDeleted,
  }) : super(key: key);

  void _handleMenuAction(BuildContext context, String value) {
    switch (value) {
      case 'view':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailsScreen(propertyId: property.id),
          ),
        );
        break;
      case 'delete':
        _showDeleteConfirmationDialog(context);
        break;
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Property'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Are you sure you want to delete this property?'),
              const SizedBox(height: 8),
              Text(
                '"${property.name}"',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This action cannot be undone.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => _deleteProperty(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProperty(BuildContext context) async {
    Navigator.of(context).pop(); // Close the dialog

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Deleting property...'),
            ],
          ),
        );
      },
    );

    try {
      final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
      final success = await propertyProvider.deleteProperty(property.id);

      // Close loading dialog
      Navigator.of(context).pop();

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Property "${property.name}" deleted successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // Call the onDeleted callback if provided
        onDeleted?.call();
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              propertyProvider.error ?? 'Failed to delete property',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting property: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => PropertyDetailsScreen(propertyId: property.id),
            ),
          );
        },
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
                    property.images.isNotEmpty
                        ? CircleAvatar(
                          backgroundImage: NetworkImage(property.images[0]),
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
                  property.address ?? 'No address provided',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_horiz,
                    color: AppColors.inputHint,
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(Icons.visibility, size: 16, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('View More'),
                        ],
                      ),
                    ),
                    if (showDeleteOption) ...[
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 16, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete Property', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ],
                  onSelected: (value) => _handleMenuAction(context, value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
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
                            value: property.size.toString(),
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
                            value: property.numberOfRooms.toString(),
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
                            value: DateTimeUtils.formatLastActivity(
                              property.createdAt,
                              property.updatedAt,
                            ),
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
      ),
    );
  }
}
