import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/core/widgets/cards/r_card.dart';

class RLanguageSelectionTile extends StatelessWidget {
  const RLanguageSelectionTile({
    super.key,
    required this.flagPath,
    required this.language,
    required this.onChanged,
    required this.value,
  });

  final String flagPath;
  final String language;
  final Function(bool? value)? onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: RCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  flagPath,
                  width: 48,
                  height: 48,
                ),
                SizedBox(width: Get.width * 0.02),
                Text(
                  language,
                  style: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Radio(
              value: value,
              groupValue: true,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
