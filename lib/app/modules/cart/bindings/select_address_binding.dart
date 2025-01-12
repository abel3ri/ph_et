import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/location_service.dart';
import 'package:pharma_et/app/modules/cart/controllers/select_address_controller.dart';
import 'package:pharma_et/core/controllers/location_controller.dart';

class SelectAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectAddressController());
    Get.lazyPut(() => LocationController());
    Get.lazyPut(() => LocationService());
  }
}
