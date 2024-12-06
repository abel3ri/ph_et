import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RProfileDetailRow extends StatelessWidget {
  const RProfileDetailRow({
    super.key,
    required this.label,
    required this.data,
  });

  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: Get.width * 0.02),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              data,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
