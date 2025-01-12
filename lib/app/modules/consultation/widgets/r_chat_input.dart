import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class RChatInput extends StatelessWidget {
  RChatInput({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.textInputAction,
    this.obscureText = false,
    this.maxLines,
    required this.validator,
    this.suffix,
    this.prefix,
    super.key,
  });

  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final int? maxLines;
  final Widget? suffix;
  final Widget? prefix;
  String? Function(String? value) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
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
          borderRadius: BorderRadius.circular(16),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
        suffixIcon: suffix,
        prefix: prefix,
      ),
      validator: validator,
      onEditingComplete: textInputAction == TextInputAction.newline
          ? null // Disable default behavior for new lines
          : null,
    );
  }
}
