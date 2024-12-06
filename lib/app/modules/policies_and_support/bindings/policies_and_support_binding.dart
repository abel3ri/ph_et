import 'package:get/get.dart';

import '../controllers/policies_and_support_controller.dart';

class PoliciesAndSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PoliciesAndSupportController>(
      () => PoliciesAndSupportController(),
    );
  }
}
