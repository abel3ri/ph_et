import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class RInputField extends StatelessWidget {
  RInputField({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.textInputAction,
    this.obscureText = false,
    required this.validator,
    required this.label,
    this.suffix,
    this.prefix,
    super.key,
  });

  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final Widget? suffix;
  final Widget? prefix;
  String? Function(String? value) validator;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: Get.width * 0.04,
          ),
          child: Text(
            label,
            style: context.textTheme.titleSmall,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: context.isDarkMode
                ? Colors.grey.shade800
                : const Color.fromARGB(255, 227, 227, 227),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            hintText: hintText,
            hintStyle: context.textTheme.bodyMedium!.copyWith(
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(100),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(100),
            ),
            suffixIcon: suffix,
            prefix: prefix,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
