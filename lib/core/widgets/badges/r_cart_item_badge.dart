import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/modules/cart/controllers/cart_controller.dart';

class RCartItemBadge extends StatelessWidget {
  const RCartItemBadge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.shopping_cart, size: 36),
          Positioned(
            top: 0,
            right: 0,
            child: Obx(
              () {
                final cartItemCount = cartController.cartItems.value.length;
                return cartItemCount > 0
                    ? CircleAvatar(
                        backgroundColor: Get.theme.colorScheme.error,
                        radius: cartItemCount > 9 ? 10 : 8,
                        child: Text(
                          cartItemCount > 9
                              ? "$cartItemCount"
                              : "$cartItemCount",
                          style: context.textTheme.bodySmall!.copyWith(
                            color: Colors.white,
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
    );
  }
}
