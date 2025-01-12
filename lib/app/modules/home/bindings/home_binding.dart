import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/ad_service.dart';
import 'package:pharma_et/app/data/services/category_service.dart';
import 'package:pharma_et/app/data/services/product_item_service.dart';
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
    Get.lazyPut<AdService>(
      () => AdService(),
    );
    Get.lazyPut<ProductItemService>(
      () => ProductItemService(),
    );
  }
}
