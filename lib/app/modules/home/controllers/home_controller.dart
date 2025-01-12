import 'dart:async';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/ad_model.dart';
import 'package:pharma_et/app/data/models/category_model.dart';
import 'package:pharma_et/app/data/models/product_item_model.dart';
import 'package:pharma_et/app/data/services/ad_service.dart';
import 'package:pharma_et/app/data/services/category_service.dart';
import 'package:pharma_et/app/data/services/product_item_service.dart';
import 'package:pharma_et/app/modules/cart/controllers/cart_controller.dart';

class HomeController extends GetxController {
  RxInt currentStaticAdIndex = 0.obs;
  Rx<List<CategoryModel>> categories = Rx<List<CategoryModel>>([]);
  Rx<List<AdModel>> ads = Rx<List<AdModel>>([]);
  Rx<List<ProductItemModel>> topPicks = Rx<List<ProductItemModel>>([]);
  RxBool isTopPicksLoading = false.obs;

  Rx<bool> isLoading = false.obs;
  RxInt currentDynamicAdIndex = 0.obs;
  RxBool isAdLoading = false.obs;

  late CategoryService categoryService;
  late ProductItemService productItemService;
  late AdService adService;
  late CartController cartController;

  StreamSubscription? adSubscription;
  StreamSubscription? categorySubscription;
  StreamSubscription? topPicksSubscription;

  @override
  void onInit() {
    super.onInit();
    categoryService = Get.find<CategoryService>();
    productItemService = Get.find<ProductItemService>();
    adService = Get.find<AdService>();
    cartController = Get.find<CartController>();

    fetchCategories();
    fetchAdsStream();
    fetchTopPicksStream();
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

  void fetchAdsStream() {
    isAdLoading(true);
    adSubscription = adService.watchAllAds().listen((res) {
      isAdLoading(false);
      res.fold(
        (l) {
          l.showError();
        },
        (r) {
          ads.value = r
              .where(
                (ad) => ad.endDate!.isAfter(DateTime.now()),
              )
              .toList();
        },
      );
    });
  }

  double calculateWeightedScore(double averageRating, int totalRatings) {
    return (averageRating * 0.7) + (totalRatings * 0.3);
  }

  void fetchTopPicksStream() {
    isTopPicksLoading(true);
    topPicksSubscription = productItemService.watchTopPicks().listen((res) {
      isTopPicksLoading(false);
      res.fold(
        (l) {
          l.showError();
        },
        (r) {
          topPicks.value = r;
        },
      );
    });
  }

  @override
  void onClose() {
    adSubscription?.cancel();
    categorySubscription?.cancel();
    topPicksSubscription?.cancel();
    super.onClose();
  }
}
