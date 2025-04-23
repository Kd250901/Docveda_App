import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/app_text_field/app_text_field.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:docveda_app/features/authentication/screens/login/login.dart';
import 'package:docveda_app/utils/constants/sizes.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _errorMessage = "";
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isOldPasswordVisible = false;

  void _resetPassword() {
    String oldPass = _oldPasswordController.text;
    String newPass = _passwordController.text;
    String confirmPass = _confirmPasswordController.text;

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      setState(() {
        _errorMessage = DocvedaTexts.fieldRequiredErrorMsg;
      });
      return;
    }

    if (oldPass == newPass) {
      setState(() {
        _errorMessage = "Old password cannot be the same as the new password.";
      });
      return;
    }

    if (newPass != confirmPass) {
      setState(() {
        _errorMessage = "New password and confirm password do not match.";
      });
      return;
    }

    setState(() {
      _errorMessage = "";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: DocvedaText(text: "Password Reset Successfully!"),
      ),
    );

    Get.offAll(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset:
            true, // 👈 Important to shift UI when keyboard appears
        appBar: AppBar(
          title: const DocvedaText(
            text: DocvedaTexts.changePassword,
            style: TextStyle(color: DocvedaColors.white),
          ),
          backgroundColor: DocvedaColors.primaryColor,
          foregroundColor: DocvedaColors.white,
          iconTheme: const IconThemeData(color: DocvedaColors.white),
          elevation: 0,
        ),
        body: SafeArea(
          // 👈 Prevents UI from going under status bar or notch
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(DocvedaSizes.spaceBtwItemsLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    DocvedaImages.darkAppLogo,
                    height: DocvedaSizes.imgHeightMd,
                  ),
                ),
                const SizedBox(height: DocvedaSizes.spaceBtwSections),

                const DocvedaText(
                  text: DocvedaTexts.enterPassword,
                  style: TextStyle(fontSize: DocvedaSizes.fontSizeMd),
                ),
                const SizedBox(height: DocvedaSizes.spaceBtwInputFields),

                // Old Password Field
                DocvedaTextFormField(
                  controller: _oldPasswordController,
                  obscureText: !isOldPasswordVisible,
                  prefixIcon: Iconsax.password_check,
                  label: "Old Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isOldPasswordVisible = !isOldPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isOldPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                    ),
                  ),
                ),
                const SizedBox(height: DocvedaSizes.spaceBtwInputFields),

// "Enter your new password" Label
                const DocvedaText(
                  text: DocvedaTexts.enterPassword,
                  style: TextStyle(fontSize: DocvedaSizes.fontSizeMd),
                ),
                const SizedBox(height: DocvedaSizes.spaceBtwInputFields),

// New Password Field
                DocvedaTextFormField(
                  controller: _passwordController,
                  obscureText: !isPasswordVisible,
                  prefixIcon: Iconsax.password_check,
                  label: DocvedaTexts.newPassword,
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

                const SizedBox(height: DocvedaSizes.spaceBtwInputFields),

                const DocvedaText(
                  text: "Confirm your new password:",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: DocvedaSizes.spaceBtwInputFields),

                // Confirm Password Field
                DocvedaTextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !isConfirmPasswordVisible,
                  prefixIcon: Iconsax.password_check,
                  label: DocvedaTexts.confirmPassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordVisible = !isConfirmPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isConfirmPasswordVisible
                          ? Iconsax.eye
                          : Iconsax.eye_slash,
                    ),
                  ),
                ),
                const SizedBox(height: DocvedaSizes.spaceBtwItemsS),

                // Error Message
                if (_errorMessage.isNotEmpty)
                  DocvedaText(
                    text: _errorMessage,
                    style: const TextStyle(color: DocvedaColors.error),
                  ),

                const SizedBox(height: DocvedaSizes.spaceBtwSections),

                // Reset Password Button
                PrimaryButton(
                  onPressed: _resetPassword,
                  text: DocvedaTexts.changePassword,
                  backgroundColor: DocvedaColors.primaryColor,
                ),

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const DocvedaText(
                      text: DocvedaTexts.login,
                      style: TextStyle(
                          fontSize: DocvedaSizes.fontSizeLg,
                          color: DocvedaColors.primaryColor,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
