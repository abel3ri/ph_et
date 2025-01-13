import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharma_et/app/data/models/order_model.dart';
import 'package:pharma_et/app/modules/order/bindings/order_details_binding.dart';
import 'package:pharma_et/app/modules/order/controllers/order_controller.dart';
import 'package:pharma_et/app/modules/order/views/order_details_view.dart';
import 'package:pharma_et/core/widgets/buttons/r_circled_button.dart';
import 'package:pharma_et/core/widgets/cards/r_card.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';

class ROrderContainer extends GetView<OrderController> {
  const ROrderContainer({
    super.key,
    required this.orders,
    this.isActiveOrder = false,
  });

  final List<OrderModel> orders;
  final bool isActiveOrder;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: RLoading());
      }

      if (orders.isEmpty) {
        return Center(
          child: Text(
            isActiveOrder
                ? "There is no active orders to display."
                : "There is no past orders to display.",
            style: context.textTheme.bodyLarge,
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: orders.length,
        controller: ScrollController(),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final order = orders[index];

          return GestureDetector(
            onTap: () {
              Get.to(
                () => const OrderDetailsView(),
                binding: OrderDetailsBinding(),
                arguments: {
                  "orderId": order.orderId,
                },
              );
            },
            child: RCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SelectableText.rich(
                          scrollPhysics: const BouncingScrollPhysics(),
                          TextSpan(
                            text: "ID: ",
                            children: [
                              TextSpan(
                                text: "${order.orderId}",
                                style: context.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      RCircledButton.medium(
                        icon: order.status == 'pending'
                            ? Icons.watch_later_rounded
                            : order.status == 'cancelled'
                                ? Icons.close
                                : Icons.check,
                        color: order.status == 'pending'
                            ? Colors.yellow.shade700
                            : order.status == 'cancelled'
                                ? Colors.red.shade700
                                : Colors.green.shade700,
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCreatedDate(order.createdAt!),
                      Text.rich(TextSpan(
                        text: "ETB ",
                        children: [
                          TextSpan(
                            text: "${order.totalAmount}",
                            style: context.textTheme.titleMedium,
                          ),
                        ],
                      ))
                    ],
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RCircledButton.medium(
                      icon: Icons.arrow_right_alt_rounded,
                      onTap: () {
                        Get.to(
                          () => const OrderDetailsView(),
                          binding: OrderDetailsBinding(),
                          arguments: {
                            "orderId": order.orderId,
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(
          height: Get.height * 0.02,
        ),
      );
    });
  }

  Widget _buildCreatedDate(DateTime date) {
    return Row(
      children: [
        const Icon(Icons.watch_later, size: 16),
        const SizedBox(width: 4),
        Text(
          DateFormat.yMMMd("en-US").add_jm().format(date),
        ),
      ],
    );
  }
}
