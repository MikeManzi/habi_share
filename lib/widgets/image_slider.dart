import 'package:flutter/material.dart';
import 'package:habi_share/utils/app_colors.dart';
import '../utils/image_utils.dart';

class ImageSlider extends StatefulWidget {
  final List<String> images;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ImageSlider({
    Key? key,
    required this.images,
    required this.isFavorite,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Handle empty images list
    List<String> displayImages = widget.images.isNotEmpty 
        ? widget.images 
        : ['assets/default_property.png'];

    return Stack(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: displayImages.length,
            itemBuilder: (context, index) {
              final imagePath = displayImages[index];
              
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ImageUtils.getImageProvider(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        // Back button
        Positioned(
          top: 40,
          left: 16,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        // Favorite button
        Positioned(
          top: 40,
          right: 16,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.9,
                red: 0.9,
                green: 0.9,
                blue: 0.9,
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: widget.isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: widget.onFavoriteToggle,
            ),
          ),
        ),
        // Page indicators
        if (displayImages.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                displayImages.length,
                (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentIndex == index
                          ? AppColors.primaryPurple
                          : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
