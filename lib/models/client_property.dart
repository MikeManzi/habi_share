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
