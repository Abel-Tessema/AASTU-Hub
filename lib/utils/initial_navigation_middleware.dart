import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InitialNavigationMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check if the user is logged in
    final isAuthenticated = Supabase.instance.client.auth.currentUser != null;
    if (!isAuthenticated) {
      return const RouteSettings(name: '/login'); // Redirect to login page
    }
    return null; // Allow the navigation
  }
}
