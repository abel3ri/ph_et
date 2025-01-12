import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RPlaceHolderContainer extends StatelessWidget {
  const RPlaceHolderContainer({
    super.key,
    required this.children,
    required this.onTap,
  });

  final void Function()? onTap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Get.theme.primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
