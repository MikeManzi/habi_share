import 'package:flutter/foundation.dart';
import '../models/property.dart';
import '../services/property_service.dart';

class PropertyProvider extends ChangeNotifier {
  final PropertyService _propertyService = PropertyService();
  
  Property _property = Property(
    id: '',
    name: '',
    phone: '',
    email: '',
    images: [],
    lastActivity: '',
    documents: [],
    tags: [],
    isFavorite: false,
    type: '',
    address: '',
    size: 0.0,
    numberOfRooms: 0,
    description: '',
    tinNumber: '',
    businessCode: '',
    priceSpan: 'Monthly',
    priceDescription: '',
    price: 0.0,
    ownerId: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    status: 'pending',
  );
  int _currentStep = 0;
  bool _isLoading = false;
  String? _error;

  Property get property => _property;
  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void updateProperty(Property newProperty) {
    _property = newProperty;
    notifyListeners();
  }

  void setCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < 4) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void reset() {
    _property = Property(
      id: '',
      name: '',
      phone: '',
      email: '',
      images: [],
      lastActivity: '',
      documents: [],
      tags: [],
      isFavorite: false,
      type: '',
      address: '',
      size: 0.0,
      numberOfRooms: 0,
      description: '',
      tinNumber: '',
      businessCode: '',
      priceSpan: 'Monthly',
      priceDescription: '',
      price: 0.0,
      ownerId: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: 'pending',
    );
    _currentStep = 0;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  void updateImage(String imagePath) {
    _property = _property.copyWith(images: [imagePath]);
    notifyListeners();
  }

  void addDocument(String documentPath) {
    final currentDocuments = List<String>.from(_property.documents);
    currentDocuments.add(documentPath);
    _property = _property.copyWith(documents: currentDocuments);
    notifyListeners();
  }

  void removeDocument(String documentPath) {
    final currentDocuments = List<String>.from(_property.documents);
    currentDocuments.remove(documentPath);
    _property = _property.copyWith(documents: currentDocuments);
    notifyListeners();
  }

  // For backward compatibility with image handling
  void addImage(String imagePath) {
    updateImage(imagePath);
  }

  void removeImage(String imagePath) {
    updateImage('');
  }

  // Submit property to Firebase
  Future<bool> submitProperty() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Validate required fields
      if (_property.name.isEmpty || 
          _property.address?.isEmpty == true ||
          _property.description.isEmpty ||
          _property.price <= 0) {
        _error = 'Please fill in all required fields';
        return false;
      }

      // Submit to Firebase
      final propertyId = await _propertyService.createProperty(_property);
      
      if (propertyId != null) {
        _property.id = propertyId;
        return true;
      }
      
      _error = 'Failed to submit property';
      return false;
    } catch (e) {
      _error = 'Error submitting property: ${e.toString()}';
      print(_error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get user's properties
  Future<List<Property>> getUserProperties() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      return await _propertyService.getUserProperties();
    } catch (e) {
      _error = 'Error loading properties: ${e.toString()}';
      print(_error);
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

 Future<Property?> getPropertyById(String propertyId) async {
  try {
    Property? property = await _propertyService.getPropertyById(propertyId);
    // if(property == null){
    //   throw Exception('Property not found');
    // }
    // if(property != null && property.images.isEmpty){
    //   // Add default property image path
    //   print("Got the property");
    //   property.images.add('assets/default_property.png');
    // }
    return property;
  } catch (e) {
    print('Error getting property by ID: $e');
    return null;
  }
}


  void clearError() {
    _error = null;
    notifyListeners();
  }
}
