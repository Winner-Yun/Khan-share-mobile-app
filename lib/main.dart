import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // import Google Fonts
import 'package:khan_share_mobile_app/screens/mainappdisplay.dart';

  void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: const Mainappdisplay(),
    );
  }
}
