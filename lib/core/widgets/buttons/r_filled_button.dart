import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RFilledButton extends StatelessWidget {
  const RFilledButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.fillColor,
    this.shape = "stadium",
  });

  final void Function()? onPressed;
  final Color? fillColor;
  final String label;
  final String? shape;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          shape == "rounded"
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
        ),
        backgroundColor: WidgetStatePropertyAll(fillColor),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: context.textTheme.bodyMedium!.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
