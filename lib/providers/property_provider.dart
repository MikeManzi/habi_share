import 'package:flutter/foundation.dart';
import '../models/property.dart';

class PropertyProvider extends ChangeNotifier {
  Property _property = Property(
    name: '',
    phone: '',
    email: '',
    image: '',
    lastActivity: '',
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
      name: '',
      phone: '',
      email: '',
      image: '',
      lastActivity: '',
    );
    _currentStep = 0;
    notifyListeners();
  }

  void updateImage(String imagePath) {
    _property = _property.copyWith(image: imagePath);
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
