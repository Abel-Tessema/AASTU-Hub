import 'package:aastu_hub/config/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/error_data.dart';
import 'cards/error_card.dart';

class LoginPrompter extends StatelessWidget {
  const LoginPrompter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ErrorCard(
                errorData: ErrorData(
                    title: 'Login required',
                    body: 'You need to log in to use this feature',
                    image: 'assets/images/not_verified.svg',
                    buttonText: 'Login to continue'),
                refresh: () => Get.toNamed(AppRoutes.loginRoute),
              ),
            )
          ],
        ),
      ),
    );
  }
}