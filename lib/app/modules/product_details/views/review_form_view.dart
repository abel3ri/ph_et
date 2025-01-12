import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/modules/product_details/controllers/review_form_controller.dart';
import 'package:pharma_et/core/widgets/buttons/r_filled_button.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';
import 'package:pharma_et/core/widgets/text_fields/r_input_field.dart';

class ReviewFormView extends GetView<ReviewFormController> {
  const ReviewFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 24,
          ),
        ),
        title: Text(
          controller.isEditing == true ? "Edit your review" : "Add a review",
          style: context.textTheme.titleSmall,
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: Get.width,
        child: Column(
          children: [
            Center(
              child: Text(
                "Rate your experience",
                style: context.textTheme.titleLarge,
              ),
            ),
            SizedBox(height: Get.height * 0.04),
            RatingBar(
              glow: false,
              allowHalfRating: false,
              maxRating: 5,
              minRating: 1,
              updateOnDrag: true,
              ratingWidget: RatingWidget(
                full: Icon(
                  Icons.star_rounded,
                  color: Get.theme.primaryColor,
                ),
                half: Icon(
                  Icons.star_half_rounded,
                  color: Get.theme.primaryColor,
                ),
                empty: const Icon(Icons.star_border_rounded),
              ),
              onRatingUpdate: (value) {
                controller.userRating.value = value;
              },
              initialRating: controller.userRating.value,
              itemCount: 5,
            ),
            SizedBox(height: Get.height * 0.01),
            RInputField(
              controller: controller.commentController,
              hintText: "Add an optional comment...",
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              validator: (value) => null,
              label: "",
              maxLines: 4,
              borderRadius: 8,
            ),
            SizedBox(height: Get.height * 0.02),
            Obx(
              () => controller.isLoading.isTrue
                  ? const RLoading()
                  : RFilledButton(
                      onPressed: () async {
                        if (controller.userRating.value == 0.0) {
                          ErrorModel(
                            body: "Please provide a rating",
                          ).showError();

                          return;
                        }

                        if (Get.focusScope?.hasFocus ?? false) {
                          Get.focusScope?.unfocus();
                        }

                        if (controller.isEditing == true) {
                          await controller.updateReview();
                        } else {
                          await controller.createReview();
                        }
                        Get.back();
                      },
                      label: "Rate",
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
