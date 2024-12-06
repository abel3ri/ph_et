import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetStartedController extends GetxController {
  Rx<int> currentIndex = 0.obs;
  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }
}
