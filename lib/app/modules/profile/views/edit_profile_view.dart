import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/modules/image_picker/views/image_picker_view.dart';
import 'package:pharma_et/app/modules/profile/controllers/edit_profile_controller.dart';
import 'package:pharma_et/core/utils/form_validator.dart';
import 'package:pharma_et/core/widgets/buttons/r_circled_button.dart';
import 'package:pharma_et/core/widgets/buttons/r_filled_button.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';
import 'package:pharma_et/core/widgets/text_fields/r_input_field.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final imagePickerController = controller.imagePickerController;
    final currentUser = controller.authController.currentUser.value;

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
          "Edit Profile".tr,
          style: context.textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  Obx(
                    () {
                      final bool isImagePicked =
                          imagePickerController.profileImagePath.value != null;
                      final bool hasProfileImage =
                          currentUser?.profileImage != null &&
                              (currentUser?.profileImage?['url']?.isNotEmpty ??
                                  false);

                      return CircleAvatar(
                        radius: 48,
                        backgroundImage: isImagePicked
                            ? FileImage(
                                File(imagePickerController
                                    .profileImagePath.value!),
                              )
                            : hasProfileImage
                                ? NetworkImage(
                                    currentUser?.profileImage?['url'])
                                : null,
                        child: (!hasProfileImage && !isImagePicked)
                            ? const Text("Profile")
                            : null,
                      );
                    },
                  ),
                  Positioned(
                    bottom: 2,
                    right: 4,
                    child: RCircledButton.medium(
                      icon: Icons.edit,
                      color: Get.theme.colorScheme.secondary,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: ImagePickerView(
                              imageType: "profile_image",
                              label: "Pick Profile Image",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              RInputField(
                controller: controller.firstNameController,
                hintText: "Enter your first name",
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: FormValidator.nameValidator,
                label: "First Name",
              ),
              SizedBox(height: Get.height * 0.02),
              RInputField(
                controller: controller.lastNameController,
                hintText: "Enter your first name",
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: FormValidator.nameValidator,
                label: "Last Name",
              ),
              SizedBox(height: Get.height * 0.02),
              Obx(
                () => controller.isLoading.isFalse
                    ? RFilledButton(
                        onPressed: () async {
                          if (controller.formKey.currentState?.validate() ??
                              false) {
                            if (Get.focusScope?.hasFocus ?? false) {
                              Get.focusScope!.unfocus();
                            }
                            await controller.updateUser();
                            Get.back();
                          }
                        },
                        label: "Edit",
                      )
                    : RLoading(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
