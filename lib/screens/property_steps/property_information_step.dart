import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/property_provider.dart';
import '../../components/reusable_components.dart';

class PropertyInformationStep extends StatefulWidget {
  final VoidCallback onNext;

  const PropertyInformationStep({super.key, required this.onNext});

  @override
  State<PropertyInformationStep> createState() =>
      _PropertyInformationStepState();
}

class _PropertyInformationStepState extends State<PropertyInformationStep> {
  final _nameController = TextEditingController();
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
    _nameController.text = provider.property.name;
    _addressController.text = provider.property.address ?? '';
    _typeController.text = provider.property.type;
    _sizeController.text = provider.property.size.toString();
    _roomsController.text = provider.property.numberOfRooms.toString();
    _isPetFriendly = provider.property.tags.contains('Pet Friendly');
    _hasCarParking = provider.property.tags.contains('Car Parking');
    _hasGarden = provider.property.tags.contains('Garden');
    _isSharedHousing = provider.property.tags.contains('Shared Housing');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _typeController.dispose();
    _sizeController.dispose();
    _roomsController.dispose();
    super.dispose();
  }

  void _saveAndNext() {
    print('_saveAndNext called');
    print('Form validation result: $_isFormValid');
    print('Name: ${_nameController.text}');
    print('Address: ${_addressController.text}');
    print('Type: ${_typeController.text}');
    print('Size: ${_sizeController.text}');
    print('Rooms: ${_roomsController.text}');
    
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    provider.updateProperty(
      provider.property.copyWith(
        name: _nameController.text,
        address: _addressController.text,
        type: _typeController.text,
        size: _sizeController.text,
        numberOfRooms: int.tryParse(_roomsController.text) ?? 0,
        tags: [
          if (_isPetFriendly) 'Pet Friendly',
          if (_hasCarParking) 'Car Parking',
          if (_hasGarden) 'Garden',
          if (_isSharedHousing) 'Shared Housing',
        ],
      ),
    );
    print('Property updated, calling onNext');
    widget.onNext();
    print('onNext called');
  }

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
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
                      hintText: 'Property Name',
                      controller: _nameController,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

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
