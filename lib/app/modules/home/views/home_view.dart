import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/modules/home/widgets/home_app_bar.dart';
import 'package:pharma_et/app/modules/home/widgets/r_banner_item.dart';
import 'package:pharma_et/core/widgets/buttons/r_circled_button.dart';
import 'package:pharma_et/core/widgets/cards/r_item_card.dart';
import 'package:pharma_et/core/widgets/indicators/r_not_found.dart';
import 'package:pharma_et/core/widgets/indicators/r_page_indicator.dart';
import 'package:pharma_et/core/widgets/shimmers/grids/r_item_card_shimmer_grid.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Obx(() {
            if (controller.isLoading.isTrue) {
              return const RItemCardShimmerGrid();
            }

            if (controller.categories.value.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 8),
                    RNotFound(
                      message: "No Category Found!",
                    ),
                  ],
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
                          Get.toNamed("/category", arguments: {
                            "category": category,
                          });
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
                  _buildBannerCarousel(controller),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 32,
                      child: RPageIndicator(
                        controller: controller,
                        itemCount: 3,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBannerCarousel(HomeController controller) {
    final banners = [
      {
        "imageUrl":
            "https://buynatural.com.au/wp-content/uploads/2024/05/DALL%C2%B7E-2024-05-20-21.15.31-A-vibrant-and-engaging-image-featuring-a-variety-of-natural-health-and-wellness-products-arranged-aesthetically.-Include-items-such-as-organic-turmeri.webp",
        "label": "Your Health, Our Priority!",
      },
      {
        "imageUrl":
            "https://newlifeclinic.bg/wp-content/uploads/2022/11/Untitled-design-2-900x390.png",
        "label": "Gentle Care for Your Little Ones",
      },
      {
        "imageUrl":
            "https://cdn.sanity.io/images/l5pf5h4v/store/e73a2ba87c91a0c43563110711ba05a807794b36-2240x1260.jpg?w=1088&h=612&fit=max&auto=format",
        "label": "Fuel Your Workouts with the Best Protein",
      },
    ];

    return CarouselSlider(
      items: banners
          .map((banner) => RBannerItem(
                imageUrl: banner['imageUrl']!,
                label: banner['label']!,
              ))
          .toList(),
      options: CarouselOptions(
        onPageChanged: (index, reason) => controller.currentIndex.value = index,
        viewportFraction: 1,
        enlargeCenterPage: true,
        autoPlay: true,
        height: 128,
      ),
    );
  }
}
