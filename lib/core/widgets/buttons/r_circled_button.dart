import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RCircledButton extends StatelessWidget {
  const RCircledButton({
    super.key,
    required this.icon,
    this.onTap,
    this.iconSize,
    this.radius,
    this.color,
  });

  final IconData icon;
  final Function()? onTap;
  final double? iconSize;
  final double? radius;
  final Color? color;

  const RCircledButton.small({
    super.key,
    required this.icon,
    this.onTap,
    this.color,
  })  : iconSize = 14,
        radius = 10;

  const RCircledButton.medium({
    super.key,
    required this.icon,
    this.onTap,
    this.color,
  })  : iconSize = 20,
        radius = 14;

  const RCircledButton.large({
    super.key,
    required this.icon,
    this.onTap,
    this.color,
  })  : iconSize = 28,
        radius = 20;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: color ?? Get.theme.primaryColor,
        radius: radius ?? 12,
        child: Icon(
          icon,
          color: Colors.white,
          size: iconSize ?? 16,
        ),
      ),
    );
  }
}
