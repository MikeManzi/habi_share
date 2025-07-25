import 'package:flutter/material.dart';
import 'package:habi_share/screens/login.dart';
import 'package:habi_share/screens/signup/personal_information.dart';
import 'package:habi_share/widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/round_about.jpg',
            ), // Add your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(
              0.6,
            ), // Dark overlay for better text visibility
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Logo and App Name
                  _buildLogoSection(),

                  const SizedBox(height: 40),

                  // Welcome Text
                  const Text(
                    'Welcome to HabiShare',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Client Section
                  _buildClientSection(context),

                  const SizedBox(height: 40),

                  // Property Owner Section
                  _buildPropertyOwnerSection(context),

                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // Logo placeholder - replace with your actual logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.home_work_outlined,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        // App Name
        const Text(
          'HabiShare',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildClientSection(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Join as a Client',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        // Client Register Button
        CustomButton(
          text: 'Register',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PersonalInformation(),
              ),
            );
          },
          height: 54,
          fontSize: 17,
        ),

        const SizedBox(height: 12),

        // Client Login Link
        _buildLoginLink(context, 'Already have an account? ', 'Login', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        }),
      ],
    );
  }

  Widget _buildPropertyOwnerSection(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Join as a Property Owner',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        // Property Owner Register Button
        CustomButton(
          text: 'Register',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PersonalInformation(),
              ),
            );
          },
          height: 54,
          fontSize: 17,
        ),

        const SizedBox(height: 12),

        // Property Owner Login Link
        _buildLoginLink(context, 'Already have an account? ', 'Login', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        }),
      ],
    );
  }

  Widget _buildLoginLink(
    BuildContext context,
    String prefix,
    String linkText,
    VoidCallback onTap,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(prefix, style: const TextStyle(color: Colors.white, fontSize: 16)),
        GestureDetector(
          onTap: onTap,
          child: Text(
            linkText,
            style: const TextStyle(
              color: Color(0xFF8A2851),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
