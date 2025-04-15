import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/app_text_field/app_text_field.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart'; // Import Iconsax for icons
import 'package:docveda_app/features/authentication/screens/login/login.dart';
import 'package:docveda_app/utils/constants/sizes.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _errorMessage = "";
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void _resetPassword() {
    if (_passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Both fields are required.";
      });
    } else if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match.";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: DocvedaText(text: "Password Reset Successfully!")),
      );

      // Navigate to Login Screen and remove all previous screens
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DocvedaText(
          text: "Change Password",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: DocvedaColors.primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                DocvedaImages.darkAppLogo,
                height: 80, // Adjust size as needed
              ),
            ),
            const SizedBox(height: DocvedaSizes.spaceBtwSections),

            const DocvedaText(
              text: "Enter your new password:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: DocvedaSizes.spaceBtwInputFields),

            // New Password Field
            DocvedaTextFormField(
              controller: _passwordController,
              obscureText: !isPasswordVisible,
              prefixIcon: Iconsax.password_check,
              label: "New Password",
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

            // Confirm Password Field
            DocvedaTextFormField(
              controller: _confirmPasswordController,
              obscureText: !isConfirmPasswordVisible,
              prefixIcon: Iconsax.password_check,
              label: "Confirm Password",
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isConfirmPasswordVisible = !isConfirmPasswordVisible;
                  });
                },
                icon: Icon(
                  isConfirmPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Error Message
            if (_errorMessage.isNotEmpty)
              DocvedaText(
                text: _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: DocvedaSizes.spaceBtwSections),

            // Reset Password Button
            PrimaryButton(
                onPressed: _resetPassword,
                text: 'Change Password',
                backgroundColor: DocvedaColors.primaryColor),

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
                  text: "Login",
                  style: TextStyle(
                    fontSize: 18,
                    color: DocvedaColors.primaryColor,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
