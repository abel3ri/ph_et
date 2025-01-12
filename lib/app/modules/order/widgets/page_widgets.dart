import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pharma_et/app/data/models/order_model.dart';
import 'package:pharma_et/app/modules/order/controllers/order_details_controller.dart';
import 'package:pharma_et/app/modules/order/views/map_view.dart';
import 'package:pharma_et/core/widgets/buttons/r_circled_button.dart';
import 'package:pharma_et/core/widgets/buttons/r_filled_button.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildOrderHeader(OrderModel order) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SelectableText.rich(
            TextSpan(
              text: "Order ID: ",
              children: [
                TextSpan(
                  text: "${order.orderId}",
                  style: Get.textTheme.titleMedium,
                ),
              ],
            ),
          ),
          RCircledButton.medium(
            icon: order.status == 'pending'
                ? Icons.watch_later_rounded
                : order.status == 'cancelled'
                    ? Icons.close
                    : Icons.check,
            color: order.status == 'pending'
                ? Colors.yellow.shade700
                : order.status == 'cancelled'
                    ? Colors.red.shade700
                    : Colors.green.shade700,
          ),
        ],
      ),
      SizedBox(height: Get.height * 0.01),
      Align(
        alignment: Alignment.centerLeft,
        child: Text.rich(
          TextSpan(
            text: "Payment method: ",
            children: [
              TextSpan(
                text: "${order.paymentMethod?.split("_").join(" ")}",
                style: Get.context?.textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: Get.height * 0.01),
    ],
  );
}

Widget buildCreatedDate(DateTime date) {
  return Row(
    children: [
      const Icon(Icons.watch_later, size: 16),
      const SizedBox(width: 4),
      Text(
        DateFormat.yMMMd("en-US").add_jm().format(date),
      ),
    ],
  );
}

Widget buildProductList(List<dynamic> productResults, OrderModel order) {
  return ConstrainedBox(
    constraints: BoxConstraints(maxHeight: Get.height * 0.2),
    child: ListView.separated(
      controller: ScrollController(),
      itemCount: order.products?.length ?? 0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final productResult = productResults[index];
        return productResult.fold(
          (error) => const Text("Error loading product info"),
          (product) => GestureDetector(
            onTap: () {
              Get.toNamed("/product-details", arguments: {
                "productId": product.productId,
              });
            },
            child: Row(
              children: [
                Text(
                  "${order.products?[index]['quantity']}x",
                  style: Get.textTheme.titleMedium,
                ),
                SizedBox(width: Get.width * 0.02),
                CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: product.images.first?['url'] ?? '',
                  placeholder: (context, url) => const RLoading(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: 64,
                  height: 64,
                ),
                SizedBox(width: Get.width * 0.02),
                Expanded(
                  child: Text(
                    product.name,
                    overflow: TextOverflow.ellipsis,
                    style: Get.textTheme.titleMedium,
                  ),
                ),
                Text("${product.price} ETB"),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(
        height: Get.height * 0.01,
      ),
    ),
  );
}

Widget buildDeliveryAddress(String address, OrderModel order) {
  return Row(
    children: [
      const Text("Address: "),
      Expanded(
        child: SelectableText(
          address,
          style: Get.textTheme.titleSmall,
        ),
      ),
      RCircledButton.medium(
        icon: Icons.map,
        onTap: () {
          Get.to(
            () => MapView(
              position: LatLng(
                order.deliveryAddress!.latitude,
                order.deliveryAddress!.longitude,
              ),
            ),
          );
        },
      ),
    ],
  );
}

Widget buildTotalAmount(OrderModel order) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text("Total:", style: Get.textTheme.bodyMedium),
      Text.rich(
        TextSpan(
          text: "${order.totalAmount}",
          style: Get.textTheme.titleLarge,
          children: [
            TextSpan(
              text: " ETB",
              style: Get.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildUserInfo(BuildContext context, OrderModel order) {
  return Column(
    children: [
      const Divider(thickness: .3),
      Align(
        alignment: Alignment.center,
        child: Text(
          "User information",
          style: context.textTheme.titleMedium,
        ),
      ),
      SizedBox(height: Get.height * 0.02),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Full name"),
          SizedBox(width: Get.width * 0.04),
          Flexible(
            child: Text(
              '${order.userFullName}',
              style: context.textTheme.titleMedium!,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      SizedBox(height: Get.height * 0.01),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Phone number"),
          SizedBox(width: Get.width * 0.04),
          Flexible(
            child: GestureDetector(
              onTap: () async {
                await launchUrl(
                  Uri.parse('tel:${order.userPhoneNumber}'),
                );
              },
              child: Text(
                '${order.userPhoneNumber}',
                style: context.textTheme.titleMedium!.copyWith(
                  decoration: TextDecoration.underline,
                  color: Get.theme.primaryColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
      const Divider(thickness: .3),
    ],
  );
}

Widget buildReceipt(OrderModel order) {
  return Column(
    children: [
      if (order.paymentMethod == "bank_transfer") ...[
        SizedBox(height: Get.height * 0.02),
        Stack(
          children: [
            CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: order.receiptImage?['url'],
              placeholder: (context, url) => const RLoading(),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: RCircledButton.medium(
                icon: Icons.fullscreen,
                onTap: () {
                  Get.toNamed(
                    "/image-preview",
                    arguments: {
                      "imageUrl": order.receiptImage?['url'],
                      "imageType": "network_image",
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    ],
  );
}

Widget buildOrderActions(OrderModel order, OrderDetailsController controller) {
  if (order.status == 'pending') {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RFilledButton(
          fillColor: Get.theme.colorScheme.error,
          onPressed: () async {
            await controller.editOrder({
              "status": "cancelled",
            });
          },
          label: "Cancel Order",
          shape: "rounded",
        ),
        SizedBox(width: Get.width * 0.02),
        RFilledButton(
          fillColor: Get.theme.primaryColor,
          onPressed: () async {
            await controller.editOrder({
              "status": "delivered",
            });
          },
          label: "Mark Delivered",
          shape: "rounded",
        ),
      ],
    );
  } else if (order.status == 'cancelled') {
    return Center(
      child: RFilledButton(
        fillColor: Get.theme.primaryColor,
        onPressed: () async {
          await controller.editOrder({
            "status": "pending",
          });
        },
        label: "Re-create order",
        shape: "rounded",
      ),
    );
  }

  return const SizedBox.shrink();
}
