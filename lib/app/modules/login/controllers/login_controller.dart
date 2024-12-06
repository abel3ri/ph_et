import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/core/controllers/auth_controller.dart';

class LoginController extends GetxController {
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Rx<bool> isLoading = false.obs;

  Rx<bool> showPassword = false.obs;

  Future<void> loginWithEmail() async {
    isLoading(true);
    final authController = Get.find<AuthController>();
    final res = await authController.loginWithEmailAndPass(userData: {
      "email": emailOrPhoneController.text,
      "password": passwordController.text,
    });
    isLoading(false);

    res.fold((l) {
      l.showError();
    }, (r) {
      Get.offAllNamed("/home-wrapper");
    });
  }

  Future<void> loginWithPhoneNumber() async {
    final authController = Get.find<AuthController>();
    final Map<String, dynamic> userData = {
      "phoneNumber": emailOrPhoneController.text,
    };
    isLoading(true);
    final res = await authController.verifyPhoneNumber(userData: userData);
    isLoading(false);
    res.fold((l) {
      l.showError();
    }, (r) {
      Get.toNamed("/otp-verification", arguments: {
        "userData": userData,
      });
      r.showSuccess();
    });
  }

  @override
  void onClose() {
    super.onClose();
    emailOrPhoneController.dispose();
    passwordController.dispose();
  }
}
