import 'package:aastu_hub/screens/calendar/senior_calendar_screen.dart';
import 'package:aastu_hub/screens/grades/dashboard_screen.dart';
import 'package:aastu_hub/screens/grades/grade_calculator_screen.dart';
import 'package:get/get.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/main_layout_screen.dart';
import '../utils/initial_navigation_middleware.dart';

class AppRoutes {
  static String get profileRoute => '/profile';
  static String get forgotPasswordRoute => '/forgot-password';
  static String get changePasswordRoute => '/change-password';
  static String get termsAndConditionsRoute => '/terms-and-conditions';
  static String get privacyPolicyRoute => '/privacy-policy';
  static String get helpAndSupportRoute => '/help-and-support';
  static String get contactUsRoute => '/contact-us';
  static String get aboutUsRoute => '/about-us';
  static String get settingsRoute => '/settings';
  static String get routeDetailRoute => '/route-detail';
  static String get seniorCalendar => '/senior-calendar';
  static String get gradeCalculator => '/grade-calculator';
  static String get myGrade => '/my-grade';
  static String get signupRoute => '/signup';
  static String get loginRoute => '/login';
  static String get mainLayoutRoute => '/home';
}

class Pages {
  static final pages = [
    // GetPage(
    //   name: AppRoutes.forgotPasswordRoute,
    //   page: () => const ForgotPasswordScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.changePasswordRoute,
    //   page: () => const ChangePasswordScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.termsAndConditionsRoute,
    //   page: () => const TermsAndConditionsScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.privacyPolicyRoute,
    //   page: () => const PrivacyPolicyScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.helpAndSupportRoute,
    //   page: () => const HelpAndSupportScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.contactUsRoute,
    //   page: () => const ContactUsScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.aboutUsRoute,
    //   page: () => const AboutUsScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.settingsRoute,
    //   page: () => SettingsScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.routeDetailRoute,
    //   page: () => const RouteDetailScreen(),
    // ),
    GetPage(
      name: AppRoutes.myGrade,
      page: () => DashboardScreen(),
      middlewares: [InitialNavigationMiddleware()],
    ),
    GetPage(
      name: AppRoutes.seniorCalendar,
      page: () => SeniorCalendar(),
    ),
    GetPage(
      name: AppRoutes.gradeCalculator,
      page: () => const GradeCalculator(),
    ),
    GetPage(
      name: AppRoutes.signupRoute,
      page: () => const SignupScreen(),
    ),
    GetPage(
      name: AppRoutes.loginRoute,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.mainLayoutRoute,
      page: () => MainLayoutScreen(),
    ),
  ];
}
