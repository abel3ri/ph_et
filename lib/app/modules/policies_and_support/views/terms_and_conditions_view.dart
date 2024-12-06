import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/modules/policies_and_support/controllers/policies_and_support_controller.dart';
import 'package:pharma_et/core/widgets/cards/r_detailed_text_card.dart';

class TermsAndConditionsView extends GetView<PoliciesAndSupportController> {
  const TermsAndConditionsView({super.key});
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
          "Terms and Conditions".tr,
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
              "These Terms and Conditions govern your use of the Pharma ET platform. By using our app, you agree to comply with these terms."
                  .tr,
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            RDetailedTextCard(
              heading: "Use of the App".tr,
              body: "You must be at least 18 years old to use this app".tr,
            ),
            SizedBox(height: Get.height * 0.01),
            RDetailedTextCard(
              heading: "Orders and Payments".tr,
              body:
                  "Prices are listed in [currency] and include applicable taxes."
                      .tr,
            ),
            SizedBox(height: Get.height * 0.01),
            RDetailedTextCard(
              heading: "Limitation of Liability".tr,
              body:
                  "We are not liable for any health issues arising from misuse of products purchased through our app. Consult a healthcare professional before using any products."
                      .tr,
            ),
            SizedBox(height: Get.height * 0.01),
            RDetailedTextCard(
              heading: "Changes to Terms".tr,
              body:
                  "We may update these Terms at any time. Continued use of the app constitutes acceptance of the updated Terms."
                      .tr,
            ),
          ],
        ),
      ),
    );
  }
}
