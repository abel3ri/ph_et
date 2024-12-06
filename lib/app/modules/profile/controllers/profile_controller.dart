import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/user_service.dart';
import 'package:pharma_et/core/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  Rx<bool> isLoading = false.obs;

  late AuthController authController;
  late UserService userService;

  @override
  void onInit() {
    super.onInit();
    authController = Get.find<AuthController>();
    userService = Get.find<UserService>();
  }

  Future<void> getUserData() async {
    isLoading(true);
    if (authController.currentUser.value == null) {
      isLoading(false);
      return;
    }
    final res = await userService.findOne(
      userId: authController.currentUser.value!.userId!,
    );
    isLoading(false);
    res.fold((l) => l.showError(), (r) {
      authController.currentUser.value = r;
      authController.saveUserData(
        authController.currentUser.value?.toJson() ?? r.toJson(),
      );
    });
  }

  Future<void> deleteAccount() async {
    isLoading(true);

    final res = await authController.deleteAccount();
    isLoading(false);
    res.fold((l) => l.showError(), (r) {
      Get.offAllNamed("/get-started");
      r.showSuccess();
    });
  }
}
