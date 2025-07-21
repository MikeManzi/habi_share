import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habi_share/screens/property_details_screen.dart';
import 'package:habi_share/providers/property_provider.dart';
import '../models/property.dart';
import '../utils/app_colors.dart';
import '../utils/date_utils.dart';
import '../utils/image_utils.dart';
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
    // Close the confirmation dialog first
    Navigator.of(context).pop();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Expanded(child: Text('Deleting property...')),
              ],
            ),
          ),
        );
      },
    );

    try {
      final propertyProvider = Provider.of<PropertyProvider>(context, listen: false);
      final success = await propertyProvider.deleteProperty(property.id);

      // Always close the loading dialog first
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      if (success) {
        // Show success dialog with navigation option
        _showSuccessDialog(context);
      } else {
        // Show error message
        _showErrorMessage(
          context,
          propertyProvider.error ?? 'Failed to delete property',
        );
      }
    } catch (e) {
      // Always close the loading dialog first
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      // Show error message
      _showErrorMessage(context, 'Error deleting property: ${e.toString()}');
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 48,
          ),
          title: const Text('Property Deleted'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Property "${property.name}" has been deleted successfully.'),
              const SizedBox(height: 16),
              const Text(
                'The property has been removed from your listings.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close success dialog
                // Call the onDeleted callback to refresh the list
                onDeleted?.call();
              },
              child: const Text('Stay Here'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close success dialog
                // Navigate back to dashboard (pop until we reach the dashboard)
                Navigator.of(context).popUntil((route) => route.isFirst);
                // Call the onDeleted callback to refresh the list
                onDeleted?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Back to Dashboard'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(
            Icons.error,
            color: Colors.red,
            size: 48,
          ),
          title: const Text('Delete Failed'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
                          backgroundImage: ImageUtils.getImageProvider(property.images[0]),
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
