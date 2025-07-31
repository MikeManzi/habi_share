import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user stream
  Stream<User?> get userStream {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return await getUserData(firebaseUser.uid);
    });
  }

  // Get current user
  auth.User? get currentFirebaseUser => _firebaseAuth.currentUser;

  // Get current user data
  Future<User?> get currentUser async {
    final firebaseUser = currentFirebaseUser;
    if (firebaseUser == null) return null;
    return await getUserData(firebaseUser.uid);
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword({
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
      // Create user with Firebase Auth
      final auth.UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final auth.User? firebaseUser = result.user;
      if (firebaseUser == null) return null;

      // Create user document in Firestore
      final user = User(
        uid: firebaseUser.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        telephone: telephone,
        username: username,
        gender: gender,
        role: role,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(user.toMap());

      return user;
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final auth.UserCredential result = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final auth.User? firebaseUser = result.user;
      if (firebaseUser == null) return null;

      return await getUserData(firebaseUser.uid);
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  // Sign in with phone and password
  Future<User?> signInWithPhoneAndPassword({
    required String phone,
    required String password,
  }) async {
    try {
      // Find user by phone number
      final QuerySnapshot querySnapshot =
          await _firestore
              .collection('users')
              .where('telephone', isEqualTo: phone)
              .limit(1)
              .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No user found with this phone number');
      }

      final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      final email = userData['email'];

      // Sign in with email and password
      return await signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Phone sign in error: $e');
      rethrow;
    }
  }

  // Get user data from Firestore
  Future<User?> getUserData(String uid) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) return null;

      return User.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Get user data error: $e');
      return null;
    }
  }

  // Update user data
  Future<void> updateUserData(User user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update(user.copyWith(updatedAt: DateTime.now()).toMap());
    } catch (e) {
      print('Update user data error: $e');
      rethrow;
    }
  }

  // Check if username is available
  Future<bool> isUsernameAvailable(String username) async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore
              .collection('users')
              .where('username', isEqualTo: username.toLowerCase())
              .limit(1)
              .get();

      return querySnapshot.docs.isEmpty;
    } catch (e) {
      print('Username check error: $e');
      return false;
    }
  }

  // Check if email is available
  Future<bool> isEmailAvailable(String email) async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore
              .collection('users')
              .where('email', isEqualTo: email.toLowerCase())
              .limit(1)
              .get();

      return querySnapshot.docs.isEmpty;
    } catch (e) {
      print('Email check error: $e');
      return false;
    }
  }

  // Check if phone is available
  Future<bool> isPhoneAvailable(String phone) async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore
              .collection('users')
              .where('telephone', isEqualTo: phone)
              .limit(1)
              .get();

      return querySnapshot.docs.isEmpty;
    } catch (e) {
      print('Phone check error: $e');
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Reset password error: $e');
      rethrow;
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final user = currentFirebaseUser;
      if (user == null) return;

      // Delete user document from Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // Delete Firebase Auth user
      await user.delete();
    } catch (e) {
      print('Delete account error: $e');
      rethrow;
    }
  }
}
