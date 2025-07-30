import 'package:flutter/material.dart';
import 'package:habi_share/widgets/text_field.dart';
import '../widgets/custom_button.dart';
import 'package:habi_share/screens/landlord_dashboard.dart';
import 'package:habi_share/screens/client_dashboard.dart';
import 'package:habi_share/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _telephoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        // Try to login with phone number (will find email associated with phone)
        final success = await authProvider.signInWithPhone(
          phone: _telephoneController.text.trim(),
          password: _passwordController.text,
        );

        if (mounted) {
          if (success) {
            final user = authProvider.user;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Welcome back ${user?.firstName}!'),
                backgroundColor: Colors.green,
              ),
            );

            // Navigate based on user role
            if (user?.isOwner == true) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LandlordDashboard(),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClientDashboardScreen(),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authProvider.error ?? 'Login failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _handleRegister() {
    // Navigate back to home page to choose role
    Navigator.pop(context);
  }

  String? _validateTelephone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your telephone number';
    }

    // Remove any spaces, dashes, or parentheses
    String cleanedValue = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Check if it contains only digits after cleaning
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanedValue)) {
      return 'Please enter a valid telephone number';
    }

    // Check length (adjust based on your country's phone number format)
    if (cleanedValue.length < 10) {
      return 'Telephone number must be at least 10 digits';
    }

    if (cleanedValue.length > 15) {
      return 'Telephone number cannot exceed 15 digits';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (value.length > 50) {
      return 'Password cannot exceed 50 characters';
    }

    // Optional: Add more password strength requirements
    // if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
    //   return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
    // }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/round_about.jpg',
            ), // You'll need to add this image
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Back button
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: IconButton(
                          onPressed: () {
                            // Handle back navigation
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Logo and Title
                    Row(
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

                    const SizedBox(height: 80),

                    // Log in to HabiShare text
                    const Text(
                      'Log in to HabiShare',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Register link - UPDATED TO NAVIGATE TO SIGNUP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap:
                              _handleRegister, // This now navigates to signup
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Color(0xFF8A2851),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Telephone input - ENHANCED VALIDATION
                    CustomTextField(
                      hintText: 'Telephone',
                      controller: _telephoneController,
                      keyboardType: TextInputType.phone,
                      validator: _validateTelephone,
                      prefixIcon: const Icon(Icons.phone, color: Colors.grey),
                    ),

                    // Password input - ENHANCED VALIDATION
                    CustomTextField(
                      hintText: 'Password',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: _validatePassword,
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Login button
                    CustomButton(
                      text: 'Log in',
                      onPressed: _handleLogin,
                      isLoading: _isLoading,
                      backgroundColor: const Color(0xFF8A2851),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
