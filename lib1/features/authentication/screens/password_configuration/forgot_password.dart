import 'package:docveda_app/common/widgets/app_text_field/app_text_field.dart';
import 'package:docveda_app/features/authentication/screens/password_configuration/otp_screen.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(),
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
            // Heading
            Text(
              "Forgot Password",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: DocvedaSizes.spaceBtwItems),
            Text(
              "Don't worry, sometimes people forget too! Enter your email and we will send you a password reset link.",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: DocvedaSizes.spaceBtwSections * 2),

            // Text Field
            DocvedaTextFormField(
              label: "E-mail",
              prefixIcon: Iconsax.direct_right,
            ),
            const SizedBox(height: DocvedaSizes.spaceBtwSections),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const OtpScreen()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DocvedaColors.primaryColor,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  overlayColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
