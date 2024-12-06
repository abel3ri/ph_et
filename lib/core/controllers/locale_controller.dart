import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends GetxController {
  Rx<Locale> currentLocale = Rx<Locale>(const Locale('en'));

  @override
  void onInit() {
    super.onInit();
    getCurrentLocale();
  }

  void changeLocale(String localeCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("locale", localeCode);

    currentLocale.value = _getLocale(localeCode);
    Get.updateLocale(currentLocale.value);
  }

  void getCurrentLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString("locale") ?? 'en';
    currentLocale.value = _getLocale(localeCode);
    Get.updateLocale(currentLocale.value);
  }

  Locale _getLocale(String localeCode) {
    switch (localeCode) {
      case 'am':
        return const Locale('am');
      case 'en':
      default:
        return const Locale('en');
    }
  }
}
