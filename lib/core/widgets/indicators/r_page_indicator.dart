import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RPageIndicator extends StatelessWidget {
  const RPageIndicator({
    super.key,
    required this.controller,
    required this.itemCount,
    this.color,
  });

  final dynamic controller;
  final int itemCount;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Obx(
            () => Center(
              child: Container(
                width: controller.currentIndex.value == index ? 32 : 8,
                height: 4,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
      ),
    );
  }
}
