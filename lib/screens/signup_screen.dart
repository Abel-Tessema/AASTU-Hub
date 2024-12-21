//FOR WHEN FEATURES COME UP NEEDING SIGN UP.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../utils/animations.dart';
import '../../widgets/footer.dart';
import '../../widgets/input_field.dart';
import '../../widgets/loading_animation_button.dart';
import '../../widgets/main_button.dart';
import '../controllers/auth_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  UserController signUpController = Get.put(UserController());
  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 1.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 300.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 300.ms,
          begin: const Offset(0, 140),
          end: const Offset(0, 0),
        ),
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 300.ms,
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
        ),
        TiltEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 300.ms,
          begin: const Offset(-0.349, 0),
          end: const Offset(0, 0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
  }

  bool agreedToTerms = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 6,
            child: Container(
              width: 100,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4B39EF), Color(0xFFEE8B60)],
                  stops: [0, 1],
                  begin: AlignmentDirectional(0.87, -1),
                  end: AlignmentDirectional(-0.87, 1),
                ),
              ),
              alignment: const AlignmentDirectional(0, -1),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 70, 0, 32),
                      child: Container(
                        width: 284,
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: const AlignmentDirectional(0, 0),
                        child: const Text(
                          'AASTU-Hub',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                    buildBody(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxWidth: 570,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x33000000),
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildForm(context),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                  child: Obx(
                    () => signUpController.signingUp.value
                        ? LoadingAnimatedButton(
                            onTap: () {},
                            borderRadius: 20,
                            height: 65,
                            child: const Text(
                              'Create Account',
                              style: TextStyle(color: Color(0xFF4B39EF)),
                            ),
                          )
                        : MainButton(
                            isLoading: signUpController.isLoading.value,
                            onPress: () => signUpController.signUp(),
                            text: 'Create Account',
                          ),
                  ),
                ),
                const Footer(
                  isLogin: false,
                ),
              ],
            ),
          ),
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
    );
  }

  Widget buildForm(BuildContext context) {
    return Form(
      key: signUpController.formKey,
      child: Column(
        children: [
          InputFieldWidget(
              textEditingController: signUpController.firstnameController,
              focusNode: signUpController.firstnameFocusNode,
              validator: (val) {
                if (val!.length < 2) {
                  return "First name must be at least 2 characters.";
                }
                return null;
              },
              obscureText: false,
              passwordinput: false,
              label: 'First name'),
          InputFieldWidget(
              textEditingController: signUpController.lastnameController,
              focusNode: signUpController.lastnameFocusNode,
              validator: (val) {
                if (val!.length < 2) {
                  return "Last name must be at least 2 characters.";
                }
                return null;
              },
              obscureText: false,
              passwordinput: false,
              label: 'Last name'),
          InputFieldWidget(
              textEditingController: signUpController.emailAddressController,
              focusNode: signUpController.emailAddressFocusNode,
              validator: (val) {
                if (!val!.isEmail) {
                  return "Enter a valid email.";
                }
                return null;
              },
              obscureText: false,
              passwordinput: false,
              label: 'Email'),
          InputFieldWidget(
            textEditingController: signUpController.passwordController,
            focusNode: signUpController.passwordFocusNode2,
            passwordinput: true,
            obscureText: false,
            label: 'Password',
            validator: (val) {
              print("length ${val!.length}");
              if (val.length < 8) {
                return "Password must be at least 8 characters.";
              }
              return null;
            },
          ),
          InputFieldWidget(
              textEditingController: signUpController.phoneController,
              focusNode: signUpController.phoneFocusNode,
              label: 'Phone number',
              validator: (val) {
                if (val!.length < 10) {
                  return "Invalid Phone Number";
                }
                return null;
              },
              obscureText: false,
              passwordinput: false)
        ],
      ),
    );
  }
}
