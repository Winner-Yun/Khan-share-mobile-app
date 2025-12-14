import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khan_share_mobile_app/config/appThame.dart';

class ThemeController extends GetxController {
  RxBool isDark = false.obs;

  ThemeData get theme =>
      isDark.value ? AppTheme.darkTheme : AppTheme.lightTheme;

  void toggleTheme(bool value) {
    isDark.value = value;
    Get.changeTheme(theme); // apply theme instantly
  }
}
