import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RFilterContainerBtn extends StatelessWidget {
  const RFilterContainerBtn({
    super.key,
    required this.label,
    required this.onPressed,
    this.isActive = false,
  });

  final String label;
  final void Function()? onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isActive ? Get.theme.primaryColor : null,
            border: Border.all(
              width: 1,
              color: isActive ? Get.theme.primaryColor : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: context.textTheme.titleSmall?.copyWith(
                color: isActive ? Colors.white : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
