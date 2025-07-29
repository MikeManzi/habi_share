import 'package:flutter/foundation.dart';
import '../models/property.dart';

class PropertyProvider extends ChangeNotifier {
  Property _property = Property(
    id:'',
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
    priceSpan: '',
    priceDescription: '',
    price: 0.0,

  );
  int _currentStep = 0;

  Property get property => _property;
  int get currentStep => _currentStep;

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
      priceSpan: '',
      priceDescription: '',
      price: 0.0,
    );
    _currentStep = 0;
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
}
