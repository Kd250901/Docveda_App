import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/app_text_field/app_text_field.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/features/authentication/screens/login/service/api_service.dart';
import 'package:docveda_app/features/authentication/screens/password_configuration/otp_screen.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
import 'package:docveda_app/utils/helpers/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController usernameController;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  Future<void> handleForgotPassword() async {
    print(" OTP button pressed");

    String username = usernameController.text.trim();

    if (username.isEmpty) {
      Get.snackbar(
        "Error",
        DocvedaTexts.usernameErrorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: DocvedaColors.error,
        colorText: DocvedaColors.white,
      );
      return;
    }

    final response = await apiService.getForgotPassword(
      context,
      userName: username,
    );
    print(" OTP response: $response");

    await StorageHelper.saveForgotPasswordData({
      "user": response?["mobileNumber"],
      "otp_Ric_Var": response?["otp_Ric_Var"],
      "otp_Transaction_Id": response?["otp_Transaction_Id"],
      "dlt_CD": response?["dlt_CD"],
      "user_MST_CD": response?["user_MST_CD"],
    });

    if (response != null) {
      print(" OTP sent response: $response");
      Get.to(() => const OtpScreen());
    } else {
      Get.snackbar(
        "Error",
        "Unable to send OTP. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: DocvedaColors.error,
        colorText: DocvedaColors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const DocvedaText(
          text: DocvedaTexts.forgotPasswordTitle,
          style: TextStyle(color: DocvedaColors.white),
        ),
        backgroundColor: DocvedaColors.primaryColor,
        foregroundColor: DocvedaColors.white,
        iconTheme: const IconThemeData(color: DocvedaColors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          DocvedaSizes.defaultSpace,
          DocvedaSizes.defaultSpace,
          DocvedaSizes.defaultSpace,
          keyboardSpace + DocvedaSizes.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                DocvedaImages.darkAppLogo,
                height: DocvedaSizes.imgHeightMd,
              ),
            ),
            const SizedBox(height: DocvedaSizes.spaceBtwItems),
            DocvedaText(
              text: DocvedaTexts.forgotPasswordDesc,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: DocvedaSizes.spaceBtwSections * 2),
            DocvedaTextFormField(
              controller: usernameController,
              label: DocvedaTexts.mobileno,
              prefixIcon: Iconsax.direct_right,
            ),
            const SizedBox(height: DocvedaSizes.spaceBtwSections),
            PrimaryButton(
              onPressed: handleForgotPassword,
              text: DocvedaTexts.getOTP,
              backgroundColor: DocvedaColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
