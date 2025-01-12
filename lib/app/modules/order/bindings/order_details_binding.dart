import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/order_service.dart';
import 'package:pharma_et/app/data/services/product_item_service.dart';
import 'package:pharma_et/app/modules/order/controllers/order_details_controller.dart';

class OrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderDetailsController());
    Get.lazyPut(() => OrderService());
    Get.lazyPut(() => ProductItemService());
  }
}
