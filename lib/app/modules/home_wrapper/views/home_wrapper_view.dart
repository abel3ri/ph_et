import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pharma_et/app/modules/cart/controllers/cart_controller.dart';
import 'package:pharma_et/app/modules/cart/views/cart_view.dart';
import 'package:pharma_et/app/modules/home/views/home_view.dart';
import 'package:pharma_et/app/modules/home_wrapper/widgets/r_navigation_destination.dart';
import 'package:pharma_et/app/modules/profile/views/profile_view.dart';
import 'package:pharma_et/app/modules/search/views/search_view.dart';

import '../controllers/home_wrapper_controller.dart';

class HomeWrapperView extends GetView<HomeWrapperController> {
  const HomeWrapperView({super.key});
  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.index.value,
          children: const [
            HomeView(),
            SearchView(),
            CartView(),
            ProfileView(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Obx(
              () => NavigationBar(
                onDestinationSelected: controller.onPageChanged,
                selectedIndex: controller.index.value,
                backgroundColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                height: 56,
                destinations: [
                  const RNavigationDestination(
                    iconPath: "assets/dev-icons/house.svg",
                    label: "Home",
                    selectedIconPath: "assets/dev-icons/house-fill.svg",
                  ),
                  const RNavigationDestination(
                    iconPath: "assets/dev-icons/magnifying-glass.svg",
                    label: "Search",
                    selectedIconPath:
                        "assets/dev-icons/magnifying-glass-fill.svg",
                  ),
                  Stack(
                    children: [
                      const RNavigationDestination(
                        iconPath: "assets/dev-icons/shopping-cart-simple.svg",
                        label: "Cart",
                        selectedIconPath:
                            "assets/dev-icons/shopping-cart-simple-fill.svg",
                      ),
                      Positioned(
                        top: 6,
                        right: 18,
                        child: Obx(
                          () {
                            final cartItemCount =
                                cartController.cartItems.value.length;
                            return cartItemCount > 0
                                ? CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: cartItemCount > 9 ? 10 : 8,
                                    child: Text(
                                      cartItemCount > 9
                                          ? "$cartItemCount"
                                          : "$cartItemCount",
                                      style:
                                          context.textTheme.bodySmall!.copyWith(
                                        color: Get.theme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: cartItemCount > 9 ? 10 : 12,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                  const RNavigationDestination(
                    iconPath: "assets/dev-icons/user.svg",
                    label: "Profile",
                    selectedIconPath: "assets/dev-icons/user-fill.svg",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
