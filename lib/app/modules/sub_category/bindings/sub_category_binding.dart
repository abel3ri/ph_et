import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/product_item_service.dart';
import 'package:pharma_et/app/modules/cart/controllers/cart_controller.dart';

import '../controllers/sub_category_controller.dart';

class SubCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubCategoryController>(
      () => SubCategoryController(),
    );
    Get.lazyPut<ProductItemService>(
      () => ProductItemService(),
    );
    Get.lazyPut<CartController>(
      () => CartController(),
    );
  }
}
