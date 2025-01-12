import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/chat_service.dart';

import '../controllers/consultation_controller.dart';

class ConsultationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConsultationController>(
      () => ConsultationController(),
    );
    Get.lazyPut<ChatService>(
      () => ChatService(),
    );
  }
}
