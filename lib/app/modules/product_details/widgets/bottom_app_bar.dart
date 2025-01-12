import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/data/models/success_model.dart';
import 'package:pharma_et/app/modules/product_details/controllers/product_details_controller.dart';
import 'package:pharma_et/core/widgets/buttons/r_circled_button.dart';
import 'package:pharma_et/core/widgets/buttons/r_filled_button.dart';

Widget buildBottomAppBar(product, ProductDetailsController controller) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
    child: Row(
      children: [
        Expanded(
          child: Obx(
            () => RFilledButton(
              onPressed: () {
                if (controller.authController.currentUser.value != null) {
                  Get.toNamed("/product-details/review-form", arguments: {
                    "productId": controller.productId,
                    "isEditing": false,
                  });
                }
              },
              label: controller.authController.currentUser.value != null
                  ? "Write a review"
                  : "Login or Sign up to make review",
              shape: "rounded",
            ),
          ),
        ),
        SizedBox(width: Get.width * 0.02),
        RCircledButton.large(
          icon: Icons.add_shopping_cart_rounded,
          onTap: () {
            if (controller.authController.currentUser.value == null) {
              ErrorModel(body: "Please login to access this feature")
                  .showError();
              return;
            }
            final bool isInCart = controller.cartController.cartItems.value.any(
              (prod) => prod.productId == product.productId,
            );

            if (!isInCart) {
              controller.cartController.addToCart(product);
              SuccessModel(body: "Product added to cart").showSuccess();
            } else {
              SuccessModel(body: "Product is already added to cart")
                  .showSuccess();
            }
          },
        ),
      ],
    ),
  );
}
