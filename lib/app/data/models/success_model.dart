import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessModel {
  SuccessModel({
    required this.body,
  });

  final String body;

  void showSuccess() {
    Get.closeAllSnackbars();
    Get.showSnackbar(
      GetSnackBar(
        duration: const Duration(seconds: 5),
        animationDuration: const Duration(milliseconds: 300),
        dismissDirection: DismissDirection.horizontal,
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: Colors.green.withOpacity(0.9),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        messageText: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                body,
                style: Get.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
