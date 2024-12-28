import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';

class Footer extends StatelessWidget {
  final bool isLogin;
  const Footer({
    super.key,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
      child: GestureDetector(
        onTap: () {
          if (isLogin) {
            Get.to(() => const SignupScreen());
          } else {
            Get.to(() => const LoginScreen());
          }
        },
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: isLogin
                    ? 'Don\'t have an account?  '
                    : 'Already have an account?  ',
                style: const TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: isLogin ? 'Sign Up Here' : 'Log In Here',
                style: const TextStyle(
                  fontFamily: 'Readex Pro',
                  color: Color(0xFF4B39EF),
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
          textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.textScaleFactor),
        ),
      ),
    );
  }
}
