import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RPageIndicator extends StatelessWidget {
  const RPageIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
    this.color,
  });

  final RxInt currentIndex;
  final int itemCount;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: List.generate(
          itemCount,
          (index) => Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: currentIndex.value == index ? 24 : 6,
              height: 4,
              decoration: BoxDecoration(
                color: color ?? Get.theme.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
