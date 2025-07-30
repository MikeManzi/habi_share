import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/property_provider.dart';
import '../../components/reusable_components.dart';
import '../../utils/app_colors.dart';

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
    _priceController.text = provider.property.price?.toString() ?? '';
    _descriptionController.text = provider.property.priceDescription ?? '';
    _selectedSpan = provider.property.priceSpan ?? 'Monthly';
  }

  @override
  void dispose() {
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveAndUpload() {
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    provider.updateProperty(
      provider.property.copyWith(
        price: double.tryParse(_priceController.text),
        priceSpan: _selectedSpan,
        priceDescription: _descriptionController.text,
      ),
    );
    widget.onNext();
  }

  bool get _isFormValid {
    return _priceController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty;
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
            CustomButton(
              text: 'Upload',
              onPressed: _isFormValid ? _saveAndUpload : null,
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
