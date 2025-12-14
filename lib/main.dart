import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khan_share_mobile_app/config/appThame.dart';
import 'package:khan_share_mobile_app/config/theme_provider.dart';
import 'package:khan_share_mobile_app/routes/app_routes.dart';

void main() {
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,

        themeMode: themeController.isDark.value
            ? ThemeMode.dark
            : ThemeMode.light,

        getPages: AppRoutes.pages,
        initialRoute: AppRoutes.mainAppdisplay,
      ),
    );
  }
}
