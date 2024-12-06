import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class RItemCardShimmer extends StatelessWidget {
  const RItemCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Get.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor =
        Get.isDarkMode ? Colors.grey[700]! : Colors.grey[100]!;

    return Container(
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
          // Image Placeholder
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                height: 150, // Adjust based on your design
                width: double.infinity,
                color: baseColor,
              ),
            ),
          ),
          // Content Placeholders
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Placeholder
                Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    height: 16,
                    width: 120,
                    color: baseColor,
                  ),
                ),
                const SizedBox(height: 8),
                // Description Placeholder 1
                Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    height: 12,
                    width: 200,
                    color: baseColor,
                  ),
                ),
                const SizedBox(height: 8),
                // Description Placeholder 2
                Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Container(
                    height: 12,
                    width: 150,
                    color: baseColor,
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
