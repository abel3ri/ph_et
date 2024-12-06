import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/product_item_service.dart';

import '../controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchController>(
      () => SearchController(),
    );
    Get.lazyPut<ProductItemService>(
      () => ProductItemService(),
    );
  }
}
