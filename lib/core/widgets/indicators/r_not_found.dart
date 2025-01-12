import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RNotFound extends StatelessWidget {
  const RNotFound({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * 0.04),
            SvgPicture.asset(
              width: Get.width * 0.6,
              "assets/misc/error.svg",
              fit: BoxFit.contain,
            ),
            SizedBox(height: Get.height * 0.02),
            if (message != null)
              Text(
                "$message",
                style: context.textTheme.titleMedium,
              ),
          ],
        ),
      ),
    );
  }
}
