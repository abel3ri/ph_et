import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/modules/order/widgets/r_order_container.dart';
import 'package:pharma_et/core/widgets/buttons/r_filter_container_btn.dart';
import '../controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Order Information",
          style: context.textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => RFilterContainerBtn(
                    label: "Active Orders",
                    onPressed: () {
                      controller.changePage(0);
                    },
                    isActive: controller.activeIndex.value == 0,
                  ),
                ),
                SizedBox(width: Get.width * 0.02),
                Obx(
                  () => RFilterContainerBtn(
                    label: "Order History",
                    onPressed: () {
                      controller.changePage(1);
                    },
                    isActive: controller.activeIndex.value == 1,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Obx(
                () => PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  children: [
                    ROrderContainer(
                      orders: controller.activeOrders.value,
                      isActiveOrder: true,
                    ),
                    ROrderContainer(
                      orders: controller.nonActiveOrders.value,
                      isActiveOrder: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
