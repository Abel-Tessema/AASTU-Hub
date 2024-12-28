import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../controllers/theme_mode_controller.dart';

List<BoxShadow> kCardShadow() {
  return [
    BoxShadow(
      color: ThemeModeController.isLightTheme.value
          ? Colors.grey.withOpacity(0.3)
          : Colors.black38,
      spreadRadius: 1,
      blurRadius: 10,
      offset: const Offset(0, 3), // changes position of shadow
    ),
  ];
}

String kApiBaseUrl = '${dotenv.env['SUPABASE_PROJECT_URL']}/rest/v1';
