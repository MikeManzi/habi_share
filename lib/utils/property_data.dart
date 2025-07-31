import '../models/property.dart';

class PropertyData {
  static List<Property> properties = [
    Property(
      id: '1',
      name: '2 story house',
      address: 'Kabeza',
      price: 300000,
      description: 'Open-plan living and dining area with ample natural light. Well-equipped kitchen with modern appliances and ample storage. Three spacious bedrooms, including a master bedroom with an en-suite bathroom and balcony. Additional amenities include ample parking space and water tanks.',
      images: [
        'https://images.unsplash.com/photo-1570129477492-45c003edd2be?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
        'https://images.unsplash.com/photo-1484154218962-a197022b5858?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2074&q=80',
        'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2058&q=80',
      ],
      phone: '0771234567',
      email: 'Kg5Y7@example.com',
      numberOfRooms: 3,
      size: 1234,
      type: 'Apartment',
      tags: ['pet-friendly', 'parking', 'balcony', 'water-tanks'],
      isFavorite: false,
      lastActivity: '2023-08-20',
      tinNumber: '123456789',
      businessCode: '123456789',
      priceSpan: 'Monthly',
      priceDescription: 'Includes electricity, water, and gas.',
      documents: [],
      ownerId: 'sample_owner_1',
      createdAt: DateTime(2023, 8, 20),
      updatedAt: DateTime(2023, 8, 20),
      status: 'approved',
    ),
    Property(
      id:'2',
      name: 'Modern Villa',
      address: 'Kimihurura',
      price: 450000,
      description: 'Luxurious modern villa with panoramic city views. Features include a gourmet kitchen, spacious living areas, and a private garden. Perfect for entertaining with multiple outdoor spaces and premium finishes throughout.',
      images: [
        'https://images.unsplash.com/photo-1613490493576-7fde63acd811?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2071&q=80',
        'https://images.unsplash.com/photo-1566908829077-2f3ca7a3a1e6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
      ],
      numberOfRooms: 4,
      size: 2500,
      type: 'Villa',
      tags: ['wheelchair-access', 'garden', 'garage', 'security', 'swimming-pool'],
      isFavorite: true,
      lastActivity: '2023-08-20',
      phone: '0771234567',
      email: 'Kg5Y7@example.com',
      ownerId: 'sample_owner_2',
      createdAt: DateTime(2023, 8, 20),
      updatedAt: DateTime(2023, 8, 20),
      status: 'approved',
    ),
    Property(
      id: '3',
      name: 'Cozy Apartment',
      address: 'Kacyiru',
      price: 180000,
      description: 'Charming apartment in a quiet neighborhood. Features modern amenities, well-designed spaces, and convenient address near schools and shopping centers. Perfect for young professionals or small families.',
      images: [
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2080&q=80',
        'https://images.unsplash.com/photo-1493663284031-b7e3aaa4c4bc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
      ],
      numberOfRooms: 2,
      size: 850,
      type: 'Apartment',
      tags: ['furnished', 'elevator', 'near-schools', 'shopping-center'],
      isFavorite: false,
      lastActivity: '2023-08-20',
      phone: '0771234567',
      email: 'Kg5Y7@example.com',
      ownerId: 'sample_owner_3',
      createdAt: DateTime(2023, 8, 20),
      updatedAt: DateTime(2023, 8, 20),
      status: 'approved',
    ),
  ];

  static Property? getPropertyById(String id) {
    try {
      return properties.firstWhere((property) => property.id == id);
    } catch (e) {
      return null;
    }
  }

  static void toggleFavorite(String id) {
    final index = properties.indexWhere((property) => property.id == id);
    if (index != -1) {
      properties[index] = properties[index].copyWith(
        isFavorite: !properties[index].isFavorite,
      );
    }
  }
}
