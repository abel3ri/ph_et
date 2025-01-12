import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/modules/cart/widgets/r_radio_list_tile.dart';
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
        automaticallyImplyLeading: false,
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
                      onTap: () {
                        Get.toNamed("/product-details", arguments: {
                          "productId": product.productId,
                        });
                      },
                      imageUrl: product.images?.first['url'],
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
                        () => controller.isLoading.isTrue
                            ? const RLoading()
                            : FilledButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    showDragHandle: true,
                                    context: context,
                                    builder: (context) => Wrap(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Choose Payment Option",
                                                style: context
                                                    .textTheme.titleMedium,
                                              ),
                                              const SizedBox(height: 12),
                                              RRadioListTile(
                                                controller: controller,
                                                label: "Digital Payment",
                                                iconPath:
                                                    "assets/dev-icons/chapa.svg",
                                                value: "digital_payment",
                                                subtitle:
                                                    "Pay with telebirr, CBE, Amole, Card payment, and many more!",
                                              ),
                                              const SizedBox(height: 12),
                                              RRadioListTile(
                                                controller: controller,
                                                label: "Cash on Delivery",
                                                iconPath:
                                                    "assets/dev-icons/money.svg",
                                                value: "cash_on_delivery",
                                              ),
                                              const SizedBox(height: 12),
                                              RRadioListTile(
                                                controller: controller,
                                                label: "Bank Transfer",
                                                iconPath:
                                                    "assets/dev-icons/bank.svg",
                                                value: "bank_transfer",
                                              ),
                                              const SizedBox(height: 12),
                                              Obx(
                                                () => controller
                                                        .isLoading.isTrue
                                                    ? const RLoading()
                                                    : FilledButton(
                                                        onPressed: () async {
                                                          Get.back();
                                                          Get.toNamed(
                                                            "/cart/checkout",
                                                          );
                                                        },
                                                        child: Text(
                                                          "Proceed",
                                                          style: context
                                                              .textTheme
                                                              .titleSmall!
                                                              .copyWith(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                              const SizedBox(height: 8),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Text(
                                  "Checkout",
                                  style: context.textTheme.titleSmall!.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
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
