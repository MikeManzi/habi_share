import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/property_provider.dart';
import '../../components/reusable_components.dart';
import '../../utils/app_colors.dart';

class PropertyOwnershipStep extends StatefulWidget {
  final VoidCallback onNext;

  const PropertyOwnershipStep({super.key, required this.onNext});

  @override
  State<PropertyOwnershipStep> createState() => _PropertyOwnershipStepState();
}

class _PropertyOwnershipStepState extends State<PropertyOwnershipStep> {
  final _tinController = TextEditingController();
  final _businessCodeController = TextEditingController();
  List<String> _selectedDocuments = [];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    _tinController.text = provider.property.tinNumber ?? '';
    _businessCodeController.text = provider.property.businessCode ?? '';
  }

  @override
  void dispose() {
    _tinController.dispose();
    _businessCodeController.dispose();
    super.dispose();
  }

  void _saveAndNext() {
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    provider.updateProperty(
      provider.property.copyWith(
        tinNumber: _tinController.text,
        businessCode: _businessCodeController.text,
      ),
    );
    widget.onNext();
  }

  void _pickDocuments() async {
    final provider = Provider.of<PropertyProvider>(context, listen: false);

    // Show a more realistic document picker dialog
    final result = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Documents'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select required documents:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Property Ownership Documents:',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                _documentOption('Property Title Deed', 'title_deed.pdf'),
                _documentOption(
                  'Property Registration Certificate',
                  'registration_cert.pdf',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tax Documents:',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                _documentOption('Property Tax Receipt', 'tax_receipt.pdf'),
                _documentOption('Land Tax Certificate', 'land_tax_cert.pdf'),
                const SizedBox(height: 12),
                const Text(
                  'Other Documents:',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                _documentOption('Survey Plan', 'survey_plan.pdf'),
                _documentOption('Proof of Address', 'proof_of_address.pdf'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, _selectedDocuments),
              child: const Text('Select'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      for (var fileName in result) {
        provider.addDocument(fileName);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added ${result.length} document(s)')),
        );
      }
    }
  }

  Widget _documentOption(String title, String filename) {
    return CheckboxListTile(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: Text(
        filename,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      value: _selectedDocuments.contains(filename),
      onChanged: (bool? value) {
        if (value == true) {
          _selectedDocuments.add(filename);
        } else {
          _selectedDocuments.remove(filename);
        }
      },
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }

  bool get _isFormValid {
    return _tinController.text.isNotEmpty;
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
              'Property ownership documentation.',
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
                      text: 'Upload files',
                      subtitle: '(JPEG,PDF)',
                      onPressed: _pickDocuments,
                      icon: Icons.upload_file,
                    ),
                    const SizedBox(height: 24),

                    Consumer<PropertyProvider>(
                      builder: (context, provider, child) {
                        if (provider.property.documents.isNotEmpty) {
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
                                  'Uploaded Documents:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...provider.property.documents.map(
                                  (document) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.description,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            document,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed:
                                              () => provider.removeDocument(
                                                document,
                                              ),
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 24),

                    CustomTextField(
                      hintText: 'TIN Number',
                      controller: _tinController,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      hintText: 'Business code (If applicable)',
                      controller: _businessCodeController,
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
