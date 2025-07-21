import 'package:flutter/material.dart';

class Property {
  final String imagePath;
  final String price;
  final String address;
  final bool isLarge;

  Property({
    required this.imagePath,
    required this.price,
    required this.address,
    this.isLarge = false,
  });
}
