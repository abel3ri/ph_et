import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/image_service.dart';
import 'package:pharma_et/app/data/services/user_service.dart';
import 'package:pharma_et/app/modules/image_picker/controllers/image_picker_controller.dart';
import 'package:pharma_et/app/modules/profile/controllers/profile_controller.dart';
import 'package:pharma_et/core/controllers/auth_controller.dart';

class EditProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  Rx<bool> isLoading = false.obs;

  late ImageService imageService;
  late UserService userService;
  late ImagePickerController imagePickerController;
  late AuthController authController;

  @override
  void onInit() {
    super.onInit();
    imageService = Get.find<ImageService>();
    userService = Get.find<UserService>();
    imagePickerController = Get.find<ImagePickerController>();
    authController = Get.find<AuthController>();
    initFields();
  }

  void initFields() {
    final currentUser = authController.currentUser.value;
    firstNameController.text = currentUser!.firstName!;
    lastNameController.text = currentUser.lastName!;
  }

  Future<void> updateUser() async {
    if (authController.currentUser.value == null) return;

    isLoading(true);
    try {
      final String? profileImagePath =
          imagePickerController.profileImagePath.value;

      if (profileImagePath != null && profileImagePath.isNotEmpty) {
        final imageUploadRes = await imageService.uploadImage(
          imageFile: File(profileImagePath),
          uploadPreset: "profile_images",
        );

        imageUploadRes.fold(
          (l) => l.showError(),
          (uploadedImage) async {
            log('NEW UPLOADED -  ${uploadedImage.toString()}');

            final existingImage =
                authController.currentUser.value?.profileImage;

            await userService.updateOne(
              userId: authController.currentUser.value!.userId!,
              userData: {
                "firstName": firstNameController.text,
                "lastName": lastNameController.text,
                "profileImage": uploadedImage,
              },
            );

            if (existingImage != null &&
                existingImage['publicId'] != uploadedImage['publicId']) {
              final deleteRes =
                  await imageService.deleteImage(image: existingImage);

              deleteRes.fold(
                (l) => l.showError(),
                (r) {},
              );
            }
          },
        );
      } else {
        final res = await userService.updateOne(
          userId: authController.currentUser.value!.userId!,
          userData: {
            "firstName": firstNameController.text,
            "lastName": lastNameController.text,
          },
        );

        res.fold(
          (l) => l.showError(),
          (_) => log("User updated successfully."),
        );
      }

      await Get.find<ProfileController>().getUserData();
    } catch (e) {
      log("Error in updateUser: $e");
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    super.onClose();

    firstNameController.dispose();
    lastNameController.dispose();
  }
}
