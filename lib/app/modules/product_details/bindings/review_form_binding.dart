import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/review_service.dart';
import 'package:pharma_et/app/modules/product_details/controllers/review_form_controller.dart';

class ReviewFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReviewFormController());
    Get.lazyPut(() => ReviewService());
  }
}
