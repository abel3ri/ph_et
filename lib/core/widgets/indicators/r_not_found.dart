import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class RNotFound extends StatelessWidget {
  const RNotFound({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          if (message != null)
            Text(
              "$message",
              style: context.textTheme.titleMedium,
            ),
          Lottie.asset(
            width: Get.width * 0.7,
            height: Get.height * 0.3,
            "assets/lotties/not_found.json",
          ),
        ],
      ),
    );
  }
}
