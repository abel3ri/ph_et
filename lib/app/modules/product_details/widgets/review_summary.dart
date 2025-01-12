import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pharma_et/core/widgets/cards/r_card.dart';

class ReviewSummary extends StatelessWidget {
  final double averageRating;
  final int totalRatings;
  final Map<int, int> ratingDistribution;

  const ReviewSummary({
    super.key,
    required this.averageRating,
    required this.totalRatings,
    required this.ratingDistribution,
  });

  @override
  Widget build(BuildContext context) {
    return RCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                averageRating.toStringAsFixed(1),
                style: context.textTheme.headlineLarge,
              ),
              const SizedBox(height: 4),
              RatingBarIndicator(
                itemCount: 5,
                itemSize: 20,
                rating: averageRating,
                itemBuilder: (context, index) {
                  return Icon(
                    Icons.star_rounded,
                    color: Get.theme.primaryColor,
                  );
                },
              ),
              const SizedBox(height: 4),
              Text('$totalRatings reviews'),
            ],
          ),
          SizedBox(width: Get.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(5, (index) {
                final star = 5 - index;
                final count = ratingDistribution[star] ?? 0;
                final percentage =
                    totalRatings > 0 ? (count / totalRatings) * 100 : 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text('$star', style: context.textTheme.titleMedium),
                      SizedBox(width: Get.width * 0.01),
                      Icon(Icons.star, color: Get.theme.primaryColor, size: 16),
                      SizedBox(width: Get.width * 0.02),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: percentage / 100,
                          color: Get.theme.primaryColor,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      SizedBox(width: Get.width * 0.02),
                      Text('$count', style: context.textTheme.titleSmall),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
