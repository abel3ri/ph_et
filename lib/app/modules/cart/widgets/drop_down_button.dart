import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/app/modules/cart/controllers/checkout_controller.dart';

Widget buildDropDownBtn(
    BuildContext context, List paymentInfo, CheckoutController controller) {
  return DropdownButtonFormField<String>(
    value: controller.selectedPaymentOption.value,
    items: [
      DropdownMenuItem<String>(
        value: null,
        child: Text(
          'Select an option',
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
        ),
      ),
      ...paymentInfo.map(
        (item) {
          final accountNumber = item.data()['account_number'];
          return DropdownMenuItem<String>(
            value: accountNumber,
            child: Text(
              item.data()['name'],
              style: TextStyle(
                fontSize: 16,
                color: Get.isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          );
        },
      ),
    ],
    onChanged: (value) {
      if (value != null) {
        controller.updateSelectedPaymentOption(value);

        final selectedItem = paymentInfo.firstWhere(
          (item) => item.data()['account_number'] == value,
        );
        controller.updateHolderName(
          selectedItem.data()['holder_name'],
        );
      }
    },
    decoration: InputDecoration(
      labelText: 'Select Payment Method',
      labelStyle: context.textTheme.bodyMedium,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Get.isDarkMode ? Colors.white24 : Colors.grey.shade400,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Get.isDarkMode ? Colors.white24 : Colors.grey.shade400,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Get.theme.primaryColor),
      ),
      filled: true,
      fillColor: Get.isDarkMode ? Colors.grey[800] : Colors.grey.shade50,
    ),
    dropdownColor: Get.isDarkMode ? Colors.grey[900] : Colors.white,
    icon: Icon(
      Icons.arrow_drop_down,
      color: Get.isDarkMode ? Colors.white70 : Colors.grey.shade700,
    ),
    style: context.textTheme.bodyMedium!.copyWith(
      color: Get.isDarkMode ? Colors.white : Colors.black87,
    ),
  );
}
