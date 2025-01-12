import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/modules/get_started/widgets/r_welcome_page.dart';
import 'package:pharma_et/core/widgets/indicators/r_page_indicator.dart';
import '../controllers/get_started_controller.dart';

class GetStartedView extends GetView<GetStartedController> {
  const GetStartedView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: Get.width * 0.4,
        surfaceTintColor: Colors.transparent,
        leading: RPageIndicator(
          currentIndex: controller.currentIndex,
          itemCount: 3,
          color: Get.theme.primaryColor,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Hero(
              tag: "logo",
              child: SvgPicture.asset(
                "assets/icons/icon.svg",
                width: 32,
                height: 32,
              ),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (value) {
          controller.currentIndex.value = value;
        },
        physics: const BouncingScrollPhysics(),
        children: const [
          RWelcomePage(
            headline: "Your Health, Our Priority",
            message:
                "Discover a seamless way to access medicines, health products, and expert advice—all in one place. Your journey to better health starts here.",
            lottiePath: "assets/lotties/welcome/welcome_one.json",
          ),
          RWelcomePage(
            headline: "Care at Your Fingertips",
            message:
                "Shop for medicines, track orders, and get health tips effortlessly. Trusted by thousands for their wellness needs.",
            lottiePath: "assets/lotties/welcome/welcome_two.json",
          ),
          RWelcomePage(
            headline: "Wellness Simplified",
            message:
                "Stay on top of your health with fast, secure access to your pharmacy needs. Because you deserve the best care, anytime, anywhere.",
            lottiePath: "assets/lotties/welcome/welcome_three.json",
          ),
        ],
      ),
    );
  }
}
