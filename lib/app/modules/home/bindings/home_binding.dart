import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/category_service.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<CategoryService>(
      () => CategoryService(),
    );
  }
}
