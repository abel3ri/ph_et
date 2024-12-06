import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RStyledSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSubmitted;
  final VoidCallback onClear;
  final String hintText;

  const RStyledSearchBar({
    super.key,
    required this.searchController,
    required this.onSubmitted,
    required this.onClear,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: context.textTheme.bodyMedium!.copyWith(
              color:
                  Get.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
          prefixIcon: Icon(
            Icons.search,
            color: Get.theme.primaryColor,
          ),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                  color: Get.isDarkMode
                      ? Colors.grey.shade300
                      : Colors.grey.shade600,
                )
              : null,
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        style: context.textTheme.bodyMedium!.copyWith(
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
