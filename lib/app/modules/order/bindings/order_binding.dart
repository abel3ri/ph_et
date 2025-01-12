import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/order_service.dart';
import 'package:pharma_et/app/data/services/product_item_service.dart';

import '../controllers/order_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(
      () => OrderController(),
    );
    Get.lazyPut<OrderService>(
      () => OrderService(),
    );
    Get.lazyPut<ProductItemService>(
      () => ProductItemService(),
    );
  }
}
