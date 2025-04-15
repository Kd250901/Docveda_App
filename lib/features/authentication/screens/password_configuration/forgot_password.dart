import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/app_text_field/app_text_field.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/features/authentication/screens/password_configuration/otp_screen.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    TextEditingController usernameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const DocvedaText(
          text: "Forgot Password",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: DocvedaColors.primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        // ✅ Makes content scrollable
        padding: EdgeInsets.fromLTRB(
          DocvedaSizes.defaultSpace,
          DocvedaSizes.defaultSpace,
          DocvedaSizes.defaultSpace,
          keyboardSpace + 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                DocvedaImages.darkAppLogo,
                height: 80, // Adjust size as needed
              ),
            ),
            // Heading
            // Text(
            //   "Forgot Password",
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
            const SizedBox(height: DocvedaSizes.spaceBtwItems),
            DocvedaText(
              text:
                  "Don't worry, sometimes people forget too! Enter your email and we will send you a password reset link.",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: DocvedaSizes.spaceBtwSections * 2),

            // Text Field
            DocvedaTextFormField(
              controller: usernameController,
              label: "Username",
              prefixIcon: Iconsax.direct_right,
            ),
            const SizedBox(height: DocvedaSizes.spaceBtwSections),

            // Submit Button
            PrimaryButton(
                onPressed: () {
                  if (usernameController.text.isNotEmpty) {
                    Get.to(() => const OtpScreen());
                  } else {
                    Get.snackbar(
                      "Error",
                      "Please enter your username.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                text: 'Submit',
                backgroundColor: DocvedaColors.primaryColor)
          ],
        ),
      ),
    );
  }
}
