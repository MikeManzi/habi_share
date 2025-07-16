// widgets/success_dialog.dart
import 'package:flutter/material.dart';
import 'package:habi_share/widgets/custom_button.dart';
import 'package:habi_share/screens/login.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final String userType;

  const SuccessDialog({
    super.key,
    this.title = "Your account has been created",
    this.message =
        "successfully. Shortly, a confirmation email will be sent to you.",
    this.buttonText = "Back to Log in",
    this.userType = "client",
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 20,
        ), // Reduced horizontal margin from 20 to 12
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),

              // Success Icon
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF8A2851),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 40),
              ),

              const SizedBox(height: 30),

              // Success Message
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: " "),
                    TextSpan(
                      text: "successfully.",
                      style: const TextStyle(
                        color: Color(0xFF8A2851),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(
                      text:
                          " Shortly, a confirmation email will be sent to you.",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Back to Login Button
              CustomButton(
                text: buttonText,
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();

                  // Navigate to login screen with user type
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                height: 50,
                fontSize: 16,
                borderRadius: 12,
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Static method to show the dialog
  static Future<void> show({
    required BuildContext context,
    String title = "Your account has been created",
    String message =
        "successfully. Shortly, a confirmation email will be sent to you.",
    String buttonText = "Back to Log in",
    String userType = "client",
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => SuccessDialog(
            title: title,
            message: message,
            buttonText: buttonText,
            userType: userType,
          ),
    );
  }
}
