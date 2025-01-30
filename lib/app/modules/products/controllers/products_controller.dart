import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/product_item_model.dart';
import 'package:pharma_et/app/data/models/sub_Category_model.dart';
import 'package:pharma_et/app/data/services/product_item_service.dart';
import 'package:pharma_et/app/modules/cart/controllers/cart_controller.dart';
import 'package:pharma_et/app/modules/home/controllers/home_controller.dart';

class ProductsController extends GetxController {
  static const int limit = 6;

  late ProductItemService productItemService;
  late CartController cartController;
  late HomeController homeController;

  SubCategoryModel? selectedSubCategory;
  StreamSubscription? productSubscription;
  final ScrollController scrollController = ScrollController();

  RxBool isLoading = false.obs;
  RxBool hasNext = true.obs;
  RxList<ProductItemModel> products = RxList<ProductItemModel>([]);

  @override
  void onInit() {
    super.onInit();
    selectedSubCategory = Get.arguments?['subCategory'];
    productItemService = Get.find<ProductItemService>();
    cartController = Get.find<CartController>();
    homeController = Get.find<HomeController>();
    scrollController.addListener(scrollListener);
    if (selectedSubCategory != null) {
      fetchPagedProducts();
    }
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      if (hasNext.isTrue) {
        fetchPagedProducts();
      }
    }
  }

  Future<void> fetchPagedProducts() async {
    if (selectedSubCategory == null || isLoading.isTrue) return;
    isLoading(true);
    final res = await productItemService.findAllProducts(
      selectedSubCategory!.subCategoryId!,
      lastDocument: products.isNotEmpty ? products.last.documentSnapshot : null,
      limit: limit,
    );
    isLoading(false);
    res.fold((l) {
      l.showError();
    }, (r) {
      products.addAll(r);
      if (r.length < limit) hasNext(false);
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    productSubscription?.cancel();
    super.onClose();
  }
}
