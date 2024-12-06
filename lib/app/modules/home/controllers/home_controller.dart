import 'dart:async';

import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/category_model.dart';
import 'package:pharma_et/app/data/services/category_service.dart';

class HomeController extends GetxController {
  Rx<int> currentIndex = 0.obs;
  Rx<List<CategoryModel>> categories = Rx<List<CategoryModel>>([]);
  Rx<bool> isLoading = false.obs;

  late CategoryService categoryService;
  StreamSubscription? categorySubscription;

  @override
  void onInit() {
    super.onInit();
    categoryService = Get.find<CategoryService>();
    fetchCategoriesStream();
  }

  void fetchCategoriesStream() {
    isLoading(true);
    categorySubscription = categoryService.watchAllCategories().listen((res) {
      res.fold(
        (l) {
          isLoading(false);
          l.showError();
        },
        (r) {
          categories.value = r;
          isLoading(false);
        },
      );
    });
  }

  Future<void> fetchCategories() async {
    isLoading(true);
    final res = await categoryService.findAllCategories();
    isLoading(false);

    res.fold(
      (l) => l.showError(),
      (r) => categories.value = r,
    );
  }

  Future<void> refreshCategories() async {
    await categorySubscription?.cancel();
    fetchCategoriesStream();
  }

  @override
  void onClose() {
    categorySubscription?.cancel();
    super.onClose();
  }
}
