import 'package:get/get.dart';

import '../controllers/home_wrapper_controller.dart';

class HomeWrapperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeWrapperController>(
      () => HomeWrapperController(),
    );
  }
}
