import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RRadioListTile extends StatelessWidget {
  const RRadioListTile({
    super.key,
    required this.iconPath,
    required this.label,
    required this.value,
    required this.controller,
    this.subtitle,
  });

  final String iconPath;
  final String label;
  final String value;
  final controller;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: controller.radioGroupValue.value == value
                ? Get.theme.primaryColor
                : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: RadioListTile<String>(
          title: Row(
            children: [
              SizedBox(
                width: label.toLowerCase().contains('digital') ? 48 : 32,
                height: label.toLowerCase().contains('digital') ? 48 : 32,
                child: SvgPicture.asset(
                  iconPath,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(
                    context.isDarkMode ? Colors.white : Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: context.textTheme.titleMedium,
              ),
            ],
          ),
          value: value,
          controlAffinity: ListTileControlAffinity.trailing,
          groupValue: controller.radioGroupValue.value,
          onChanged: (value) {
            controller.radioGroupValue.value = value!;
          },
          subtitle: subtitle != null ? Text(subtitle!) : null,
        ),
      ),
    );
  }
}
