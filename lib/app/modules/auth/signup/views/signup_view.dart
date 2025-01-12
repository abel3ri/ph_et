import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:pharma_et/app/modules/image_picker/controllers/image_picker_controller.dart';
import 'package:pharma_et/app/modules/image_picker/views/image_picker_view.dart';
import 'package:pharma_et/core/utils/form_validator.dart';
import 'package:pharma_et/core/widgets/buttons/r_circled_button.dart';
import 'package:pharma_et/core/widgets/buttons/r_filled_button.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';
import 'package:pharma_et/core/widgets/text_fields/r_input_field.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});
  @override
  Widget build(BuildContext context) {
    final imagePickController = Get.find<ImagePickerController>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.close),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
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
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Text(
                "Sign up",
                style: context.textTheme.headlineMedium,
              ),
              SizedBox(height: Get.height * 0.02),
              Stack(
                children: [
                  Obx(() {
                    final bool profileImagePicked =
                        imagePickController.profileImagePath.value != null;
                    return CircleAvatar(
                      radius: 48,
                      backgroundImage: profileImagePicked
                          ? FileImage(
                              File(imagePickController.profileImagePath.value!),
                            )
                          : null,
                      child: profileImagePicked ? null : const Text("Profile"),
                    );
                  }),
                  Positioned(
                    bottom: 4,
                    right: 2,
                    child: RCircledButton.small(
                      icon: Icons.add,
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Get.theme.scaffoldBackgroundColor,
                          context: context,
                          builder: (context) => const ImagePickerView(
                            imageType: "profile_image",
                            label: "Pick profile image",
                          ),
                          constraints: BoxConstraints(
                            maxHeight: Get.height * 0.3,
                          ),
                          showDragHandle: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                children: [
                  Expanded(
                    child: RInputField(
                      label: "First name",
                      controller: controller.firstNameController,
                      hintText: "Enter your first name",
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: FormValidator.nameValidator,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Expanded(
                    child: RInputField(
                      label: "Last name",
                      controller: controller.lastNameController,
                      hintText: "Enter your last name",
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: FormValidator.nameValidator,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              RInputField(
                label: "Phone",
                controller: controller.phoneController,
                hintText: "Enter your phone",
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: FormValidator.phoneNumberValidator,
              ),
              SizedBox(height: Get.height * 0.02),
              RInputField(
                label: "Email (Optional)",
                controller: controller.emailController,
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: FormValidator.emailValidator,
              ),
              SizedBox(height: Get.height * 0.02),
              Obx(
                () => RInputField(
                  controller: controller.passwordController,
                  label: "Password",
                  hintText: "Enter your password",
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  obscureText: !controller.showPassword.value,
                  validator: FormValidator.passwordValidator,
                  suffix: IconButton(
                    focusNode: FocusNode(
                      skipTraversal: true,
                    ),
                    onPressed: () {
                      controller.showPassword.value =
                          !controller.showPassword.value;
                    },
                    icon: Icon(
                      controller.showPassword.isTrue
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Obx(
                () => RInputField(
                  controller: controller.confirmPasswordController,
                  label: "Re-enter password",
                  hintText: "Confirm your password",
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  obscureText: !controller.showPassword.value,
                  validator: (value) {
                    return FormValidator.confirmPasswordValidator(
                      password: controller.passwordController.text,
                      rePassword: value,
                    );
                  },
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Obx(
                () => controller.isLoading.isFalse
                    ? RFilledButton(
                        label: "Sign up",
                        onPressed: () async {
                          if (controller.formKey.currentState?.validate() ??
                              false) {
                            if (Get.focusScope?.hasFocus ?? false) {
                              Get.focusScope!.unfocus();
                            }
                            await controller.signUpWithPhoneNumber();
                          }
                        },
                      )
                    : const RLoading(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Get.offNamed("/login");
                    },
                    child: Text(
                      "Login",
                      style: context.textTheme.titleSmall!.copyWith(
                        color: Get.theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
