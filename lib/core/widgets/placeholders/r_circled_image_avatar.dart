import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RCircledImageAvatar extends StatelessWidget {
  const RCircledImageAvatar.medium({
    super.key,
    this.imageUrl,
    this.selectedFile,
    required this.fallBackText,
  })  : radius = 36,
        boxSize = 68;

  const RCircledImageAvatar.small({
    super.key,
    this.imageUrl,
    this.selectedFile,
    required this.fallBackText,
  })  : radius = 24,
        boxSize = 44;

  const RCircledImageAvatar.large({
    super.key,
    this.imageUrl,
    this.selectedFile,
    required this.fallBackText,
  })  : radius = 48,
        boxSize = 88;

  const RCircledImageAvatar({
    super.key,
    this.imageUrl,
    this.selectedFile,
    required this.fallBackText,
  })  : radius = 40,
        boxSize = 74;

  final String? imageUrl; // Previous image URL
  final File? selectedFile; // Newly selected image file
  final String fallBackText;
  final double radius;
  final double boxSize;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Get.isDarkMode ? Colors.white : Colors.grey,
      child: ClipOval(
        child: SizedBox(
          width: boxSize,
          height: boxSize,
          child: selectedFile != null
              ? Image.file(
                  selectedFile!,
                  fit: BoxFit.cover,
                )
              : (imageUrl != null && imageUrl!.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : Container(
                      padding: const EdgeInsets.all(4),
                      color: Get.theme.primaryColor,
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            fallBackText.capitalize!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
