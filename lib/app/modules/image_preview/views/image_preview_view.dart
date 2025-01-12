import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewView extends StatelessWidget {
  const ImagePreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = Get.arguments?['imageUrl'] ?? "";
    final String imageType = Get.arguments?['imageType'] ?? "";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 28,
          ),
        ),
      ),
      body: PhotoView(
        imageProvider: imageType == "file_image"
            ? FileImage(File(imageUrl))
            : CachedNetworkImageProvider(imageUrl),
      ),
    );
  }
}
