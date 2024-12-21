import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final supabase = Supabase.instance.client;

  Future<User?> signUp(
      {required String firstName,
      required String lastName,
      required String phone,
      required String email,
      required String password}) async {
    try {
      final response =
          await supabase.auth.signUp(email: email, password: password, data: {
        'first_name': firstName,
        'last_name': lastName,
      });

      return response.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<User?> signIn(
      {required String email, required String password}) async {
    try {
      final response = await supabase.auth
          .signInWithPassword(email: email, password: password);
      return response.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool?> signOut() async {
    try {
      final response = await supabase.auth.signOut();
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
