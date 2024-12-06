import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pharma_et/app/modules/get_started/controllers/get_started_controller.dart';

class RWelcomePage extends GetView<GetStartedController> {
  const RWelcomePage({
    super.key,
    required this.headline,
    required this.lottiePath,
    required this.message,
  });

  final String headline;
  final String message;
  final String lottiePath;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final maxWidth = constraints.maxWidth;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                headline,
                style: context.textTheme.headlineMedium!.copyWith(
                    // color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: maxHeight * 0.03),
              Text(
                message,
                style: context.textTheme.bodyMedium!.copyWith(
                    // color: Colors.white,
                    ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 1),
              Container(
                width: maxWidth * 0.85,
                height: maxHeight * 0.45,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(120),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(80),
                    bottomRight: Radius.circular(100),
                  ),
                ),
                child: Lottie.asset(
                  lottiePath,
                  fit: BoxFit.cover,
                ),
              ),
              const Spacer(flex: 2),
              Obx(
                () => FilledButton.icon(
                  style: ButtonStyle(
                    // backgroundColor: WidgetStatePropertyAll(Colors.white),
                    minimumSize: WidgetStatePropertyAll(
                      Size(maxWidth * 0.8, 48),
                    ),
                  ),
                  onPressed: () {
                    if (controller.currentIndex.value != 2) {
                      controller.pageController.animateToPage(
                        controller.currentIndex.value + 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Get.toNamed("/login");
                    }
                  },
                  label: Text(
                    controller.currentIndex.value != 2
                        ? "Continue"
                        : "Get started",
                    style: context.textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(
                    Icons.arrow_right_alt_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
