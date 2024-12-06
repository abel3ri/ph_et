import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/core/controllers/auth_controller.dart';

import 'dart:async';

class OtpVerificationController extends GetxController {
  final TextEditingController otpController = TextEditingController();

  Rx<bool> isLoading = false.obs;
  RxInt countdown = 0.obs;
  Timer? _timer;

  Future<void> verifyOTP(String otp) async {
    isLoading(true);
    final Map<String, dynamic> userData = Get.arguments?['userData'] ?? {};
    final authController = Get.find<AuthController>();
    final res = await authController.verifyOTP(
      otp: otpController.text,
      userData: userData,
    );
    isLoading(false);
    res.fold((l) {
      l.showError();
    }, (r) {
      r.showSuccess();
      Get.offAllNamed("/home-wrapper");
    });
  }

  Future<void> resendOTP() async {
    isLoading(true);
    final Map<String, dynamic> userData = Get.arguments?['userData'] ?? {};
    final authController = Get.find<AuthController>();

    final res = await authController.resendCode(userData);
    isLoading(false);

    res.fold(
      (l) => l.showError(),
      (r) {
        r.showSuccess();
        startTimer();
      },
    );
  }

  void startTimer() {
    countdown.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    otpController.dispose();
    _timer?.cancel();
  }
}
