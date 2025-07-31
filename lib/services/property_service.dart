import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/property.dart';

class PropertyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  // Create a new property
  Future<String?> createProperty(Property property) async {
    try {
      print('PropertyService: Creating property ${property.name}');
      
      // Check if user is authenticated
      if (_auth.currentUser == null) {
        throw Exception('User not authenticated. Please log in again.');
      }
      
      // Generate a new document reference to get an ID
      final docRef = _firestore.collection('properties').doc();
      
      // Update the property with the generated ID
      final propertyWithId = property.copyWith(
        ownerId: _auth.currentUser?.uid,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      propertyWithId.id = docRef.id;

      print('PropertyService: Saving to Firestore with ID: ${docRef.id}');
      
      // Save to Firestore
      await docRef.set(propertyWithId.toMap());
      
      print('PropertyService: Property saved successfully');
      return docRef.id;
    } catch (e) {
      print('PropertyService: Error creating property: $e');
      
      // Provide more specific error messages
      if (e.toString().contains('NOT_FOUND') && e.toString().contains('database')) {
        throw Exception('Firebase database not configured. Please contact support.');
      } else if (e.toString().contains('PERMISSION_DENIED')) {
        throw Exception('Permission denied. Please check your login status.');
      } else if (e.toString().contains('UNAVAILABLE')) {
        throw Exception('Service temporarily unavailable. Please try again later.');
      } else {
        throw Exception('Failed to upload property: ${e.toString()}');
      }
    }
  }

  // Get properties for the current user
  Future<List<Property>> getUserProperties() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final querySnapshot = await _firestore
          .collection('properties')
          .where('ownerId', isEqualTo: userId)
          .get();

      // Sort locally after fetching to avoid composite index requirement
      final properties = querySnapshot.docs
          .map((doc) => Property.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
      
      // Sort by createdAt descending (newest first)
      properties.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return properties;
    } catch (e) {
      print('Error getting user properties: $e');
      rethrow;
    }
  }

  // Get all approved properties (for clients)
  Future<List<Property>> getApprovedProperties() async {
    try {
      final querySnapshot = await _firestore
          .collection('properties')
          .where('status', isEqualTo: 'approved')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Property.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting approved properties: $e');
      rethrow;
    }
  }

  // Update property
  Future<void> updateProperty(Property property) async {
    try {
      await _firestore
          .collection('properties')
          .doc(property.id)
          .update(property.copyWith(updatedAt: DateTime.now()).toMap());
    } catch (e) {
      print('Error updating property: $e');
      rethrow;
    }
  }

  // Delete property
  Future<void> deleteProperty(String propertyId) async {
    try {
      await _firestore.collection('properties').doc(propertyId).delete();
    } catch (e) {
      print('Error deleting property: $e');
      rethrow;
    }
  }

  // Get property by ID
  Future<Property?> getPropertyById(String propertyId) async {
    try {
      final doc = await _firestore.collection('properties').doc(propertyId).get();
      
      if (doc.exists) {
        return Property.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Error getting property by ID: $e');
      rethrow;
    }
  }
}
