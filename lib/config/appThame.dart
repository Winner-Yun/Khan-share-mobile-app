import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khan_share_mobile_app/config/appColors.dart';

class AppTheme {
  // -------------------- LIGHT THEME --------------------
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColorLight.background,

    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColorLight.textAppbar,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColorLight.iconAppbar),
    ),

    iconTheme: const IconThemeData(color: AppColorLight.iconPrimary),

    cardColor: AppColorLight.cardBackground,
    useMaterial3: true,
  );

  // -------------------- DARK THEME --------------------
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColorDark.background,

    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: AppColorDark.textAppbar,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColorDark.iconAppbar),
    ),

    iconTheme: const IconThemeData(color: AppColorDark.iconPrimary),

    cardColor: AppColorDark.cardBackground,
    useMaterial3: true,
  );
}
