import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/modules/sub_category/controllers/sub_category_controller.dart';
import 'package:pharma_et/core/widgets/buttons/r_circled_button.dart';
import 'package:pharma_et/core/widgets/cards/r_card.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';
import 'package:pharma_et/core/widgets/indicators/r_not_found.dart';
import 'package:pharma_et/core/widgets/placeholders/r_circled_image_avatar.dart';
import 'package:pharma_et/core/widgets/shimmers/grids/r_item_card_shimmer_grid.dart';
import 'package:pharma_et/core/widgets/sliders/r_carousel_slider.dart';
import 'package:pharma_et/core/widgets/text_fields/r_styled_search_input_field.dart';
import 'package:readmore/readmore.dart';

class SubCategoryView extends GetView<SubCategoryController> {
  const SubCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: controller.scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: Get.height * 0.3,
            automaticallyImplyLeading: false,
            elevation: 0,
            pinned: true,
            stretch: true,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl:
                        controller.selectedCategory?.imageUrl?['url'] ?? "",
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.error,
                        size: 32,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 32,
                    left: 16,
                    child: RCircledButton.large(
                      icon: Icons.arrow_back,
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Obx(() {
                    final isScrolled = controller.scrollOffset.value > 100;
                    return Text(
                      "${controller.selectedCategory?.name}",
                      style: context.textTheme.titleLarge?.copyWith(
                        color: Get.isDarkMode
                            ? Colors.white
                            : isScrolled
                                ? Colors.black
                                : Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ReadMoreText(
                '${controller.selectedCategory?.description}',
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: Obx(
              () {
                if (controller.isLoading.isTrue) {
                  return const SliverToBoxAdapter(
                    child: RItemCardShimmerGrid(),
                  );
                }

                if (controller.subCategories.value.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: RNotFound(
                      message: "No sub category found!",
                    ),
                  );
                }
                return SliverList.separated(
                  itemCount: controller.filteredSubCategories.value.length + 2,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Search Bar
                      return Row(
                        children: [
                          Expanded(
                            child: RStyledSearchBar(
                              hintText: "Search categories...",
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
                      );
                    }

                    if (index ==
                        (controller.filteredSubCategories.value.length ~/ 2) +
                            1) {
                      return Obx(
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
                                  .homeController
                                  .currentDynamicAdIndex
                                  .value = index,
                              currentIndex: controller
                                  .homeController.currentDynamicAdIndex,
                            ),
                          );
                        },
                      );
                    }

                    final adjustedIndex = index >
                            (controller.filteredSubCategories.value.length ~/
                                    2) +
                                1
                        ? index - 2
                        : index - 1;

                    final subCategory =
                        controller.filteredSubCategories.value[adjustedIndex];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed("/products", arguments: {
                          "subCategory": subCategory,
                        });
                      },
                      child: RCard(
                        child: Row(
                          children: [
                            RCircledImageAvatar.medium(
                              fallBackText: "Image",
                              imageUrl: subCategory.imageUrl?['url'],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${subCategory.name}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.textTheme.titleMedium,
                                  ),
                                  Text(
                                    "${subCategory.productCount ?? "N/A"} Product(s)",
                                    style: context.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            const RCircledButton.medium(
                              icon: Icons.arrow_right_alt_outlined,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      SizedBox(height: Get.height * 0.02),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
