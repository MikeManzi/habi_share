import 'package:flutter/material.dart';
import '../models/property.dart';
import '../utils/app_colors.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  const PropertyCard({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            child: Image.asset(
              property.imagePath,
              fit: BoxFit.cover,
              height: property.isLarge ? 100 : 68,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              12,
              property.isLarge ? 8 : 6,
              12,
              property.isLarge ? 8 : 6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.price,
                  style: TextStyle(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w700,
                    fontSize: property.isLarge ? 18 : 15,
                  ),
                ),
                Text(
                  '/month',
                  style: TextStyle(
                    color: Color(0xFFB0B0B0),
                    fontSize: property.isLarge ? 13 : 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  property.address,
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: property.isLarge ? 13 : 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
