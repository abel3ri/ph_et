import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/core/controllers/auth_controller.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late AuthController authController;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    authController = Get.find<AuthController>();
  }

  Future<void> resetPassword() async {
    isLoading(true);
    final res = await authController.resetPassword(email: emailController.text);
    isLoading(false);
    res.fold((l) => l.showError(), (r) {
      Get.back();
      r.showSuccess();
    });
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
  }
}
