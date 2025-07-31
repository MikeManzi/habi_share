class Property {
  String id;
  final String name;
  final String? address;
  final String phone;
  final double price;
  final String description;
  final String email;
  final String? tinNumber;
  final String? businessCode;
  final String? priceSpan;
  final String? priceDescription;
  final List<String> documents;
  final double size;
  final int numberOfRooms;
  final String lastActivity;
  final List<String> images;
  final String type;
  final List<String> tags;
  final String? rentalPrice;
  bool isFavorite;

  Property({
    required this.id,
    required this.name,
    this.address,
    required this.phone,
    required this.description,
    required this.price,
    required this.email,
    this.tinNumber,
    this.businessCode,
    this.priceSpan,
    this.priceDescription,
    this.documents = const [],
    required this.size,
    required this.numberOfRooms,
    required this.lastActivity,
    required this.images,
    required this.type,
    required this.tags,
    this.isFavorite = false,
    this.rentalPrice
  });

  factory Property.fromMap(Map<String, dynamic> map) => Property(
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    address: map['address'],
    phone: map['phone'] ?? '',
    email: map['email'] ?? '',
    tinNumber: map['tinNumber'],
    businessCode: map['businessCode'],
    priceSpan: map['priceSpan'],
    priceDescription: map['priceDescription'],
    documents: List<String>.from(map['documents'] ?? []),
    size: double.tryParse(map['size'] ?? '0.0') ?? 0.0,
    numberOfRooms: int.tryParse(map['normalRooms'] ?? '0') ?? 0,
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
    String? typeOfProperty,
    String? size,
    String? description,
    String? tinNumber,
    String? businessCode,
    String? priceSpan,
    String? priceDescription,
    List<String>? documents,
    String? lastActivity,
    int? numberOfRooms,
    double? price,
    List<String>? images,
    String? type,
    List<String>? tags,
    bool? isFavorite,
    String? rentalPrice
  }) {
    return Property(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      description: description ?? this.description,
      tinNumber: tinNumber ?? this.tinNumber,
      businessCode: businessCode ?? this.businessCode,
      priceSpan: priceSpan ?? this.priceSpan,
      priceDescription: priceDescription ?? this.priceDescription,
      documents: documents ?? this.documents,
      lastActivity: lastActivity ?? this.lastActivity,
      size: size != null ? double.parse(size) : this.size,
      numberOfRooms: numberOfRooms?? this.numberOfRooms,
      price: price ?? this.price,
      images: images ?? this.images,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,

    );
  }

}
