import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/ad_model.dart';
import 'package:pharma_et/app/modules/home/widgets/r_banner_item.dart';
import 'package:pharma_et/core/widgets/indicators/r_page_indicator.dart';

class RCarouselSlider extends StatelessWidget {
  const RCarouselSlider({
    super.key,
    required this.ads,
    required this.onPageChanged,
    required this.currentIndex,
  });

  final List<AdModel> ads;
  final Function(int index, CarouselPageChangedReason reason) onPageChanged;
  final RxInt currentIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: ads
              .map(
                (ad) => RBannerItem(
                  imageUrl: ad.imageUrl?['url'],
                  label: '${ad.title}',
                  link: ad.link,
                  showTitle: ad.showTitle,
                ),
              )
              .toList(),
          options: CarouselOptions(
            onPageChanged: onPageChanged,
            viewportFraction: 1,
            enlargeCenterPage: true,
            autoPlay: ads.length > 1,
            height: 128,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 32,
            child: RPageIndicator(
              currentIndex: currentIndex,
              itemCount: ads.length,
              color: Get.theme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
