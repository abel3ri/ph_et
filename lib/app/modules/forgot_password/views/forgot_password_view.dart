import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:pharma_et/core/utils/form_validator.dart';
import 'package:pharma_et/core/widgets/buttons/r_filled_button.dart';
import 'package:pharma_et/core/widgets/indicators/r_loading.dart';
import 'package:pharma_et/core/widgets/text_fields/r_input_field.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});
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
      body: Padding(
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

                      // height: 32,
                    ),
                  ),
                ),
              ),
              RInputField(
                controller: controller.emailController,
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: FormValidator.emailValidator,
                label: "E-mail",
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

                            await controller.resetPassword();
                          }
                        },
                        label: "Reset password",
                      )
                    : const RLoading(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
