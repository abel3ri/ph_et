import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/data/services/image_service.dart';
import 'package:pharma_et/app/modules/image_picker/controllers/image_picker_controller.dart';
import 'package:pharma_et/core/controllers/auth_controller.dart';

class SignupController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  Rx<bool> showPassword = false.obs;
  Rx<bool> isLoading = false.obs;

  Map<String, dynamic>? uploadedProfileImage;

  late ImageService imageUploadService;
  late ImagePickerController imagePickerController;

  @override
  void onInit() {
    super.onInit();
    imageUploadService = Get.find<ImageService>();
    imagePickerController = Get.find<ImagePickerController>();
  }

  Future<void> signUpWithPhoneNumber() async {
    isLoading(true);
    await uploadProfileImage();
    final Map<String, dynamic> userData = {
      "email": emailController.text,
      "phoneNumber": phoneController.text,
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "password": passwordController.text,
      "profileImage": uploadedProfileImage,
      "role": "user",
      "createdAt": DateTime.now().toIso8601String(),
    };

    final authController = Get.find<AuthController>();
    final res = await authController.verifyPhoneNumber(
      userData: userData,
      isSignUp: true,
    );
    isLoading(false);
    res.fold((l) {
      l.showError();
    }, (r) {
      Get.toNamed("/otp-verification", arguments: {
        "userData": userData,
      });
      r.showSuccess();
    });
  }

  Future<void> uploadProfileImage() async {
    final String? profileImagePath =
        imagePickerController.profileImagePath.value;
    if (profileImagePath == null || profileImagePath.isEmpty) return;
    final res = await imageUploadService.uploadImage(
      imageFile: File(profileImagePath),
      uploadPreset: "profile_images",
    );

    res.fold((l) => l.showError(), (r) {
      uploadedProfileImage = r;
    });
  }

  @override
  void onClose() {
    super.onClose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
