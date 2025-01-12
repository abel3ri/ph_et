import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class RBannerItem extends StatelessWidget {
  const RBannerItem({
    super.key,
    required this.imageUrl,
    required this.label,
    this.link,
    this.showTitle,
  });

  final String label;
  final String imageUrl;
  final String? link;
  final bool? showTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (link != null) {
          await launchUrl(
            Uri.parse(link!),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: CachedNetworkImageProvider(imageUrl),
          ),
        ),
        child: showTitle == true
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.transparent,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ))
            : null,
      ),
    );
  }
}
