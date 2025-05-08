import 'package:docveda_app/common/styles/spacing_styles.dart';
import 'package:docveda_app/features/authentication/screens/login/widgets/login_form.dart';
import 'package:docveda_app/features/authentication/screens/login/widgets/login_header.dart';
import 'package:docveda_app/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:docveda_app/utils/device/device_utility.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storage = const FlutterSecureStorage();
  bool _checkingAuth = true;
  RxString deviceId = ''.obs;

  @override
  void initState() {
    super.initState();
    _checkAccessToken();
  }

  void fetchDeviceId() async {
    deviceId.value = await DocvedaDeviceUtils.getDeviceId() ?? 'Unknown';
    print("deviceId ${deviceId}");
  }

  Future<void> _checkAccessToken() async {
    final accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null && accessToken.isNotEmpty) {
      // Redirect to HomeScreen if token exists
      Future.delayed(Duration.zero, () {
        Get.offAll(
          () => const NavigationMenu(),
        ); // Update to your actual home screen
      });
    } else {
      setState(() {
        _checkingAuth = false; // Allow login screen to show
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingAuth) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: DocvedaSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: const [
              /// Logo, Title and Sub-Title
              DocvedaLoginHeader(),

              /// Form
              DocvedaLoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
