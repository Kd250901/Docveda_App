import 'dart:convert';
import 'package:crypto/crypto.dart'; // <-- For password hashing
import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/app_text_field/app_text_field.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/features/authentication/screens/login/service/api_service.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:docveda_app/features/authentication/screens/login/login.dart';

class NewPasswordScreen extends StatefulWidget {
  final String username;
  final String userCd;

  const NewPasswordScreen({
    super.key,
    required this.username,
    required this.userCd,
  });

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ApiService apiService = ApiService();

  late final String userName;
  late final String userCd;

  String _errorMessage = "";
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isOldPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    userName = widget.username;
    userCd = widget.userCd;
  }

  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  void _resetPassword() async {
    String newPass = _passwordController.text;
    String confirmPass = _confirmPasswordController.text;

    if (newPass.isEmpty || confirmPass.isEmpty) {
      setState(() {
        _errorMessage = DocvedaTexts.fieldRequiredErrorMsg;
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
      _isLoading = true;
    });

    final response = await apiService.getresetPassword(
      context,
      userName: userName,
      hashedPassword: hashPassword(newPass),
      userCd: userCd,
    );

    setState(() => _isLoading = false);
    print("Reset Password Response: $response");
    if (response?['message'] == "The password changed  successfully.") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: DocvedaText(text: "Password Reset Successfully!")),
      );
      Get.offAll(() => const LoginScreen());
    } else {
      setState(() {
        _errorMessage = response?['message'] ?? "Reset failed. Try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
              DocvedaTextFormField(
                controller: _passwordController,
                obscureText: !isPasswordVisible,
                prefixIcon: Iconsax.password_check,
                label: DocvedaTexts.newPassword,
                suffixIcon: IconButton(
                  onPressed: () => setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  }),
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
              DocvedaTextFormField(
                controller: _confirmPasswordController,
                obscureText: !isConfirmPasswordVisible,
                prefixIcon: Iconsax.password_check,
                label: DocvedaTexts.confirmPassword,
                suffixIcon: IconButton(
                  onPressed: () => setState(() {
                    isConfirmPasswordVisible = !isConfirmPasswordVisible;
                  }),
                  icon: Icon(
                    isConfirmPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                  ),
                ),
              ),
              const SizedBox(height: DocvedaSizes.spaceBtwItemsS),
              if (_errorMessage.isNotEmpty)
                DocvedaText(
                  text: _errorMessage,
                  style: const TextStyle(color: DocvedaColors.error),
                ),
              const SizedBox(height: DocvedaSizes.spaceBtwSections),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : PrimaryButton(
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
