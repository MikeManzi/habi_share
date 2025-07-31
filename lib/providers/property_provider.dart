import 'package:flutter/foundation.dart';
import '../models/property.dart';
import '../services/property_service.dart';

class PropertyProvider extends ChangeNotifier {
  final PropertyService _propertyService = PropertyService();
  
  // Current property being created/edited
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

  // Client dashboard properties
  List<Property> _allProperties = [];
  List<Property> _filteredProperties = [];
  bool _hasMoreProperties = true;
  String _currentFilter = 'All';
  String _searchQuery = '';
  
  // Loading states
  int _currentStep = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isRefreshing = false;
  String? _error;

  // Getters for current property
  Property get property => _property;
  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Getters for client dashboard
  List<Property> get allProperties => _allProperties;
  List<Property> get filteredProperties => _filteredProperties;
  bool get hasMoreProperties => _hasMoreProperties;
  bool get isLoadingMore => _isLoadingMore;
  bool get isRefreshing => _isRefreshing;
  String get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;

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

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // === CLIENT DASHBOARD METHODS ===

  // Debug method to load ALL properties
  Future<void> loadAllPropertiesForDebugging() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('PropertyProvider: Loading ALL properties for debugging...');
      final properties = await _propertyService.getAllPropertiesForDebugging();
      print('PropertyProvider: Received ${properties.length} total properties');
      
      _allProperties = properties;
      _applyFilters();
      
      print('PropertyProvider: After filtering: ${_filteredProperties.length} properties');
      
      _hasMoreProperties = false; // No pagination for debug
    } catch (e) {
      _error = 'Error loading properties: ${e.toString()}';
      print('PropertyProvider: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load initial properties for client dashboard
  Future<void> loadClientProperties() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('PropertyProvider: Loading client properties...');
      final properties = await _propertyService.getApprovedProperties(limit: 20);
      print('PropertyProvider: Received ${properties.length} properties');
      
      _allProperties = properties;
      _applyFilters();
      
      print('PropertyProvider: After filtering: ${_filteredProperties.length} properties');
      
      // Store last document for pagination
      if (properties.isNotEmpty) {
        // We'll need to get the document snapshot separately for pagination
        _hasMoreProperties = properties.length == 20;
      } else {
        _hasMoreProperties = false;
      }
    } catch (e) {
      _error = 'Error loading properties: ${e.toString()}';
      print('PropertyProvider: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh properties (pull-to-refresh)
  Future<void> refreshClientProperties() async {
    try {
      _isRefreshing = true;
      _error = null;
      notifyListeners();

      final properties = await _propertyService.getApprovedProperties(limit: 20);
      _allProperties = properties;
      _hasMoreProperties = properties.length == 20;
      _applyFilters();
    } catch (e) {
      _error = 'Error refreshing properties: ${e.toString()}';
      print(_error);
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  // Load more properties (pagination)
  Future<void> loadMoreClientProperties() async {
    if (!_hasMoreProperties || _isLoadingMore) return;

    try {
      _isLoadingMore = true;
      notifyListeners();

      // For simplified pagination, we'll use offset-based approach
      final moreProperties = await _propertyService.getApprovedProperties(limit: 20);
      
      // In a real implementation, you'd use startAfterDocument
      // For now, we'll simulate by checking if we get fewer than requested
      if (moreProperties.length < 20) {
        _hasMoreProperties = false;
      }

      _allProperties.addAll(moreProperties);
      _applyFilters();
    } catch (e) {
      _error = 'Error loading more properties: ${e.toString()}';
      print(_error);
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Apply search and filter
  void _applyFilters() {
    print('PropertyProvider: Applying filters - currentFilter: $_currentFilter, searchQuery: "$_searchQuery"');
    print('PropertyProvider: Total properties before filtering: ${_allProperties.length}');
    
    List<Property> filtered = List.from(_allProperties);

    // Apply type filter
    if (_currentFilter != 'All') {
      print('PropertyProvider: Applying filter: $_currentFilter');
      filtered = filtered.where((property) {
        switch (_currentFilter) {
          case 'Apartments':
            return property.type.toLowerCase().contains('apartment');
          case 'For sale':
            return property.priceSpan?.toLowerCase() == 'one-time' || 
                   property.tags.any((tag) => tag.toLowerCase().contains('sale'));
          case 'Shared':
            return property.tags.any((tag) => tag.toLowerCase().contains('shared')) ||
                   property.description.toLowerCase().contains('shared');
          default:
            return true;
        }
      }).toList();
      print('PropertyProvider: After type filter: ${filtered.length} properties');
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      print('PropertyProvider: Applying search: "$_searchQuery"');
      filtered = filtered.where((property) {
        final query = _searchQuery.toLowerCase();
        return property.name.toLowerCase().contains(query) ||
               property.address?.toLowerCase().contains(query) == true ||
               property.description.toLowerCase().contains(query);
      }).toList();
      print('PropertyProvider: After search filter: ${filtered.length} properties');
    }

    _filteredProperties = filtered;
    print('PropertyProvider: Final filtered properties: ${_filteredProperties.length}');
  }

  // Set filter
  void setFilter(String filter) {
    _currentFilter = filter;
    _applyFilters();
    notifyListeners();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Get featured properties (first 2 properties)
  List<Property> get featuredProperties {
    return _filteredProperties.take(2).toList();
  }

  // Get properties by category
  List<Property> getPropertiesByCategory(String category) {
    return _filteredProperties.where((property) {
      switch (category.toLowerCase()) {
        case 'shared housing':
          return property.tags.any((tag) => tag.toLowerCase().contains('shared')) ||
                 property.description.toLowerCase().contains('shared');
        case 'for sale':
          return property.priceSpan?.toLowerCase() == 'one-time' || 
                 property.tags.any((tag) => tag.toLowerCase().contains('sale'));
        case 'apartments':
          return property.type.toLowerCase().contains('apartment');
        default:
          return false;
      }
    }).toList();
  }

  // Toggle property favorite status
  void toggleFavorite(String propertyId) {
    final index = _allProperties.indexWhere((p) => p.id == propertyId);
    if (index != -1) {
      _allProperties[index].isFavorite = !_allProperties[index].isFavorite;
      _applyFilters();
      notifyListeners();
      
      // Here you could also update the favorite status in Firebase
      // _propertyService.updatePropertyFavorite(propertyId, _allProperties[index].isFavorite);
    }
  }
}
