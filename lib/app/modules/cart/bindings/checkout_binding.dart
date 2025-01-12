import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/image_service.dart';
import 'package:pharma_et/app/data/services/order_service.dart';
import 'package:pharma_et/app/modules/cart/controllers/checkout_controller.dart';
import 'package:pharma_et/app/modules/image_picker/controllers/image_picker_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CheckoutController());
    Get.lazyPut(() => ImagePickerController());
    Get.lazyPut(() => OrderService());
    Get.lazyPut(() => ImageService());
  }
}
