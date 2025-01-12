import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';

class RItemCard extends StatelessWidget {
  const RItemCard({
    super.key,
    required this.child,
    required this.imageUrl,
    this.onTap,
  });
  final Widget child;
  final String imageUrl;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: context.isDarkMode ? Colors.black54 : Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  width: Get.width,
                  imageUrl: imageUrl,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    height: 96,
                    width: double.infinity,
                    child: const Center(
                      child: RLoading(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/misc/placeholder.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
