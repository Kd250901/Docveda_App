import 'package:docveda_app/features/authentication/screens/login/login.dart';
import 'package:docveda_app/utils/helpers/storage_helper.dart';
import 'package:flutter/widgets.dart'; // required for WidgetsBinding
import 'package:get/get.dart';

class UnauthorizedHelper {
  static void handle() {
    print('Unauthorized access. Clearing tokens and redirecting...');
    StorageHelper.clearTokens();

    Get.snackbar('Session Expired', 'Please login again');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAll(() => const LoginScreen());
    });
  }
}
