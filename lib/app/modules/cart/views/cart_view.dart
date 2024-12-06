import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import 'package:pharma_et/core/widgets/badges/r_cart_item_badge.dart';
import 'package:pharma_et/core/widgets/buttons/r_circled_button.dart';
import 'package:pharma_et/core/widgets/cards/r_item_card.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';

import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool hasPreviousPage = Get.arguments?['hasPreviousPage'] ?? false;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: hasPreviousPage
            ? IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 28,
                ),
              )
            : null,
        title: Text(
          "My Cart",
          style: context.textTheme.titleMedium,
        ),
        centerTitle: true,
        actions: const [
          RCartItemBadge(),
        ],
      ),
      body: Obx(
        () {
          if (controller.cartItems.value.isEmpty) {
            return Center(
              child: Text(
                "Your cart is empty. Try adding products!",
                style: context.textTheme.titleSmall,
              ),
            );
          }

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: MasonryGridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.cartItems.value.length,
                  physics: const BouncingScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    final product = controller.cartItems.value[index];
                    return RItemCard(
                      imageUrl: product.imageUrl?['url'],
                      child: Column(
                        children: [
                          Text('${product.name}'),
                          SizedBox(height: Get.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RCircledButton.medium(
                                icon: Icons.remove,
                                onTap: () {
                                  controller.removeItemFromCart(product);
                                },
                              ),
                              SizedBox(width: Get.width * 0.02),
                              Text(
                                "${product.quantity}",
                                style: context.textTheme.titleSmall,
                              ),
                              SizedBox(width: Get.width * 0.02),
                              RCircledButton.medium(
                                icon: Icons.add,
                                onTap: () {
                                  controller.addToCart(product);
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Text.rich(
                            TextSpan(
                              text: "ETB ",
                              children: [
                                TextSpan(
                                  text: product.price ?? "",
                                  style: context.textTheme.titleMedium,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Total: ETB ",
                          children: [
                            TextSpan(
                              text: controller.totalAmount.toStringAsFixed(2),
                              style: context.textTheme.titleLarge,
                            )
                          ],
                        ),
                      ),
                      Obx(
                        () {
                          if (controller.isLoading.isTrue) {
                            return const RLoading();
                          }
                          return FilledButton(
                            onPressed: () async {
                              await controller.pay();
                            },
                            child: Text(
                              "Checkout",
                              style: context.textTheme.titleSmall!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
