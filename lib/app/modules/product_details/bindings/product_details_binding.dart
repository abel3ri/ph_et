import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/product_item_service.dart';
import 'package:pharma_et/app/data/services/review_service.dart';
import 'package:pharma_et/app/data/services/user_service.dart';

import '../controllers/product_details_controller.dart';

class ProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductDetailsController>(
      () => ProductDetailsController(),
    );
    Get.lazyPut<ReviewService>(
      () => ReviewService(),
    );
    Get.lazyPut<UserService>(
      () => UserService(),
    );
    Get.lazyPut<ProductItemService>(
      () => ProductItemService(),
    );
  }
}
