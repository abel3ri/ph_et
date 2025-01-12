import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pharma_et/core/bindings/app_bindings.dart';
import 'package:pharma_et/core/controllers/auth_controller.dart';
import 'package:pharma_et/core/controllers/locale_controller.dart';
import 'package:pharma_et/core/controllers/theme_controller.dart';
import 'package:pharma_et/core/l10n/app_translations.dart';
import 'package:pharma_et/core/services/theme_service.dart';
import 'package:pharma_et/firebase_options.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    final themeController = Get.put(ThemeController());
    Get.put<AuthController>(AuthController());
    final localeController = Get.put(LocaleController());
    runApp(
      GetMaterialApp(
        title: "Pharma ET",
        initialRoute: AppPages.INITIAL,
        initialBinding: AppBindings(),
        getPages: AppPages.routes,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.currentTheme.value,
        debugShowCheckedModeBanner: false,
        translations: AppTranslations(),
        locale: localeController.currentLocale.value,
        fallbackLocale: const Locale("en", "us"),
        defaultTransition: Transition.cupertino,
      ),
    );
  });
}
