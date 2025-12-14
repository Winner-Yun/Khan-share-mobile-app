import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:khan_share_mobile_app/auth/login.dart';
import 'package:khan_share_mobile_app/auth/signup.dart';
import 'package:khan_share_mobile_app/auth/welcomepage.dart';
import 'package:khan_share_mobile_app/screens/createbooklist.dart';
import 'package:khan_share_mobile_app/screens/homepage.dart';
import 'package:khan_share_mobile_app/screens/mainappdisplay.dart';
import 'package:khan_share_mobile_app/screens/map_picker_screen.dart';
import 'package:khan_share_mobile_app/screens/mappage.dart';
import 'package:khan_share_mobile_app/screens/messagescreen%20.dart';
import 'package:khan_share_mobile_app/screens/notification_screen.dart';
import 'package:khan_share_mobile_app/screens/profilescreen.dart';
import 'package:khan_share_mobile_app/screens/settingscreen.dart';

class AppRoutes {
  static String login = '/login';
  static String signup = '/signup';
  static String welcomepage = '/welcome';
  static String homepage = '/homepage';
  static String mapPage = '/map_page';
  static String messageScreen = '/message_screen';
  static String notiScreen = '/noti_screen';
  static String profileScreen = '/profile_screen';
  static String settingScreen = '/set_screen';
  static String createBookScreen = '/cre_b_screen';
  static String mapPicker = '/map_picker';
  static String mainAppdisplay = '/main_app';

  static final pages = [
    GetPage(name: AppRoutes.welcomepage, page: () => const WelcomeScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.signup, page: () => const SignupScreen()),
    GetPage(name: AppRoutes.homepage, page: () => const HomepageScreen()),
    GetPage(name: AppRoutes.mapPage, page: () => const MapViewScreen()),
    GetPage(name: AppRoutes.messageScreen, page: () => const MessageScreen()),
    GetPage(name: AppRoutes.notiScreen, page: () => const NotificationScreen()),
    GetPage(name: AppRoutes.profileScreen, page: () => const ProfileScreen()),
    GetPage(name: AppRoutes.settingScreen, page: () => const SettingsScreen()),
    GetPage(
      name: AppRoutes.createBookScreen,
      page: () => const Createbooklist(),
    ),
    GetPage(name: AppRoutes.mapPicker, page: () => const MapPickerScreen()),
    GetPage(name: AppRoutes.mainAppdisplay, page: () => const Mainappdisplay()),
  ];
}
