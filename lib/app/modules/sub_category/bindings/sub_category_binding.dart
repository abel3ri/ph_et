import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/product_item_service.dart';
import 'package:pharma_et/app/data/services/sub_category_service.dart';
import 'package:pharma_et/app/modules/sub_category/controllers/sub_category_controller.dart';

class SubCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubCategoryController>(
      () => SubCategoryController(),
    );
    Get.lazyPut<SubCategoryService>(
      () => SubCategoryService(),
    );
    Get.lazyPut<ProductItemService>(
      () => ProductItemService(),
    );
  }
}
