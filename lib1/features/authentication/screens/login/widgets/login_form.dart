import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/app_text_field/app_text_field.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/features/authentication/screens/login/service/api_service.dart';
import 'package:docveda_app/features/authentication/screens/password_configuration/forgot_password.dart';
import 'package:docveda_app/navigation_menu.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/encryption/pkec_keys.dart';
import 'package:docveda_app/utils/helpers/storage_helper.dart';
import 'package:docveda_app/utils/bottom_sheet/bottom_sheet.dart';
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

      print(" Username: $username");
      print(" Password: $password");
      print(" codeChallenger: $codeChallenger");
      print(" codeVerifier: $codeVerifier");

      if (username.isEmpty || password.isEmpty) {
        Get.snackbar(
          "Error",
          "Email and password are required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      //  Issue Authorization Code
      final authCodeResponse = await apiService.issueAuthCode(
        username,
        password,
        codeChallenger,
      );
      print(" Auth Code Response: $authCodeResponse");

      if (!authCodeResponse.containsKey("authCode") &&
          !authCodeResponse.containsKey("code")) {
        throw Exception("Authorization code not received.");
      }

      String authCode = authCodeResponse["code"]; // Ensure this is correct

      print("Received Authorization Code: $codeVerifier"); // Force unwrap
      print("Received Authorization Code: $codeChallenger");

      final tokenResponse = await apiService.issueToken(authCode, codeVerifier);
      // print(" Full Token Response: $tokenResponse"); // Add this line

      //  Fetch User Access
      // final userAccess = await apiService.getUserAccess(roleId, accessToken);
      // print("User Access: $userAccess");

      print("accessToken from response : ${tokenResponse["accessToken"]}");
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
        "Login Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
                label: "Username",
                prefixIcon: Iconsax.direct_right),
            const SizedBox(height: DocvedaSizes.spaceBtwInputFields),
            DocvedaTextFormField(
              controller: passwordController,
              prefixIcon: Iconsax.password_check,
              label: "Password",
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
                      text: "Remember me",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),

                // Forgot Password
                TextButton(
                  onPressed: () => Get.to(() => const ForgotPassword()),
                  child: const DocvedaText(
                    text: "Forgot Password ?",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DocvedaSizes.spaceBtwSections),

            PrimaryButton(
                onPressed: loginUser,
                text: 'Log In',
                backgroundColor: DocvedaColors.primaryColor)
            // // Sign In Button
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     // onPressed: loginUser,
            //     onPressed: () {
            //       BottomSheetUtils.showCustomBottomSheet(
            //         context: context,
            //         child: const _BottomSheetContent(),
            //       );
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor:
            //           DocvedaColors.primaryColor, // ✅ Button background color
            //       foregroundColor: Colors.white, // ✅ Text color
            //       shadowColor: Colors.transparent, // ✅ Removes shadow
            //       overlayColor:
            //           Colors.transparent, // ✅ Removes blue highlight on press
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(
            //           8,
            //         ), // Optional: Adjust border radius
            //       ),
            //     ),
            //     child: const DocvedaText(text: "Sign In"),
            //   ),
            // ),
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
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align content to top
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // No extra top padding or margin
            Image.asset(
              DocvedaImages.updateApp,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'New Updates Available!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Update application to continue using',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
                onPressed: _launchPlayStore,
                text: 'Go to Playstore',
                backgroundColor: DocvedaColors.primaryColor)
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: _launchPlayStore,
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: DocvedaColors.primaryColor,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(30),
            //       ),
            //       padding: const EdgeInsets.symmetric(vertical: 14),
            //     ),
            //     child: const Text(
            //       'Go to Playstore',
            //       style: TextStyle(fontSize: 16),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
