import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pharma_et/app/modules/cart/controllers/cart_controller.dart';
import 'package:pharma_et/core/widgets/buttons/r_circled_button.dart';
import 'package:pharma_et/core/widgets/cards/r_item_card.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';
import 'package:pharma_et/core/widgets/indicators/r_not_found.dart';
import 'package:readmore/readmore.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller.searchController,
          onChanged: controller.searchProducts,
          decoration: InputDecoration(
            hintText: "Search Products...",
            hintStyle: context.textTheme.bodyLarge!.copyWith(
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Get.theme.primaryColor,
                width: 2.0, // Border width
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Get.theme.primaryColor,
                width: 2.0, // Border width
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Get.theme.primaryColor,
                width: 2.0,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20.0,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              if (controller.isLoading.value) {
                return Center(child: RLoading());
              }

              if (controller.searchController.text.isEmpty &&
                  controller.searchResults.isEmpty &&
                  controller.animateSearchLottie.isTrue) {
                return Center(
                  child: Lottie.asset(
                    "assets/lotties/search.json",
                  ),
                );
              }
              if (controller.searchResults.isEmpty) {
                return const RNotFound(
                  message: "No product found!",
                );
              }

              return MasonryGridView.builder(
                mainAxisSpacing: 16,
                shrinkWrap: true,
                crossAxisSpacing: 8,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.searchResults.length,
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  final product = controller.searchResults[index];
                  return RItemCard(
                    imageUrl: product.imageUrl?['url'],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${product.name}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleSmall,
                        ),
                        ReadMoreText(
                          '${product.description}',
                          trimExpandedText: "less",
                          trimMode: TrimMode.Line,
                          trimCollapsedText: "more",
                          trimLines: 2,
                          delimiter: "...",
                        ),
                        SizedBox(height: Get.height * 0.02),
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
                                final bool isInCart =
                                    cartController.cartItems.value.any((prod) =>
                                        prod.productId == product.productId);

                                return RCircledButton.medium(
                                  icon: isInCart ? Icons.remove : Icons.add,
                                  onTap: () {
                                    if (isInCart) {
                                      cartController
                                          .removeItemFromCart(product);
                                    } else {
                                      cartController.addToCart(product);
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
            }),
          ],
        ),
      ),
    );
  }
}
