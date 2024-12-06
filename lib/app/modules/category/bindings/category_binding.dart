import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/product_item_service.dart';
import 'package:pharma_et/app/data/services/sub_category_service.dart';

import '../controllers/category_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryController>(
      () => CategoryController(),
    );
    Get.lazyPut<SubCategoryService>(
      () => SubCategoryService(),
    );
    Get.lazyPut<ProductItemService>(
      () => ProductItemService(),
    );
  }
}
