import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/modules/product_details/widgets/bottom_app_bar.dart';
import 'package:pharma_et/app/modules/product_details/widgets/rating_list.dart';
import 'package:pharma_et/app/modules/product_details/widgets/review_summary.dart';
import 'package:pharma_et/app/modules/product_details/widgets/sliver_app_bar.dart';
import 'package:pharma_et/core/widgets/buttons/r_circled_button.dart';
import 'package:readmore/readmore.dart';

import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.product.value == null) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
            ),
          ),
          body: const Center(
            child: Text("Product not found"),
          ),
        );
      }

      final product = controller.product.value!;
      return Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: CustomScrollView(
                controller: controller.scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  buildSliverAppBar(product, controller),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${product.name}',
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textTheme.titleLarge,
                                ),
                              ),
                              SizedBox(width: Get.width * 0.02),
                              Text.rich(
                                TextSpan(
                                  text: "ETB ",
                                  children: [
                                    TextSpan(
                                      text: "${product.price}",
                                      style: context.textTheme.titleLarge!
                                          .copyWith(
                                        color: Get.theme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: Get.height * 0.01),
                          ReadMoreText(
                            product.description != null
                                ? '${product.description}'
                                : "Description not available",
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Text(
                            "Ingredients",
                            style: context.textTheme.titleMedium,
                          ),
                          SizedBox(height: Get.height * 0.01),
                          if (product.ingredients == null)
                            const Text(
                                "Ingredients not specified for this product")
                          else
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    const RCircledButton.small(
                                      icon: Icons.check,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${product.ingredients?[index]}',
                                      style: context.textTheme.titleSmall,
                                    )
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                height: Get.height * 0.01,
                              ),
                              itemCount: product.ingredients?.length ?? 0,
                            ),
                          SizedBox(height: Get.height * 0.02),
                          Obx(
                            () => controller.isLoading.isFalse
                                ? ReviewSummary(
                                    averageRating: product.averageRating ?? 0.0,
                                    totalRatings: product.totalRatings ?? 0,
                                    ratingDistribution:
                                        controller.getRatingDistribution(),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          SizedBox(height: Get.height * 0.04),
                          buildRatingList(controller),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            buildBottomAppBar(product, controller),
          ],
        ),
      );
    });
  }
}
