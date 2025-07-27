class Property {
  final String name;
  final String? address;
  final String phone;
  final String email;
  final String? typeOfProperty;
  final String? size;
  final String? numberOfRooms;
  final bool isPetFriendly;
  final bool hasCarParking;
  final bool hasGarden;
  final bool isSharedHousing;
  final String? description;
  final String image;
  final String? tinNumber;
  final String? businessCode;
  final String? rentalPrice;
  final String? priceSpan;
  final String? priceDescription;
  final List<String> documents;
  final String lastActivity;

  Property({
    required this.name,
    this.address,
    required this.phone,
    required this.email,
    this.typeOfProperty,
    this.size,
    this.numberOfRooms,
    this.isPetFriendly = false,
    this.hasCarParking = false,
    this.hasGarden = false,
    this.isSharedHousing = false,
    this.description,
    required this.image,
    this.tinNumber,
    this.businessCode,
    this.rentalPrice,
    this.priceSpan,
    this.priceDescription,
    this.documents = const [],
    required this.lastActivity,
  });

  factory Property.fromMap(Map<String, dynamic> map) => Property(
    name: map['name'] ?? '',
    address: map['address'],
    phone: map['phone'] ?? '',
    email: map['email'] ?? '',
    typeOfProperty: map['typeOfProperty'],
    size: map['size'],
    numberOfRooms: map['numberOfRooms'],
    isPetFriendly: map['isPetFriendly'] ?? false,
    hasCarParking: map['hasCarParking'] ?? false,
    hasGarden: map['hasGarden'] ?? false,
    isSharedHousing: map['isSharedHousing'] ?? false,
    description: map['description'],
    image: map['image'] ?? '',
    tinNumber: map['tinNumber'],
    businessCode: map['businessCode'],
    rentalPrice: map['rentalPrice'],
    priceSpan: map['priceSpan'],
    priceDescription: map['priceDescription'],
    documents: List<String>.from(map['documents'] ?? []),
    lastActivity: map['lastActivity'] ?? '',
  );

  Property copyWith({
    String? name,
    String? address,
    String? phone,
    String? email,
    String? typeOfProperty,
    String? size,
    String? numberOfRooms,
    bool? isPetFriendly,
    bool? hasCarParking,
    bool? hasGarden,
    bool? isSharedHousing,
    String? description,
    String? image,
    String? tinNumber,
    String? businessCode,
    String? rentalPrice,
    String? priceSpan,
    String? priceDescription,
    List<String>? documents,
    String? lastActivity,
  }) {
    return Property(
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      typeOfProperty: typeOfProperty ?? this.typeOfProperty,
      size: size ?? this.size,
      numberOfRooms: numberOfRooms ?? this.numberOfRooms,
      isPetFriendly: isPetFriendly ?? this.isPetFriendly,
      hasCarParking: hasCarParking ?? this.hasCarParking,
      hasGarden: hasGarden ?? this.hasGarden,
      isSharedHousing: isSharedHousing ?? this.isSharedHousing,
      description: description ?? this.description,
      image: image ?? this.image,
      tinNumber: tinNumber ?? this.tinNumber,
      businessCode: businessCode ?? this.businessCode,
      rentalPrice: rentalPrice ?? this.rentalPrice,
      priceSpan: priceSpan ?? this.priceSpan,
      priceDescription: priceDescription ?? this.priceDescription,
      documents: documents ?? this.documents,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }
}
