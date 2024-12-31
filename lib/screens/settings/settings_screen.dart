import 'package:auto_size_text/auto_size_text.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/pages.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/cards/profile_list_card.dart';
import 'app_info/help_and_support_screen.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final List<Map<String, dynamic>> routesList = [
    {
      'name': 'My Grades',
      'icon': EneftyIcons.wallet_2_bold,
      'onTap': () => Get.toNamed(AppRoutes.myGrade),
      'isFirstTile': true,
      'isLastTile': true,
    },
    {
      'name': 'Help and Support',
      'icon': Icons.help_rounded,
      'onTap': () => PersistentNavBarNavigator.pushNewScreen(Get.context!,
          screen: const HelpAndSupportScreen(), withNavBar: true),
      'isFirstTile': true,
      'isLastTile': false,
    },
    {
      'name': 'Terms and Conditions',
      'icon': Icons.view_headline_sharp,
      'onTap': () => Get.toNamed(
            AppRoutes.termsAndConditionsRoute,
          ),
      'isFirstTile': false,
      'isLastTile': false,
    },
    {
      'name': 'Privacy Policy',
      'icon': Icons.privacy_tip_rounded,
      'onTap': () => Get.toNamed(AppRoutes.privacyPolicyRoute),
      'isFirstTile': false,
      'isLastTile': false,
    },
    {
      'name': 'About Us',
      'icon': Icons.info_rounded,
      'onTap': () => Get.toNamed(AppRoutes.aboutUsRoute),
      'isFirstTile': false,
      'isLastTile': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(top: 24, left: 16, right: 8),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //         width: MediaQuery.of(context).size.width * 0.2,
                //         decoration: BoxDecoration(
                //             border: Border.all(color: Colors.white, width: 2),
                //             borderRadius: BorderRadius.circular(15)),
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //           child: DropdownButtonFormField<String>(
                //             items: [
                //               DropdownMenuItem(
                //                   child: Text(
                //                 'En',
                //               ))
                //             ],
                //             onChanged: (v) {},
                //           ),
                //         ),
                //       ),
                //       AnimatedToggleSwitch<bool>.dual(
                //         current: ThemeModeController.isLightTheme.value,
                //         first: false,
                //         second: true,
                //         borderWidth: 0.0,
                //         height: 40,
                //         onChanged: (val) {
                //           ThemeModeController.toggleThemeMode(); // Toggle theme
                //         },
                //         style: ToggleStyle(
                //           indicatorColor: ThemeModeController.isLightTheme.value
                //               ? maincolor
                //               : null,
                //           // backgroundGradient: LinearGradient(colors: [
                //           //   ThemeModeController.isLightTheme.value
                //           //       ? Colors.white
                //           //       : maincolor,
                //           //   ThemeModeController.isLightTheme.value
                //           //       ? Colors.grey
                //           //       : Colors.black
                //           // ]),
                //           indicatorBorder: Border.all(
                //             color: ThemeModeController.isLightTheme.value
                //                 ? Colors.transparent
                //                 : maincolor,
                //           ),
                //         ),
                //         iconBuilder: (value) => value
                //             ? const Icon(Icons.light_mode, color: Colors.white)
                //             : const Icon(Icons.dark_mode, color: Colors.white),
                //         textBuilder: (value) => value
                //             ? const Center(child: Text('Light'))
                //             : const Center(child: Text('Dark')),
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 24, left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Row(
                            children: [
                              Icon(
                                EneftyIcons.profile_circle_bold,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width * 0.1,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(() => SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width *
                                                    0.4) -
                                                16,
                                        child: AutoSizeText(
                                          (UserController.loggedInUser.value!
                                                          .userMetadata?[
                                                      'first_name'] ??
                                                  '') +
                                              (' ') +
                                              (UserController.loggedInUser
                                                          .value!.userMetadata?[
                                                      'last_name'] ??
                                                  ''),
                                          maxLines: 1,
                                          minFontSize: 9,
                                          maxFontSize: 16,
                                          stepGranularity: 0.5,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                      )),
                                  // Obx(() => SizedBox(
                                  //       width:
                                  //           (MediaQuery.of(context).size.width *
                                  //                   0.4) -
                                  //               16,
                                  //       child: AutoSizeText(
                                  //         '+${UserController.loggedInUser.value?.phone ?? ''}',
                                  //         maxLines: 1,
                                  //         minFontSize: 5,
                                  //         maxFontSize: 12,
                                  //         stepGranularity: 0.5,
                                  //         style: const TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 12),
                                  //       ),
                                  //     )),
                                  Obx(() => Text(
                                        (UserController.loggedInUser.value
                                                    ?.email ??
                                                '')
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ...routesList.map(
            (route) => ProfileListCard(
              name: route['name'],
              icon: route['icon'],
              onTap: route['onTap'],
              isFirstTile: route['isFirstTile'],
              isLastTile: route['isLastTile'],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Supabase.instance.client.auth.signOut();
                  UserController.isLoggedIn.value = false;
                  Get.toNamed(AppRoutes.loginRoute);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
