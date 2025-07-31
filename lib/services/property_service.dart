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

  // Helper method to convert document to Property
  Property _documentToProperty(QueryDocumentSnapshot doc) {
    final data = Map<String, dynamic>.from(doc.data() as Map);
    data['id'] = doc.id;
    return Property.fromMap(data);
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
          .map((doc) => _documentToProperty(doc))
          .toList();
      
      // Sort by createdAt descending (newest first)
      properties.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return properties;
    } catch (e) {
      print('Error getting user properties: $e');
      rethrow;
    }
  }

  // Temporary debug method - get ALL properties regardless of status
  Future<List<Property>> getAllPropertiesForDebugging() async {
    try {
      print('PropertyService: Fetching ALL properties for debugging...');
      final querySnapshot = await _firestore
          .collection('properties')
          .get();

      print('PropertyService: Found ${querySnapshot.docs.length} total properties');

      final properties = querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            print('Property: ${data['name']}, Status: ${data['status']}, Type: ${data['type']}');
            return _documentToProperty(doc);
          })
          .toList();
      
      // Sort by createdAt descending (newest first)
      properties.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return properties;
    } catch (e) {
      print('Error getting all properties: $e');
      rethrow;
    }
  }

  // Get all approved properties (for clients) - Initial load
  Future<List<Property>> getApprovedProperties({int limit = 20}) async {
    try {
      print('PropertyService: Fetching properties...');
      
      // Try to get approved properties first
      var querySnapshot = await _firestore
          .collection('properties')
          .where('status', isEqualTo: 'approved')
          .get();

      print('PropertyService: Found ${querySnapshot.docs.length} approved properties');

      // If no approved properties found, get all properties
      if (querySnapshot.docs.isEmpty) {
        print('PropertyService: No approved properties found, fetching all properties...');
        querySnapshot = await _firestore
            .collection('properties')
            .get();
        
        print('PropertyService: Found ${querySnapshot.docs.length} total properties');
        
        // Log first few properties to debug
        for (var doc in querySnapshot.docs.take(3)) {
          final data = doc.data();
          print('Property: ${data['name']}, status: ${data['status']}, ownerId: ${data['ownerId']}');
        }
      }

      // Sort locally after fetching
      final properties = querySnapshot.docs
          .map((doc) => _documentToProperty(doc))
          .toList();
      
      // Sort by createdAt descending (newest first)
      properties.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      // Apply limit after sorting
      return properties.take(limit).toList();
    } catch (e) {
      print('Error getting approved properties: $e');
      rethrow;
    }
  }

  // Get more approved properties (pagination)
  Future<List<Property>> getMoreApprovedProperties({
    required DocumentSnapshot lastDocument,
    int limit = 20,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('properties')
          .where('status', isEqualTo: 'approved')
          .orderBy('createdAt', descending: true)
          .startAfterDocument(lastDocument)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => _documentToProperty(doc))
          .toList();
    } catch (e) {
      print('Error getting more approved properties: $e');
      rethrow;
    }
  }

  // Get approved properties with real-time updates (Stream)
  Stream<List<Property>> getApprovedPropertiesStream({int limit = 20}) {
    return _firestore
        .collection('properties')
        .where('status', isEqualTo: 'approved')
        .snapshots()
        .map((snapshot) {
          // Sort locally after fetching to avoid composite index requirement
          final properties = snapshot.docs
              .map((doc) => _documentToProperty(doc))
              .toList();
          
          // Sort by createdAt descending (newest first)
          properties.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          
          // Apply limit after sorting
          return properties.take(limit).toList();
        });
  }

  // Get properties by type (for filtering)
  Future<List<Property>> getApprovedPropertiesByType({
    required String type,
    DocumentSnapshot? lastDocument,
    int limit = 20,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('properties')
          .where('status', isEqualTo: 'approved')
          .where('type', isEqualTo: type)
          .get();

      // Sort locally after fetching to avoid composite index requirement
      final properties = querySnapshot.docs
          .map((doc) => _documentToProperty(doc))
          .toList();
      
      // Sort by createdAt descending (newest first)
      properties.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      // Apply limit after sorting
      return properties.take(limit).toList();
    } catch (e) {
      print('Error getting properties by type: $e');
      rethrow;
    }
  }

  // Search properties by name or address
  Future<List<Property>> searchApprovedProperties({
    required String searchTerm,
    int limit = 20,
  }) async {
    try {
      // Note: This is a simple search. For more advanced search, consider using Algolia or similar
      final nameQuery = await _firestore
          .collection('properties')
          .where('status', isEqualTo: 'approved')
          .where('name', isGreaterThanOrEqualTo: searchTerm)
          .where('name', isLessThan: searchTerm + 'z')
          .limit(limit)
          .get();

      final addressQuery = await _firestore
          .collection('properties')
          .where('status', isEqualTo: 'approved')
          .where('address', isGreaterThanOrEqualTo: searchTerm)
          .where('address', isLessThan: searchTerm + 'z')
          .limit(limit)
          .get();

      final nameResults = nameQuery.docs
          .map((doc) => _documentToProperty(doc))
          .toList();

      final addressResults = addressQuery.docs
          .map((doc) => _documentToProperty(doc))
          .toList();

      // Combine and deduplicate results
      final allResults = [...nameResults, ...addressResults];
      final uniqueResults = <String, Property>{};
      for (final property in allResults) {
        uniqueResults[property.id] = property;
      }

      return uniqueResults.values.toList();
    } catch (e) {
      print('Error searching properties: $e');
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
        final data = Map<String, dynamic>.from(doc.data()!);
        data['id'] = doc.id;
        return Property.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Error getting property by ID: $e');
      rethrow;
    }
  }
}
