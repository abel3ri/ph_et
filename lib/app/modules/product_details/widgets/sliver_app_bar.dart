import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/core/widgets/buttons/r_circled_button.dart';
import 'package:pharma_et/core/widgets/indicators/r_page_indicator.dart';

Widget buildSliverAppBar(product, controller) {
  return SliverAppBar(
    expandedHeight: Get.height * 0.3,
    automaticallyImplyLeading: false,
    elevation: 0,
    pinned: true,
    stretch: true,
    surfaceTintColor: Colors.transparent,
    flexibleSpace: FlexibleSpaceBar(
      background: Stack(
        fit: StackFit.expand,
        children: [
          CarouselSlider.builder(
            itemCount: product?.images?.length ?? 0,
            itemBuilder: (context, index, realIndex) {
              final imageUrl = product?.images?[index]['url'] ?? "";

              return CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(
                    Icons.error,
                    size: 32,
                  ),
                ),
              );
            },
            options: CarouselOptions(
              viewportFraction: 1,
              enableInfiniteScroll: true,
              height: double.infinity,
              onPageChanged: (index, reason) {
                controller.currentIndex.value = index;
              },
            ),
          ),
          Positioned(
            top: 32,
            left: 16,
            child: RCircledButton.large(
              icon: Icons.arrow_back_rounded,
              onTap: () {
                Get.back();
              },
            ),
          ),
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: RPageIndicator(
                currentIndex: controller.currentIndex,
                itemCount: product?.images?.length ?? 0,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
