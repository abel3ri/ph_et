import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pharma_et/core/controllers/auth_controller.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final authController = Get.find<AuthController>();
        if (authController.currentUser.value != null) {
          Future.delayed(Duration.zero, () {
            Get.offNamed("/home-wrapper");
          });
        } else {
          Future.delayed(Duration.zero, () {
            Get.offNamed("/get-started");
          });
        }
        return const Center(
          child: RLoading(),
        );
      }),
    );
  }
}
