import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/product_item_service.dart';
import 'package:pharma_et/app/modules/cart/controllers/cart_controller.dart';
import 'package:pharma_et/app/modules/products/controllers/products_controller.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductsController>(
      () => ProductsController(),
    );
    Get.lazyPut<ProductItemService>(
      () => ProductItemService(),
    );
    Get.lazyPut<CartController>(
      () => CartController(),
    );
  }
}
