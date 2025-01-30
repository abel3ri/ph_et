import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/modules/products/controllers/products_controller.dart';
import 'package:pharma_et/core/widgets/badges/r_cart_item_badge.dart';
import 'package:pharma_et/core/widgets/buttons/r_circled_button.dart';
import 'package:pharma_et/core/widgets/cards/r_item_card.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';
import 'package:pharma_et/core/widgets/indicators/r_not_found.dart';
import 'package:pharma_et/core/widgets/sliders/r_carousel_slider.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 28,
          ),
        ),
        title: Text(
          '${controller.selectedSubCategory?.name}',
          style: context.textTheme.titleMedium,
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed("/cart", arguments: {
                "hasPreviousPage": true,
              });
            },
            child: const RCartItemBadge(),
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.products.isEmpty && !controller.isLoading.value) {
            return const RNotFound(
              message: "Product not found!",
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              controller.products.clear();
              controller.hasNext(true);
              await controller.fetchPagedProducts();
            },
            child: Column(
              children: [
                Obx(
                  () {
                    if (controller.homeController.isAdLoading.isTrue) {
                      return const Center(
                        child: RLoading(),
                      );
                    }
                    if (controller.homeController.ads.value.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: RCarouselSlider(
                        ads: controller.homeController.ads.value,
                        onPageChanged: (index, reason) => controller
                            .homeController.currentDynamicAdIndex.value = index,
                        currentIndex:
                            controller.homeController.currentDynamicAdIndex,
                      ),
                    );
                  },
                ),
                Expanded(
                  child: MasonryGridView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    controller: controller.scrollController,
                    itemCount: controller.products.length +
                        (controller.hasNext.value ? 1 : 0),
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemBuilder: (context, index) {
                      if (index >= controller.products.length) {
                        return const Center(
                          child: RLoading(),
                        );
                      }
                      final product = controller.products[index];
                      return RItemCard(
                        onTap: () {
                          Get.toNamed("/product-details", arguments: {
                            "productId": product.productId,
                          });
                        },
                        imageUrl: product.images?.first['url'],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product.name}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.titleSmall,
                            ),
                            SizedBox(height: Get.height * 0.01),
                            Row(
                              children: [
                                Text(
                                  "${product.averageRating?.toStringAsFixed(1)}",
                                  style: context.textTheme.titleLarge,
                                ),
                                Icon(
                                  Icons.star_rounded,
                                  color: Get.theme.primaryColor,
                                ),
                                Expanded(
                                  child: Text(
                                    "(${product.totalRatings ?? 0} reviews)",
                                    style: context.textTheme.bodySmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: Get.height * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  TextSpan(text: "ETB ", children: [
                                    TextSpan(
                                      text: product.price ?? "",
                                      style: context.textTheme.titleMedium,
                                    )
                                  ]),
                                ),
                                Obx(
                                  () {
                                    final bool isInCart = controller
                                        .cartController.cartItems.value
                                        .any((prod) =>
                                            prod.productId ==
                                            product.productId);

                                    return RCircledButton.medium(
                                      icon: isInCart ? Icons.remove : Icons.add,
                                      onTap: () {
                                        if (isInCart) {
                                          controller.cartController
                                              .removeItemFromCart(product);
                                        } else {
                                          controller.cartController
                                              .addToCart(product);
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
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
