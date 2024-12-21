import 'package:aastu_hub/config/config_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'aastu_hub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigPreference.init();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_PROJECT_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    headers: {'Authorization': dotenv.env['SUPABASE_SECRET_KEY'] ?? ''},
  );
  runApp(const AastuHub());
}
