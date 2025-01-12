import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pharma_et/core/widgets/shimmers/items/r_item_card_shimmer.dart';

class RItemCardShimmerGrid extends StatelessWidget {
  const RItemCardShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return const RItemCardShimmer();
      },
    );
  }
}
