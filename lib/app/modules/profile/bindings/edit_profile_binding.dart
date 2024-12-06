import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/image_service.dart';
import 'package:pharma_et/app/data/services/user_service.dart';
import 'package:pharma_et/app/modules/image_picker/controllers/image_picker_controller.dart';
import 'package:pharma_et/app/modules/profile/controllers/edit_profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(
      () => EditProfileController(),
    );
    Get.lazyPut<ImagePickerController>(
      () => ImagePickerController(),
    );
    Get.lazyPut<UserService>(
      () => UserService(),
    );
    Get.lazyPut<ImageService>(
      () => ImageService(),
    );
  }
}
