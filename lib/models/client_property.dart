class ClientProperty {
  final String imagePath;
  final String price;
  final String address;
  final bool isLarge;

  ClientProperty({
    required this.imagePath,
    required this.price,
    required this.address,
    this.isLarge = false,
  });
}

class Property {
  final String name;
  final String address;
  final String phone;
  final String email;
  final String size;
  final String rooms;
  final String lastActivity;
  final String image;

  Property({
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.size,
    required this.rooms,
    required this.lastActivity,
    required this.image,
  });

  factory Property.fromMap(Map<String, String> map) => Property(
    name: map['name'] ?? '',
    address: map['address'] ?? '',
    phone: map['phone'] ?? '',
    email: map['email'] ?? '',
    size: map['size'] ?? '',
    rooms: map['rooms'] ?? '',
    lastActivity: map['lastActivity'] ?? '',
    image: map['image'] ?? '',
  );
}
