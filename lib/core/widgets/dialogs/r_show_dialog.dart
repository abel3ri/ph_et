import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> rShowDialog({
  required String title,
  required String content,
  required String mainActionLabel,
  String cancelLabel = 'Cancel',
}) async {
  return await showDialog<bool>(
    context: Get.context!,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(title.tr),
      content: Text(content.tr),
      actions: [
        TextButton(
          onPressed: () async {
            Get.back(result: true);
          },
          child: Text(
            mainActionLabel.tr,
            style: context.textTheme.titleSmall!.copyWith(
              color: Get.theme.primaryColor,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back(result: false);
          },
          child: Text(
            cancelLabel.tr,
            style: context.textTheme.titleSmall!.copyWith(
              color: Get.theme.primaryColor,
            ),
          ),
        ),
      ],
    ),
  );
}
