import 'package:flutter/material.dart';
import 'package:habi_share/screens/login.dart';
import 'package:habi_share/widgets/custom_button.dart';
import 'package:habi_share/widgets/text_field.dart';
import 'package:habi_share/models/user.dart';
import 'package:habi_share/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AccountInformation extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String telephone;
  final String email;
  final UserRole role;

  const AccountInformation({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.telephone,
    required this.email,
    required this.role,
  });

  @override
  State<AccountInformation> createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _selectedGender = 'Male';
  bool _acceptTerms = false;
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (value.length > 20) {
      return 'Username cannot exceed 20 characters';
    }

    // Check if username contains only letters, numbers, and underscores
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }

  Future<void> _validateUsernameAsync() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty || username.length < 3) return;

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isAvailable = await authProvider.isUsernameAvailable(username);

      if (mounted && !isAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username is already taken'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      // Handle error silently or show a message
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept the terms and conditions'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      print('Starting registration process...');

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        print('Calling register method...');
        final success = await authProvider
            .register(
              email: widget.email,
              password: _passwordController.text,
              firstName: widget.firstName,
              lastName: widget.lastName,
              telephone: widget.telephone,
              username: _usernameController.text,
              gender: _selectedGender,
              role: widget.role,
            )
            .timeout(
              const Duration(seconds: 30),
              onTimeout: () {
                print('Registration timed out');
                throw Exception('Registration timed out. Please try again.');
              },
            );

        print('Registration completed. Success: $success');

        if (mounted) {
          print('Widget is still mounted, updating UI...');
          // Stop loading first
          setState(() {
            _isLoading = false;
          });

          if (success) {
            print('Registration successful, showing success dialog...');
            // Registration successful - show success message first
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration successful!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );

            // Show a simple dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Success!'),
                    content: const Text(
                      'Your account has been created successfully. You can now log in.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: const Text('Go to Login'),
                      ),
                    ],
                  ),
            );
          } else {
            print('Registration failed, showing error message...');
            // Registration failed - show error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(authProvider.error ?? 'Registration failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          print('Widget is no longer mounted');
        }
      } catch (e) {
        print('Exception during registration: $e');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/round_about.jpg'), // Use same background
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
          child: SafeArea(
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
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

                const SizedBox(height: 20),

                // Progress indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8A2851),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Section title
                const Text(
                  'Register to HabiShare',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 30),

                // Form
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            'Account Information',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Username field
                          CustomTextField(
                            hintText: 'Username',
                            controller: _usernameController,
                            validator: _validateUsername,
                            onChanged: (value) {
                              // Debounce username validation
                              if (value.length >= 3) {
                                Future.delayed(
                                  const Duration(milliseconds: 500),
                                  () {
                                    if (_usernameController.text == value) {
                                      _validateUsernameAsync();
                                    }
                                  },
                                );
                              }
                            },
                          ),

                          // Gender dropdown
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _selectedGender,
                              decoration: InputDecoration(
                                hintText: 'Gender',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  borderSide: const BorderSide(
                                    color: Colors.deepPurple,
                                    width: 2,
                                  ),
                                ),
                              ),
                              dropdownColor: Colors.white,
                              items:
                                  ['Male', 'Female', 'Other']
                                      .map(
                                        (gender) => DropdownMenuItem(
                                          value: gender,
                                          child: Text(
                                            gender,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value!;
                                });
                              },
                            ),
                          ),

                          // Password field
                          CustomTextField(
                            hintText: 'Password',
                            controller: _passwordController,
                            obscureText: !_showPassword,
                            validator: _validatePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                          ),

                          // Confirm Password field
                          CustomTextField(
                            hintText: 'Confirm password',
                            controller: _confirmPasswordController,
                            obscureText: !_showConfirmPassword,
                            validator: _validateConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showConfirmPassword = !_showConfirmPassword;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Terms and conditions checkbox
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _acceptTerms = value!;
                                    });
                                  },
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.resolveWith((
                                    states,
                                  ) {
                                    if (states.contains(
                                      MaterialState.selected,
                                    )) {
                                      return const Color(0xFF8A2851);
                                    }
                                    return Colors.white;
                                  }),
                                ),
                                const Expanded(
                                  child: Text(
                                    'Accept Our Terms and conditions',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Register button
                          CustomButton(
                            text: 'Register',
                            onPressed: _handleRegister,
                            isLoading: _isLoading,
                            backgroundColor: const Color(0xFF8A2851),
                            borderRadius: 10,
                          ),

                          const SizedBox(height: 20),

                          // Login link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: _navigateToLogin,
                                child: const Text(
                                  'Log in',
                                  style: TextStyle(
                                    color: Color(0xFF8A2851),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
