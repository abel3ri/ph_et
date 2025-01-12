import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/order_model.dart';
import 'package:pharma_et/app/modules/order/controllers/order_details_controller.dart';
import 'package:pharma_et/app/modules/order/widgets/page_widgets.dart';
import 'package:pharma_et/core/widgets/cards/r_card.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';

// ignore: must_be_immutable
class ROrderDetailsContainer extends GetView<OrderDetailsController> {
  OrderModel order;
  ROrderDetailsContainer({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([
          controller.getOrderProdFutures(order),
          controller.getPlaceName(
            order.deliveryAddress!.latitude,
            order.deliveryAddress!.longitude,
          ),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: RLoading());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          final productResults = snapshot.data![0] as List<dynamic>;
          final address = snapshot.data![1] as String;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            child: Stack(
              children: [
                RCard(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildOrderHeader(order),
                        SizedBox(height: Get.height * 0.01),
                        buildCreatedDate(order.createdAt!),
                        SizedBox(height: Get.height * 0.01),
                        buildProductList(productResults, order),
                        SizedBox(height: Get.height * 0.02),
                        buildDeliveryAddress(address, order),
                        SizedBox(height: Get.height * 0.02),
                        buildTotalAmount(order),
                        SizedBox(height: Get.height * 0.02),
                        buildUserInfo(context, order),
                        SizedBox(height: Get.height * 0.02),
                        buildReceipt(order),
                        SizedBox(height: Get.height * 0.02),
                        buildOrderActions(order, controller),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        color: order.status == 'cancelled'
                            ? Get.theme.colorScheme.error
                            : order.status == 'delivered'
                                ? Get.theme.primaryColor
                                : Colors.yellow.shade700,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                          topLeft: Radius.circular(4),
                        )),
                    child: Text(
                      '${order.status?.capitalize}',
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
