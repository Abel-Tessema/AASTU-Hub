import 'package:aastu_hub/services/user_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/pages.dart';

class UserController extends GetxController {
  var isLoading = false.obs;
  static final Rx<User?> loggedInUser =
      Supabase.instance.client.auth.currentUser.obs;
  static final RxBool isLoggedIn = false.obs;
  var loggingIn = false.obs;
  var signingUp = false.obs;
  TextEditingController emailTextEditingController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();

  // Form key to validate the form
  final formKey = GlobalKey<FormState>();
  TextEditingController passwordTextEditingController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();

  TextEditingController firstnameController = TextEditingController();
  FocusNode firstnameFocusNode = FocusNode();

  TextEditingController lastnameController = TextEditingController();
  FocusNode lastnameFocusNode = FocusNode();

  TextEditingController phoneController = TextEditingController();
  FocusNode phoneFocusNode = FocusNode();

  TextEditingController emailAddressController = TextEditingController();
  FocusNode emailAddressFocusNode = FocusNode();

  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocusNode2 = FocusNode();

  void login() async {
    try {
      loggingIn.value = true;
      await UserService().signIn(
          email: emailTextEditingController.text,
          password: passwordTextEditingController.text);
      isLoggedIn.value = true;
      loggedInUser.value = Supabase.instance.client.auth.currentUser;
      Get.offNamed(AppRoutes.mainLayoutRoute);
      loggingIn.value = false;
    } catch (e, s) {
      loggingIn.value = false;
      Logger().t(e, stackTrace: s);
      Get.snackbar('Error', e.toString());
    }
  }

  var hasAgreedToTerms = false.obs;
  void signUp() async {
    if (formKey.currentState!.validate() == false) return;
    if (!hasAgreedToTerms.value) {
      Get.snackbar('Error',
          'Please agree to the terms and conditions and privacy policy');
      return;
    }
    try {
      signingUp.value = true;
      await UserService().signUp(
        firstName: firstnameController.text,
        lastName: lastnameController.text,
        email: emailAddressController.text,
        phone: phoneController.text,
        password: passwordController.text,
      );
      Get.offNamed(AppRoutes.mainLayoutRoute);
      signingUp.value = false;
    } catch (err, stack) {
      signingUp.value = false;
      Logger().t(err, stackTrace: stack);
      Get.snackbar('Error', err.toString());
    }
  }
}
