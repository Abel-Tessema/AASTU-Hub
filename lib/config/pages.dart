import 'package:aastu_hub/screens/cafe/cafe_schedule_screen.dart';
import 'package:aastu_hub/screens/department/department_screen.dart';
import 'package:aastu_hub/screens/grades/dashboard_screen.dart';
import 'package:aastu_hub/screens/grades/grade_calculator_screen.dart';
import 'package:aastu_hub/screens/lounges/lounge_screen.dart';
import 'package:get/get.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/calendars/freshman_calendar_screen.dart';
import '../screens/calendars/senior_calendar_screen.dart';
import '../screens/main_layout_screen.dart';
import '../screens/settings/app_info/about_us_screen.dart';
import '../screens/settings/app_info/contact_us_screen.dart';
import '../screens/settings/app_info/help_and_support_screen.dart';
import '../screens/settings/app_info/privacy_policy_screen.dart';
import '../screens/settings/app_info/terms_and_conditions_screen.dart';
import '../screens/settings/settings_screen.dart';
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
  static String get cafeScheduleRoute => '/cafe-schedule';
  static String get seniorCalendarRoute => '/senior-calendar';
  static String get freshmanCalendarRoute => '/freshman-calendar';
  static String get gradeCalculator => '/grade-calculator';
  static String get myGrade => '/my-grade';
  static String get signupRoute => '/signup';
  static String get loginRoute => '/login';
  static String get mainLayoutRoute => '/home';
  static String get departmentRoute => '/department';
  static String get loungeRoute => '/lounge';
}

class Pages {
  static final pages = [
    // GetPage(
    //   name: AppRoutes.forgotPasswordRoute,
    //   page: () => const ForgotPasswordScreen(),
    // ),
    GetPage(
      name: AppRoutes.loungeRoute,
      page: () => LoungeScreen(),
    ),
    GetPage(
      name: AppRoutes.termsAndConditionsRoute,
      page: () => const TermsAndConditionsScreen(),
    ),
    GetPage(
      name: AppRoutes.privacyPolicyRoute,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
      name: AppRoutes.helpAndSupportRoute,
      page: () => const HelpAndSupportScreen(),
    ),
    GetPage(
      name: AppRoutes.contactUsRoute,
      page: () => const ContactUsScreen(),
    ),
    GetPage(
      name: AppRoutes.aboutUsRoute,
      page: () => const AboutUsScreen(),
    ),
    GetPage(
      name: AppRoutes.settingsRoute,
      page: () => SettingsScreen(),
    ),
    GetPage(
      name: AppRoutes.cafeScheduleRoute,
      page: () => CafeScheduleScreen(),
    ),
    GetPage(
      name: AppRoutes.myGrade,
      page: () => DashboardScreen(),
      middlewares: [InitialNavigationMiddleware()],
    ),
    GetPage(
      name: AppRoutes.seniorCalendarRoute,
      page: () => SeniorCalendarScreen(),
    ),
    GetPage(
      name: AppRoutes.freshmanCalendarRoute,
      page: () => FreshmanCalendarScreen(),
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
    GetPage(
        name: AppRoutes.departmentRoute, page: () => const DepartmentScreen())
  ];
}
