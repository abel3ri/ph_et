import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/user_service.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<UserService>(
      () => UserService(),
    );
  }
}
