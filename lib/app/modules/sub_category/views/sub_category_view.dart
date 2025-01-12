import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import 'package:pharma_et/core/widgets/badges/r_cart_item_badge.dart';
import 'package:pharma_et/core/widgets/buttons/r_circled_button.dart';
import 'package:pharma_et/core/widgets/cards/r_item_card.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';
import 'package:pharma_et/core/widgets/indicators/r_not_found.dart';
import 'package:pharma_et/core/widgets/shimmers/grids/r_item_card_shimmer_grid.dart';
import 'package:pharma_et/core/widgets/sliders/r_carousel_slider.dart';
import 'package:pharma_et/core/widgets/text_fields/r_styled_search_input_field.dart';

import '../controllers/sub_category_controller.dart';

class SubCategoryView extends GetView<SubCategoryController> {
  const SubCategoryView({super.key});
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
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => controller.fetchProducts()),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: RStyledSearchBar(
                      hintText: "Search products...",
                      searchController: controller.searchController,
                      onSubmitted: (value) {
                        controller.applySearch(value);
                      },
                      onClear: () {
                        controller.searchController.clear();
                        controller.applySearch("");
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
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
                    padding: const EdgeInsets.only(top: 8),
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
              SizedBox(height: Get.height * 0.02),
              Obx(
                () {
                  if (controller.isLoading.isTrue) {
                    return const RItemCardShimmerGrid();
                  }
                  if (controller.filteredProducts.value.isEmpty) {
                    return const RNotFound(
                      message: "No Product Found!",
                    );
                  }
                  return MasonryGridView.builder(
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    crossAxisSpacing: 8,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.filteredProducts.value.length,
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      final product = controller.filteredProducts.value[index];
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
