class Property {
  final String id;
  final String title;
  final String location;
  final double price;
  final String description;
  final List<String> images;
  final int normalRooms;
  final int masterBedrooms;
  final double size;
  final String type;
  final List<String> tags;
  bool isFavorite;

  Property({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.description,
    required this.images,
    required this.normalRooms,
    required this.masterBedrooms,
    required this.size,
    required this.type,
    required this.tags,
    this.isFavorite = false,
  });

  Property copyWith({
    String? id,
    String? title,
    String? location,
    double? price,
    String? description,
    List<String>? images,
    int? normalRooms,
    int? masterBedrooms,
    double? size,
    String? type,
    bool? isFavorite,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      price: price ?? this.price,
      description: description ?? this.description,
      images: images ?? this.images,
      normalRooms: normalRooms ?? this.normalRooms,
      masterBedrooms: masterBedrooms ?? this.masterBedrooms,
      size: size ?? this.size,
      type: type ?? this.type,
      tags: tags,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
