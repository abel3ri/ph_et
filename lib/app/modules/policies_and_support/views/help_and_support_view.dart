import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pharma_et/core/widgets/cards/r_card.dart';

class HelpAndSupportView extends GetView {
  const HelpAndSupportView({super.key});
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
          "Help and Support".tr,
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
              "We’re here to assist you with any inquiries or issues you might encounter while using our app. Below are some common topics and ways to reach us:"
                  .tr,
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            RCard(
              child: Column(
                children: [
                  RContactInfoRow(
                    label: "E-mail".tr,
                    value: "info@pharmaet.com",
                    onPressed: () async {},
                  ),
                  SizedBox(height: Get.height * 0.02),
                  RContactInfoRow(
                    label: "Phone".tr,
                    value: "+251956139090",
                    onPressed: () async {},
                  ),
                  SizedBox(height: Get.height * 0.02),
                  RContactInfoRow(
                    label: "Operating hours".tr,
                    value: "24/7",
                    onPressed: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RContactInfoRow extends StatelessWidget {
  const RContactInfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.onPressed,
  });

  final String label;
  final String value;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        GestureDetector(
          onTap: onPressed,
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium!.copyWith(
              decoration: onPressed != null ? TextDecoration.underline : null,
              color: context.theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
