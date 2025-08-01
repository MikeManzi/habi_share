import 'dart:io';
import 'package:flutter/material.dart';

class ImageUtils {
  /// Gets the appropriate ImageProvider based on the image path type
  static ImageProvider getImageProvider(String imagePath) {
    // Handle empty or null paths
    if (imagePath.isEmpty) {
      return const AssetImage('assets/default_property.png');
    }

    // Check if it's a local file path
    if (imagePath.startsWith('/') || 
        imagePath.startsWith('C:') || 
        imagePath.contains('\\') ||
        imagePath.startsWith('file://')) {
      
      // Clean the path (remove file:// prefix if present)
      String cleanPath = imagePath.replaceFirst('file://', '');
      
      final file = File(cleanPath);
      if (file.existsSync()) {
        return FileImage(file);
      } else {
        // Fallback to default asset if file doesn't exist
        print('ImageUtils: File not found at $cleanPath, using default image');
        return const AssetImage('assets/default_property.png');
      }
    } 
    // Check if it's an asset path
    else if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    } 
    // Check if it's a network URL
    else if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    } 
    // Default fallback
    else {
      print('ImageUtils: Unknown image path format: $imagePath, using default image');
      return const AssetImage('assets/default_property.png');
    }
  }

  /// Gets a Widget for displaying an image with proper error handling
  static Widget buildImageWidget({
    required String imagePath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
  }) {
    if (imagePath.isEmpty) {
      return errorWidget ?? 
        Image.asset(
          'assets/default_property.png',
          width: width,
          height: height,
          fit: fit,
        );
    }

    // For local files
    if (imagePath.startsWith('/') || 
        imagePath.startsWith('C:') || 
        imagePath.contains('\\') ||
        imagePath.startsWith('file://')) {
      
      String cleanPath = imagePath.replaceFirst('file://', '');
      final file = File(cleanPath);
      
      if (file.existsSync()) {
        return Image.file(
          file,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            print('ImageUtils: Error loading file image: $error');
            return errorWidget ?? 
              Image.asset(
                'assets/default_property.png',
                width: width,
                height: height,
                fit: fit,
              );
          },
        );
      }
    }
    
    // For assets
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          print('ImageUtils: Error loading asset image: $error');
          return errorWidget ?? 
            Image.asset(
              'assets/default_property.png',
              width: width,
              height: height,
              fit: fit,
            );
        },
      );
    }
    
    // For network images
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          print('ImageUtils: Error loading network image: $error');
          return errorWidget ?? 
            Image.asset(
              'assets/default_property.png',
              width: width,
              height: height,
              fit: fit,
            );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / 
                    loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }
    
    // Fallback
    return errorWidget ?? 
      Image.asset(
        'assets/default_property.png',
        width: width,
        height: height,
        fit: fit,
      );
  }
}
