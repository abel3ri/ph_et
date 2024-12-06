import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pharma_et/app/modules/policies_and_support/controllers/policies_and_support_controller.dart';
import 'package:pharma_et/core/widgets/cards/r_detailed_text_card.dart';

class PrivacyPolicyView extends GetView<PoliciesAndSupportController> {
  const PrivacyPolicyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          "Privacy Policy".tr,
          style: context.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "PharmaET values your privacy and is committed to protecting your personal data. This Privacy Policy explains how we collect, use, and safeguard your information."
                  .tr,
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            RDetailedTextCard(
              heading: "Information We Collect".tr,
              body:
                  "Personal Information: Name, email, address, and payment details."
                      .tr,
            ),
            SizedBox(height: Get.height * 0.01),
            RDetailedTextCard(
              heading: "How We Use Your Information".tr,
              body: "To process orders and deliver products.".tr,
            ),
            SizedBox(height: Get.height * 0.01),
            RDetailedTextCard(
              heading: "Sharing Your Information".tr,
              body: "When required by law to share data.".tr,
            ),
            SizedBox(height: Get.height * 0.01),
            RDetailedTextCard(
              heading: "Your Rights".tr,
              body:
                  "Request access to your data or deletion of personal information."
                      .tr,
            ),
          ],
        ),
      ),
    );
  }
}
