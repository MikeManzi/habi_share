import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/step_indicator.dart';
import 'property_steps/property_information_step.dart';
import 'property_steps/property_description_step.dart';
import 'property_steps/property_ownership_step.dart';
import 'property_steps/rental_price_step.dart';
import 'property_steps/success_step.dart';

class PropertyUploadFlow extends StatefulWidget {
  const PropertyUploadFlow({super.key});

  @override
  State<PropertyUploadFlow> createState() => _PropertyUploadFlowState();
}

class _PropertyUploadFlowState extends State<PropertyUploadFlow> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToStep(int step) {
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToNextStep() {
    print('_goToNextStep called');
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    print('Current step: ${provider.currentStep}');
    if (provider.currentStep < 4) {
      provider.nextStep();
      print('Moving to step: ${provider.currentStep}');
      _navigateToStep(provider.currentStep);
      print('Navigation completed');
    } else {
      print('Already at last step');
    }
  }

  void _goToPreviousStep() {
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    if (provider.currentStep > 0) {
      provider.previousStep();
      _navigateToStep(provider.currentStep);
    } else {
      Navigator.pop(context);
    }
  }

  void _goToHome() {
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    provider.reset();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PropertyProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: CustomAppBar(
            title: 'Upload new listing/property',
            onClosePressed: _goToHome,
            onBackPressed: provider.currentStep == 4 ? null : _goToPreviousStep,
            showBackButton: provider.currentStep != 4,
          ),
          body: Column(
            children: [
              if (provider.currentStep < 4) ...[
                const SizedBox(height: 30),
                StepIndicator(currentStep: provider.currentStep, totalSteps: 4),
                const SizedBox(height: 40),
              ],
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    PropertyInformationStep(onNext: _goToNextStep),
                    PropertyDescriptionStep(onNext: _goToNextStep),
                    PropertyOwnershipStep(onNext: _goToNextStep),
                    RentalPriceStep(onNext: _goToNextStep),
                    SuccessStep(onBackToHome: _goToHome),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
