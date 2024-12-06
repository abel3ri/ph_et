import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/category_model.dart';
import 'package:pharma_et/app/data/models/sub_Category_model.dart';
import 'package:pharma_et/app/data/services/sub_category_service.dart';

class CategoryController extends GetxController {
  final scrollController = ScrollController();
  final scrollOffset = 0.0.obs;
  final searchController = TextEditingController();

  Rx<List<SubCategoryModel>> subCategories = Rx<List<SubCategoryModel>>([]);
  Rx<List<SubCategoryModel>> filteredSubCategories =
      Rx<List<SubCategoryModel>>([]);
  RxMap<String, int> subCategoryProductCounts = <String, int>{}.obs;
  Rx<bool> isLoading = false.obs;

  CategoryModel? selectedCategory;
  late SubCategoryService subCategoryService;
  StreamSubscription? subCategorySubscription;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      scrollOffset.value = scrollController.offset;
    });
    searchController.addListener(_onSearchChanged);
    selectedCategory = Get.arguments?['category'];
    subCategoryService = Get.find<SubCategoryService>();

    if (selectedCategory != null) {
      watchSubCategories();
    }
  }

  void _onSearchChanged() {
    applySearch(searchController.text.trim());
  }

  void applySearch(String query) {
    if (query.isEmpty) {
      filteredSubCategories.value = subCategories.value;
    } else {
      filteredSubCategories.value = subCategories.value
          .where((subCategory) =>
              subCategory.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void watchSubCategories() {
    isLoading(true);
    subCategorySubscription = subCategoryService
        .watchAllSubCategories(selectedCategory!.categoryId!)
        .listen((event) {
      isLoading(false);
      event.fold(
        (l) => l.showError(),
        (r) async {
          subCategories.value = r;
          filteredSubCategories.value = r;
          await _fetchProductCounts();
        },
      );
    });
  }

  Future<void> _fetchProductCounts() async {
    for (final subCategory in subCategories.value) {
      final count = await subCategoryService
          .countProductsInSubCategory(subCategory.subCategoryId!);
      subCategoryProductCounts[subCategory.subCategoryId!] = count;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    subCategorySubscription?.cancel();
    super.onClose();
  }
}
