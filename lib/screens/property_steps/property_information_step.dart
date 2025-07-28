import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/property_provider.dart';
import '../../components/reusable_components.dart';
import '../../utils/app_colors.dart';

class PropertyInformationStep extends StatefulWidget {
  final VoidCallback onNext;

  const PropertyInformationStep({super.key, required this.onNext});

  @override
  State<PropertyInformationStep> createState() =>
      _PropertyInformationStepState();
}

class _PropertyInformationStepState extends State<PropertyInformationStep> {
  final _addressController = TextEditingController();
  final _typeController = TextEditingController();
  final _sizeController = TextEditingController();
  final _roomsController = TextEditingController();

  bool _isPetFriendly = false;
  bool _hasCarParking = false;
  bool _hasGarden = false;
  bool _isSharedHousing = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    _addressController.text = provider.property.address ?? '';
    _typeController.text = provider.property.typeOfProperty ?? '';
    _sizeController.text = provider.property.size ?? '';
    _roomsController.text = provider.property.numberOfRooms ?? '';
    _isPetFriendly = provider.property.isPetFriendly;
    _hasCarParking = provider.property.hasCarParking;
    _hasGarden = provider.property.hasGarden;
    _isSharedHousing = provider.property.isSharedHousing;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _typeController.dispose();
    _sizeController.dispose();
    _roomsController.dispose();
    super.dispose();
  }

  void _saveAndNext() {
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    provider.updateProperty(
      provider.property.copyWith(
        address: _addressController.text,
        typeOfProperty: _typeController.text,
        size: _sizeController.text,
        numberOfRooms: _roomsController.text,
        isPetFriendly: _isPetFriendly,
        hasCarParking: _hasCarParking,
        hasGarden: _hasGarden,
        isSharedHousing: _isSharedHousing,
      ),
    );
    widget.onNext();
  }

  bool get _isFormValid {
    return _addressController.text.isNotEmpty &&
        _typeController.text.isNotEmpty &&
        _sizeController.text.isNotEmpty &&
        _roomsController.text.isNotEmpty;
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
              'Property Information',
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
                      hintText: 'Address',
                      controller: _addressController,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      hintText: 'Type of property',
                      controller: _typeController,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      hintText: 'Size',
                      suffixText: 'Sqm',
                      controller: _sizeController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      hintText: 'Number of rooms',
                      controller: _roomsController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 24),

                    // Checkboxes
                    Row(
                      children: [
                        Expanded(
                          child: CustomCheckbox(
                            label: 'Pet-friendly',
                            value: _isPetFriendly,
                            onChanged: (value) {
                              setState(() {
                                _isPetFriendly = value ?? false;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomCheckbox(
                            label: '<2-car parking',
                            value: _hasCarParking,
                            onChanged: (value) {
                              setState(() {
                                _hasCarParking = value ?? false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: CustomCheckbox(
                            label: 'Garden',
                            value: _hasGarden,
                            onChanged: (value) {
                              setState(() {
                                _hasGarden = value ?? false;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomCheckbox(
                            label: 'Shared housing',
                            value: _isSharedHousing,
                            onChanged: (value) {
                              setState(() {
                                _isSharedHousing = value ?? false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            CustomButton(
              text: 'Next',
              onPressed: _isFormValid ? _saveAndNext : null,
              isEnabled: _isFormValid,
              backgroundColor: Colors.white,
              textColor: const Color(0xFF8A2851),
            ),
          ],
        ),
      ),
    );
  }
}
