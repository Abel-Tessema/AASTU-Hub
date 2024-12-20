import 'package:aastu_hub/screens/senior_calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_PROJECT_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    headers: {'Authorization': dotenv.env['SUPABASE_SECRET_KEY'] ?? ''},
  );
  runApp(const AastuHub());
}

class AastuHub extends StatelessWidget {
  const AastuHub({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Freshman Calendar',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SeniorCalendar(),
    );
  }
}
