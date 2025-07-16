import 'package:flutter/material.dart';

class RegistrationSuccess extends StatelessWidget {
  const RegistrationSuccess({super.key});

  void _navigateToLogin(BuildContext context) {
    // Navigate back to login page (clear all previous screens)
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Logo and title
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.apps,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'HabiShare',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Success modal
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(30),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Success icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: Color(0xFF8A2851),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Success message
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(text: 'Your account has been created '),
                              TextSpan(
                                text: 'successfully',
                                style: TextStyle(
                                  color: Color(0xFF8A2851),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '. Shortly, a confirmation email will be sent to you.',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Back to login button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _navigateToLogin(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8A2851),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Back to Log in',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),

            // Bottom section with terms
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Terms checkbox (disabled/checked)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8A2851),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Accept Our Terms and conditions',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Already have account text
                  const Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
