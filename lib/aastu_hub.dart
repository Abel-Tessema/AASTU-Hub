import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'config/pages.dart';
import 'controllers/theme_mode_controller.dart';

class AastuHub extends StatelessWidget {
  const AastuHub({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ThemeModeController(context));
    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeModeController.getThemeMode(),
          initialRoute: AppRoutes.mainLayoutRoute,
          getPages: Pages.pages,
        ));
  }
}
