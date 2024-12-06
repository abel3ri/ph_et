import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/modules/profile/widgets/r_language_selection_tile.dart';
import 'package:pharma_et/core/controllers/locale_controller.dart';

class ChangeLanguageView extends GetView<LocaleController> {
  const ChangeLanguageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 28,
          ),
        ),
        title: Text(
          "changeLanguage".tr,
          style: context.textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(
              () => RLanguageSelectionTile(
                flagPath: "assets/flags/us.png",
                language: "English",
                onChanged: (value) {
                  controller.changeLocale('en');
                },
                value: controller.currentLocale.value == const Locale("en"),
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            Obx(
              () => RLanguageSelectionTile(
                flagPath: "assets/flags/et.png",
                language: "አማርኛ",
                onChanged: (value) {
                  controller.changeLocale("am");
                },
                value: controller.currentLocale.value == const Locale("am"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
