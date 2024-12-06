import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pharma_et/core/utils/form_validator.dart';
import 'package:pharma_et/core/widgets/buttons/r_filled_button.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';
import 'package:pharma_et/core/widgets/text_fields/r_input_field.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              SizedBox(
                height: 96,
                width: 96,
                child: FittedBox(
                  child: Hero(
                    tag: "logo",
                    child: SvgPicture.asset(
                      "assets/icons/icon.svg",
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.01),
              Text(
                "Login",
                style: context.textTheme.headlineMedium,
              ),
              SizedBox(height: Get.height * 0.04),
              RInputField(
                label: "Email or Phone",
                controller: controller.emailOrPhoneController,
                hintText: "Enter your email or phone",
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: FormValidator.emailOrPhoneValidator,
              ),
              SizedBox(height: Get.height * 0.02),
              Obx(
                () => RInputField(
                  controller: controller.passwordController,
                  label: "Password",
                  hintText: "Enter your password",
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  obscureText: !controller.showPassword.value,
                  validator: FormValidator.passwordValidator,
                  suffix: IconButton(
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
                () => controller.isLoading.isFalse
                    ? RFilledButton(
                        label: "Login",
                        onPressed: () async {
                          if (controller.formKey.currentState?.validate() ??
                              false) {
                            if (Get.focusScope?.hasFocus ?? false) {
                              Get.focusScope!.unfocus();
                            }
                            if (GetUtils.isEmail(
                              controller.emailOrPhoneController.text,
                            )) {
                              await controller.loginWithEmail();
                            } else {
                              await controller.loginWithPhoneNumber();
                            }
                          }
                        },
                      )
                    : const RLoading(),
              ),
              TextButton(
                onPressed: () {
                  Get.toNamed("/forgot-password");
                },
                child: Text(
                  "Forgot password?",
                  style: context.textTheme.titleSmall!.copyWith(
                    color: Get.theme.primaryColor,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Get.offNamed("/signup");
                    },
                    child: Text(
                      "Sign up",
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
