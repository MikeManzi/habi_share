// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habi_share/models/user.dart';
import 'package:habi_share/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:habi_share/widgets/custom_button.dart';
import 'package:habi_share/widgets/text_field.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showConfirmPassword = false;

  bool _isLoading = false;
  bool _showPassword = false;
  late AuthProvider _authProvider;
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Get the AuthProvider instance
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _loadUserData(null);
  }

  void _loadUserData(User? user) {
    // Get current user data from AuthProvider
    final currentUser = user ?? _authProvider.user;
    if (currentUser != null) {
      _firstNameController.text = currentUser.firstName;
      _lastNameController.text = currentUser.lastName ;
      _phoneController.text = currentUser.telephone;
      _emailController.text = currentUser.email;
      // Don't pre-populate password for security reasons
      _passwordController.text = '';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value !=null && value.isNotEmpty && value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    // Check for at least one uppercase letter
    if (value!=null && value.isNotEmpty && !RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (value!=null && value.isNotEmpty && !RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one number
    if (value!=null && value.isNotEmpty && !RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (_passwordController.text.isNotEmpty && ( value == null || value.isEmpty)) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Update user profile
        final updatedUser = await _authProvider.updateUserProfile(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          telephone: _phoneController.text.trim(),
          password:
              _passwordController.text.isNotEmpty
                  ? _passwordController.text
                  : null, // Only update password if provided
        );

        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          _loadUserData(updatedUser);
        }
      } catch (e) {
        if (mounted) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating profile: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and close button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color:  Color(0xFF8A2851),
                      size: 24,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color:  Color(0xFF8A2851),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Title
            const Text(
              'Profile Settings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),

            const SizedBox(height: 30),

            // Edit Profile subtitle
            const Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),

            const SizedBox(height: 30),

            // Form
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // First Name
                      CustomTextField(
                        hintText: 'First Name',
                        controller: _firstNameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),

                      // Last Name
                      CustomTextField(
                        hintText: 'Last Name',
                        controller: _lastNameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),

                      // Phone Number
                      CustomTextField(
                        hintText: 'Phone Number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (value.length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),

                      // Email
                      CustomTextField(
                        hintText: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),

                      // Password (Optional - leave empty to keep current password)
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

                      // Helper text for password
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Leave password field empty to keep your current password',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Save Changes Button
                      CustomButton(
                        text: 'Save Changes',
                        onPressed: _saveChanges,
                        isLoading: _isLoading,
                        backgroundColor: const Color(0xFF8A2851),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
