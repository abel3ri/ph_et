import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pharma_et/app/modules/profile/controllers/profile_controller.dart';
import 'package:pharma_et/app/modules/profile/widgets/r_profile_detail_row.dart';
import 'package:pharma_et/app/modules/profile/widgets/r_profile_page_title.dart';
import 'package:pharma_et/core/controllers/auth_controller.dart';
import 'package:pharma_et/core/controllers/theme_controller.dart';
import 'package:pharma_et/core/widgets/buttons/r_circled_button.dart';
import 'package:pharma_et/core/widgets/buttons/r_filled_button.dart';
import 'package:pharma_et/core/widgets/cards/r_card.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';
import 'package:pharma_et/core/widgets/placeholders/r_circled_image_avatar.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final themeController = Get.find<ThemeController>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Profile".tr,
          style: context.textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.delayed(Durations.medium2),
        // onRefresh: controller.getUserData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            children: [
              Obx(
                () {
                  if (controller.isLoading.isTrue) {
                    return const Center(
                      child: RLoading(),
                    );
                  }
                  final user = authController.currentUser.value;
                  return RCard(
                    color: context.theme.primaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (user != null) ...[
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    "/profile/image-preview",
                                    arguments: {
                                      "imageUrl": user.profileImage?['url'],
                                    },
                                  );
                                },
                                child: RCircledImageAvatar.large(
                                  imageUrl: user.profileImage?['url'],
                                  fallBackText:
                                      '${user.firstName?[0]}${user.lastName![0]}',
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                right: 2,
                                child: RCircledButton.small(
                                  color: Get.theme.colorScheme.secondary,
                                  icon: Icons.edit,
                                  onTap: () {
                                    Get.toNamed("/profile/edit-profile");
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                left: 2,
                                child: RCircledButton.small(
                                  color: Get.theme.colorScheme.secondary,
                                  icon: Icons.fullscreen,
                                  onTap: () {
                                    Get.toNamed(
                                      "/profile/image-preview",
                                      arguments: {
                                        "imageUrl": user.profileImage?['url'],
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * 0.01),
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: context.textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.02),
                          RProfileDetailRow(
                            label: "E-mail".tr,
                            data: "${user.email}".toLowerCase(),
                          ),
                          SizedBox(height: Get.height * 0.02),
                          RProfileDetailRow(
                            label: "Phone".tr,
                            data: "${user.phoneNumber}".toLowerCase(),
                          ),
                          SizedBox(height: Get.height * 0.02),
                          RProfileDetailRow(
                            label: "Date Joined".tr,
                            data: DateFormat.yMMMd("en-us")
                                .format(user.createdAt!),
                          ),
                        ],
                        if (authController.currentUser.value == null) ...[
                          Text(
                            "Login or Sign up to View Your Profile".tr,
                            style: context.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RFilledButton(
                                label: "Sign up",
                                onPressed: () {
                                  Get.offAllNamed("signup", arguments: {
                                    "previousRoute": "home",
                                  });
                                },
                              ),
                              const SizedBox(width: 12),
                              RFilledButton(
                                label: "Login",
                                onPressed: () {
                                  Get.offAllNamed("signup", arguments: {
                                    "previousRoute": "home",
                                  });
                                },
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: Get.height * 0.02),
              RCard(
                child: ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    RProfilePageTile(
                      title: "Theme".tr,
                      onPressed: null,
                      icon: Icons.color_lens_rounded,
                      trailing: DropdownButton(
                        value: themeController.currentTheme.value.name,
                        alignment: Alignment.centerRight,
                        style: context.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        underline: const SizedBox.shrink(),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        elevation: 0,
                        borderRadius: BorderRadius.circular(8),
                        items: [
                          DropdownMenuItem(
                            value: "system",
                            child: Text("System".tr),
                          ),
                          DropdownMenuItem(
                            value: "light",
                            child: Text("Light".tr),
                          ),
                          DropdownMenuItem(
                            value: "dark",
                            child: Text("Dark".tr),
                          )
                        ],
                        onChanged: (value) {
                          themeController.changeTheme(value ?? "system");
                        },
                      ),
                    ),
                    RProfilePageTile(
                      title: "language".tr,
                      onPressed: () {
                        Get.toNamed("/profile/change-language");
                      },
                      icon: Icons.translate_rounded,
                      trailing: const Icon(Icons.arrow_right_alt_rounded),
                    ),
                    RProfilePageTile(
                      title: "Help & Support".tr,
                      onPressed: () {
                        Get.toNamed(
                          "/policies-and-support/help-and-support",
                        );
                      },
                      icon: Icons.help,
                      trailing: const Icon(Icons.arrow_right_alt_rounded),
                    ),
                    RProfilePageTile(
                      title: "Privacy Policy".tr,
                      icon: Icons.shield,
                      onPressed: () {
                        Get.toNamed(
                          "/policies-and-support/privacy-policy",
                        );
                      },
                      trailing: const Icon(Icons.arrow_right_alt_rounded),
                    ),
                    RProfilePageTile(
                      title: "Terms and Conditions".tr,
                      icon: Icons.article_sharp,
                      onPressed: () {
                        Get.toNamed(
                          "/policies-and-support/terms-and-conditions",
                        );
                      },
                      trailing: const Icon(Icons.arrow_right_alt_rounded),
                    ),
                    if (authController.currentUser.value != null) ...[
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: Text("Logout".tr),
                        trailing: const Icon(Icons.arrow_right_alt_rounded),
                        iconColor: context.theme.colorScheme.error,
                        textColor: context.theme.colorScheme.error,
                        titleTextStyle: context.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        onTap: () async {
                          await authController.logout();
                          Get.offAllNamed("/get-started");
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_forever_rounded),
                        title: Text("Delete Account".tr),
                        trailing: const Icon(Icons.arrow_right_alt_rounded),
                        iconColor: context.theme.colorScheme.error,
                        textColor: context.theme.colorScheme.error,
                        titleTextStyle: context.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              title: Text(
                                  "Ar you sure you want to delete your account?"
                                      .tr),
                              content: Text(
                                  "Deleting your account is a permanent action that cannot be undone. Are you sure you want to proceed?"
                                      .tr),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    Get.back();
                                    await controller.deleteAccount();
                                  },
                                  child: Text(
                                    "I understand".tr,
                                    style:
                                        context.textTheme.titleMedium!.copyWith(
                                      color: Get.theme.primaryColor,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "Cancel".tr,
                                    style:
                                        context.textTheme.titleMedium!.copyWith(
                                      color: Get.theme.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
