import 'dart:ffi';

class Property {
  final String id;
  final String name;
  final String address;
  final String phone;
  final double price;
  final String description;
  final String email;
  final double size;
  final int normalRooms;
  final int masterBedrooms;
  final String lastActivity;
  final List<String> images;
  final String type;
  final List<String> tags;
  bool isFavorite;

  Property({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.description,
    required this.price,
    required this.email,
    required this.size,
    required this.normalRooms,
    required this.masterBedrooms,
    required this.lastActivity,
    required this.images,
    required this.type,
    required this.tags,
    this.isFavorite = false,
  });

  factory Property.fromMap(Map<String, String> map) => Property(
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    address: map['address'] ?? '',
    phone: map['phone'] ?? '',
    email: map['email'] ?? '',
    size: double.tryParse(map['size'] ?? '0.0') ?? 0.0,
    normalRooms: int.tryParse(map['normalRooms'] ?? '0') ?? 0,
    masterBedrooms: int.tryParse(map['masterBedrooms'] ?? '0') ?? 0,
    lastActivity: map['lastActivity'] ?? '',
    images: List<String>.from(map['images']?.split(',') ?? []),
    type: map['type'] ?? '',
    tags: List<String>.from(map['tags']?.split(',') ?? []),
    isFavorite: map['isFavorite'] == 'true',
    description: map['description'] ?? '',
    price: double.tryParse(map['price'] ?? '0.0') ?? 0.0,
  );

  Property copyWith({
    String? name,
    String? address,
    String? phone,
    String? email,
    double? size,
    int? normalRooms,
    int? masterBedrooms,
    String? lastActivity,
    List<String>? images,
    String? type,
    List<String>? tags,
    bool? isFavorite,
    String? description,
    double? price,
  }) {
    return Property(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      size: size ?? this.size,
      normalRooms: normalRooms ?? this.normalRooms,
      masterBedrooms: masterBedrooms ?? this.masterBedrooms,
      lastActivity: lastActivity ?? this.lastActivity,
      images: images ?? this.images,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }
}
