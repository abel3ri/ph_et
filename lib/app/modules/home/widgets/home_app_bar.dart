import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/modules/home_wrapper/controllers/home_wrapper_controller.dart';
import 'package:pharma_et/core/controllers/auth_controller.dart';
import 'package:pharma_et/core/widgets/placeholders/r_circled_image_avatar.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Obx(
        () {
          final currentUser = Get.find<AuthController>().currentUser.value;
          return Row(
            children: [
              GestureDetector(
                onTap: () async {
                  Get.find<HomeWrapperController>().index.value = 4;
                },
                child: RCircledImageAvatar.small(
                  fallBackText: "profile",
                  imageUrl: currentUser?.profileImage?['url'],
                ),
              ),
              SizedBox(width: Get.width * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Hello,"),
                    Text(
                      '${currentUser?.firstName?.capitalize} ${currentUser?.lastName?.capitalize}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: context.textTheme.titleSmall!,
                    )
                  ],
                ),
              ),
              SizedBox(width: Get.width * 0.02),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Hero(
                  tag: "logo",
                  child: SvgPicture.asset(
                    "assets/icons/icon.svg",
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
