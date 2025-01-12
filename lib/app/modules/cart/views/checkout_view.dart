import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/models/error_model.dart';
import 'package:pharma_et/app/modules/cart/bindings/select_address_binding.dart';
import 'package:pharma_et/app/modules/cart/controllers/checkout_controller.dart';
import 'package:pharma_et/app/modules/cart/views/select_address_view.dart';
import 'package:pharma_et/app/modules/cart/widgets/drop_down_button.dart';
import 'package:pharma_et/app/modules/cart/widgets/r_placeholder_container.dart';
import 'package:pharma_et/app/modules/image_picker/views/image_picker_view.dart';
import 'package:pharma_et/core/utils/form_validator.dart';
import 'package:pharma_et/core/widgets/buttons/r_circled_button.dart';
import 'package:pharma_et/core/widgets/buttons/r_filled_button.dart';
import 'package:pharma_et/core/widgets/cards/r_card.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';
import 'package:pharma_et/core/widgets/text_fields/r_input_field.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          "Checkout",
          style: context.textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (controller.cartController.radioGroupValue.value ==
                'bank_transfer')
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("payment_info")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: RLoading(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error loading data from server."),
                    );
                  }
                  final paymentInfo = snapshot.data?.docs ?? [];

                  if (controller.selectedPaymentOption.value != null &&
                      !paymentInfo.any((item) =>
                          item.data()['account_number'] ==
                          controller.selectedPaymentOption.value)) {
                    controller.updateSelectedPaymentOption(null);
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select an Option to Deposit",
                        style: context.textTheme.titleMedium,
                      ),
                      SizedBox(height: Get.height * 0.04),
                      buildDropDownBtn(context, paymentInfo, controller),
                      SizedBox(height: Get.height * 0.02),
                      Obx(
                        () {
                          final selectedAccountNumber =
                              controller.selectedPaymentOption.value;
                          final selectedHolderName =
                              controller.holderName.value;

                          return selectedAccountNumber != null
                              ? RCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Expanded(
                                              child: Text("Account Number")),
                                          Text(selectedAccountNumber),
                                          IconButton(
                                            onPressed: () async {
                                              await Clipboard.setData(
                                                ClipboardData(
                                                  text: selectedAccountNumber,
                                                ),
                                              );
                                              Get.snackbar(
                                                'Copied',
                                                'Account Number copied to clipboard.',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                              );
                                            },
                                            icon: const Icon(Icons.copy),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: Get.height * 0.02),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Expanded(
                                              child: Text("Holder Name")),
                                          Text(selectedHolderName ?? "-"),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox();
                        },
                      ),
                    ],
                  );
                },
              ),
            SizedBox(height: Get.height * 0.02),
            RCard(
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    Text(
                      "Customer Information",
                      style: context.textTheme.titleMedium,
                    ),
                    SizedBox(height: Get.height * 0.02),
                    RInputField(
                      controller: controller.fullNameController,
                      hintText: "Enter your full name",
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: FormValidator.fullNameValidator,
                      label: "Full name",
                    ),
                    SizedBox(height: Get.height * 0.02),
                    RInputField(
                      controller: controller.phoneController,
                      hintText: "Enter your phone number",
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      validator: FormValidator.phoneNumberValidator,
                      label: "Phone number",
                    ),
                    SizedBox(height: Get.height * 0.02),
                    RPlaceHolderContainer(
                      children: const [
                        Icon(Icons.location_on_rounded),
                        Text("Select your address"),
                      ],
                      onTap: () {
                        Get.to(
                          () => const SelectAddressView(),
                          binding: SelectAddressBinding(),
                        );
                      },
                    ),
                    Obx(() {
                      final address = controller.selectedAddress.value;
                      if (address != null) {
                        return FutureBuilder(
                          future: controller.getPlaceName(
                              address.latitude, address.longitude),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const RLoading();
                            }
                            if (snapshot.hasError) {
                              return const Text("Unable to get address name");
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                              child: SelectableText.rich(
                                TextSpan(
                                  text: "Delivery address: ",
                                  children: [
                                    TextSpan(
                                      text: '${snapshot.data}',
                                      style: context.textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    }),
                    SizedBox(height: Get.height * 0.02),
                    if (controller.cartController.radioGroupValue.value ==
                        'bank_transfer') ...[
                      RPlaceHolderContainer(
                        children: const [
                          Icon(Icons.upload_rounded),
                          Text("Upload receipt"),
                        ],
                        onTap: () {
                          showModalBottomSheet(
                            showDragHandle: true,
                            context: context,
                            builder: (context) => const ImagePickerView(
                              imageType: "receipt_image",
                              label: "Pick receipt image",
                            ),
                          );
                        },
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Obx(
                        () => controller.imagePickerController.receiptImagePath
                                    .value !=
                                null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: SizedBox(
                                      width: Get.width,
                                      height: 120,
                                      child: Image.file(
                                        File(
                                          controller.imagePickerController
                                              .receiptImagePath.value!,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: RCircledButton.small(
                                      color: Get.theme.colorScheme.secondary,
                                      icon: Icons.close,
                                      onTap: () {
                                        controller.imagePickerController
                                            .receiptImagePath.value = null;
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    left: 4,
                                    child: RCircledButton.small(
                                      color: Get.theme.colorScheme.secondary,
                                      icon: Icons.fullscreen,
                                      onTap: () {
                                        Get.toNamed(
                                          "/image_preview",
                                          arguments: {
                                            "imageUrl": controller
                                                .imagePickerController
                                                .receiptImagePath
                                                .value,
                                            "imageType": "file_image"
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ),
                    ],
                    Obx(
                      () => controller.isLoading.isTrue
                          ? const RLoading()
                          : RFilledButton(
                              onPressed: () async {
                                if (controller
                                        .cartController.radioGroupValue.value ==
                                    'bank_transfer') {
                                  if (controller.selectedPaymentOption.value ==
                                      null) {
                                    ErrorModel(
                                      body: "Please select payment option",
                                    ).showError();
                                    return;
                                  }
                                }

                                if (controller.formKey.currentState
                                        ?.validate() ??
                                    false) {
                                  if (controller.selectedAddress.value ==
                                      null) {
                                    ErrorModel(
                                      body: "Please select delivery address",
                                    ).showError();
                                    return;
                                  }

                                  if (controller.cartController.radioGroupValue
                                          .value ==
                                      "bank_transfer") {
                                    if (controller.imagePickerController
                                            .receiptImagePath.value ==
                                        null) {
                                      ErrorModel(
                                        body: "Please upload receipt image",
                                      ).showError();
                                      return;
                                    }
                                  }

                                  if (Get.focusScope?.hasFocus ?? false) {
                                    Get.focusScope?.unfocus();
                                  }

                                  if (controller.cartController.radioGroupValue
                                          .value !=
                                      'digital_payment') {
                                    await controller.createOrder();
                                  } else {
                                    await controller.chapaPay();
                                  }
                                }
                              },
                              label: "Continue",
                            ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
