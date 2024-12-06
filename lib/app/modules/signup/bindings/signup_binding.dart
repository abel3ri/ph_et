import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/image_service.dart';
import 'package:pharma_et/app/modules/image_picker/controllers/image_picker_controller.dart';

import '../controllers/signup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(
      () => SignupController(),
    );
    Get.lazyPut<ImagePickerController>(
      () => ImagePickerController(),
    );
    Get.lazyPut<ImageService>(
      () => ImageService(),
    );
  }
}
