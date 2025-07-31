import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/property_provider.dart';
import '../../components/reusable_components.dart';
import '../../widgets/custom_button.dart' as widgets;

class RentalPriceStep extends StatefulWidget {
  final VoidCallback onNext;

  const RentalPriceStep({super.key, required this.onNext});

  @override
  State<RentalPriceStep> createState() => _RentalPriceStepState();
}

class _RentalPriceStepState extends State<RentalPriceStep> {
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedSpan = 'Monthly';

  final List<String> _spanOptions = ['Monthly', 'Yearly'];
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    _priceController.text = provider.property.price.toString();
    _descriptionController.text = provider.property.priceDescription ?? '';

    // Ensure the selected span is always valid
    String providerSpan = provider.property.priceSpan ?? 'Monthly';
    _selectedSpan =
        _spanOptions.contains(providerSpan) ? providerSpan : 'Monthly';
  }

  @override
  void dispose() {
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveAndUpload() async {
    print('Starting property upload...');
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    
    // Update property with final pricing info
    provider.updateProperty(
      provider.property.copyWith(
        price: double.tryParse(_priceController.text),
        priceSpan: _selectedSpan,
        priceDescription: _descriptionController.text,
      ),
    );
    
    print('Property data updated, submitting to Firebase...');
    print('Property details: ${provider.property.name}, ${provider.property.address}');

    try {
      // Submit the property to Firebase
      final success = await provider.submitProperty();
      
      print('Upload result: $success');
      
      if (success) {
        print('Upload successful, navigating to success screen');
        widget.onNext(); // Navigate to success screen
      } else {
        print('Upload failed with error: ${provider.error}');
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.error ?? 'Failed to upload property'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      print('Exception during upload: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading property: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  bool get _isFormValid {
    return _priceController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PropertyProvider>(
      builder: (context, provider, child) {
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
                  'Rental price proposals',
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
                        CustomTextField(
                          hintText: 'Rental Prices',
                          suffixText: 'RWF',
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 16),

                        CustomDropdown(
                          hintText: 'Span (Monthly, Yearly)',
                          value: _selectedSpan,
                          items:
                              _spanOptions.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSpan = value ?? 'Monthly';
                            });
                          },
                        ),
                        const SizedBox(height: 24),

                        CustomTextField(
                          hintText: 'Detailed price description and justification',
                          controller: _descriptionController,
                          maxLines: 6,
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                widgets.CustomButton(
                  text: provider.isLoading ? 'Uploading...' : 'Upload',
                  onPressed: (_isFormValid && !provider.isLoading) ? _saveAndUpload : () {},
                  isLoading: provider.isLoading,
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFF8A2851),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
