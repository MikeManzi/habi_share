import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/property_provider.dart';
import '../../components/reusable_components.dart';
import '../../utils/image_utils.dart';

class PropertyDescriptionStep extends StatefulWidget {
  final VoidCallback onNext;

  const PropertyDescriptionStep({super.key, required this.onNext});

  @override
  State<PropertyDescriptionStep> createState() =>
      _PropertyDescriptionStepState();
}

class _PropertyDescriptionStepState extends State<PropertyDescriptionStep> {
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    _descriptionController.text = provider.property.description;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveAndNext() {
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    provider.updateProperty(
      provider.property.copyWith(description: _descriptionController.text),
    );
    widget.onNext();
  }

  void _pickImages() async {
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    final ImagePicker picker = ImagePicker();

    try {
      // Show options to pick from gallery or camera
      final result = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () => Navigator.pop(context, 'gallery'),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () => Navigator.pop(context, 'camera'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );

      if (result != null) {
        XFile? image;

        switch (result) {
          case 'gallery':
            image = await picker.pickImage(source: ImageSource.gallery);
            break;
          case 'camera':
            image = await picker.pickImage(source: ImageSource.camera);
            break;
        }

        if (image != null) {
          // Store the full path instead of just the name
          provider.addImage(image.path);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image added successfully')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Color(0xFF8A2851),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Property description and pictures',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    UploadButton(
                      text: 'Upload pictures',
                      subtitle: '(JPEG,PDF)',
                      onPressed: _pickImages,
                      icon: Icons.camera_alt,
                    ),
                    const SizedBox(height: 24),

                    Consumer<PropertyProvider>(
                      builder: (context, provider, child) {
                        if (provider.property.images.isNotEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Uploaded Images:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...provider.property.images.map((imagePath) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        // Image preview
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: ImageUtils.buildImageWidget(
                                            imagePath: imagePath,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // File name
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Image ${provider.property.images.indexOf(imagePath) + 1}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                imagePath.split('/').last,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Delete button
                                        IconButton(
                                          onPressed: () => provider.removeImage(imagePath),
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 24),

                    CustomTextField(
                      hintText:
                          'Detailed description (Previous rental prices and occupancy history if applicable.)',
                      controller: _descriptionController,
                      maxLines: 6,
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            CustomButton(
              text: 'Next',
              onPressed: _saveAndNext,
              backgroundColor: Colors.white,
              textColor: const Color(0xFF8A2851),
            ),
          ],
        ),
      ),
    );
  }
}
