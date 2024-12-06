import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> currentTheme = Rx<ThemeMode>(ThemeMode.system);

  @override
  void onInit() {
    super.onInit();
    getCurrentTheme();
  }

  void changeTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("theme", theme);

    ThemeMode newTheme;
    if (theme == "light") {
      newTheme = ThemeMode.light;
    } else if (theme == "dark") {
      newTheme = ThemeMode.dark;
    } else {
      newTheme = ThemeMode.system;
    }

    currentTheme(newTheme);
    Get.changeThemeMode(newTheme);
  }

  void getCurrentTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString("theme");

    if (theme == "light") {
      currentTheme(ThemeMode.light);
    } else if (theme == "dark") {
      currentTheme(ThemeMode.dark);
    } else {
      currentTheme(ThemeMode.system);
    }

    Get.changeThemeMode(currentTheme.value);
  }
}
