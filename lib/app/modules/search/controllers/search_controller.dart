import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/data/models/product_item_model.dart';
import 'package:pharma_et/app/data/services/product_item_service.dart';
import 'package:pharma_et/app/modules/cart/controllers/cart_controller.dart';

class SearchController extends GetxController {
  late ProductItemService productItemService;
  late CartController cartController;
  final RxList<ProductItemModel> searchResults = <ProductItemModel>[].obs;
  final RxBool isLoading = false.obs;

  final searchController = TextEditingController();

  final RxString query = ''.obs;
  Rx<bool> animateSearchLottie = true.obs;

  @override
  void onInit() {
    super.onInit();
    productItemService = Get.find<ProductItemService>();
    cartController = Get.find<CartController>();

    debounce<String>(
      query,
      (value) => searchProducts(value),
      time: const Duration(milliseconds: 500),
    );
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isLoading.value = true;
    final result = await productItemService.findAll(
      collectionPath: "products",
      queryBuilder: productItemService.db
          .collection("products")
          .where("name", isGreaterThanOrEqualTo: query)
          .where(
            "name",
            isLessThanOrEqualTo: '$query\uf8ff',
          ),
    );
    result.fold(
      (ErrorModel error) {
        searchResults.clear();
      },
      (List<ProductItemModel> products) {
        searchResults.value = products;
      },
    );
    isLoading.value = false;
  }

  void onSearchChanged(String newValue) {
    query.value = newValue;
  }

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
  }
}
