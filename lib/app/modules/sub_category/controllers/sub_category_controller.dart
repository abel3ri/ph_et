import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/product_item_model.dart';
import 'package:pharma_et/app/data/models/sub_Category_model.dart';
import 'package:pharma_et/app/data/services/product_item_service.dart';

class SubCategoryController extends GetxController {
  Rx<List<ProductItemModel>> products = Rx<List<ProductItemModel>>([]);
  Rx<List<ProductItemModel>> filteredProducts = Rx<List<ProductItemModel>>([]);
  Rx<bool> isLoading = false.obs;

  SubCategoryModel? selectedSubCategory;
  late ProductItemService productItemService;
  StreamSubscription? productSubscription;

  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    selectedSubCategory = Get.arguments?['subCategory'];

    productItemService = Get.find<ProductItemService>();

    if (selectedSubCategory != null) {
      watchProducts();
    }

    searchController.addListener(() {
      applySearch(searchController.text);
    });
  }

  void watchProducts() {
    isLoading(true);
    productSubscription = productItemService
        .watchAllProducts(selectedSubCategory!.subCategoryId!)
        .listen((event) {
      isLoading(false);
      event.fold(
        (l) => l.showError(),
        (r) {
          products.value = r;
          filteredProducts.value = r;
        },
      );
    });
  }

  Future<void> fetchProducts() async {
    if (selectedSubCategory == null) return;

    isLoading(true);
    final res = await productItemService.findAllProducts(
      selectedSubCategory!.subCategoryId!,
    );
    isLoading(false);

    res.fold(
      (l) => l.showError(),
      (r) {
        products.value = r;
        filteredProducts.value = r;
      },
    );
  }

  void applySearch(String query) {
    if (query.isEmpty) {
      filteredProducts.value = products.value;
    } else {
      filteredProducts.value = products.value
          .where((product) =>
              product.name?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .toList();
    }
  }

  Future<void> refreshProducts() async {
    await productSubscription?.cancel();
    watchProducts();
  }

  @override
  void onClose() {
    productSubscription?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
