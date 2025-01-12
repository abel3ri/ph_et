import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorModel {
  ErrorModel({
    required this.body,
    this.stackTrace,
  });

  final String body;
  final StackTrace? stackTrace;

  void showError() {
    Get.closeAllSnackbars();
    Get.showSnackbar(
      GetSnackBar(
        duration: const Duration(seconds: 5),
        animationDuration: const Duration(milliseconds: 300),
        dismissDirection: DismissDirection.horizontal,
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: Colors.red.withOpacity(0.9),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        messageText: Row(
          children: [
            const Icon(
              Icons.error_outline,
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
