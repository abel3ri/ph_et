import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/modules/order/controllers/order_details_controller.dart';
import 'package:pharma_et/app/modules/order/widgets/r_order_details_container.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';
import 'package:pharma_et/core/widgets/indicators/r_not_found.dart';

class OrderDetailsView extends GetView<OrderDetailsController> {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Order Details",
          style: context.textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Obx(
        () {
          if (controller.isLoading.isTrue) {
            return const Center(
              child: RLoading(),
            );
          }
          if (controller.order == null) {
            return const Center(
              child: RNotFound(
                message: "Order not found",
              ),
            );
          }

          return ROrderDetailsContainer(
            order: controller.order!,
          );
        },
      ),
    );
  }
}
