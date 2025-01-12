import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/order_model.dart';
import 'package:pharma_et/app/data/models/success_model.dart';
import 'package:pharma_et/app/data/services/order_service.dart';
import 'package:pharma_et/app/data/services/product_item_service.dart';
import 'package:pharma_et/core/controllers/auth_controller.dart';
import 'package:pharma_et/core/widgets/dialogs/r_show_dialog.dart';

class OrderController extends GetxController {
  late PageController pageController;

  StreamSubscription? orderSubscription;

  Rx<List<OrderModel>> nonActiveOrders = Rx<List<OrderModel>>([]);
  Rx<List<OrderModel>> activeOrders = Rx<List<OrderModel>>([]);

  RxBool isLoading = false.obs;
  RxInt activeIndex = 0.obs;

  late OrderService orderService;
  late ProductItemService productItemService;
  late AuthController authController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(keepPage: true);

    orderService = Get.find<OrderService>();
    productItemService = Get.find<ProductItemService>();
    authController = Get.find<AuthController>();

    watchOrders();
  }

  void changePage(int index) {
    activeIndex.value = index;
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    activeIndex.value = index;
  }

  void watchOrders() {
    isLoading(true);
    orderSubscription = orderService
        .watchAllOrdersByUser(
      authController.currentUser.value!.userId!,
    )
        .listen((event) {
      isLoading(false);
      event.fold(
        (l) => l.showError(),
        (r) async {
          activeOrders.value =
              r.where((order) => order.status == "pending").toList();
          nonActiveOrders.value =
              r.where((order) => order.status != "pending").toList();

          activeOrders.refresh();
          nonActiveOrders.refresh();
        },
      );
    });
  }

  Future<String> getPlaceName(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.name}, ${place.locality}, ${place.country}";
      } else {
        return "No place found";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<void> cancelOrder(String orderId) async {
    final result = await rShowDialog(
      title: "Cancel Order",
      content: "Are you sure you want to cancel this order?",
      mainActionLabel: "Cancel Order",
      cancelLabel: "Close",
    );

    if (result ?? false) {
      final res = await orderService.updateOrder(
        orderId,
        {"status": "cancelled"},
      );

      res.fold((l) {
        l.showError();
      }, (r) {
        SuccessModel(body: "Order cancelled successfully").showSuccess();
      });
    }
  }

  Future<void> recreateOrder(OrderModel order) async {
    order.status = 'pending';
    final res = await orderService.createOrder(order);
    res.fold((l) {
      l.showError();
    }, (r) {
      SuccessModel(body: "Order created successfully").showSuccess();
    });
  }

  @override
  void onClose() {
    super.onClose();
    orderSubscription?.cancel();
    pageController.dispose();
  }
}
