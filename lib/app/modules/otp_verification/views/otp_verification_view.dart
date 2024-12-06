import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../controllers/otp_verification_controller.dart';

class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final String phoneNumber = Get.arguments?['userData']['phoneNumber'] ?? "";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.close),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Obx(
            () => controller.isLoading.isTrue
                ? const LinearProgressIndicator()
                : const SizedBox(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              Text(
                "Verification",
                style: context.textTheme.headlineMedium,
              ),
              SizedBox(height: Get.height * 0.02),
              const Text("Enter the code sent to the number"),
              SizedBox(height: Get.height * 0.02),
              Text(
                phoneNumber,
                style: context.textTheme.titleSmall,
              ),
              SizedBox(height: Get.height * 0.02),
              Pinput(
                controller: controller.otpController,
                autofocus: true,
                length: 6,
                onCompleted: (value) async {
                  await controller.verifyOTP(value);
                },
              ),
              SizedBox(height: Get.height * 0.02),
              const Text("Didn't receive code?"),
              Obx(() {
                final int minutes = controller.countdown.value ~/ 60;
                final int seconds = controller.countdown.value % 60;
                return Column(
                  children: [
                    if (controller.countdown.value > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "Resend code in ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                          style: context.textTheme.titleSmall!.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      )
                    else
                      TextButton(
                        onPressed: () async {
                          await controller.resendOTP();
                        },
                        child: const Text("Resend"),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
