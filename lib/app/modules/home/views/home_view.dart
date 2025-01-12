import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/modules/home/widgets/home_app_bar.dart';
import 'package:pharma_et/core/widgets/buttons/r_circled_button.dart';
import 'package:pharma_et/core/widgets/cards/r_item_card.dart';
import 'package:pharma_et/core/widgets/dialogs/r_show_dialog.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';
import 'package:pharma_et/core/widgets/indicators/r_not_found.dart';
import 'package:pharma_et/core/widgets/shimmers/grids/r_item_card_shimmer_grid.dart';
import 'package:pharma_et/core/widgets/sliders/r_carousel_slider.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await rShowDialog(
          title: "Exit App",
          content: "Are you sure you want to exit the app?",
          mainActionLabel: "Exit",
        );
        if (context.mounted && shouldExit == true) {
          if (GetPlatform.isAndroid) {
            SystemNavigator.pop();
          } else if (GetPlatform.isIOS) {
            exit(0);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(32),
            child: HomeAppBar(),
          ),
          surfaceTintColor: Colors.transparent,
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => Future.sync(() => controller.fetchCategories()),
            child: Obx(
              () {
                if (controller.isLoading.isTrue) {
                  return const RItemCardShimmerGrid();
                }

                if (controller.categories.value.isEmpty) {
                  return const Center(
                    child: RNotFound(
                      message: "No Category Found!",
                    ),
                  );
                }

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Categories", style: context.textTheme.titleMedium),
                      SizedBox(height: Get.height * 0.02),
                      MasonryGridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.categories.value.length,
                        shrinkWrap: true,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) {
                          final category = controller.categories.value[index];
                          return RItemCard(
                            onTap: () {
                              if (category.name?.toLowerCase() ==
                                  'consultation') {
                                Get.toNamed("/consultation");
                              } else {
                                Get.toNamed("/category", arguments: {
                                  "category": category,
                                });
                              }
                            },
                            imageUrl: category.imageUrl?['url'] ?? "",
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    category.name ?? "No Name",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.textTheme.titleSmall,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const RCircledButton.small(
                                  icon: Icons.arrow_right_alt_rounded,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Obx(
                        () {
                          if (controller.isAdLoading.isTrue) {
                            return const RLoading();
                          }
                          if (controller.ads.value.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return RCarouselSlider(
                            ads: controller.ads.value,
                            onPageChanged: (index, reason) =>
                                controller.currentDynamicAdIndex.value = index,
                            currentIndex: controller.currentDynamicAdIndex,
                          );
                        },
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Text(
                        "Top Picks",
                        style: context.textTheme.titleMedium,
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Obx(
                        () {
                          if (controller.isTopPicksLoading.isTrue) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (controller.topPicks.value.isEmpty) {
                            return const Center(
                              child: Text("No top picks available!"),
                            );
                          }
                          return MasonryGridView.builder(
                            mainAxisSpacing: 16,
                            shrinkWrap: true,
                            crossAxisSpacing: 8,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.topPicks.value.length,
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) {
                              final product = controller.topPicks.value[index];
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
                                            "(${product.totalRatings} reviews)",
                                            style: context.textTheme.bodySmall,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: Get.height * 0.01),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text.rich(
                                          TextSpan(text: "ETB ", children: [
                                            TextSpan(
                                              text: product.price ?? "",
                                              style:
                                                  context.textTheme.titleMedium,
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
                                              icon: isInCart
                                                  ? Icons.remove
                                                  : Icons.add,
                                              onTap: () {
                                                if (isInCart) {
                                                  controller.cartController
                                                      .removeItemFromCart(
                                                          product);
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
