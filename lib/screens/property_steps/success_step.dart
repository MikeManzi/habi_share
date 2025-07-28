import 'package:flutter/material.dart';
import '../../components/reusable_components.dart';
import '../../utils/app_colors.dart';

class SuccessStep extends StatelessWidget {
  final VoidCallback onBackToHome;

  const SuccessStep({super.key, required this.onBackToHome});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF8A2851)),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24.0, 60.0, 24.0, 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 250,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 40,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                const Text(
                  'Your property has been uploaded successfully, your listing will be approved or re-assessed in 3-5 working days. Shortly, an email will be sent you with your listing ID and details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),

                CustomButton(
                  text: 'Back to dashboard',
                  onPressed: onBackToHome,
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFF8A2851),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
