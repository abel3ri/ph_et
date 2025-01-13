import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pharma_et/app/data/models/review_model.dart';
import 'package:pharma_et/app/data/models/user_model.dart';
import 'package:pharma_et/app/modules/product_details/controllers/product_details_controller.dart';
import 'package:pharma_et/core/widgets/buttons/r_circled_button.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';
import 'package:pharma_et/core/widgets/placeholders/r_circled_image_avatar.dart';

Widget buildRatingList(ProductDetailsController controller) {
  return Flexible(
    child: PagedListView<int, ReviewModel>.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      pagingController: controller.pagingController,
      builderDelegate: PagedChildBuilderDelegate<ReviewModel>(
        itemBuilder: (context, review, index) {
          return StreamBuilder(
            stream: controller.userService
                .findOneAsStream(userId: review.userId ?? ""),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Failed to load user data");
              }

              UserModel? userData;

              snapshot.data?.fold(
                (error) => Text(error.body),
                (user) => userData = user,
              );

              if (userData != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RCircledImageAvatar.small(
                          fallBackText: "profile",
                          imageUrl: userData?.profileImage?['url'],
                        ),
                        SizedBox(width: Get.width * 0.02),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${userData?.firstName} ${userData?.lastName}",
                                style: context.textTheme.titleSmall,
                              ),
                              RatingBarIndicator(
                                itemBuilder: (context, index) => Icon(
                                  Icons.star_rounded,
                                  color: Get.theme.primaryColor,
                                ),
                                itemCount: 5,
                                itemSize: 16,
                                rating: review.rating ?? 0.0,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              timeago.format(
                                review.createdAt ?? DateTime.now(),
                              ),
                              style: context.textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (controller.authController.currentUser.value !=
                                    null &&
                                controller.authController.currentUser.value
                                        ?.userId ==
                                    review.userId) ...[
                              const SizedBox(height: 6),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RCircledButton(
                                    icon: Icons.edit_rounded,
                                    onTap: () {
                                      Get.toNamed(
                                        "/product-details/review-form",
                                        arguments: {
                                          "productId": controller.productId,
                                          "isEditing": true,
                                          "review": review,
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  RCircledButton(
                                    icon: Icons.delete_rounded,
                                    onTap: () async {
                                      await controller.deleteReview(
                                        reviewId: review.reviewId!,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                            if (review.createdAt != review.updatedAt) ...[
                              const SizedBox(height: 4),
                              Text(
                                "edited",
                                style: context.textTheme.bodySmall,
                              )
                            ],
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.02),
                    if (review.comment != null)
                      ReadMoreText(
                        review.comment!,
                        trimLines: 3,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        trimMode: TrimMode.Line,
                      ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          );
        },
        newPageProgressIndicatorBuilder: (context) => const SizedBox(
          width: 64,
          height: 64,
          child: RLoading(),
        ),
        firstPageProgressIndicatorBuilder: (context) => const SizedBox(
          width: 64,
          height: 64,
          child: RLoading(),
        ),
        newPageErrorIndicatorBuilder: (context) => const Center(
          child: Text("Failed to load reviews"),
        ),
        firstPageErrorIndicatorBuilder: (context) => const Center(
          child: Text(
            "Failed to load reviews",
          ),
        ),
        noItemsFoundIndicatorBuilder: (context) => const Center(
          child: Text(
            "No reviews yet",
          ),
        ),
      ),
      separatorBuilder: (context, index) => Divider(
        thickness: .2,
        color: Get.theme.primaryColor,
      ),
    ),
  );
}
