import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isClient => _user?.isClient ?? false;
  bool get isOwner => _user?.isOwner ?? false;

  AuthProvider() {
    _authService.userStream.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String telephone,
    required String username,
    required String gender,
    required UserRole role,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      // Check if email is already in use
      final isEmailAvailable = await _authService.isEmailAvailable(email);
      if (!isEmailAvailable) {
        _setError('Email is already in use');
        return false;
      }

      // Check if username is already taken
      final isUsernameAvailable = await _authService.isUsernameAvailable(
        username,
      );
      if (!isUsernameAvailable) {
        _setError('Username is already taken');
        return false;
      }

      // Check if phone is already in use
      final isPhoneAvailable = await _authService.isPhoneAvailable(telephone);
      if (!isPhoneAvailable) {
        _setError('Phone number is already in use');
        return false;
      }

      final user = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        telephone: telephone,
        username: username,
        gender: gender,
        role: role,
      );

      if (user != null) {
        _user = user;
        return true;
      }
      return false;
    } catch (e) {
      _setError(_getErrorMessage(e.toString()));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user != null) {
        _user = user;
        return true;
      }
      return false;
    } catch (e) {
      _setError(_getErrorMessage(e.toString()));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signInWithPhone({
    required String phone,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final user = await _authService.signInWithPhoneAndPassword(
        phone: phone,
        password: password,
      );

      if (user != null) {
        _user = user;
        return true;
      }
      return false;
    } catch (e) {
      _setError(_getErrorMessage(e.toString()));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.signOut();
      _user = null;
    } catch (e) {
      _setError(_getErrorMessage(e.toString()));
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _setError(null);
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _setError(_getErrorMessage(e.toString()));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    return await _authService.isUsernameAvailable(username);
  }

  Future<bool> isEmailAvailable(String email) async {
    return await _authService.isEmailAvailable(email);
  }

  Future<bool> isPhoneAvailable(String phone) async {
    return await _authService.isPhoneAvailable(phone);
  }

  void clearError() {
    _setError(null);
  }

  String _getErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'No user found with this email address';
    } else if (error.contains('wrong-password')) {
      return 'Incorrect password';
    } else if (error.contains('email-already-in-use')) {
      return 'Email is already in use';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak';
    } else if (error.contains('invalid-email')) {
      return 'Email address is invalid';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Please check your internet connection';
    } else if (error.contains('too-many-requests')) {
      return 'Too many requests. Please try again later';
    } else if (error.contains('No user found with this phone number')) {
      return 'No user found with this phone number';
    } else {
      return 'An error occurred. Please try again';
    }
  }
}
