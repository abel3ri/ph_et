import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/review_model.dart';
import 'package:pharma_et/app/data/models/success_model.dart';
import 'package:pharma_et/app/data/services/review_service.dart';
import 'package:pharma_et/app/modules/product_details/controllers/product_details_controller.dart';
import 'package:pharma_et/core/controllers/auth_controller.dart';

class ReviewFormController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<double> userRating = 0.0.obs;
  String? productId;
  bool? isEditing;
  ReviewModel? editingReview;

  final commentController = TextEditingController();

  late AuthController authController;
  late ReviewService reviewService;
  late ProductDetailsController productDetailsController;

  @override
  void onInit() {
    super.onInit();
    productId = Get.arguments?['productId'];
    isEditing = Get.arguments?['isEditing'] ?? false;
    editingReview = Get.arguments?['review'];
    initFields();

    authController = Get.find<AuthController>();
    reviewService = Get.find<ReviewService>();
    productDetailsController = Get.find<ProductDetailsController>();
  }

  void initFields() {
    if (isEditing == true && editingReview != null) {
      userRating.value = editingReview!.rating!;
      commentController.text = editingReview?.comment ?? "";
    }
  }

  Future<void> createReview() async {
    isLoading(true);

    DateTime creationTime = DateTime.now();
    final review = ReviewModel(
      comment: commentController.text.isEmpty ? null : commentController.text,
      rating: userRating.value,
      createdAt: creationTime,
      updatedAt: creationTime,
      productId: productId,
      userId: authController.currentUser.value?.userId,
    );

    final res = await reviewService.addReviewTransaction(review: review);
    isLoading(false);

    res.fold(
      (l) {
        l.showError();
      },
      (r) async {
        Get.back();
        productDetailsController.pagingController.refresh();
        SuccessModel(body: "Review added successfully").showSuccess();
      },
    );
  }

  Future<void> updateReview() async {
    if (isEditing != true && editingReview == null) return;

    isLoading(true);
    final review = ReviewModel(
      reviewId: editingReview!.reviewId,
      comment: commentController.text.isEmpty ? null : commentController.text,
      rating: userRating.value,
      createdAt: editingReview!.createdAt!,
      updatedAt: DateTime.now(),
      productId: editingReview!.productId!,
      userId: editingReview!.userId,
    );

    final res = await reviewService.updateReviewTransaction(
      reviewId: review.reviewId!,
      updatedReview: review,
    );
    isLoading(false);

    res.fold((l) {
      l.showError();
    }, (r) {
      Get.back();
      productDetailsController.pagingController.refresh();
      SuccessModel(body: "Review edited successfully").showSuccess();
    });
  }

  @override
  void onClose() {
    super.onClose();
    commentController.dispose();
  }
}
