import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/app_text_field/app_text_field.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/features/authentication/screens/login/service/api_service.dart';
import 'package:docveda_app/features/authentication/screens/password_configuration/forgot_password.dart';
import 'package:docveda_app/navigation_menu.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:docveda_app/utils/encryption/pkec_keys.dart';
import 'package:docveda_app/utils/helpers/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DocvedaLoginForm extends StatefulWidget {
  const DocvedaLoginForm({super.key});

  @override
  _DocvedaLoginFormState createState() => _DocvedaLoginFormState();
}

class _DocvedaLoginFormState extends State<DocvedaLoginForm> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  bool isPasswordVisible = false;
  bool isLoading = false; //  Loading state
  final ApiService apiService = ApiService(); //  API service instance

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      String username = usernameController.text.trim();
      String password = passwordController.text.trim();

      final pkceKeys = PKCEKeys.generatePKCEKeys();
      String codeVerifier = pkceKeys["code_verifier"] ?? "";
      String codeChallenger = pkceKeys["code_challenge"] ?? "";

      if (username.isEmpty || password.isEmpty) {
        Get.snackbar(
          "Error",
          DocvedaTexts.loginErrorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: DocvedaColors.error,
          colorText: DocvedaColors.white,
        );
        return;
      }

      //  Issue Authorization Code
      final authCodeResponse = await apiService.issueAuthCode(
        username,
        password,
        codeChallenger,
      );

      if (!authCodeResponse.containsKey("authCode") &&
          !authCodeResponse.containsKey("code")) {
        throw Exception(DocvedaTexts.authorizationErrorMsg);
      }

      String authCode = authCodeResponse["code"]; // Ensure this is correct

      final tokenResponse = await apiService.issueToken(authCode, codeVerifier);
      await StorageHelper.storeTokens(
        tokenResponse["accessToken"],
        tokenResponse["idToken"],
        tokenResponse["refreshToken"],
      );

      //  Navigate to Dashboard
      Get.offAll(() => NavigationMenu());
    } catch (e) {
      print(" Login Error: $e");
      Get.snackbar(
        DocvedaTexts.loginFailedErrorMsg,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: DocvedaColors.error,
        colorText: DocvedaColors.white,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: DocvedaSizes.spaceBtwSections,
        ),
        child: Column(
          children: [
            // Email
            DocvedaTextFormField(
                controller: usernameController,
                label: DocvedaTexts.username,
                prefixIcon: Iconsax.direct_right),
            const SizedBox(height: DocvedaSizes.spaceBtwInputFields),
            DocvedaTextFormField(
              controller: passwordController,
              prefixIcon: Iconsax.password_check,
              label: DocvedaTexts.password,
              obscureText: !isPasswordVisible,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                icon: Icon(
                  isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                ),
              ),
            ),

            const SizedBox(height: DocvedaSizes.spaceBtwInputFields / 2),
            // Remember Me and Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    ),
                    const DocvedaText(
                      text: DocvedaTexts.rememberMe,
                      style: TextStyle(fontSize: DocvedaSizes.inputFieldRadius),
                    ),
                  ],
                ),

                // Forgot Password
                TextButton(
                  onPressed: () => Get.to(() => const ForgotPassword()),
                  child: const DocvedaText(
                    text: DocvedaTexts.forgotPassword,
                    style: TextStyle(fontSize: DocvedaSizes.inputFieldRadius),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DocvedaSizes.spaceBtwSections),

            PrimaryButton(
                onPressed: loginUser,
                text: DocvedaTexts.login,
                backgroundColor: DocvedaColors.primaryColor)
          ],
        ),
      ),
    );
  }
}

class _BottomSheetContent extends StatelessWidget {
  const _BottomSheetContent();

  void _launchPlayStore() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.example.yourapp'; // Replace with your actual app ID
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(DocvedaSizes.defaultSpace),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align content to top
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // No extra top padding or margin
            Image.asset(
              DocvedaImages.updateApp,
              height: DocvedaSizes.imgHeightLs,
            ),
            const SizedBox(height: DocvedaSizes.spaceBtwItemsLg),
            const Text(
              DocvedaTexts.updateAppTitle,
              style: TextStyle(
                  fontSize: DocvedaSizes.fontSizeLg,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: DocvedaSizes.spaceBtwItemsSm),
            const Text(
              DocvedaTexts.updateAppDesc,
              style: TextStyle(fontSize: 14, color: DocvedaColors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DocvedaSizes.defaultSpace),
            PrimaryButton(
                onPressed: _launchPlayStore,
                text: DocvedaTexts.goToPlaystore,
                backgroundColor: DocvedaColors.primaryColor)
          ],
        ),
      ),
    );
  }
}
