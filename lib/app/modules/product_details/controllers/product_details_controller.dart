import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pharma_et/app/data/models/product_item_model.dart';
import 'package:pharma_et/app/data/models/review_model.dart';
import 'package:pharma_et/app/data/models/success_model.dart';
import 'package:pharma_et/app/data/services/product_item_service.dart';
import 'package:pharma_et/app/data/services/review_service.dart';
import 'package:pharma_et/app/data/services/user_service.dart';
import 'package:pharma_et/app/modules/cart/controllers/cart_controller.dart';
import 'package:pharma_et/core/controllers/auth_controller.dart';
import 'package:pharma_et/core/widgets/dialogs/r_show_dialog.dart';

class ProductDetailsController extends GetxController {
  Rx<ProductItemModel?> product = Rx<ProductItemModel?>(null);
  final scrollController = ScrollController();
  final scrollOffset = 0.0.obs;

  static const int pageSize = 5;

  final PagingController<int, ReviewModel> pagingController =
      PagingController(firstPageKey: 0);

  RxInt currentIndex = 0.obs;
  Rx<List<ReviewModel>> reviews = Rx<List<ReviewModel>>([]);
  RxBool isLoading = false.obs;

  late ReviewService reviewService;
  late UserService userService;
  late CartController cartController;
  late AuthController authController;
  late ProductItemService productService;

  StreamSubscription? reviewSubscription;

  String? productId;

  @override
  void onInit() {
    super.onInit();

    reviewService = Get.find<ReviewService>();
    userService = Get.find<UserService>();
    cartController = Get.find<CartController>();
    authController = Get.find<AuthController>();
    productService = Get.find<ProductItemService>();

    productId = Get.arguments?['productId'];
    if (productId != null) {
      fetchProduct(productId!);
    }

    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });

    fetchReviewsStream();
  }

  void fetchProduct(String productId) {
    productService.watchProduct(productId: productId).listen((res) {
      res.fold(
        (l) {
          l.showError();
        },
        (r) {
          product.value = r;
        },
      );
    });
  }

  Future<void> fetchPage(int pageKey) async {
    if (product.value == null) return;

    try {
      final reviewsSnapshot = await reviewService.findPaginatedReviewsByProduct(
        productId: product.value!.productId!,
        limit: pageSize,
        startAfter: pageKey,
      );

      reviewsSnapshot.fold(
        (error) => pagingController.error = error.body,
        (newReviews) {
          final isLastPage = newReviews.length < pageSize;
          if (isLastPage) {
            pagingController.appendLastPage(newReviews);
          } else {
            final nextPageKey = pageKey + newReviews.length;
            pagingController.appendPage(newReviews, nextPageKey);
          }
        },
      );
    } catch (error) {
      pagingController.error = error.toString();
    }
  }

  void fetchReviewsStream() {
    if (productId == null) return;

    isLoading(true);
    reviewSubscription =
        reviewService.watchAllReviewsByProduct(productId!).listen((res) {
      res.fold(
        (l) {
          isLoading(false);
          l.showError();
        },
        (r) {
          reviews.value = r;
          isLoading(false);
        },
      );
    });
  }

  Map<int, int> getRatingDistribution() {
    Map<int, int> distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    for (var review in reviews.value) {
      if (review.rating != null) {
        int rating = review.rating!.round();
        if (distribution.containsKey(rating)) {
          distribution[rating] = distribution[rating]! + 1;
        }
      }
    }
    return distribution;
  }

  Future<void> deleteReview({
    required String reviewId,
  }) async {
    if (productId == null) return;

    final result = await rShowDialog(
      title: "Delete Review",
      content: "Are you sure you want to delete this review?",
      mainActionLabel: "Delete Review",
    );

    if (result == true) {
      final res = await reviewService.deleteReviewTransaction(
        reviewId: reviewId,
        productId: productId!,
      );

      res.fold((l) {
        l.showError();
      }, (r) {
        pagingController.refresh();
        SuccessModel(body: "Review deleted successfully").showSuccess();
      });
    }
  }

  @override
  void onClose() {
    super.onClose();
    pagingController.dispose();
    scrollController.dispose();
    reviewSubscription?.cancel();
  }
}
